--
-- PostgreSQL database cluster dump
--

-- Started on 2025-10-31 16:20:30

\restrict cdxUo5B9xoTaOggo1vQiagF3E6KbtahipBXwIOep2zfayYFUqw9XAecwq0SmfvI

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pgg_superadmins;
ALTER ROLE pgg_superadmins WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:J86v022GJvFG+LsoPZc/HA==$MJeY1Xs3DbsyqfdnmfcXwMCqO9c2O0nDLou87JAIwLI=:WPh/CRov5IYrH147fgElOlS18EI8VA6PMBJ0EC1vZzo=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:OFOcqKuviZTR0Dkkw9P4NA==$i2QUNI3b4KFTOr13pUTlTBhBBkxY2uBvDhAVr6lbvV4=:xRjNBvq6NOWbUVHsGiPXD4RsTed+WoJWpqpBAMmfTOs=';

--
-- User Configurations
--








\unrestrict cdxUo5B9xoTaOggo1vQiagF3E6KbtahipBXwIOep2zfayYFUqw9XAecwq0SmfvI

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict mAMWmY6xIkF7YoTJnJ6f0qmcOGRa6DBsQMryiLyb6VqB6BfAkYtPxKFZ4oVWwnk

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-31 16:20:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-10-31 16:20:37

--
-- PostgreSQL database dump complete
--

\unrestrict mAMWmY6xIkF7YoTJnJ6f0qmcOGRa6DBsQMryiLyb6VqB6BfAkYtPxKFZ4oVWwnk

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict cCve54V7I3mFwSsPbZl688EAYjcNgEp1H4Q99VDQ5pwTkK8fESsr7qljQ2VeKkc

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-31 16:20:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 3079 OID 16489)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 3 (class 3079 OID 16396)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 4 (class 3079 OID 16477)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1141 (class 1247 OID 17140)
-- Name: promotions_discount_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promotions_discount_type_enum AS ENUM (
    'percentage',
    'fixed_amount'
);


ALTER TYPE public.promotions_discount_type_enum OWNER TO postgres;

--
-- TOC entry 1144 (class 1247 OID 17146)
-- Name: users_customer_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_customer_type_enum AS ENUM (
    'individual',
    'business'
);


ALTER TYPE public.users_customer_type_enum OWNER TO postgres;

--
-- TOC entry 416 (class 1255 OID 17151)
-- Name: products_search_vec_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vec_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.search_vec :=
      setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.product_name,''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.sku,''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.short_description,''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.long_description,''))), 'C')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.specs::text,''))), 'C')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.origin,''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.user_manual,''))), 'D')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.caution_notes,''))), 'D');
  RETURN NEW;
END
$$;


ALTER FUNCTION public.products_search_vec_update() OWNER TO postgres;

--
-- TOC entry 394 (class 1255 OID 17152)
-- Name: unaccent_imm(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unaccent_imm(text) RETURNS text
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
  SELECT unaccent('public.unaccent'::regdictionary, $1)
$_$;


ALTER FUNCTION public.unaccent_imm(text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 17153)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    address_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    street character varying(255) NOT NULL,
    ward character varying(100) NOT NULL,
    district character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    "userUserId" integer
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17159)
-- Name: addresses_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.addresses_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_address_id_seq OWNER TO postgres;

--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 220
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;


--
-- TOC entry 221 (class 1259 OID 17160)
-- Name: attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attributes (
    attribute_id integer NOT NULL,
    attribute_name character varying(100) NOT NULL,
    value_type character varying(20) NOT NULL
);


ALTER TABLE public.attributes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17163)
-- Name: attributes_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attributes_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attributes_attribute_id_seq OWNER TO postgres;

--
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 222
-- Name: attributes_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attributes_attribute_id_seq OWNED BY public.attributes.attribute_id;


--
-- TOC entry 223 (class 1259 OID 17164)
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    cart_item_id integer NOT NULL,
    quantity integer NOT NULL,
    cart_id integer,
    product_id integer
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17167)
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_cart_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_cart_item_id_seq OWNER TO postgres;

--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 224
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_cart_item_id_seq OWNED BY public.cart_items.cart_item_id;


--
-- TOC entry 225 (class 1259 OID 17168)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    cart_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17172)
-- Name: carts_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carts_cart_id_seq OWNER TO postgres;

--
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 226
-- Name: carts_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_cart_id_seq OWNED BY public.carts.cart_id;


--
-- TOC entry 227 (class 1259 OID 17173)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    description text,
    parent_category_id integer
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17178)
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 228
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- TOC entry 229 (class 1259 OID 17179)
-- Name: category_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_attributes (
    category_id integer NOT NULL,
    attribute_id integer NOT NULL
);


ALTER TABLE public.category_attributes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17182)
-- Name: customer_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_services (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    description character varying,
    slug character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customer_services OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17190)
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    message text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17197)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17202)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 233
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 234 (class 1259 OID 17203)
-- Name: option_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_types (
    option_type_id integer NOT NULL,
    name character varying(100) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.option_types OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17207)
-- Name: option_types_option_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.option_types_option_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.option_types_option_type_id_seq OWNER TO postgres;

--
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 235
-- Name: option_types_option_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_types_option_type_id_seq OWNED BY public.option_types.option_type_id;


--
-- TOC entry 236 (class 1259 OID 17208)
-- Name: option_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_values (
    option_value_id integer NOT NULL,
    option_type_id integer NOT NULL,
    value character varying(100) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.option_values OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17212)
-- Name: option_values_option_value_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.option_values_option_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.option_values_option_value_id_seq OWNER TO postgres;

--
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 237
-- Name: option_values_option_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_values_option_value_id_seq OWNED BY public.option_values.option_value_id;


--
-- TOC entry 238 (class 1259 OID 17213)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    quantity integer NOT NULL,
    price_per_unit numeric(12,2) NOT NULL,
    order_id integer,
    product_id integer
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17216)
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_order_item_id_seq OWNER TO postgres;

--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- TOC entry 240 (class 1259 OID 17217)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    subtotal numeric(15,2) NOT NULL,
    discount_amount numeric(15,2) DEFAULT '0'::numeric NOT NULL,
    total_amount numeric(15,2) NOT NULL,
    status character varying DEFAULT 'Pending'::character varying NOT NULL,
    order_date timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer,
    promotion_id integer
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17225)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 241
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 242 (class 1259 OID 17226)
-- Name: policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.policies (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    description character varying,
    slug character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.policies OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17234)
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    image_id integer NOT NULL,
    image_url character varying(255) NOT NULL,
    alt_text character varying(255),
    is_primary boolean DEFAULT false NOT NULL,
    product_id integer
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17240)
-- Name: product_images_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_images_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_images_image_id_seq OWNER TO postgres;

--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_images_image_id_seq OWNED BY public.product_images.image_id;


--
-- TOC entry 245 (class 1259 OID 17241)
-- Name: product_variant_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory (
    variant_id integer NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    safety_stock integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_variant_inventory OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 17247)
-- Name: product_variant_option_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option_values (
    variant_id integer NOT NULL,
    option_value_id integer NOT NULL
);


ALTER TABLE public.product_variant_option_values OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17250)
-- Name: product_variant_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_prices (
    price_id integer NOT NULL,
    variant_id integer NOT NULL,
    price_type text NOT NULL,
    currency_code character(3) DEFAULT 'VND'::bpchar NOT NULL,
    price numeric(12,2) NOT NULL,
    start_at timestamp without time zone DEFAULT now() NOT NULL,
    end_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT product_variant_prices_price_type_check CHECK ((price_type = ANY (ARRAY['retail'::text, 'sale'::text, 'wholesale'::text])))
);


ALTER TABLE public.product_variant_prices OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17259)
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_variant_prices_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_prices_price_id_seq OWNER TO postgres;

--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 248
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variant_prices_price_id_seq OWNED BY public.product_variant_prices.price_id;


--
-- TOC entry 249 (class 1259 OID 17260)
-- Name: product_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variants (
    variant_id integer NOT NULL,
    product_id integer NOT NULL,
    variant_name character varying(255) NOT NULL,
    sku character varying(50),
    barcode character varying(64),
    attributes jsonb DEFAULT '{}'::jsonb,
    status integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_variants OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17269)
-- Name: product_variants_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_variants_variant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variants_variant_id_seq OWNER TO postgres;

--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 250
-- Name: product_variants_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variants_variant_id_seq OWNED BY public.product_variants.variant_id;


--
-- TOC entry 251 (class 1259 OID 17270)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    sku character varying(50) NOT NULL,
    long_description text,
    short_description text,
    status integer DEFAULT 1 NOT NULL,
    price numeric(12,2) NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    category_id integer NOT NULL,
    search_vec tsvector,
    specs jsonb,
    origin text,
    user_manual text,
    caution_notes text
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17279)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 252
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 253 (class 1259 OID 17280)
-- Name: promotion_applicability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_applicability (
    applicability_id integer NOT NULL,
    promotion_id integer,
    product_id integer,
    category_id integer
);


ALTER TABLE public.promotion_applicability OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 17283)
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotion_applicability_applicability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_applicability_applicability_id_seq OWNER TO postgres;

--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 254
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_applicability_applicability_id_seq OWNED BY public.promotion_applicability.applicability_id;


--
-- TOC entry 255 (class 1259 OID 17284)
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    promotion_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    discount_type public.promotions_discount_type_enum NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 17290)
-- Name: promotions_promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotions_promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_promotion_id_seq OWNER TO postgres;

--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 256
-- Name: promotions_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_promotion_id_seq OWNED BY public.promotions.promotion_id;


--
-- TOC entry 257 (class 1259 OID 17291)
-- Name: user_profile_business; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile_business (
    user_id integer NOT NULL,
    company_name character varying(255) NOT NULL,
    tax_id character varying(20) NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.user_profile_business OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 17294)
