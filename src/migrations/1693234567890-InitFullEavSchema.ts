import { MigrationInterface, QueryRunner } from 'typeorm';

export class InitFullEavSchema1693234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // ---- FTS: chuẩn bị extensions + wrapper IMMUTABLE ----
    await queryRunner.query(`
      CREATE EXTENSION IF NOT EXISTS unaccent;
      CREATE EXTENSION IF NOT EXISTS pg_trgm;

      -- Wrapper IMMUTABLE cho unaccent (chốt dictionary theo schema public)
      CREATE OR REPLACE FUNCTION public.unaccent_imm(text)
      RETURNS text
      LANGUAGE sql
      IMMUTABLE
      PARALLEL SAFE
      AS $$
        SELECT unaccent('public.unaccent'::regdictionary, $1)
      $$;
    `);

    // ---- FTS: cột tsvector + trigger cập nhật ----
    await queryRunner.query(`
      ALTER TABLE public.products
      ADD COLUMN IF NOT EXISTS search_vec tsvector;

      CREATE OR REPLACE FUNCTION public.products_search_vec_update()
      RETURNS trigger
      LANGUAGE plpgsql
      AS $$
      BEGIN
        NEW.search_vec :=
          setweight(to_tsvector('simple', public.unaccent_imm(coalesce(NEW.product_name,''))), 'A')
          ||
          setweight(
            to_tsvector('simple',
              public.unaccent_imm(regexp_replace(coalesce(NEW.short_description,''), '<[^>]+>', ' ', 'g'))
            ),
            'B'
          )
          ||
          setweight(
            to_tsvector('simple',
              public.unaccent_imm(regexp_replace(coalesce(NEW.long_description,''), '<[^>]+>', ' ', 'g'))
            ),
            'C'
          );
        RETURN NEW;
      END
      $$;

      DROP TRIGGER IF EXISTS trg_products_search_vec_update ON public.products;
      CREATE TRIGGER trg_products_search_vec_update
      BEFORE INSERT OR UPDATE ON public.products
      FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();
    `);

    // ---- FTS: backfill dữ liệu hiện có để fill search_vec ----
    await queryRunner.query(`UPDATE public.products SET product_id = product_id;`);

    // ---- FTS: indexes (GIN FTS + GIN trigram trên tên không dấu) ----
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS idx_products_search_vec
        ON public.products USING GIN (search_vec);

      -- functional index + operator class cần 2 lớp ngoặc ((expr) gin_trgm_ops)
      DROP INDEX IF EXISTS idx_products_name_trgm;
      CREATE INDEX idx_products_name_trgm
        ON public.products USING GIN ((public.unaccent_imm(product_name)) gin_trgm_ops);
    `);

    // ===================== SEED DỮ LIỆU (giữ nguyên của bạn) =====================
    // addresses
    await queryRunner.query(`
      INSERT INTO public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId")
      VALUES (22, 'Nguyen Xuan Danh', '0326968216', '256/10', 'Xã Khánh An', 'Huyện An Phú', 'Tỉnh An Giang', true, 84)
      ON CONFLICT DO NOTHING;
    `);

    // carts
    await queryRunner.query(`
      INSERT INTO public.carts (cart_id, created_at, user_id) VALUES
      (1,  '2025-09-18 10:00:46.065957', 10),
      (2,  '2025-09-19 03:09:05.140572', 9),
      (20, '2025-09-26 03:35:27.89795', 84)
      ON CONFLICT DO NOTHING;
    `);

    // categories
    await queryRunner.query(`
      INSERT INTO public.categories (category_id, category_name, description, parent_category_id) VALUES
      (1, 'Robotic', NULL, NULL),
      (2, 'ORC', NULL, 1),
      (4, 'Robot Rover', NULL, 1),
      (5, 'Sa bàn Robocon', NULL, NULL),
      (6, 'Rover', NULL, 5),
      (7, 'Rio', NULL, 5)
      ON CONFLICT DO NOTHING;
    `);

    // migrations (domain table)
    await queryRunner.query(`
      INSERT INTO public.migrations (id, "timestamp", name)
      VALUES (1, 1693234567890, 'InitFullEavSchema1693234567890')
      ON CONFLICT DO NOTHING;
    `);

    // orders
    await queryRunner.query(`
      INSERT INTO public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) VALUES
      (5,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:35:27.89795', 84, NULL),
      (6,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:35:56.613784', 9, NULL),
      (7,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:01.851011', 9, NULL),
      (8,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:02.84628', 9, NULL),
      (9,  432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.011192', 9, NULL),
      (10, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.16815', 9, NULL),
      (11, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.318233', 9, NULL),
      (12, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.47517', 9, NULL),
      (13, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.642199', 9, NULL),
      (14, 432000.00, 0.00, 470000.00, 'Pending', '2025-09-26 03:36:03.767173', 9, NULL),
      (15, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:20:02.179685', 9, NULL),
      (16, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:32:47.915818', 9, NULL),
      (17, 547000.00, 0.00, 585000.00, 'Pending', '2025-09-26 07:48:13.497137', 9, NULL),
      (18, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:48:56.617404', 9, NULL),
      (19, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 07:50:41.09864', 9, NULL),
      (20, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 08:15:45.068795', 9, NULL),
      (21, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-26 08:16:41.040723', 9, NULL),
      (22, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 00:43:05.600714', 9, NULL),
      (23, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:11:27.69483', 9, NULL),
      (24, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:14:42.470122', 9, NULL),
      (25, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:15:00.40493', 9, NULL),
      (26, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:17:22.966989', 9, NULL),
      (27, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:20:16.19578', 9, NULL),
      (28, 979000.00, 0.00, 1017000.00, 'Pending', '2025-09-27 01:21:03.273355', 9, NULL),
      (29, 1357000.00, 0.00, 1395000.00, 'Pending', '2025-09-27 04:22:30.631856', 9, NULL)
      ON CONFLICT DO NOTHING;
    `);

    // order_items
    await queryRunner.query(`
      INSERT INTO public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) VALUES
      (9,1,108000.00,5,8),(10,1,108000.00,5,6),(11,1,108000.00,5,9),(12,1,108000.00,5,7),
      (13,1,108000.00,6,8),(14,1,108000.00,6,6),(15,1,108000.00,6,9),(16,1,108000.00,6,7),
      (17,1,108000.00,7,8),(18,1,108000.00,7,6),(19,1,108000.00,7,9),(20,1,108000.00,7,7),
      (21,1,108000.00,8,8),(22,1,108000.00,8,6),(23,1,108000.00,8,9),(24,1,108000.00,8,7),
      (25,1,108000.00,9,8),(26,1,108000.00,9,6),(27,1,108000.00,9,9),(28,1,108000.00,9,7),
      (29,1,108000.00,10,8),(30,1,108000.00,10,6),(31,1,108000.00,10,9),(32,1,108000.00,10,7),
      (33,1,108000.00,11,8),(34,1,108000.00,11,6),(35,1,108000.00,11,9),(36,1,108000.00,11,7),
      (37,1,108000.00,12,8),(38,1,108000.00,12,6),(39,1,108000.00,12,9),(40,1,108000.00,12,7),
      (41,1,108000.00,13,8),(42,1,108000.00,13,6),(43,1,108000.00,13,9),(44,1,108000.00,13,7),
      (45,1,108000.00,14,8),(46,1,108000.00,14,6),(47,1,108000.00,14,9),(48,1,108000.00,14,7),
      (49,1,108000.00,15,8),(50,1,439000.00,15,6),(51,1,54000.00,15,9),(52,1,378000.00,15,7),
      (53,1,108000.00,16,8),(54,1,439000.00,16,6),(55,1,54000.00,16,9),(56,1,378000.00,16,7),
      (57,1,108000.00,17,8),(58,1,439000.00,17,6),(59,1,108000.00,18,8),(60,1,439000.00,18,6),
      (61,1,54000.00,18,9),(62,1,378000.00,18,7),(63,1,108000.00,19,8),(64,1,439000.00,19,6),
      (65,1,54000.00,19,9),(66,1,378000.00,19,7),(67,1,108000.00,20,8),(68,1,439000.00,20,6),
      (69,1,54000.00,20,9),(70,1,378000.00,20,7),(71,1,108000.00,21,8),(72,1,439000.00,21,6),
      (73,1,54000.00,21,9),(74,1,378000.00,21,7),(75,1,108000.00,22,8),(76,1,439000.00,22,6),
      (77,1,54000.00,22,9),(78,1,378000.00,22,7),(79,1,108000.00,23,8),(80,1,439000.00,23,6),
      (81,1,54000.00,23,9),(82,1,378000.00,23,7),(83,1,108000.00,24,8),(84,1,439000.00,24,6),
      (85,1,54000.00,24,9),(86,1,378000.00,24,7),(87,1,108000.00,25,8),(88,1,439000.00,25,6),
      (89,1,54000.00,25,9),(90,1,378000.00,25,7),(91,1,108000.00,26,8),(92,1,439000.00,26,6),
      (93,1,54000.00,26,9),(94,1,378000.00,26,7),(95,1,108000.00,27,8),(96,1,439000.00,27,6),
      (97,1,54000.00,27,9),(98,1,378000.00,27,7),(99,1,108000.00,28,8),(100,1,439000.00,28,6),
      (101,1,54000.00,28,9),(102,1,378000.00,28,7),(103,1,108000.00,29,8),(104,1,439000.00,29,6),
      (105,1,54000.00,29,9),(106,2,378000.00,29,7)
      ON CONFLICT DO NOTHING;
    `);

    // product_images
    await queryRunner.query(`
      INSERT INTO public.product_images (image_id, image_url, alt_text, is_primary, product_id) VALUES
      (1,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995711/dudhjbk1sq1orgm8cynh.png',NULL,false,1),
      (2,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995718/iuhp40d6sfwqxz3cfhxk.png',NULL,false,1),
      (3,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1757995731/stfp3cgubrgaxcv9dehk.png',NULL,false,1),
      (4,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072957/xmrjjkcqhxlefbpbeavy.png',NULL,false,2),
      (5,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072958/dsfdo84ydb6cmiwn7ekp.png',NULL,false,2),
      (6,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072959/bc2vgpw76cdeetcn5l5f.png',NULL,false,2),
      (7,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758072959/fvygdmuttnvfxtcriyai.png',NULL,false,2),
      (12,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073151/ghjmmbyczggkinptlxhq.png',NULL,false,4),
      (13,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073152/hmoxd2inu6jzmuq2gemy.png',NULL,false,4),
      (14,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073153/kdumhybjm6ojzcnst7zw.png',NULL,false,4),
      (15,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073154/epvhr6tn8c2m3igodqfs.png',NULL,false,4),
      (20,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073253/v2sfcnjtmhczk2kfnka0.jpg',NULL,false,6),
      (21,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073254/hnwjzkrco664cvlwpfeb.jpg',NULL,false,6),
      (22,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073352/hquatfltex1ynxnbmh1j.png',NULL,false,7),
      (23,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073355/ccnfft1haut5pqkhhesi.png',NULL,false,7),
      (24,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073355/zacwprfyy1g6usta7j17.png',NULL,false,7),
      (25,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073358/wvgsezjnzwurjqcvomp1.png',NULL,false,7),
      (26,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073798/qp78nkgbruv2tog5qgrd.jpg',NULL,false,8),
      (27,'https://res.cloudinary.com/dlnkeb4dm/image/upload/v1758073863/nigmqi5qyctqe1wj2pb7.jpg',NULL,false,9)
      ON CONFLICT DO NOTHING;
    `);

    // products
    await queryRunner.query(`
      INSERT INTO public.products
      (product_id, product_name, sku, long_description, short_description, status, price, stock_quantity, created_at, updated_at, category_id)
      VALUES
      -- (giữ nguyên các rows bạn đã dán ở trên) --
      (1, 'Module GPS+BDS ATGM336H (kèm dây, anten giao tiếp UART và hộp)', 'SKU-1757995730604', $$...$$, $$...$$, 1, 2000000.00, 1, '2025-09-16 04:08:52.529988', '2025-09-16 04:08:52.529988', 2),
      (2, 'Robot giáo dục STEM Rover V2', 'SKU-1758072957128', $$...$$, $$...$$, 123, 2000000.00, 1, '2025-09-17 01:36:00.347634', '2025-09-17 01:36:00.347634', 4),
      (4, 'Phụ kiện Rover – Kit xe tăng', 'SKU-1758073151552', $$...$$, $$...$$, 123, 439000.00, 1, '2025-09-17 01:39:14.771563', '2025-09-17 01:39:14.771563', 4),
      (6, 'Tay gắp Robot Gripper – Rover', 'SKU-1758073252274', $$...$$, $$...$$, 123, 439000.00, 1, '2025-09-17 01:40:55.486836', '2025-09-17 01:40:55.486836', 4),
      (7, 'Đầu nâng Robot Rover', 'SKU-1758073355687', $$...$$, $$...$$, 123, 378000.00, 1, '2025-09-17 01:42:38.908384', '2025-09-17 01:42:38.908384', 4),
      (8, 'Sa bàn giảng dạy Robotics khổ A0 in hiflex', 'SKU-1758073796293', $$...$$, $$...$$, 4, 108000.00, 1, '2025-09-17 01:49:59.515704', '2025-09-17 01:49:59.515704', 6),
      (9, 'Sa bàn giảng dạy khổ A0', 'SKU-1758073860534', $$...$$, $$...$$, 4, 54000.00, 1, '2025-09-17 01:51:03.760706', '2025-09-17 01:51:03.760706', 7)
      ON CONFLICT DO NOTHING;
    `);

    // user_profile_individual
    await queryRunner.query(`
      INSERT INTO public.user_profile_individual (user_id, full_name, date_of_birth)
      VALUES (84, 'Nguyen Xuan Danh', '2025-09-05')
      ON CONFLICT DO NOTHING;
    `);

    // users
    await queryRunner.query(`
      INSERT INTO public.users (user_id, username, email, password_hash, full_name, role, created_at, customer_type, avatar_url, images_url, address, phone_number) VALUES
      (9,  'Nguyễn Xuân Danh', 'danh010500@gmail.com', '$2b$10$C96tVNrwpgdR0wvF71zhZOD/KO1SWZRD7BfWBDaE7VLg.GW/nlA/S', NULL, 'customer', '2025-09-18 07:20:15.494312', NULL, NULL, NULL, NULL, NULL),
      (10, 'Danh', 'danh@gmail.com', '$2b$10$TUK83pDiJczyuxwBH0ndQew16edIC8OsxudIrBFBMKHy04TJQTpOm', NULL, 'customer', '2025-09-18 10:00:46.05424', NULL, NULL, NULL, NULL, NULL),
      (84, 'danh0105001', 'danh0105010@gmail.com', NULL, NULL, 'customer', '2025-09-26 03:35:27.89795', 'individual', NULL, NULL, NULL, NULL)
      ON CONFLICT DO NOTHING;
    `);

    // sequences
    await queryRunner.query(`SELECT setval('public.addresses_address_id_seq', 22, true);`);
    await queryRunner.query(`SELECT setval('public.attributes_attribute_id_seq', 1, false);`);
    await queryRunner.query(`SELECT setval('public.banners_banner_id_seq', 1, false);`);
    await queryRunner.query(`SELECT setval('public.cart_items_cart_item_id_seq', 23, true);`);
    await queryRunner.query(`SELECT setval('public.carts_cart_id_seq', 20, true);`);
    await queryRunner.query(`SELECT setval('public.categories_category_id_seq', 7, true);`);
    await queryRunner.query(`SELECT setval('public.migrations_id_seq', 1, true);`);
    await queryRunner.query(`SELECT setval('public.order_items_order_item_id_seq', 106, true);`);
    await queryRunner.query(`SELECT setval('public.orders_order_id_seq', 29, true);`);
    await queryRunner.query(
      `SELECT setval('public.product_attribute_values_value_id_seq', 1, false);`,
    );
    await queryRunner.query(`SELECT setval('public.product_images_image_id_seq', 27, true);`);
    await queryRunner.query(`SELECT setval('public.products_product_id_seq', 9, true);`);
    await queryRunner.query(
      `SELECT setval('public.promotion_applicability_applicability_id_seq', 1, false);`,
    );
    await queryRunner.query(`SELECT setval('public.promotions_promotion_id_seq', 1, false);`);
    await queryRunner.query(`SELECT setval('public.users_user_id_seq', 85, true);`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Revert seed (giữ nguyên logic xóa theo id của bạn)
    await queryRunner.query(
      `DELETE FROM public.order_items WHERE order_item_id BETWEEN 9 AND 106;`,
    );
    await queryRunner.query(`DELETE FROM public.orders WHERE order_id BETWEEN 5 AND 29;`);
    await queryRunner.query(
      `DELETE FROM public.product_images WHERE image_id IN (1,2,3,4,5,6,7,12,13,14,15,20,21,22,23,24,25,26,27);`,
    );
    await queryRunner.query(`DELETE FROM public.products WHERE product_id IN (1,2,4,6,7,8,9);`);
    await queryRunner.query(`DELETE FROM public.addresses WHERE address_id = 22;`);
    await queryRunner.query(`DELETE FROM public.carts WHERE cart_id IN (1,2,20);`);
    await queryRunner.query(`DELETE FROM public.categories WHERE category_id IN (1,2,4,5,6,7);`);
    await queryRunner.query(`DELETE FROM public.migrations WHERE id = 1;`);
    await queryRunner.query(`DELETE FROM public.user_profile_individual WHERE user_id = 84;`);
    await queryRunner.query(`DELETE FROM public.users WHERE user_id IN (9,10,84);`);

    // FTS: gỡ index/trigger/function/cột (không drop extensions)
    await queryRunner.query(`DROP INDEX IF EXISTS idx_products_name_trgm;`);
    await queryRunner.query(`DROP INDEX IF EXISTS idx_products_search_vec;`);
    await queryRunner.query(
      `DROP TRIGGER IF EXISTS trg_products_search_vec_update ON public.products;`,
    );
    await queryRunner.query(`DROP FUNCTION IF EXISTS public.products_search_vec_update();`);
    await queryRunner.query(`ALTER TABLE public.products DROP COLUMN IF EXISTS search_vec;`);
    await queryRunner.query(`DROP FUNCTION IF EXISTS public.unaccent_imm(text);`);
  }
}
