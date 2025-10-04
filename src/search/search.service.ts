// src/search/search.service.ts
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class SearchService {
  constructor(private readonly ds: DataSource) { }

  private searchVecExists?: boolean;

  private async ensureSearchVecExists(): Promise<boolean> {
    if (this.searchVecExists === undefined) {
      const r = await this.ds.query(`
        SELECT EXISTS(
          SELECT 1
          FROM information_schema.columns
          WHERE table_schema = 'public'
            AND table_name   = 'products'
            AND column_name  = 'search_vec'
        ) AS ok;
      `);
      this.searchVecExists = Boolean(r?.[0]?.ok ?? r?.[0]?.ok === true);
    }
    return this.searchVecExists!;
  }

  private inlineSearchVec(alias = 'p'): string {
    return `
      setweight(to_tsvector('simple', public.unaccent_imm(coalesce(${alias}.product_name,''))), 'A')
      || setweight(
          to_tsvector('simple',
            public.unaccent_imm(regexp_replace(coalesce(${alias}.short_description,''), '<[^>]+>', ' ', 'g'))
          ), 'B'
        )
      || setweight(
          to_tsvector('simple',
            public.unaccent_imm(regexp_replace(coalesce(${alias}.long_description,''), '<[^>]+>', ' ', 'g'))
          ), 'C'
        )
    `;
  }

  /**
   * @param q          Từ khóa (nullable)
   * @param page       Trang
   * @param limit      Kích thước trang
   * @param categoryId Lọc theo danh mục (bao gồm cả danh mục con) khi không có q, hoặc kết hợp với q.
   */
  async searchProducts(
    q: string,
    page = 1,
    limit = 10,
    categoryId?: number | null,
  ) {
    const term = (q ?? '').trim();
    const offset = Math.max(0, (page - 1) * limit);
    if (!term && categoryId == null) {
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };
    }
    // ===== A) KHÔNG có q nhưng CÓ categoryId -> lọc theo cây danh mục (không FTS)
    if (!term && categoryId != null) {
      const items = await this.ds.query(
        `
        WITH RECURSIVE cat_tree AS (
          SELECT $1::int AS id
          UNION ALL
          SELECT c.category_id
          FROM public.categories c
          JOIN cat_tree t ON c.parent_category_id = t.id
        )
        SELECT
          p.product_id,
          p.product_name,
          (p.price)::double precision AS price,
          NULLIF(BTRIM(REGEXP_REPLACE(COALESCE(p.short_description,''), '<[^>]+>', ' ', 'g')), '') AS short_description,
          NULL::double precision AS rank,
          img.image_url
        FROM public.products p
        LEFT JOIN LATERAL (
          SELECT pi.image_url
          FROM public.product_images pi
          WHERE pi.product_id = p.product_id
          ORDER BY pi.is_primary DESC, pi.image_id ASC
          LIMIT 1
        ) AS img ON TRUE
        WHERE p.category_id IN (SELECT id FROM cat_tree)
        ORDER BY p.product_id DESC
        LIMIT $2 OFFSET $3;
        `,
        [categoryId, limit, offset],
      );

      const totalRes = await this.ds.query(
        `
        WITH RECURSIVE cat_tree AS (
          SELECT $1::int AS id
          UNION ALL
          SELECT c.category_id
          FROM public.categories c
          JOIN cat_tree t ON c.parent_category_id = t.id
        )
        SELECT COUNT(*)::int AS count
        FROM public.products p
        WHERE p.category_id IN (SELECT id FROM cat_tree);
        `,
        [categoryId],
      );

      const total: number = totalRes?.[0]?.count ?? 0;
      for (const it of items) {
        if (it.price != null) it.price = Number(it.price);
      }
      return {
        items,
        pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
      };
    }

    // ===== B) KHÔNG có q & KHÔNG có categoryId -> giữ nguyên hành vi cũ (trả rỗng)
    if (!term && categoryId == null) {
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };
    }

    // ===== C/D) CÓ q (có thể kèm/không kèm categoryId) -> FTS
    const hasCol = await this.ensureSearchVecExists();
    const sv = hasCol ? 'p.search_vec' : this.inlineSearchVec('p');

    // WITH cho ITEMS: nếu có categoryId thì cần cat_tree với $4::int
    const withItems = categoryId != null
      ? `
        WITH RECURSIVE
          cat_tree AS (
            SELECT $4::int AS id
            UNION ALL
            SELECT c.category_id
            FROM public.categories c
            JOIN cat_tree t ON c.parent_category_id = t.id
          ),
          q AS (
            SELECT
              public.unaccent_imm($1)                                 AS uq,
              websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
          )
      `
      : `
        WITH q AS (
          SELECT
            public.unaccent_imm($1)                                 AS uq,
            websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
        )
      `;

    const whereCat = categoryId != null ? `AND p.category_id IN (SELECT id FROM cat_tree)` : ``;
    const itemsParams = categoryId != null ? [term, limit, offset, categoryId] : [term, limit, offset];

    const items = await this.ds.query(
      `
      ${withItems}
      SELECT
        p.product_id,
        p.product_name,
        (p.price)::double precision AS price,
        NULLIF(BTRIM(REGEXP_REPLACE(COALESCE(p.short_description,''), '<[^>]+>', ' ', 'g')), '') AS short_description,
        ts_rank_cd(${sv}, q.tsq, 32) AS rank,
        img.image_url
      FROM public.products p
      CROSS JOIN q
      LEFT JOIN LATERAL (
        SELECT pi.image_url
        FROM public.product_images pi
        WHERE pi.product_id = p.product_id
        ORDER BY pi.is_primary DESC, pi.image_id ASC
        LIMIT 1
      ) AS img ON TRUE
      WHERE
        (
          (${sv} @@ q.tsq)
          OR public.unaccent_imm(p.product_name) ILIKE ('%' || q.uq || '%')
        )
        ${whereCat}
      ORDER BY rank DESC NULLS LAST, p.product_id
      LIMIT $2 OFFSET $3;
      `,
      itemsParams,
    );

    // WITH cho TOTAL: nếu có categoryId thì cat_tree phải dùng $2::int (vì totalParams = [term, categoryId])
    const withTotal = categoryId != null
      ? `
        WITH RECURSIVE
          cat_tree AS (
            SELECT $2::int AS id
            UNION ALL
            SELECT c.category_id
            FROM public.categories c
            JOIN cat_tree t ON c.parent_category_id = t.id
          ),
          q AS (
            SELECT
              public.unaccent_imm($1)                                 AS uq,
              websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
          )
      `
      : `
        WITH q AS (
          SELECT
            public.unaccent_imm($1)                                 AS uq,
            websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
        )
      `;

    const totalParams = categoryId != null ? [term, categoryId] : [term];

    const totalRes = await this.ds.query(
      `
      ${withTotal}
      SELECT COUNT(*)::int AS count
      FROM public.products p, q
      WHERE
        (
          (${sv} @@ q.tsq)
          OR public.unaccent_imm(p.product_name) ILIKE ('%' || q.uq || '%')
        )
        ${whereCat};
      `,
      totalParams,
    );

    const total: number = totalRes?.[0]?.count ?? 0;

    for (const it of items) {
      if (it.rank != null) it.rank = Number(it.rank);
      if (it.price != null) it.price = Number(it.price);
    }

    return {
      items,
      pagination: { page, limit, total, pages: Math.max(1, Math.ceil(total / limit)) },
    };
  }
}