-- Name: user_profile_individual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile_individual (
    user_id integer NOT NULL,
    full_name character varying(50) NOT NULL,
    date_of_birth date
);


ALTER TABLE public.user_profile_individual OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 17297)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255),
    full_name character varying(100),
    phone_number character varying(20),
    role character varying DEFAULT 'customer'::character varying NOT NULL,
    images_url character varying(255),
    address character varying(255),
    customer_type public.users_customer_type_enum DEFAULT 'individual'::public.users_customer_type_enum,
    avatar_url character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 17305)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3707 (class 2604 OID 17541)
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- TOC entry 3709 (class 2604 OID 17542)
-- Name: attributes attribute_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes ALTER COLUMN attribute_id SET DEFAULT nextval('public.attributes_attribute_id_seq'::regclass);


--
-- TOC entry 3710 (class 2604 OID 17543)
-- Name: cart_items cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_items_cart_item_id_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 17544)
-- Name: carts cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN cart_id SET DEFAULT nextval('public.carts_cart_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 17545)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 17546)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 17547)
-- Name: option_types option_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types ALTER COLUMN option_type_id SET DEFAULT nextval('public.option_types_option_type_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 17548)
-- Name: option_values option_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values ALTER COLUMN option_value_id SET DEFAULT nextval('public.option_values_option_value_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 17549)
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 17550)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 3732 (class 2604 OID 17551)
-- Name: product_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN image_id SET DEFAULT nextval('public.product_images_image_id_seq'::regclass);


--
-- TOC entry 3737 (class 2604 OID 17552)
-- Name: product_variant_prices price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices ALTER COLUMN price_id SET DEFAULT nextval('public.product_variant_prices_price_id_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 17553)
-- Name: product_variants variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN variant_id SET DEFAULT nextval('public.product_variants_variant_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 17554)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 17555)
-- Name: promotion_applicability applicability_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability ALTER COLUMN applicability_id SET DEFAULT nextval('public.promotion_applicability_applicability_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 17556)
-- Name: promotions promotion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promotion_id SET DEFAULT nextval('public.promotions_promotion_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 17557)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4004 (class 0 OID 17153)
-- Dependencies: 219
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId") FROM stdin;
23	Nguyen Danh	0326968216	Địa Chỉ : 231/1 Nguyễn Phúc Chu - Phường 15 - Quận Tân Bình - TP. Hồ Chí Minh.	Xã Khánh An	Huyện An Phú	Tỉnh An Giang	f	86
\.


--
-- TOC entry 4006 (class 0 OID 17160)
-- Dependencies: 221
-- Data for Name: attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attributes (attribute_id, attribute_name, value_type) FROM stdin;
\.


--
-- TOC entry 4008 (class 0 OID 17164)
-- Dependencies: 223
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (cart_item_id, quantity, cart_id, product_id) FROM stdin;
\.


--
-- TOC entry 4010 (class 0 OID 17168)
-- Dependencies: 225
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (cart_id, created_at, user_id) FROM stdin;
1	2025-09-18 10:00:46.065957	10
2	2025-09-19 03:09:05.140572	9
20	2025-09-26 03:35:27.89795	84
21	2025-10-27 01:15:42.387878	86
\.


--
-- TOC entry 4012 (class 0 OID 17173)
-- Dependencies: 227
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name, description, parent_category_id) FROM stdin;
8	Tivi	\N	\N
9	LG	\N	8
12	Simplehome 	\N	8
\.


--
-- TOC entry 4014 (class 0 OID 17179)
-- Dependencies: 229
-- Data for Name: category_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_attributes (category_id, attribute_id) FROM stdin;
\.


--
-- TOC entry 4015 (class 0 OID 17182)
-- Dependencies: 230
-- Data for Name: customer_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_services (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4016 (class 0 OID 17190)
-- Dependencies: 231
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, name, email, message, "createdAt") FROM stdin;
\.


--
-- TOC entry 4017 (class 0 OID 17197)
-- Dependencies: 232
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1693234567890	InitFullEavSchema1693234567890
2	1693234567890	InitFullEavSchema1693234567890
\.


--
-- TOC entry 4019 (class 0 OID 17203)
-- Dependencies: 234
-- Data for Name: option_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_types (option_type_id, name, "position") FROM stdin;
\.


--
-- TOC entry 4021 (class 0 OID 17208)
-- Dependencies: 236
-- Data for Name: option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_values (option_value_id, option_type_id, value, "position") FROM stdin;
\.


--
-- TOC entry 4023 (class 0 OID 17213)
-- Dependencies: 238
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) FROM stdin;
107	1	5990000.00	30	31
108	1	5990000.00	31	30
109	1	5990000.00	32	31
\.


--
-- TOC entry 4025 (class 0 OID 17217)
-- Dependencies: 240
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) FROM stdin;
30	5990000.00	0.00	5990000.00	Pending	2025-10-27 01:15:42.387878	86	\N
31	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:35:48.97484	86	\N
32	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:36:33.918068	86	\N
\.


--
-- TOC entry 4027 (class 0 OID 17226)
-- Dependencies: 242
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policies (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4028 (class 0 OID 17234)
-- Dependencies: 243
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (image_id, image_url, alt_text, is_primary, product_id) FROM stdin;
40	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245539/onbhwf82gngtz5ozcf8i.png	\N	f	25
41	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245547/tm1lhnleskx5gfzdskbg.png	\N	f	26
42	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245547/yfugcdxf56kp30ewjec1.png	\N	f	27
43	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245548/q8tj1ihvc2rup2dneflg.png	\N	f	28
44	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245548/mhvapr0e7tlvehlvof0a.png	\N	f	29
45	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245547/rmmi92xdzmfpmibsxoub.png	\N	f	30
46	https://res.cloudinary.com/dlnkeb4dm/image/upload/v1761245555/vch9d6td9xt63sbtuf3n.png	\N	f	31
\.


--
-- TOC entry 4030 (class 0 OID 17241)
-- Dependencies: 245
-- Data for Name: product_variant_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory (variant_id, stock_quantity, safety_stock, updated_at) FROM stdin;
\.


--
-- TOC entry 4031 (class 0 OID 17247)
-- Dependencies: 246
-- Data for Name: product_variant_option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option_values (variant_id, option_value_id) FROM stdin;
\.


--
-- TOC entry 4032 (class 0 OID 17250)
-- Dependencies: 247
-- Data for Name: product_variant_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_prices (price_id, variant_id, price_type, currency_code, price, start_at, end_at, created_at) FROM stdin;
\.


--
-- TOC entry 4034 (class 0 OID 17260)
-- Dependencies: 249
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (variant_id, product_id, variant_name, sku, barcode, attributes, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4036 (class 0 OID 17270)
-- Dependencies: 251
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, sku, long_description, short_description, status, price, stock_quantity, created_at, updated_at, category_id, search_vec, specs, origin, user_manual, caution_notes) FROM stdin;
25	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245540003	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:20.99393	2025-10-23 18:52:20.99393	12	'-10':2653 '-1761245540003':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
26	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245547484	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:28.411331	2025-10-23 18:52:28.411331	12	'-10':2653 '-1761245547484':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
27	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245547543	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:28.480109	2025-10-23 18:52:28.480109	12	'-10':2653 '-1761245547543':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
28	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245547723	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:28.623354	2025-10-23 18:52:28.623354	12	'-10':2653 '-1761245547723':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
29	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245547810	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:28.709091	2025-10-23 18:52:28.709091	12	'-10':2653 '-1761245547810':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
30	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245548129	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:29.028811	2025-10-23 18:52:29.028811	12	'-10':2653 '-1761245548129':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
31	Smart Tivi Simplehome HD 32 Inch HS32C	SKU-1761245555943	<h2><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Smart Tivi Simplehome HD 32 Inch HS32C: Thiết kế nhỏ gọn, âm thanh sống động, kết nối đa dạng</span></h2><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế nhỏ gọn và tinh tế</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi-simplehome?t=smart-tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Smart Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C sở hữu thiết kế tối giản nhưng đầy sức hút, phù hợp với lối sống hiện đại. Với kích thước màn hình 32 inch, sản phẩm này không chiếm nhiều diện tích, dễ dàng di chuyển và lắp đặt ở bất kỳ vị trí nào trong nhà. Bạn có thể treo tường để tiết kiệm không gian hoặc đặt trên bàn khi kết hợp với chân đế chắc chắn.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Viền màn hình siêu mỏng giúp mở rộng góc nhìn, tạo cảm giác hình ảnh lan tỏa rộng rãi hơn, giống như đang xem trên một chiếc tivi lớn hơn thực tế. Chất liệu nhựa cao cấp được sử dụng cho viền và chân đế không chỉ đảm bảo độ bền mà còn giữ trọng lượng nhẹ, tiện lợi cho việc vận chuyển hoặc thay đổi vị trí.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/thiet-ke-smart-tivi-simplehome-hd-32-inch-hs32c.jpg" alt="Smart Tivi Simplehome HD 32 Inch HS32C"></span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Thiết kế này đặc biệt lý tưởng cho các gia đình trẻ hoặc cá nhân sống ở căn hộ nhỏ có không gian hạn chế. Ví dụ, bạn có thể đặt tivi trong phòng ngủ để xem phim trước khi ngủ hoặc đặt trong bếp để theo dõi công thức nấu ăn qua các ứng dụng trực tuyến.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải màn hình HD</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Độ phân giải HD (1366x768 pixel) của Smart Tivi Simplehome HD 32 Inch HS32C là lựa chọn phù hợp cho kích thước màn hình 32 inch, mang lại hình ảnh rõ ràng mà không đòi hỏi tài nguyên phần cứng cao. Điều này giúp tivi hoạt động mượt mà, tiết kiệm năng lượng và giữ giá thành hợp lý. Nếu bạn là người dùng cơ bản, thích xem tin tức hoặc phim gia đình thì độ phân giải này hoàn toàn có thể đáp ứng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với khả năng hiển thị lên đến 16.7 triệu màu, sản phẩm cũng hứa hẹn tái tạo màu sắc sinh động, từ những cảnh phim hành động kịch tính đến hình ảnh thiên nhiên tươi đẹp, giúp trải nghiệm xem của mọi khách hàng trở nên chân thực hơn.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dễ sử dụng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hệ điều hành Coolita 3.0 dựa trên nền tảng Linux là trái tim của Smart </span><a href="https://dienmaycholon.com/tivi-simplehome" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi Simplehome</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> HD 32 Inch HS32C, mang lại giao diện thân thiện và tốc độ xử lý nhanh chóng. Không giống như các hệ điều hành phức tạp, Coolita 3.0 tập trung vào sự đơn giản, cho phép người dùng dễ dàng điều hướng qua menu.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Đặc biệt, Coolita 3.0 được thiết kế tối ưu hóa cho màn hình nhỏ, giúp tiết kiệm pin remote và giảm độ trễ khi kết nối với thiết bị di động. Nếu bạn mới làm quen với smart tivi, hệ điều hành này sẽ là người bạn đồng hành lý tưởng với hướng dẫn trực quan và khả năng tùy chỉnh cá nhân hóa.</span></p><p class="ql-align-center"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);"><img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/kkt/smart-tivi-simplehome-hd-32-inch-hs32c-su-dung.jpg" alt="Hệ điều hành Coolita 3.0 dễ sử dụng"></span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Công suất loa 20W ấn tượng</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Một trong những điểm cộng lớn của Smart Tivi Simplehome HD 32 Inch HS32C là hệ thống âm thanh với tổng công suất 20W từ 2 loa vật lý. So với nhiều mẫu tivi 32 inch trên thị trường, mức công suất này mang lại âm thanh mạnh mẽ, rõ ràng, đủ để lấp đầy không gian phòng khách nhỏ hoặc phòng ngủ. Bạn có thể thưởng thức phim hành động với tiếng nổ sống động hoặc nghe nhạc với bass sâu mà không cần loa ngoài bổ sung.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Hỗ trợ nhiều ngôn ngữ bao gồm tiếng Việt</span></h3><p class="ql-align-justify"><a href="https://dienmaycholon.com/tivi" rel="noopener noreferrer" target="_blank" style="background-color: rgb(255, 255, 255); color: rgb(0, 123, 255);">Tivi</a><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);"> Simplehome HD 32 Inch HS32C nổi bật với OSD Language hỗ trợ đa dạng, bao gồm tiếng Việt, Anh, Pháp, Đức, Ý, Tây Ban Nha và Bồ Đào Nha. Điều này giúp người dùng Việt Nam dễ dàng thiết lập và sử dụng mà không gặp rào cản ngôn ngữ. Menu cài đặt, thông báo và hướng dẫn đều có thể hiển thị bằng tiếng Việt để bạn sử dụng tivi dễ dàng.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Tính năng này giúp cho tivi trở nên thân thiện với mọi lứa tuổi, đặc biệt là người lớn tuổi hoặc những ai không quen với tiếng Anh. Bạn có thể chuyển đổi ngôn ngữ nhanh chóng qua cài đặt, đảm bảo trải nghiệm cá nhân hóa.</span></p><h3><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Cổng kết nối đa dạng và linh hoạt</span></h3><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Với hệ thống cổng kết nối phong phú, Smart Tivi Simplehome HD 32 Inch HS32C dễ dàng tích hợp vào hệ sinh thái thiết bị gia đình. Các cổng như HDMI Input, USB, Earphone output, AV Input (R,L), RF Input, Coaxial, RJ45 và Wi-Fi cho phép bạn phối ghép tivi với các thiết bị ngoại vi như máy chơi game, USB lưu trữ, đầu thu truyền hình,... Tính linh hoạt này làm cho tivi không chỉ là thiết bị nghe nhìn đơn thuần mà còn trở thành trung tâm giải trí đa phương tiện.</span></p><p class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);">Có thể nói, Smart Tivi Simplehome HD 32 Inch HS32C là sự kết hợp hoàn hảo giữa thiết kế nhỏ gọn, chất lượng hình ảnh HD sắc nét và tính năng thông minh tiện lợi. Với hệ điều hành Coolita 3.0, âm thanh 20W mạnh mẽ, hỗ trợ tiếng Việt và cổng kết nối đa dạng, sản phẩm này đáp ứng tốt nhu cầu giải trí hàng ngày mà không làm phức tạp hóa trải nghiệm người dùng. Nếu bạn đang tìm kiếm một chiếc tivi 32 inch giá tốt, dễ sử dụng cho gia đình hoặc cá nhân thì đây là lựa chọn rất đáng cân nhắc.</span></p><p><br></p>	Tính năng nổi bật:Độ sáng cao, loa 20W (10Wx2)Đổi trả 365 ngày (lỗi kỹ thuật)Bảo hành 24 Tháng, Sản xuất Việt NamInternet TV, Youtube, FPT Play...Cổng kết nối USB , HDMI Hệ điều hành Coolita 3.0 (Linux)	12	5990000.00	1	2025-10-23 18:52:36.899988	2025-10-23 18:52:36.899988	12	'-10':2653 '-1761245555943':9A '-60':2658 '/ch-':2300 '1':2113,2185,2311,2504,2600 '10':2445 '10w':1520C '10wx2':19B '1366x768':288C '16.7':376C '2':582C,1518C,1586C,1747C,2176,2194,2320,2543,2602,2606,2610,2643 '20w':18B,554C,580C,924C,1517C '24':29B,2109C '245':1012C,1013C,1014C,1444C,1445C,1446C,1610C,1611C,1612C,1842C,1843C,1844C,1972C,1973C,1974C '255':1042C,1043C,1044C,1075C,1076C,1077C,1108C,1109C,1110C,1143C,1144C,1145C,1176C,1177C,1178C,1210C,1211C,1212C,1242C,1243C,1244C,1276C,1277C,1278C,1310C,1311C,1312C,1345C,1346C,1347C,1377C,1378C,1379C,1412C,1413C,1414C,1474C,1475C,1476C,1509C,1510C,1511C,1544C,1545C,1546C,1578C,1579C,1580C,1639C,1640C,1641C,1673C,1674C,1675C,1705C,1706C,1707C,1737C,1738C,1739C,1771C,1772C,1773C,1808C,1809C,1810C,1870C,1871C,1872C,1905C,1906C,1907C,1937C,1938C,1939C,2002C,2003C,2004C,2036C,2037C,2038C,2068C,2069C,2070C,2101C,2102C,2103C '3':1818C,2209,2221,2328,2587,2612 '3.0':48B,422C,430C,470C,490C,921C,1285C '32':5A,54C,80C,105C,295C,308C,444C,568C,591C,658C,796C,888C,967C,1151C,2598 '365':22B '3m':2607 '4':2272,2630 '43':2604 '45':2657 '5':2304,2601,2611,2652,2661 '50':2608 '51':1005C,1006C,1007C,1047C,1048C,1049C,1080C,1081C,1082C,1113C,1114C,1115C,1148C,1149C,1150C,1181C,1182C,1183C,1215C,1216C,1217C,1247C,1248C,1249C,1281C,1282C,1283C,1315C,1316C,1317C,1350C,1351C,1352C,1382C,1383C,1384C,1417C,1418C,1419C,1437C,1438C,1439C,1479C,1480C,1481C,1514C,1515C,1516C,1549C,1550C,1551C,1583C,1584C,1585C,1603C,1604C,1605C,1644C,1645C,1646C,1678C,1679C,1680C,1710C,1711C,1712C,1742C,1743C,1744C,1776C,1777C,1778C,1813C,1814C,1815C,1835C,1836C,1837C,1875C,1876C,1877C,1910C,1911C,1912C,1942C,1943C,1944C,1965C,1966C,1967C,2007C,2008C,2009C,2041C,2042C,2043C,2073C,2074C,2075C,2106C,2107C,2108C '5m':2603,2613 '6':2339,2701 '7':2361,2739 '8':2382 '9':2415 'ai':751C 'align':1027C,1060C,1093C,1128C,1161C,1195C,1227C,1261C,1295C,1330C,1362C,1397C,1459C,1494C,1529C,1563C,1624C,1658C,1690C,1722C,1756C,1793C,1855C,1890C,1922C,1987C,2021C,2053C,2086C 'am':61C,574C,602C,922C,1449C,1783C,2158,2257,2420,2439,2562,2673,2734 'an':271C,555C,2506 'anh':166C,313C,400C,674C,756C,905C,1782C,2130,2419,2556,2621 'anh/am':2426 'anh/nhac':2379 'anten':2155 'anten/cap':2277 'audio':2406 'auto':2292 'av':819C,2153,2400 'back':2267 'background':1009C,1039C,1072C,1105C,1140C,1173C,1207C,1239C,1273C,1307C,1342C,1374C,1409C,1441C,1471C,1506C,1541C,1575C,1607C,1636C,1670C,1702C,1734C,1768C,1805C,1839C,1867C,1902C,1934C,1969C,1999C,2033C,2065C,2098C 'background-color':1008C,1038C,1071C,1104C,1139C,1172C,1206C,1238C,1272C,1306C,1341C,1373C,1408C,1440C,1470C,1505C,1540C,1574C,1606C,1635C,1669C,1701C,1733C,1767C,1804C,1838C,1866C,1901C,1933C,1968C,1998C,2032C,2064C,2097C 'bam':2195,2707 'ban':130C,143C,247C,344C,349C,519C,533C,620C,679C,723C,757C,833C,960C,2227 'bang':719C 'bao':27B,200C,651C,670C,710C,770C,1977C,2076C,2149,2575,2773 'bass':637C 'bat':13B,123C,662C 'bat/tat':2136,2232 'ben':202C,2140 'bep':264C,2567 'bi':515C,808C,840C,865C,2387,2390,2527,2571,2580 'bien':1881C 'biet':224C,488C,744C,2626 'bo':644C,682C,2115,2120 'bui':2697 'bullet':993C,1023C,1056C,1089C,1124C,1157C,1191C,1223C,1257C,1291C,1326C,1358C,1393C,1425C,1455C,1490C,1525C,1559C,1591C,1620C,1654C,1686C,1718C,1752C,1789C,1823C,1851C,1886C,1918C,1953C,1983C,2017C,2049C,2082C 'buoc':2184,2193,2208,2310,2319,2327 'ca':233C,548C,773C,978C 'cac':228C,273C,463C,811C,838C,2114,2171,2247,2385 'cach':2177,2222,2451,2455,2590,2594 'cai':707C,767C,2316,2423 'cam':163C,2366,2517 'can':237C,641C,703C,987C,2355 'canh':392C,2144 'cao':16B,187C,324C,2738 'cap':188C 'cau':944C 'ch':2259,2260,2299 'chac':150C 'cham':2510 'chan':148C,151C,195C,415C,1320C 'chat':184C,902C,1318C,1385C,2679 'chay':2541 'che':244C,2437 'chi':198C,862C 'chiec':178C,965C 'chiem':111C 'chinh':547C,2117,2238,2417,2432 'cho':192C,211C,227C,303C,477C,497C,733C,831C,859C,974C,2210,2294,2648 'choi':845C,2397 'chon':300C,984C,2246,2281,2287,2315,2321,2329,2346,2359,2375,2377,2436 'chong':459C,765C 'chromecast':2412 'chua':2284,2751 'chuc':2172,2229 'chuyen':118C,214C,760C,2251,2261,2302 'class':995C,1024C,1030C,1057C,1063C,1090C,1096C,1125C,1131C,1158C,1164C,1192C,1198C,1224C,1230C,1258C,1264C,1292C,1298C,1327C,1333C,1359C,1365C,1394C,1400C,1427C,1456C,1462C,1491C,1497C,1526C,1532C,1560C,1566C,1593C,1621C,1627C,1655C,1661C,1687C,1693C,1719C,1725C,1753C,1759C,1790C,1796C,1825C,1852C,1858C,1887C,1893C,1919C,1925C,1955C,1984C,1990C,2018C,2024C,2050C,2056C,2083C,2089C 'co':131C,240C,248C,348C,365C,621C,715C,758C,881C,1117C,2226,2285,2467,2475 'coaxial':825C 'color':1003C,1010C,1040C,1045C,1073C,1078C,1106C,1111C,1141C,1146C,1174C,1179C,1208C,1213C,1240C,1245C,1274C,1279C,1308C,1313C,1343C,1348C,1375C,1380C,1410C,1415C,1435C,1442C,1472C,1477C,1507C,1512C,1542C,1547C,1576C,1581C,1601C,1608C,1637C,1642C,1671C,1676C,1703C,1708C,1735C,1740C,1769C,1774C,1806C,1811C,1833C,1840C,1868C,1873C,1903C,1908C,1935C,1940C,1963C,1970C,2000C,2005C,2034C,2039C,2066C,2071C,2099C,2104C 'con':204C,871C,2683 'cong':39B,268C,551C,561C,578C,597C,776C,787C,812C,932C,1447C,1483C,1613C,1779C,2146,2369,2391,2405 'contenteditable':999C,1034C,1067C,1100C,1135C,1168C,1202C,1234C,1268C,1302C,1337C,1369C,1404C,1431C,1466C,1501C,1536C,1570C,1597C,1631C,1665C,1697C,1729C,1763C,1800C,1829C,1862C,1897C,1929C,1959C,1994C,2028C,2060C,2093C 'coolita':47B,421C,429C,469C,489C,920C,1284C 'cua':290C,409C,439C,563C,2118,2174 'cuc':2717 'cung':323C,381C 'da':67C,668C,779C,878C,935C 'dac':223C,487C,743C,2625 'dai':99C,2727 'dam':199C,769C,2574 'dan':540C,713C 'dang':68C,116C,174C,482C,669C,693C,728C,780C,800C,936C,961C,986C,2350 'dao':683C 'dap':367C,940C,2712 'dat':121C,141C,250C,262C,708C,768C,2179,2317,2424,2547,2549 'data':991C,1021C,1054C,1087C,1122C,1155C,1189C,1221C,1255C,1289C,1324C,1356C,1391C,1423C,1453C,1488C,1523C,1557C,1589C,1618C,1652C,1684C,1716C,1750C,1787C,1821C,1849C,1884C,1916C,1951C,1981C,2015C,2047C,2080C 'data-list':990C,1020C,1053C,1086C,1121C,1154C,1188C,1220C,1254C,1288C,1323C,1355C,1390C,1422C,1452C,1487C,1522C,1556C,1588C,1617C,1651C,1683C,1715C,1749C,1786C,1820C,1848C,1883C,1915C,1950C,1980C,2014C,2046C,2079C 'dau':850C,2394,2685 'day':90C,611C,981C,2188,2521,2526 'de':115C,135C,149C,196C,255C,265C,423C,481C,609C,692C,722C,727C,799C,971C,1321C,2135,2166,2205,2301,2358,2380,2525,2539,2565,2695,2729,2749 'den':375C,398C 'dep':404C 'deu':714C 'di':117C,516C,2250 'diem':560C 'dien':113C,450C,2192,2237,2408,2508,2518,2538 'dien/day':2464 'dieu':45B,325C,419C,427C,465C,483C,527C,685C,918C,1251C,2160,2167,2416 'dinh':230C,357C,810C,976C,2688 'do':14B,201C,278C,284C,359C,455C,508C,1184C,2288,2295,2430,2433,2438,2477,2737 'doi':20B,217C,267C,318C,761C 'don':475C,868C 'dong':64C,330C,389C,395C,517C,534C,627C,632C,2182,2213,2291,2492,2753 'du':246C,608C 'dua':431C 'duc':676C 'dung':191C,275C,347C,425C,480C,689C,698C,725C,958C,973C,1879C,2134,2165,2224,2298,2348,2356,2500,2533,2577,2585,2666,2678,2704,2716,2723 'duoc':189C,491C,1947C,2483 'duoi':2143 'dvd':2395 'earphone':817C 'em':2584,2629 'enter':2242 'false':1000C,1035C,1068C,1101C,1136C,1169C,1203C,1235C,1269C,1303C,1338C,1370C,1405C,1432C,1467C,1502C,1537C,1571C,1598C,1632C,1666C,1698C,1730C,1764C,1801C,1830C,1863C,1898C,1930C,1960C,1995C,2029C,2061C,2094C 'fi':830C,2326,2333,2488 'fpt':37B 'game':846C,2398 'gan':2566,2616 'gap':701C,2450,2529,2741 'gay':2618,2698 'ghep':835C 'gia':229C,339C,356C,809C,969C,975C 'giac':164C 'giai':280C,286C,361C,876C,945C,1186C 'giam':507C,2256,2429 'gian':88C,139C,242C,476C,613C,2632,2726 'giao':449C,2236 'giay':2220 'gio':2644 'giong':172C,461C 'giu':205C,338C 'giua':897C 'giup':157C,327C,405C,501C,687C,732C 'goc':160C 'gom':652C,671C,2150 'gon':60C,72C,901C 'han':243C 'hang':412C,947C,2010C 'hanh':28B,46B,394C,420C,428C,466C,528C,535C,626C,919C,1252C,1978C,2077C,2774 'hao':896C 'hd':4A,53C,79C,283C,287C,294C,443C,567C,657C,795C,887C,906C,1218C 'hdmi':43B,814C,1816C,2151,2399,2402 'he':44B,418C,426C,464C,526C,572C,785C,804C,917C,1250C,2766 'hen':383C 'hien':98C,372C,717C,2127 'hinh':104C,154C,165C,282C,307C,312C,399C,499C,853C,904C,1119C,1781C,2125,2129,2275,2418,2425,2676 'ho':238C,646C,666C,927C 'hoa':496C,550C,775C,954C 'hoac':140C,215C,232C,261C,354C,617C,633C,749C,977C,2142,2200,2515,2524,2670,2710,2735,2756,2770 'hoan':363C,895C 'hoat':329C,783C,856C,2491 'hoi':319C,2672 'home':2314,2345 'home/menu':2234 'hon':171C,181C,417C,2218 'hong':2141,2699 'hop':94C,146C,302C,341C,802C,894C,2597 'hs32c':7A,56C,82C,297C,446C,570C,660C,798C,890C 'hua':382C 'huong':484C,539C,712C,2622 'hut':92C 'huu':84C 'ich':1846C 'inch':6A,55C,81C,106C,296C,309C,445C,569C,592C,659C,797C,889C,968C,1152C,2599,2605,2609 'input':815C,820C,824C 'internet':1649C,2307 'justify':1028C,1061C,1094C,1129C,1162C,1196C,1228C,1262C,1296C,1331C,1363C,1398C,1460C,1495C,1530C,1564C,1625C,1659C,1691C,1723C,1757C,1794C,1856C,1891C,1923C,1988C,2022C,2054C,2087C 'ke':58C,70C,86C,221C,493C,899C 'kenh':2262,2276,2286,2289,2296,2303,2476,2478 'keo':2520 'ket':40B,65C,145C,511C,777C,788C,893C,933C,1614C,1647C,2147,2186,2305,2337,2383,2392,2759 'kha':370C,544C 'khac':2388,2452 'khach':411C,615C 'khan':2667,2671 'khau':2336 'khe':2692 'khi':144C,259C,510C,2498,2530,2591,2702,2740 'khien':2161,2168 'kho':2669 'khoan':2353 'khoang':2589,2593 'khoi':2181,2212,2752 'khong':110C,138C,197C,241C,317C,460C,612C,640C,700C,752C,861C,950C,1945C,2458,2466,2474,2481,2490,2509,2519,2531,2564,2579,2634,2641,2677,2706,2721,2743 'khuyen':2639 'kich':101C,304C,396C,1116C 'kiem':137C,334C,503C,963C,2461,2469,2484,2757 'ky':25B,124C,2689,2767 'l':822C 'la':298C,345C,436C,531C,571C,745C,863C,891C,982C 'lai':311C,448C,601C,2479,2754 'lam':521C,858C,951C 'lan':167C,2154 'language':665C 'lap':120C,610C,695C,2178,2747 'laptop':2401 'lau':2217,2534,2638,2674 'len':374C,2459 'li':989C,1019C,1052C,1085C,1120C,1153C,1187C,1219C,1253C,1287C,1322C,1354C,1389C,1421C,1451C,1486C,1521C,1555C,1587C,1616C,1650C,1682C,1714C,1748C,1785C,1819C,1847C,1882C,1914C,1949C,1979C,2013C,2045C,2078C 'lien':2645,2765 'lieu':185C,1319C,1386C 'linh':782C,855C 'linux':49B,435C,1286C 'list':992C,1022C,1055C,1088C,1123C,1156C,1190C,1222C,1256C,1290C,1325C,1357C,1392C,1424C,1454C,1489C,1524C,1558C,1590C,1619C,1653C,1685C,1717C,1751C,1788C,1822C,1850C,1885C,1917C,1952C,1982C,2016C,2048C,2081C 'lo':2568 'loa':17B,553C,583C,642C,1485C,1554C,2156,2403,2690 'loai':1050C 'loi':24B,96C,210C,915C,2448,2454,2742,2764 'lon':180C,562C,747C 'lua':299C,741C,983C,2245 'luc':2624 'luong':207C,336C,903C,1553C,2258 'luu':848C,2496 'ly':225C,342C,457C,536C,585C,2457 'ma':203C,316C,332C,639C,699C,870C,949C 'man':103C,153C,281C,306C,498C,1118C,2124,2675 'mang':310C,447C,600C,2322,2480 'manh':604C,925C,2523,2682,2709 'mat':2335,2554,2620,2649 'mau':378C,386C,589C 'may':844C,2396,2700,2755 'me':605C,926C 'mem':2668 'menu':486C,706C,2252 'minh':913C 'mirroring':2411 'mo':158C,2122,2206,2235 'moi':410C,520C,740C,2495,2619,2656,2732 'mong':156C 'mot':177C,557C,964C,2446 'muc':596C 'mui':2248 'muot':331C 'mute':2263,2473 'nam':691C,2112B,2139 'naminternet':34B 'nang':11B,335C,371C,545C,730C,911C,2173,2230,2557 'nao':127C 'nau':270C 'nay':109C,222C,326C,362C,529C,599C,686C,731C,857C,939C 'nem/va':2711 'nen':414C,433C,736C,2647 'net':908C,2435 'netfilx':1948C 'netflix':2342 'network':2323 'neu':343C,518C,959C,2283,2354,2720,2762 'ngat':2536 'ngay':23B,948C,2535 'nghe':634C,866C,1448C 'nghi':2640,2650 'nghiem':407C,772C,956C 'nghieng':2581 'ngoai':643C,841C,2404 'ngoi':2614,2651 'ngon':649C,704C,762C 'ngu':254C,260C,619C,650C,705C,763C 'nguoi':346C,479C,532C,688C,746C,957C 'nguon':2133,2189,2202,2460,2465,2522,2537 'nguyen':321C 'nha':129C,680C,684C 'nhac':635C,988C,2442 'nhan':234C,549C,774C,979C,1780C,2244,2278,2312,2344,2373 'nhanh':458C,764C,2266 'nhap':2334,2351 'nhe':208C 'nhien':402C 'nhiet':2573,2694,2736 'nhieu':112C,588C,648C 'nhin':161C,867C 'nho':59C,71C,239C,500C,616C,900C 'nhu':173C,462C,813C,843C,943C 'nhua':186C,1353C,1420C 'nhung':89C,391C,559C,750C 'no':630C,2542 'noi':12B,41B,66C,512C,661C,778C,789C,883C,934C,1615C,1648C,2126,2148,2187,2306,2338,2384,2393,2552,2561,2760 'nut':2132,2196,2228,2279,2313,2472 'o':122C,236C,2191,2463,2516,2551 'ok':2241 'osd':664C 'out/optical/bluetooth':2407 'output':818C 'pham':108C,380C,938C,1018C 'phan':279C,285C,322C,360C,1185C,2116,2121 'phap':675C 'phat':2157,2381 'phep':478C,832C 'phim':257C,355C,393C,625C,2201,2363,2441 'pho':1880C 'phoi':834C 'phong':253C,614C,618C,790C 'phu':93C,301C,791C,2596 'phuc':467C,952C,2453 'phuong':879C 'phut':2654,2659 'pin':504C,2494,2715,2719 'pixel':289C 'play':38B 'power':2197,2231 'ql':997C,1026C,1032C,1059C,1065C,1092C,1098C,1127C,1133C,1160C,1166C,1194C,1200C,1226C,1232C,1260C,1266C,1294C,1300C,1329C,1335C,1361C,1367C,1396C,1402C,1429C,1458C,1464C,1493C,1499C,1528C,1534C,1562C,1568C,1595C,1623C,1629C,1657C,1663C,1689C,1695C,1721C,1727C,1755C,1761C,1792C,1798C,1827C,1854C,1860C,1889C,1895C,1921C,1927C,1957C,1986C,1992C,2020C,2026C,2052C,2058C,2085C,2091C 'ql-align-justify':1025C,1058C,1091C,1126C,1159C,1193C,1225C,1259C,1293C,1328C,1360C,1395C,1457C,1492C,1527C,1561C,1622C,1656C,1688C,1720C,1754C,1791C,1853C,1888C,1920C,1985C,2019C,2051C,2084C 'ql-ui':996C,1031C,1064C,1097C,1132C,1165C,1199C,1231C,1265C,1299C,1334C,1366C,1401C,1428C,1463C,1498C,1533C,1567C,1594C,1628C,1662C,1694C,1726C,1760C,1797C,1826C,1859C,1894C,1926C,1956C,1991C,2025C,2057C,2090C 'qua':272C,485C,766C,2364,2615,2637,2642,2708 'quan':542C,1016C,2502 'quay':2268 'quen':522C,753C 'r':821C 'rai':170C 'rang':315C,607C 'rao':702C 'rat':985C 'remote':505C,2164,2204,2225,2357,2489,2705,2713,2730 'rf':823C 'rgb':1004C,1011C,1041C,1046C,1074C,1079C,1107C,1112C,1142C,1147C,1175C,1180C,1209C,1214C,1241C,1246C,1275C,1280C,1309C,1314C,1344C,1349C,1376C,1381C,1411C,1416C,1436C,1443C,1473C,1478C,1508C,1513C,1543C,1548C,1577C,1582C,1602C,1609C,1638C,1643C,1672C,1677C,1704C,1709C,1736C,1741C,1770C,1775C,1807C,1812C,1834C,1841C,1869C,1874C,1904C,1909C,1936C,1941C,1964C,1971C,2001C,2006C,2035C,2040C,2067C,2072C,2100C,2105C 'rj45':826C 'ro':314C,606C 'rong':159C,169C 'rua':2681 'sac':387C,907C,2434 'san':31B,107C,379C,937C,1017C,2011C 'sang':15B,2431 'sau':638C,2655 'scan/search':2293 'screen':2410 'se':530C,2216,2617 'settings':2318 'sieu':155C 'simplehome':3A,52C,78C,293C,442C,566C,656C,794C,886C,2044C 'sinh':388C,805C,2572,2664,2687 'sku':8A 'smart':1A,50C,76C,291C,440C,524C,564C,792C,884C,1083C,2214,2239,2308,2413 'so':83C,586C,1552C,2447 'song':63C,97C,235C,631C 'source':2374 'source/input':2280 'span':994C,1029C,1036C,1062C,1069C,1095C,1102C,1130C,1137C,1163C,1170C,1197C,1204C,1229C,1236C,1263C,1270C,1297C,1304C,1332C,1339C,1364C,1371C,1399C,1406C,1426C,1461C,1468C,1496C,1503C,1531C,1538C,1565C,1572C,1592C,1626C,1633C,1660C,1667C,1692C,1699C,1724C,1731C,1758C,1765C,1795C,1802C,1824C,1857C,1864C,1892C,1899C,1924C,1931C,1954C,1989C,1996C,2023C,2030C,2055C,2062C,2088C,2095C 'strong':1001C,1433C,1599C,1831C,1961C 'style':1002C,1037C,1070C,1103C,1138C,1171C,1205C,1237C,1271C,1305C,1340C,1372C,1407C,1434C,1469C,1504C,1539C,1573C,1600C,1634C,1668C,1700C,1732C,1766C,1803C,1832C,1865C,1900C,1932C,1962C,1997C,2031C,2063C,2096C 'su':190C,424C,474C,697C,724C,892C,972C,2223,2499,2532,2703,2722 'sua':2750 'suat':552C,579C,598C,1484C 'suc':91C 'sung':645C 'suoi':2569 'ta':2123 'tai':320C,384C,2352 'tam':875C,2772 'tan':2693 'tang':434C,2255,2428 'tao':162C,385C 'tap':468C,471C,953C 'tat':2264 'tay':678C,2511,2680 'te':75C,183C 'ten':2249,2330 'thai':806C 'than':451C,737C 'thang':30B,2110C 'thanh':62C,340C,575C,603C,873C,923C,1450C,1784C,2159,2421,2427,2440 'thao':2718,2746 'thay':216C,2493,2714 'the':132C,249C,366C,622C,716C,759C,882C 'theo':266C 'thi':358C,373C,594C,718C,980C,2128,2623 'thich':350C 'thien':401C,452C,738C 'thiet':57C,69C,85C,220C,492C,514C,694C,807C,839C,864C,898C,2386,2389,2570 'thoai':2409 'thoang':2553 'thoi':2631,2725 'thong':573C,709C,786C,912C 'thu':851C 'thuan':869C 'thuat':26B,2768 'thuc':182C,269C,416C,624C 'thuoc':102C,305C 'thuong':623C,2138,2449 'tich':114C,801C 'tien':209C,880C,914C,1845C 'tieng':629C,653C,672C,720C,755C,929C,2265,2468 'tiep':2559 'tiet':136C,333C,502C 'tiktok':2343 'tim':438C,962C 'tin':352C,2443 'tinh':10B,74C,397C,729C,854C,910C 'tivi':2A,51C,77C,179C,251C,292C,328C,441C,525C,565C,590C,655C,726C,734C,793C,836C,860C,885C,966C,1051C,1084C,1388C,2119,2137,2145,2175,2183,2199,2207,2211,2233,2372,2501,2514,2548,2550,2576,2636,2665,2748 'toa':168C 'toan':364C,2507 'toc':454C 'toi':87C,494C 'tong':577C,1015C,1482C 'tot':942C,970C 'tra':21B,2462,2470,2485,2758 'trai':406C,437C,771C,955C 'trang':2270 'tranh':2540,2555,2560,2582,2696,2728 'tre':231C,509C,2583,2628 'tren':142C,176C,432C,593C,2198,2203,2371 'treo':133C 'tri':126C,219C,877C,946C,2546 'trieu':377C 'tro':413C,647C,667C,735C,872C,928C 'trong':128C,206C,252C,263C,558C,2503,2724,2731 'tru':849C 'truc':276C,541C,2558 'trung':472C,874C,2771 'truoc':258C,2271,2761 'truong':595C,2733 'truyen':852C,2274 'tu':390C,581C,2162,2169,2290,2744 'tuc':353C,2444,2646 'tuoi':403C,742C,748C 'tuong':134C,226C,537C,556C 'tuy':546C 'tuyen':277C 'tv':35B,2215,2240,2309,2414 'tv/antenna/cable':2282 'ui':998C,1033C,1066C,1099C,1134C,1167C,1201C,1233C,1267C,1301C,1336C,1368C,1403C,1430C,1465C,1500C,1535C,1569C,1596C,1630C,1664C,1696C,1728C,1762C,1799C,1828C,1861C,1896C,1928C,1958C,1993C,2027C,2059C,2092C 'ung':274C,368C,941C,1878C,2347 'uot':2512,2563 'usb':42B,816C,847C,1713C,1745C,2152,2365,2367,2370,2376 'uu':495C 'va':73C,119C,194C,337C,453C,506C,543C,681C,696C,711C,781C,827C,909C,931C,2180,2691 'vai':2219 'van':213C,2763 'vao':473C,803C,2190,2368,2422,2482,2513,2586 'vat':584C 've':2269,2505,2544,2588,2662,2663,2686 'vi':125C,218C,245C,842C,2545 'video':2131,2360 'video/hinh':2378 'viec':212C 'vien':152C,193C,1387C,2769 'viet':33B,654C,673C,690C,721C,930C,2111B 'voi':95C,100C,147C,369C,513C,523C,538C,576C,587C,628C,636C,663C,739C,754C,784C,837C,916C,2627 'vol':2253,2254,2471 'vung':2578 'wi':829C,2325,2332,2487 'wi-fi':828C,2324,2331,2486 'wifi':1681C 'x':1519C,1746C,1817C 'xa':2163,2170 'xac':2243 'xang':2684 'xem':175C,256C,351C,408C,1946C,2273,2340,2362,2592,2595,2633,2635,2660 'xoan':2528 'xong':2297 'xu':456C,1976C,2456 'xuat':32B,1975C,2012C 'y':677C,2497,2745 'youtube':36B,1913C,2341 'youtube/netflix':2349	"<ol><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tổng quan sản phẩm</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Loại Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Smart Tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kích cỡ màn hình</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">32 Inch</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Độ phân giải</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HD</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hệ điều hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Coolita 3.0 (Linux)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu chân đế</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Chất liệu viền tivi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Nhựa</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Công nghệ âm thanh</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Tổng công suất loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">20W (2 x 10W)</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Số lượng loa</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">2</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Cổng kết nối</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Kết nối Internet</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Wifi</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">USB x 2</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Cổng nhận hình ảnh, âm thanh</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">HDMI x 3</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Tiện ích</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Ứng dụng phổ biến</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- YouTube</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">- Không xem được Netfilx</span></li><li data-list=\\"bullet\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><strong style=\\"color: rgb(51, 51, 51); background-color: rgb(245, 245, 245);\\">Xuất Xứ &amp; Bảo Hành</strong></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Hãng Sản Xuất</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Simplehome</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">Bảo Hành</span></li><li data-list=\\"bullet\\" class=\\"ql-align-justify\\"><span class=\\"ql-ui\\" contenteditable=\\"false\\"></span><span style=\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\">24 Tháng</span></li></ol><p><br></p>"	Việt Nam	📺 1. Các bộ phận chính của tivi\nBộ phận\tMô tả\nMàn hình\tNơi hiển thị hình ảnh, video.\nNút nguồn\tDùng để bật/tắt tivi (thường nằm bên hông hoặc dưới cạnh tivi).\nCổng kết nối\tBao gồm HDMI, USB, AV, LAN, Anten…\nLoa\tPhát âm thanh.\nĐiều khiển từ xa (remote)\tDùng để điều khiển từ xa các chức năng của tivi.\n🔌 2. Cách lắp đặt và khởi động tivi\n\n✅ Bước 1: Kết nối dây nguồn vào ổ điện.\n✅ Bước 2: Bấm nút Power trên tivi hoặc phím nguồn trên remote để mở tivi.\n✅ Bước 3: Chờ tivi khởi động (Smart TV sẽ lâu hơn vài giây).\n\n🎮 3. Cách sử dụng remote cơ bản\nNút\tChức năng\nPower (🔴)\tBật/Tắt tivi\nHome/Menu\tMở giao diện chính (Smart TV)\nOK / Enter\tXác nhận lựa chọn\nCác mũi tên ⬆⬇⬅➡\tDi chuyển menu\nVol + / Vol -\tTăng giảm âm lượng\nCH + / CH -\tChuyển kênh\nMute 🔇\tTắt tiếng nhanh\nBack\tQuay về trang trước\n📡 4. Xem truyền hình (kênh anten/cáp)\n\nNhấn nút Source/Input → chọn TV/Antenna/Cable.\n\nNếu chưa có kênh → chọn Dò kênh tự động (Auto Scan/Search).\n\nChờ dò kênh xong → dùng CH+/CH- để chuyển kênh.\n\n🌐 5. Kết nối internet (Smart TV)\n\n✅ Bước 1: Nhấn nút Home → chọn Cài đặt (Settings).\n✅ Bước 2: Chọn Mạng (Network) → Wi-Fi.\n✅ Bước 3: Chọn tên Wi-Fi → nhập mật khẩu → Kết nối.\n\n📲 6. Xem YouTube, Netflix, TikTok…\n\nNhấn Home.\n\nChọn ứng dụng YouTube/Netflix/...\n\nĐăng nhập tài khoản (nếu cần).\n\nDùng remote để chọn video.\n\n💾 7. Xem phim qua USB\n\n✅ Cắm USB vào cổng USB trên tivi\n✅ Nhấn Source → chọn USB\n✅ Chọn video/hình ảnh/nhạc để phát\n\n🎮 8. Kết nối các thiết bị khác\nThiết bị\tCổng kết nối\nĐầu DVD, Máy chơi game\tHDMI, AV\nLaptop\tHDMI\nLoa ngoài\tCổng Audio Out/Optical/Bluetooth\nĐiện thoại\tScreen Mirroring / Chromecast (Smart TV)\n⚙️ 9. Điều chỉnh hình ảnh & âm thanh\n\nVào Cài đặt → Hình ảnh/Âm thanh\n✅ Tăng giảm độ sáng\n✅ Chỉnh độ sắc nét\n✅ Chọn chế độ âm thanh (Phim, Nhạc, Tin tức…)\n\n❗ 10. Một số lỗi thường gặp & cách khắc phục\nLỗi\tCách xử lý\nKhông lên nguồn\tKiểm tra ổ điện/dây nguồn\nKhông có tiếng\tKiểm tra Vol, nút Mute\nKhông có kênh\tDò kênh lại\nMạng không vào được\tKiểm tra Wi-Fi\nRemote không hoạt động\tThay pin mới	⚠️ LƯU Ý KHI SỬ DỤNG TIVI (QUAN TRỌNG)\n✅ 1. Về an toàn điện\n\nKhông chạm tay ướt vào tivi hoặc ổ cắm điện.\n\nKhông kéo dây nguồn mạnh hoặc để dây bị xoắn, gấp.\n\nKhi không sử dụng lâu ngày → ngắt nguồn điện để tránh cháy nổ.\n\n✅ 2. Về vị trí đặt tivi\n\nĐặt tivi ở nơi thoáng mát, tránh ánh nắng trực tiếp, tránh nơi ẩm ướt.\n\nKhông để gần bếp, lò sưởi, thiết bị sinh nhiệt.\n\nĐảm bảo tivi đứng vững, không bị nghiêng, tránh trẻ em đụng vào.\n\n✅ 3. Về khoảng cách khi xem\n\nKhoảng cách xem phù hợp:\n📺 32 inch: 1,5 – 2,5m\n📺 43 inch: 2 – 3m\n📺 50 inch: 2,5 – 3,5m\n👉 Ngồi quá gần sẽ gây mỏi mắt, ảnh hưởng thị lực, đặc biệt với trẻ em.\n\n✅ 4. Thời gian xem\n\nKhông xem tivi quá lâu (khuyến nghị không quá 2 giờ liên tục).\n\nNên cho mắt nghỉ ngơi 5–10 phút sau mỗi 45–60 phút xem.\n\n✅ 5. Về vệ sinh tivi\n\nDùng khăn mềm, khô hoặc khăn hơi ẩm lau màn hình.\n\nKhông dùng chất tẩy rửa mạnh (cồn, xăng, dầu…).\n\nVệ sinh định kỳ loa và khe tản nhiệt để tránh bụi gây hỏng máy.\n\n✅ 6. Khi sử dụng remote\n\nKhông bấm quá mạnh hoặc ném/va đập remote.\n\nThay pin đúng cực (+/-), tháo pin nếu không sử dụng trong thời gian dài.\n\nTránh để remote trong môi trường ẩm hoặc nhiệt độ cao.\n\n✅ 7. Khi gặp lỗi\n\nKhông tự ý tháo lắp tivi để sửa chữa.\n\nKhởi động lại máy hoặc kiểm tra kết nối trước.\n\nNếu vẫn lỗi → liên hệ kỹ thuật viên hoặc trung tâm bảo hành.
\.


--
-- TOC entry 4038 (class 0 OID 17280)
-- Dependencies: 253
-- Data for Name: promotion_applicability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_applicability (applicability_id, promotion_id, product_id, category_id) FROM stdin;
\.


--
-- TOC entry 4040 (class 0 OID 17284)
-- Dependencies: 255
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, name, description, discount_type, discount_value, start_date, end_date, is_active) FROM stdin;
\.


--
-- TOC entry 4042 (class 0 OID 17291)
-- Dependencies: 257
-- Data for Name: user_profile_business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_business (user_id, company_name, tax_id, email) FROM stdin;
\.


--
-- TOC entry 4043 (class 0 OID 17294)
-- Dependencies: 258
-- Data for Name: user_profile_individual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_individual (user_id, full_name, date_of_birth) FROM stdin;
84	Nguyen Xuan Danh	2025-09-05
86	Nguyen Danh	\N
\.


--
-- TOC entry 4044 (class 0 OID 17297)
-- Dependencies: 259
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, email, password_hash, full_name, phone_number, role, images_url, address, customer_type, avatar_url, created_at) FROM stdin;
10	Danh	danh@gmail.com	$2b$10$TUK83pDiJczyuxwBH0ndQew16edIC8OsxudIrBFBMKHy04TJQTpOm	\N	\N	customer	\N	\N	\N	\N	2025-09-18 10:00:46.05424
84	danh0105001	danh0105010@gmail.com	\N	\N	\N	customer	\N	\N	individual	\N	2025-09-26 03:35:27.89795
9	admin	admin@gmail.com	$2b$10$C96tVNrwpgdR0wvF71zhZOD/KO1SWZRD7BfWBDaE7VLg.GW/nlA/S	\N	\N	admin	\N	\N	\N	\N	2025-09-18 07:20:15.494312
86	danh010500	danh010500@gmail.com	\N	\N	\N	customer	\N	\N	individual	\N	2025-10-27 01:15:42.387878
\.


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 220
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 23, true);


--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 222
-- Name: attributes_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attributes_attribute_id_seq', 1, false);


--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 224
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_cart_item_id_seq', 23, true);


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 226
-- Name: carts_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_cart_id_seq', 21, true);


--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 228
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 12, true);


