import { MigrationInterface, QueryRunner } from "typeorm";

export class InitFullEavSchema1693234567890 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            -- =====================================================================
            -- SCHEMA HOÀN CHỈNH: MÔ HÌNH EAV + CARTS + ORDERS + PROMOTIONS
            -- =====================================================================

            -- ============================================================
            -- ENUMS
            -- ============================================================
            DO $$ BEGIN
                CREATE TYPE discount_type_enum AS ENUM('percentage', 'fixed_amount');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;

            DO $$ BEGIN
                CREATE TYPE banner_position_enum AS ENUM('homepage_slider', 'category_top', 'sidebar');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;

            -- ============================================================
            -- USERS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "users"(
                "user_id" SERIAL PRIMARY KEY,
                "username" VARCHAR(50) UNIQUE NOT NULL,
                "email" VARCHAR(100) UNIQUE NOT NULL,
                "password_hash" VARCHAR(255) NOT NULL,
                "full_name" VARCHAR(100),
                "phone_number" VARCHAR(20),
                "role" VARCHAR(20) NOT NULL DEFAULT 'customer',
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );

            -- ============================================================
            -- CATEGORIES
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "categories"(
                "category_id" SERIAL PRIMARY KEY,
                "category_name" VARCHAR(100) NOT NULL,
                "parent_category_id" INT REFERENCES "categories"("category_id") ON DELETE SET NULL,
                "description" TEXT
            );

            -- ============================================================
            -- PRODUCTS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "products"(
                "product_id" SERIAL PRIMARY KEY,
                "product_name" VARCHAR(255) NOT NULL,
                "sku" VARCHAR(50) UNIQUE NOT NULL,
                "long_description" TEXT,
                "short_description" TEXT,
                "price" DECIMAL(12, 2) NOT NULL CHECK(price >= 0),
                 "status" INTEGER NOT NULL DEFAULT 1 CHECK(status IN (0, 1, 2)), 
                "stock_quantity" INT NOT NULL DEFAULT 0 CHECK(stock_quantity >= 0),
                "category_id" INT NOT NULL REFERENCES "categories"("category_id") ON DELETE RESTRICT,
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                "updated_at" TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );

            -- ============================================================
            -- ATTRIBUTES & EAV
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "attributes"(
                "attribute_id" SERIAL PRIMARY KEY,
                "attribute_name" VARCHAR(100) UNIQUE NOT NULL,
                "value_type" VARCHAR(20) NOT NULL CHECK(value_type IN('string', 'number', 'boolean', 'date')),
                display_name VARCHAR(100),
                attribute_group VARCHAR(50),
                is_filterable BOOLEAN NOT NULL DEFAULT FALSE
            );

            CREATE TABLE IF NOT EXISTS "category_attributes"(
                "category_id" INT NOT NULL REFERENCES "categories"("category_id") ON DELETE CASCADE,
                "attribute_id" INT NOT NULL REFERENCES "attributes"("attribute_id") ON DELETE CASCADE,
                PRIMARY KEY("category_id", "attribute_id")
            );

            CREATE TABLE IF NOT EXISTS "product_attribute_values"(
                "value_id" SERIAL PRIMARY KEY,
                "product_id" INT NOT NULL REFERENCES "products"("product_id") ON DELETE CASCADE,
                "attribute_id" INT NOT NULL REFERENCES "attributes"("attribute_id") ON DELETE CASCADE,
                "value_text" TEXT,
                "value_number" DECIMAL(18, 4),
                "value_boolean" BOOLEAN,
                "value_date" DATE
            );

            -- ============================================================
            -- PRODUCT IMAGES
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "product_images"(
                "image_id" SERIAL PRIMARY KEY,
                "product_id" INT NOT NULL REFERENCES "products"("product_id") ON DELETE CASCADE,
                "image_url" VARCHAR(255) NOT NULL,
                "alt_text" VARCHAR(255),
                "is_primary" BOOLEAN NOT NULL DEFAULT FALSE
            );

            -- ============================================================
            -- CARTS & CART ITEMS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "carts"(
                "cart_id" SERIAL PRIMARY KEY,
                "user_id" INT NOT NULL UNIQUE REFERENCES "users"("user_id") ON DELETE CASCADE,
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );

           CREATE TABLE IF NOT EXISTS "cart_items"(
                "cart_item_id" SERIAL PRIMARY KEY,
                "cart_id" INT NOT NULL REFERENCES "carts"("cart_id") ON DELETE CASCADE,
                "product_id" INT NOT NULL REFERENCES "products"("product_id") ON DELETE CASCADE,
                "quantity" INT NOT NULL CHECK(quantity > 0),
                CONSTRAINT "unique_cart_product" UNIQUE ("cart_id", "product_id")
            );


            -- ============================================================
            -- PROMOTIONS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "promotions"(
                "promotion_id" SERIAL PRIMARY KEY,
                "name" VARCHAR(100) NOT NULL,
                "description" TEXT,
                "discount_type" discount_type_enum NOT NULL,
                "discount_value" DECIMAL(10, 2) NOT NULL CHECK(discount_value > 0),
                "start_date" TIMESTAMPTZ NOT NULL,
                "end_date" TIMESTAMPTZ NOT NULL,
                "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
                CONSTRAINT "end_date_after_start_date" CHECK("end_date" > "start_date")
            );

            CREATE TABLE IF NOT EXISTS "promotion_applicability"(
                "applicability_id" SERIAL PRIMARY KEY,
                "promotion_id" INT NOT NULL REFERENCES "promotions"("promotion_id") ON DELETE CASCADE,
                "product_id" INT REFERENCES "products"("product_id") ON DELETE CASCADE,
                "category_id" INT REFERENCES "categories"("category_id") ON DELETE CASCADE,
                CONSTRAINT "only_one_target" CHECK((product_id IS NOT NULL AND category_id IS NULL) OR (product_id IS NULL AND category_id IS NOT NULL))
            );

            -- ============================================================
            -- ORDERS & ORDER ITEMS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "orders"(
                "order_id" SERIAL PRIMARY KEY,
                "user_id" INT NOT NULL REFERENCES "users"("user_id") ON DELETE RESTRICT,
                "order_date" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                "status" VARCHAR(50) NOT NULL DEFAULT 'Pending',
                "shipping_address" TEXT NOT NULL,
                "subtotal" DECIMAL(15, 2) NOT NULL,
                "discount_amount" DECIMAL(15, 2) DEFAULT 0,
                "total_amount" DECIMAL(15, 2) NOT NULL,
                "promotion_id" INT REFERENCES "promotions"("promotion_id") ON DELETE SET NULL
            );

            CREATE TABLE IF NOT EXISTS "order_items"(
                "order_item_id" SERIAL PRIMARY KEY,
                "order_id" INT NOT NULL REFERENCES "orders"("order_id") ON DELETE CASCADE,
                "product_id" INT NOT NULL REFERENCES "products"("product_id") ON DELETE RESTRICT,
                "quantity" INT NOT NULL CHECK(quantity > 0),
                "price_per_unit" DECIMAL(12, 2) NOT NULL
            );

            -- ============================================================
            -- BANNERS
            -- ============================================================
            CREATE TABLE IF NOT EXISTS "banners"(
                "banner_id" SERIAL PRIMARY KEY,
                "title" VARCHAR(100) NOT NULL,
                "image_url" VARCHAR(255) NOT NULL,
                "link_url" VARCHAR(255),
                "position" banner_position_enum NOT NULL,
                "display_order" INT DEFAULT 0,
                "is_active" BOOLEAN NOT NULL DEFAULT TRUE
            );

            -- ============================================================
            -- FUNCTIONS & TRIGGERS
            -- ============================================================
            CREATE OR REPLACE FUNCTION trigger_set_timestamp()
            RETURNS TRIGGER AS $$
            BEGIN
                NEW.updated_at = NOW();
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER set_timestamp_on_products
            BEFORE UPDATE ON "products"
            FOR EACH ROW
            EXECUTE PROCEDURE trigger_set_timestamp();

            CREATE OR REPLACE FUNCTION enforce_value_type()
            RETURNS TRIGGER AS $$
            DECLARE
                v_type VARCHAR;
            BEGIN
                SELECT value_type INTO v_type FROM attributes WHERE attribute_id = NEW.attribute_id;

                IF v_type = 'string' AND (NEW.value_text IS NULL OR NEW.value_number IS NOT NULL OR NEW.value_boolean IS NOT NULL OR NEW.value_date IS NOT NULL) THEN
                    RAISE EXCEPTION 'Thuộc tính #% yêu cầu giá trị kiểu string.', NEW.attribute_id;
                ELSIF v_type = 'number' AND (NEW.value_number IS NULL OR NEW.value_text IS NOT NULL OR NEW.value_boolean IS NOT NULL OR NEW.value_date IS NOT NULL) THEN
                    RAISE EXCEPTION 'Thuộc tính #% yêu cầu giá trị kiểu number.', NEW.attribute_id;
                ELSIF v_type = 'boolean' AND (NEW.value_boolean IS NULL OR NEW.value_text IS NOT NULL OR NEW.value_number IS NOT NULL OR NEW.value_date IS NOT NULL) THEN
                    RAISE EXCEPTION 'Thuộc tính #% yêu cầu giá trị kiểu boolean.', NEW.attribute_id;
                ELSIF v_type = 'date' AND (NEW.value_date IS NULL OR NEW.value_text IS NOT NULL OR NEW.value_number IS NOT NULL OR NEW.value_boolean IS NOT NULL) THEN
                    RAISE EXCEPTION 'Thuộc tính #% yêu cầu giá trị kiểu date.', NEW.attribute_id;
                END IF;

                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;

            CREATE TRIGGER trg_check_value_type
            BEFORE INSERT OR UPDATE ON "product_attribute_values"
            FOR EACH ROW
            EXECUTE PROCEDURE enforce_value_type();

            -- ============================================================
            -- INDEXES
            -- ============================================================
            CREATE INDEX IF NOT EXISTS idx_products_category ON "products"("category_id");
            CREATE INDEX IF NOT EXISTS idx_product_images_product ON "product_images"("product_id");
            CREATE INDEX IF NOT EXISTS idx_product_attribute_values_product ON "product_attribute_values"("product_id");
            CREATE INDEX IF NOT EXISTS idx_product_attribute_values_attribute ON "product_attribute_values"("attribute_id");
            CREATE INDEX IF NOT EXISTS idx_product_attribute_values_combo ON "product_attribute_values"("product_id", "attribute_id");
            CREATE INDEX IF NOT EXISTS idx_carts_user ON "carts"("user_id");
            CREATE INDEX IF NOT EXISTS idx_cart_items_cart ON "cart_items"("cart_id");
            CREATE INDEX IF NOT EXISTS idx_cart_items_product ON "cart_items"("product_id");
            CREATE INDEX IF NOT EXISTS idx_orders_user ON "orders"("user_id");
            CREATE INDEX IF NOT EXISTS idx_order_items_product ON "order_items"("product_id");
            CREATE INDEX IF NOT EXISTS idx_order_items_order ON "order_items"("order_id");
            CREATE INDEX IF NOT EXISTS idx_promo_applicability_product ON "promotion_applicability"("product_id");
            CREATE INDEX IF NOT EXISTS idx_promo_applicability_category ON "promotion_applicability"("category_id");
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DROP TRIGGER IF EXISTS trg_check_value_type ON product_attribute_values;
            DROP TRIGGER IF EXISTS set_timestamp_on_products ON products;
            DROP FUNCTION IF EXISTS enforce_value_type();
            DROP FUNCTION IF EXISTS trigger_set_timestamp();

            DROP TABLE IF EXISTS "banners";
            DROP TABLE IF EXISTS "order_items";
            DROP TABLE IF EXISTS "orders";
            DROP TABLE IF EXISTS "promotion_applicability";
            DROP TABLE IF EXISTS "promotions";
            DROP TABLE IF EXISTS "cart_items";
            DROP TABLE IF EXISTS "carts";
            DROP TABLE IF EXISTS "product_images";
            DROP TABLE IF EXISTS "product_attribute_values";
            DROP TABLE IF EXISTS "category_attributes";
            DROP TABLE IF EXISTS "attributes";
            DROP TABLE IF EXISTS "products";
            DROP TABLE IF EXISTS "categories";
            DROP TABLE IF EXISTS "users";

            DROP TYPE IF EXISTS discount_type_enum;
            DROP TYPE IF EXISTS banner_position_enum;
        `);
    }
}
