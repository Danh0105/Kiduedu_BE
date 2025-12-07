// src/search/search.service.ts
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class SearchService {
  constructor(private readonly ds: DataSource) { }

  private searchVecExists?: boolean;

  // ------------------------------
  // Check cột search_vec có tồn tại không (cache 1 lần)
  // ------------------------------
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

      this.searchVecExists = Boolean(r?.[0]?.ok);
    }
    return this.searchVecExists!;
  }

  // ------------------------------
  // Inline search vector khi không có search_vec column
  // ------------------------------
  private inlineSearchVec(alias = 'p'): string {
    return `
      setweight(to_tsvector('simple', public.unaccent_imm(coalesce(${alias}.product_name,''))), 'A') ||
      setweight(
        to_tsvector('simple',
          public.unaccent_imm(regexp_replace(coalesce(${alias}.short_description,''), '<[^>]+>', ' ', 'g'))
        ), 'B'
      ) ||
      setweight(
        to_tsvector('simple',
          public.unaccent_imm(regexp_replace(coalesce(${alias}.long_description,''), '<[^>]+>', ' ', 'g'))
        ), 'C'
      )
    `;
  }

  // ------------------------------
  // Query chung: SELECT product fields
  // ------------------------------
  private baseProductSelect(): string {
    return `
    p.product_id AS "productId",
    p.product_name AS "productName",


      (
        SELECT pvpr.price
        FROM public.product_variant_prices pvpr
        JOIN public.product_variants pv ON pv.variant_id = pvpr.variant_id
        WHERE pv.product_id = p.product_id
          AND pvpr.start_at <= NOW()
          AND (pvpr.end_at IS NULL OR pvpr.end_at >= NOW())
        ORDER BY
          CASE
            WHEN pvpr.price_type = 'promo' THEN 0
            WHEN pvpr.price_type = 'base'  THEN 1
            ELSE 2
          END,
          pvpr.start_at DESC
        LIMIT 1
      ) AS price,

      NULLIF(
        BTRIM(REGEXP_REPLACE(COALESCE(p.short_description, ''), '<[^>]+>', ' ', 'g')),
      '') AS "shortDescription",

      img.image_url AS "imageUrl"
    `;
  }

  // ------------------------------
  // Query lấy ảnh đại diện sản phẩm
  // ------------------------------
  private baseImageJoin(): string {
    return `
      LEFT JOIN LATERAL (
    SELECT 
        pi.image_url,
        pi.is_primary
        FROM public.product_images pi
        WHERE pi.product_id = p.product_id
        ORDER BY pi.is_primary DESC, pi.image_id ASC
        LIMIT 1
    ) AS img ON TRUE

    `;
  }

  // ------------------------------
  // Query xây cây danh mục
  // ------------------------------
  private categoryTree(): string {
    return `
      WITH RECURSIVE cat_tree AS (
        SELECT $1::int AS id
        UNION ALL
        SELECT c.category_id
        FROM public.categories c
        JOIN cat_tree t ON c.parent_category_id = t.id
      )
    `;
  }

  // ============================================================================
  //  PUBLIC METHOD: SEARCH / FILTER PRODUCTS
  // ============================================================================
  async searchProducts(q: string, page = 1, limit = 10, categoryId?: number | null) {
    const term = (q ?? '').trim();
    const offset = Math.max(0, (page - 1) * limit);

    // ------------------------------------------------------------
    // 1. Không có từ khóa + không có category → trả rỗng
    // ------------------------------------------------------------
    if (!term && categoryId == null) {
      return { items: [], pagination: { page, limit, total: 0, pages: 0 } };
    }

    // ------------------------------------------------------------
    // 2. Chỉ lọc category → không search
    // ------------------------------------------------------------
    if (!term && categoryId != null) {
      const sql = `
        ${this.categoryTree()}
        SELECT
          ${this.baseProductSelect()}
        FROM public.products p
        ${this.baseImageJoin()}
        WHERE p.category_id IN (SELECT id FROM cat_tree)
        ORDER BY p.product_id DESC
        LIMIT $2 OFFSET $3;
      `;

      const items = await this.ds.query(sql, [categoryId, limit, offset]);

      const totalRes = await this.ds.query(
        `
        ${this.categoryTree()}
        SELECT COUNT(*)::int AS count
        FROM public.products p
        WHERE p.category_id IN (SELECT id FROM cat_tree);
        `,
        [categoryId]
      );

      const total: number = totalRes?.[0]?.count ?? 0;
      return { items, pagination: { page, limit, total, pages: Math.ceil(total / limit) } };
    }

    // ------------------------------------------------------------
    // 3. Search full-text
    // ------------------------------------------------------------
    const hasCol = await this.ensureSearchVecExists();
    const sv = hasCol ? 'p.search_vec' : this.inlineSearchVec('p');

    const withCatTree = categoryId != null
      ? `
        WITH RECURSIVE cat_tree AS (
          SELECT $4::int AS id
          UNION ALL
          SELECT c.category_id
          FROM public.categories c
          JOIN cat_tree t ON c.parent_category_id = t.id
        ), q AS (
          SELECT public.unaccent_imm($1) AS uq,
                 websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
        )
      `
      : `
        WITH q AS (
          SELECT public.unaccent_imm($1) AS uq,
                 websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
        )
      `;

    const whereCat = categoryId != null ? `AND p.category_id IN (SELECT id FROM cat_tree)` : ``;
    const params = categoryId != null ? [term, limit, offset, categoryId] : [term, limit, offset];

    const items = await this.ds.query(
      `
      ${withCatTree}
      SELECT
        ${this.baseProductSelect()},
        ts_rank_cd(${sv}, q.tsq, 32) AS rank
      FROM public.products p
      CROSS JOIN q
      ${this.baseImageJoin()}
      WHERE
        (${sv} @@ q.tsq OR public.unaccent_imm(p.product_name) ILIKE ('%' || q.uq || '%'))
        ${whereCat}
      ORDER BY rank DESC NULLS LAST, p.product_id
      LIMIT $2 OFFSET $3;
      `,
      params
    );

    const totalRes = await this.ds.query(
      `
      WITH q AS (
        SELECT public.unaccent_imm($1) AS uq,
               websearch_to_tsquery('simple', public.unaccent_imm($1)) AS tsq
      )
      SELECT COUNT(*)::int AS count
      FROM public.products p, q
      WHERE
        (${sv} @@ q.tsq OR public.unaccent_imm(p.product_name) ILIKE ('%' || q.uq || '%'))
        ${whereCat};
      `,
      categoryId != null ? [term, categoryId] : [term]
    );

    const total: number = totalRes?.[0]?.count ?? 0;

    return { items, pagination: { page, limit, total, pages: Math.ceil(total / limit) } };
  }
}