--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 233
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);


--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 235
-- Name: option_types_option_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_types_option_type_id_seq', 1, false);


--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 237
-- Name: option_values_option_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_values_option_value_id_seq', 1, false);


--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 109, true);


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 241
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 32, true);


--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_image_id_seq', 46, true);


--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 248
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_prices_price_id_seq', 1, false);


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 250
-- Name: product_variants_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variants_variant_id_seq', 1, false);


--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 252
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 31, true);


--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 254
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_applicability_applicability_id_seq', 1, false);


--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 256
-- Name: promotions_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promotion_id_seq', 1, false);


--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 86, true);


--
-- TOC entry 3823 (class 2606 OID 17324)
-- Name: user_profile_individual PK_059f53ecf53e772aa79eb3c57f1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "PK_059f53ecf53e772aa79eb3c57f1" PRIMARY KEY (user_id);


--
-- TOC entry 3766 (class 2606 OID 17326)
-- Name: cart_items PK_136052dba9e33c62b93c6a291f8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "PK_136052dba9e33c62b93c6a291f8" PRIMARY KEY (cart_item_id);


--
-- TOC entry 3796 (class 2606 OID 17328)
-- Name: product_images PK_2212515ba306c79f42c46a99db7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "PK_2212515ba306c79f42c46a99db7" PRIMARY KEY (image_id);


--
-- TOC entry 3768 (class 2606 OID 17330)
-- Name: carts PK_2fb47cbe0c6f182bb31c66689e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "PK_2fb47cbe0c6f182bb31c66689e9" PRIMARY KEY (cart_id);


--
-- TOC entry 3762 (class 2606 OID 17332)
-- Name: attributes PK_3225fe233475419d420a293d5d6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "PK_3225fe233475419d420a293d5d6" PRIMARY KEY (attribute_id);


--
-- TOC entry 3772 (class 2606 OID 17334)
-- Name: categories PK_51615bef2cea22812d0dcab6e18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_51615bef2cea22812d0dcab6e18" PRIMARY KEY (category_id);


--
-- TOC entry 3790 (class 2606 OID 17336)
-- Name: order_items PK_54c952fdc94b9b487ef968b4047; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_54c952fdc94b9b487ef968b4047" PRIMARY KEY (order_item_id);


--
-- TOC entry 3776 (class 2606 OID 17338)
-- Name: customer_services PK_56089dcf272f4aca67b6ce27a8b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "PK_56089dcf272f4aca67b6ce27a8b" PRIMARY KEY (id);


--
-- TOC entry 3794 (class 2606 OID 17340)
-- Name: policies PK_603e09f183df0108d8695c57e28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT "PK_603e09f183df0108d8695c57e28" PRIMARY KEY (id);


--
-- TOC entry 3760 (class 2606 OID 17342)
-- Name: addresses PK_7075006c2d82acfeb0ea8c5dce7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_7075006c2d82acfeb0ea8c5dce7" PRIMARY KEY (address_id);


--
-- TOC entry 3782 (class 2606 OID 17344)
-- Name: feedback PK_8389f9e087a57689cd5be8b2b13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT "PK_8389f9e087a57689cd5be8b2b13" PRIMARY KEY (id);


--
-- TOC entry 3784 (class 2606 OID 17346)
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- TOC entry 3825 (class 2606 OID 17348)
-- Name: users PK_96aac72f1574b88752e9fb00089; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_96aac72f1574b88752e9fb00089" PRIMARY KEY (user_id);


--
-- TOC entry 3812 (class 2606 OID 17350)
-- Name: products PK_a8940a4bf3b90bd7ac15c8f4dd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_a8940a4bf3b90bd7ac15c8f4dd9" PRIMARY KEY (product_id);


--
-- TOC entry 3821 (class 2606 OID 17352)
-- Name: user_profile_business PK_ad95ecfa0d8f92b9b3c5c025375; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "PK_ad95ecfa0d8f92b9b3c5c025375" PRIMARY KEY (user_id);


--
-- TOC entry 3792 (class 2606 OID 17354)
-- Name: orders PK_cad55b3cb25b38be94d2ce831db; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_cad55b3cb25b38be94d2ce831db" PRIMARY KEY (order_id);


--
-- TOC entry 3774 (class 2606 OID 17356)
-- Name: category_attributes PK_e135f7d323a2899937cd2a2cb7b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "PK_e135f7d323a2899937cd2a2cb7b" PRIMARY KEY (category_id, attribute_id);


--
-- TOC entry 3819 (class 2606 OID 17358)
-- Name: promotions PK_e151ef85c700deef77ec80ff13a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "PK_e151ef85c700deef77ec80ff13a" PRIMARY KEY (promotion_id);


--
-- TOC entry 3817 (class 2606 OID 17360)
-- Name: promotion_applicability PK_e76ef1dcb40f4f690c444052917; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "PK_e76ef1dcb40f4f690c444052917" PRIMARY KEY (applicability_id);


--
-- TOC entry 3770 (class 2606 OID 17362)
-- Name: carts REL_2ec1c94a977b940d85a4f498ae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "REL_2ec1c94a977b940d85a4f498ae" UNIQUE (user_id);


--
-- TOC entry 3778 (class 2606 OID 17364)
-- Name: customer_services UQ_06ef5acfc04805b8783b2885328; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_06ef5acfc04805b8783b2885328" UNIQUE (title);


--
-- TOC entry 3827 (class 2606 OID 17366)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 3780 (class 2606 OID 17368)
-- Name: customer_services UQ_c0c13d2e89510645f36044cc989; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_c0c13d2e89510645f36044cc989" UNIQUE (slug);


--
-- TOC entry 3814 (class 2606 OID 17370)
-- Name: products UQ_c44ac33a05b144dd0d9ddcf9327; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "UQ_c44ac33a05b144dd0d9ddcf9327" UNIQUE (sku);


--
-- TOC entry 3764 (class 2606 OID 17372)
-- Name: attributes UQ_e8ab1373d517dbee20df5430bb0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "UQ_e8ab1373d517dbee20df5430bb0" UNIQUE (attribute_name);


--
-- TOC entry 3829 (class 2606 OID 17374)
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- TOC entry 3802 (class 2606 OID 17376)
-- Name: product_variant_prices ex_variant_price_unique_window; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT ex_variant_price_unique_window EXCLUDE USING gist (variant_id WITH =, price_type WITH =, tsrange(start_at, COALESCE(end_at, 'infinity'::timestamp without time zone), '[)'::text) WITH &&);


--
-- TOC entry 3786 (class 2606 OID 17378)
-- Name: option_types option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types
    ADD CONSTRAINT option_types_pkey PRIMARY KEY (option_type_id);


--
-- TOC entry 3788 (class 2606 OID 17380)
-- Name: option_values option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (option_value_id);


--
-- TOC entry 3798 (class 2606 OID 17382)
-- Name: product_variant_inventory product_variant_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3800 (class 2606 OID 17384)
-- Name: product_variant_option_values product_variant_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- TOC entry 3804 (class 2606 OID 17386)
-- Name: product_variant_prices product_variant_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_pkey PRIMARY KEY (price_id);


--
-- TOC entry 3808 (class 2606 OID 17388)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3810 (class 2606 OID 17390)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 3805 (class 1259 OID 17391)
-- Name: idx_product_variants_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_product_id ON public.product_variants USING btree (product_id);


--
-- TOC entry 3806 (class 1259 OID 17392)
-- Name: idx_product_variants_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_status ON public.product_variants USING btree (status);


--
-- TOC entry 3815 (class 1259 OID 17558)
-- Name: products_search_vec_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_search_vec_idx ON public.products USING gin (search_vec);


--
-- TOC entry 3858 (class 2620 OID 17393)
-- Name: products products_search_vec_tg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER products_search_vec_tg BEFORE INSERT OR UPDATE OF product_name, sku, short_description, long_description, specs, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3859 (class 2620 OID 17559)
-- Name: products trg_products_search_vec; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec BEFORE INSERT OR UPDATE OF product_name, sku, short_description, long_description, specs, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3860 (class 2620 OID 17394)
-- Name: products trg_products_search_vec_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec_update BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3857 (class 2606 OID 17395)
-- Name: user_profile_individual FK_059f53ecf53e772aa79eb3c57f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "FK_059f53ecf53e772aa79eb3c57f1" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3830 (class 2606 OID 17400)
-- Name: addresses FK_0cb4a718cc49a5bc41bf4f950e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_0cb4a718cc49a5bc41bf4f950e8" FOREIGN KEY ("userUserId") REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3838 (class 2606 OID 17405)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 3833 (class 2606 OID 17410)
-- Name: carts FK_2ec1c94a977b940d85a4f498aea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "FK_2ec1c94a977b940d85a4f498aea" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3831 (class 2606 OID 17415)
-- Name: cart_items FK_30e89257a105eab7648a35c7fce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_30e89257a105eab7648a35c7fce" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3842 (class 2606 OID 17420)
-- Name: product_images FK_4f166bb8c2bfcef2498d97b4068; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "FK_4f166bb8c2bfcef2498d97b4068" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3835 (class 2606 OID 17425)
-- Name: category_attributes FK_55050a8a1b2d2f5202f226d4ac1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_55050a8a1b2d2f5202f226d4ac1" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3832 (class 2606 OID 17430)
-- Name: cart_items FK_6385a745d9e12a89b859bb25623; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_6385a745d9e12a89b859bb25623" FOREIGN KEY (cart_id) REFERENCES public.carts(cart_id) ON DELETE CASCADE;


--
-- TOC entry 3836 (class 2606 OID 17435)
-- Name: category_attributes FK_6730826326fa81ff5511cb0981a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_6730826326fa81ff5511cb0981a" FOREIGN KEY (attribute_id) REFERENCES public.attributes(attribute_id) ON DELETE CASCADE;


--
-- TOC entry 3839 (class 2606 OID 17440)
-- Name: order_items FK_9263386c35b6b242540f9493b00; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_9263386c35b6b242540f9493b00" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE RESTRICT;


--
-- TOC entry 3852 (class 2606 OID 17445)
-- Name: products FK_9a5f6868c96e0069e699f33e124; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_9a5f6868c96e0069e699f33e124" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3840 (class 2606 OID 17450)
-- Name: orders FK_a922b820eeef29ac1c6800e826a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_a922b820eeef29ac1c6800e826a" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- TOC entry 3856 (class 2606 OID 17455)
-- Name: user_profile_business FK_ad95ecfa0d8f92b9b3c5c025375; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "FK_ad95ecfa0d8f92b9b3c5c025375" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3853 (class 2606 OID 17460)
-- Name: promotion_applicability FK_bccec24fb5216b1dd58b643a8dc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_bccec24fb5216b1dd58b643a8dc" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3834 (class 2606 OID 17465)
-- Name: categories FK_de08738901be6b34d2824a1e243; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "FK_de08738901be6b34d2824a1e243" FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- TOC entry 3854 (class 2606 OID 17470)
-- Name: promotion_applicability FK_e8045fc739f5da9b5b8e2bff562; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_e8045fc739f5da9b5b8e2bff562" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3855 (class 2606 OID 17475)
-- Name: promotion_applicability FK_eb83792e55a6d9d50bcd60d2701; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_eb83792e55a6d9d50bcd60d2701" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 3841 (class 2606 OID 17480)
-- Name: orders FK_ef840932f45535891306fc3f327; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_ef840932f45535891306fc3f327" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE SET NULL;


--
-- TOC entry 3850 (class 2606 OID 17602)
-- Name: product_variants fk_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3843 (class 2606 OID 17612)
-- Name: product_variant_inventory fk_variant_inventory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT fk_variant_inventory FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3845 (class 2606 OID 17617)
-- Name: product_variant_option_values fk_variant_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT fk_variant_option FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3848 (class 2606 OID 17607)
-- Name: product_variant_prices fk_variant_price; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT fk_variant_price FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3837 (class 2606 OID 17485)
-- Name: option_values option_values_option_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_option_type_id_fkey FOREIGN KEY (option_type_id) REFERENCES public.option_types(option_type_id) ON DELETE CASCADE;


--
-- TOC entry 3844 (class 2606 OID 17490)
-- Name: product_variant_inventory product_variant_inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3846 (class 2606 OID 17495)
-- Name: product_variant_option_values product_variant_option_values_option_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_option_value_id_fkey FOREIGN KEY (option_value_id) REFERENCES public.option_values(option_value_id) ON DELETE CASCADE;


--
-- TOC entry 3847 (class 2606 OID 17500)
-- Name: product_variant_option_values product_variant_option_values_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3849 (class 2606 OID 17505)
-- Name: product_variant_prices product_variant_prices_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3851 (class 2606 OID 17510)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


-- Completed on 2025-10-31 16:20:46

--
-- PostgreSQL database dump complete
--

\unrestrict cCve54V7I3mFwSsPbZl688EAYjcNgEp1H4Q99VDQ5pwTkK8fESsr7qljQ2VeKkc

--
-- Database "readme_to_recover" dump
--

--
-- PostgreSQL database dump
--

\restrict azirJFhUibgwJ97jOcblUWOPEyqeyPRVFdL6ZhUsefEuqcaTRZzfDrNDWZI3FN6

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-31 16:20:46

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3397 (class 1262 OID 17537)
-- Name: readme_to_recover; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE readme_to_recover WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE readme_to_recover OWNER TO postgres;

\unrestrict azirJFhUibgwJ97jOcblUWOPEyqeyPRVFdL6ZhUsefEuqcaTRZzfDrNDWZI3FN6
\connect readme_to_recover
\restrict azirJFhUibgwJ97jOcblUWOPEyqeyPRVFdL6ZhUsefEuqcaTRZzfDrNDWZI3FN6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 17538)
-- Name: readme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.readme (
    text_field character varying(255)
);


ALTER TABLE public.readme OWNER TO postgres;

--
-- TOC entry 3391 (class 0 OID 17538)
-- Dependencies: 215
-- Data for Name: readme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.readme (text_field) FROM stdin;
All your data is backed up. You must pay 0.0041 BTC to bc1qqmyg9d9uj2fm93fjjjfuw2xrq2fwpr53uhf52d In 48 hours, your data will be publicly disclosed and deleted. (more information: go to http://2info.win/psg)
After paying send mail to us: rambler+39u8l@onionmail.org and we will provide a link for you to download your data. Your DBCODE is: 39U8L
All your data is backed up. You must pay 0.0041 BTC to bc1qqmyg9d9uj2fm93fjjjfuw2xrq2fwpr53uhf52d In 48 hours, your data will be publicly disclosed and deleted. (more information: go to http://2info.win/psg)
After paying send mail to us: rambler+39u8l@onionmail.org and we will provide a link for you to download your data. Your DBCODE is: 39U8L
\.


-- Completed on 2025-10-31 16:20:50

--
-- PostgreSQL database dump complete
--

\unrestrict azirJFhUibgwJ97jOcblUWOPEyqeyPRVFdL6ZhUsefEuqcaTRZzfDrNDWZI3FN6

-- Completed on 2025-10-31 16:20:50

--
-- PostgreSQL database cluster dump complete
--

