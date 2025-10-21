--
-- PostgreSQL database cluster dump
--

-- Started on 2025-10-21 13:40:08

\restrict 8iX3VuWH864iMQYVUcXTSCgbfAyrz97lnB9EE6VhE0uXhcctvMLQrDWS3DkEG02

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








\unrestrict 8iX3VuWH864iMQYVUcXTSCgbfAyrz97lnB9EE6VhE0uXhcctvMLQrDWS3DkEG02

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

\restrict ohvn9kBFDVeRL8nohmImvhLcQ41sezhifikK4v0aWAvhXwkzOmfTa7lBSqizg3n

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-21 13:40:08

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

-- Completed on 2025-10-21 13:40:09

--
-- PostgreSQL database dump complete
--

\unrestrict ohvn9kBFDVeRL8nohmImvhLcQ41sezhifikK4v0aWAvhXwkzOmfTa7lBSqizg3n

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict ldJyZ7tajx0IqoNqqWOXfI2eYxYSeMwR76I4BZsSbCnoP2UddLbwpTcBjWL6ZR6

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-21 13:40:09

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
-- TOC entry 5 (class 3079 OID 20079)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 4 (class 3079 OID 17571)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 3 (class 3079 OID 17564)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 2 (class 3079 OID 16937)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1123 (class 1247 OID 17079)
-- Name: promotions_discount_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promotions_discount_type_enum AS ENUM (
    'percentage',
    'fixed_amount'
);


ALTER TYPE public.promotions_discount_type_enum OWNER TO postgres;

--
-- TOC entry 1120 (class 1247 OID 17050)
-- Name: users_customer_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_customer_type_enum AS ENUM (
    'individual',
    'business'
);


ALTER TYPE public.users_customer_type_enum OWNER TO postgres;

--
-- TOC entry 419 (class 1255 OID 17653)
-- Name: products_search_vec_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vec_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.search_vec :=
    setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.product_name,''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.sku,''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.short_descriptio,''))), 'B')
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
-- TOC entry 412 (class 1255 OID 17652)
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
-- TOC entry 235 (class 1259 OID 17777)
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
-- TOC entry 234 (class 1259 OID 17776)
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
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 234
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;


--
-- TOC entry 220 (class 1259 OID 17705)
-- Name: attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attributes (
    attribute_id integer NOT NULL,
    attribute_name character varying(100) NOT NULL,
    value_type character varying(20) NOT NULL
);


ALTER TABLE public.attributes OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17704)
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
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 219
-- Name: attributes_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attributes_attribute_id_seq OWNED BY public.attributes.attribute_id;


--
-- TOC entry 231 (class 1259 OID 17760)
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
-- TOC entry 230 (class 1259 OID 17759)
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
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 230
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_cart_item_id_seq OWNED BY public.cart_items.cart_item_id;


--
-- TOC entry 233 (class 1259 OID 17767)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    cart_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17766)
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
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 232
-- Name: carts_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_cart_id_seq OWNED BY public.carts.cart_id;


--
-- TOC entry 223 (class 1259 OID 17719)
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
-- TOC entry 222 (class 1259 OID 17718)
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
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- TOC entry 221 (class 1259 OID 17713)
-- Name: category_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_attributes (
    category_id integer NOT NULL,
    attribute_id integer NOT NULL
);


ALTER TABLE public.category_attributes OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17851)
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
-- TOC entry 248 (class 1259 OID 17865)
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
-- TOC entry 250 (class 1259 OID 17975)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17974)
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
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 249
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 255 (class 1259 OID 18705)
-- Name: option_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_types (
    option_type_id integer NOT NULL,
    name character varying(100) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.option_types OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 18704)
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
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 254
-- Name: option_types_option_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_types_option_type_id_seq OWNED BY public.option_types.option_type_id;


--
-- TOC entry 257 (class 1259 OID 18713)
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
-- TOC entry 256 (class 1259 OID 18712)
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
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 256
-- Name: option_values_option_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_values_option_value_id_seq OWNED BY public.option_values.option_value_id;


--
-- TOC entry 227 (class 1259 OID 17738)
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
-- TOC entry 226 (class 1259 OID 17737)
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
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- TOC entry 245 (class 1259 OID 17830)
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
-- TOC entry 244 (class 1259 OID 17829)
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
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 244
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 246 (class 1259 OID 17841)
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
-- TOC entry 225 (class 1259 OID 17728)
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
-- TOC entry 224 (class 1259 OID 17727)
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
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 224
-- Name: product_images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_images_image_id_seq OWNED BY public.product_images.image_id;


--
-- TOC entry 253 (class 1259 OID 18691)
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
-- TOC entry 258 (class 1259 OID 18725)
-- Name: product_variant_option_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option_values (
    variant_id integer NOT NULL,
    option_value_id integer NOT NULL
);


ALTER TABLE public.product_variant_option_values OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 20062)
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
-- TOC entry 259 (class 1259 OID 20061)
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
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variant_prices_price_id_seq OWNED BY public.product_variant_prices.price_id;


--
-- TOC entry 252 (class 1259 OID 17999)
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
-- TOC entry 251 (class 1259 OID 17998)
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
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_variants_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variants_variant_id_seq OWNED BY public.product_variants.variant_id;


--
-- TOC entry 229 (class 1259 OID 17745)
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
-- TOC entry 228 (class 1259 OID 17744)
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
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 228
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 241 (class 1259 OID 17813)
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
-- TOC entry 240 (class 1259 OID 17812)
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
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 240
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_applicability_applicability_id_seq OWNED BY public.promotion_applicability.applicability_id;


--
-- TOC entry 243 (class 1259 OID 17820)
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
-- TOC entry 242 (class 1259 OID 17819)
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
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 242
-- Name: promotions_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_promotion_id_seq OWNED BY public.promotions.promotion_id;


--
-- TOC entry 237 (class 1259 OID 17791)
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
-- TOC entry 236 (class 1259 OID 17786)
-- Name: user_profile_individual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile_individual (
    user_id integer NOT NULL,
    full_name character varying(50) NOT NULL,
    date_of_birth date
);


ALTER TABLE public.user_profile_individual OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17797)
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
-- TOC entry 238 (class 1259 OID 17796)
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
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 238
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3720 (class 2604 OID 17780)
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- TOC entry 3707 (class 2604 OID 17708)
-- Name: attributes attribute_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes ALTER COLUMN attribute_id SET DEFAULT nextval('public.attributes_attribute_id_seq'::regclass);


--
-- TOC entry 3717 (class 2604 OID 17763)
-- Name: cart_items cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_items_cart_item_id_seq'::regclass);


--
-- TOC entry 3718 (class 2604 OID 17770)
-- Name: carts cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN cart_id SET DEFAULT nextval('public.carts_cart_id_seq'::regclass);


--
-- TOC entry 3708 (class 2604 OID 17722)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 17978)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3750 (class 2604 OID 18708)
-- Name: option_types option_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types ALTER COLUMN option_type_id SET DEFAULT nextval('public.option_types_option_type_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 18716)
-- Name: option_values option_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values ALTER COLUMN option_value_id SET DEFAULT nextval('public.option_values_option_value_id_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 17741)
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 17833)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 3709 (class 2604 OID 17731)
-- Name: product_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN image_id SET DEFAULT nextval('public.product_images_image_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 20065)
-- Name: product_variant_prices price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices ALTER COLUMN price_id SET DEFAULT nextval('public.product_variant_prices_price_id_seq'::regclass);


--
-- TOC entry 3742 (class 2604 OID 18002)
-- Name: product_variants variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN variant_id SET DEFAULT nextval('public.product_variants_variant_id_seq'::regclass);


--
-- TOC entry 3712 (class 2604 OID 17748)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 17816)
-- Name: promotion_applicability applicability_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability ALTER COLUMN applicability_id SET DEFAULT nextval('public.promotion_applicability_applicability_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 17823)
-- Name: promotions promotion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promotion_id SET DEFAULT nextval('public.promotions_promotion_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 17800)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4016 (class 0 OID 17777)
-- Dependencies: 235
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId") FROM stdin;
22	Nguyen Xuan Danh	0326968216	256/10	Xã Khánh An	Huyện An Phú	Tỉnh An Giang	t	84
\.


--
-- TOC entry 4001 (class 0 OID 17705)
-- Dependencies: 220
-- Data for Name: attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attributes (attribute_id, attribute_name, value_type) FROM stdin;
\.


--
-- TOC entry 4012 (class 0 OID 17760)
-- Dependencies: 231
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (cart_item_id, quantity, cart_id, product_id) FROM stdin;
\.


--
-- TOC entry 4014 (class 0 OID 17767)
-- Dependencies: 233
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (cart_id, created_at, user_id) FROM stdin;
1	2025-09-18 10:00:46.065957	10
2	2025-09-19 03:09:05.140572	9
20	2025-09-26 03:35:27.89795	84
\.


--
-- TOC entry 4004 (class 0 OID 17719)
-- Dependencies: 223
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name, description, parent_category_id) FROM stdin;
8	Tivi	\N	\N
9	LG	\N	8
\.


--
-- TOC entry 4002 (class 0 OID 17713)
-- Dependencies: 221
-- Data for Name: category_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_attributes (category_id, attribute_id) FROM stdin;
\.


--
-- TOC entry 4028 (class 0 OID 17851)
-- Dependencies: 247
-- Data for Name: customer_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_services (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4029 (class 0 OID 17865)
-- Dependencies: 248
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, name, email, message, "createdAt") FROM stdin;
\.


--
-- TOC entry 4031 (class 0 OID 17975)
-- Dependencies: 250
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1693234567890	InitFullEavSchema1693234567890
2	1693234567890	InitFullEavSchema1693234567890
\.


--
-- TOC entry 4036 (class 0 OID 18705)
-- Dependencies: 255
-- Data for Name: option_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_types (option_type_id, name, "position") FROM stdin;
\.


--
-- TOC entry 4038 (class 0 OID 18713)
-- Dependencies: 257
-- Data for Name: option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_values (option_value_id, option_type_id, value, "position") FROM stdin;
\.


--
-- TOC entry 4008 (class 0 OID 17738)
-- Dependencies: 227
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) FROM stdin;
\.


--
-- TOC entry 4026 (class 0 OID 17830)
-- Dependencies: 245
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) FROM stdin;
\.


--
-- TOC entry 4027 (class 0 OID 17841)
-- Dependencies: 246
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policies (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
2069e08c-6456-45f0-b92b-e41de806c4b9	Quy trình xử lý đổi / trả hàng	• Thời gian xử lý: tối đa 02 tuần kể từ ngày nhận đủ thông tin và chứng từ của khách hàng.\n• Hình thức xử lý: Đổi hàng hoặc sửa chữa theo quy định của nhà sản xuất, nhà cung cấp hoặc trung tâm bảo hành ủy quyền.\n• Mọi quy trình được thực hiện minh bạch, đảm bảo quyền lợi khách hàng theo quy định của pháp luật.	CSDTH	2025-10-20 06:45:09.826508	2025-10-20 06:45:09.826508
2456e7bf-2a7c-4121-aeb6-fdb5db0558b2	Thời hạn ước tính cho việc giao hàng	Sau khi nhận được thông tin đặt hàng, chúng tôi sẽ xử lý đơn trong vòng 24 giờ và liên hệ xác nhận thông tin thanh toán – giao nhận với khách hàng.\n\n⏰ Thời gian giao hàng dự kiến: 3 – 5 ngày kể từ khi chốt đơn hoặc theo thỏa thuận.\n\nMột số trường hợp có thể kéo dài hơn do:\n• Không liên lạc được với khách hàng qua điện thoại.\n• Địa chỉ giao hàng không chính xác hoặc khó tìm.\n• Số lượng đơn hàng tăng đột biến làm chậm tiến độ xử lý.\n• Đối tác cung cấp hoặc đơn vị vận chuyển bị chậm trễ ngoài dự kiến.\n\n🚚 Phí vận chuyển: Kido sử dụng dịch vụ vận chuyển ngoài, vì vậy phí giao hàng sẽ được tính theo biểu phí của đơn vị vận chuyển tùy khu vực và khối lượng hàng hóa. Chúng tôi sẽ thông báo cụ thể mức phí khi xác nhận đơn hàng.	CSGH	2025-10-20 06:40:57.041962	2025-10-20 06:40:57.041962
444d325c-98f4-4853-ad43-c3d607c62655	Giới hạn về mặt địa lý cho việc giao hàng	Với khách hàng ở tỉnh xa hoặc mua số lượng lớn, Kido sẽ sử dụng dịch vụ giao nhận của các công ty vận chuyển uy tín. \nCước phí sẽ được tính theo mức phí của đơn vị giao nhận hoặc theo thỏa thuận hợp đồng giữa hai bên.	CSGH	2025-10-20 06:41:34.915238	2025-10-20 06:41:34.915238
538dbc70-6113-401a-a675-82ed17fed1c2	Chính sách đổi máy mới trong 30 ngày đầu	Tất cả sản phẩm Laptop được bán tại Kido (trừ sản phẩm do nhà phân phối bảo hành riêng, ghi rõ trong phần chi tiết) sẽ được đổi mới trong 30 ngày đầu nếu gặp lỗi phần cứng không thể sửa chữa hoặc thay linh kiện.\n\n• Khách hàng không phải chi trả bất kỳ chi phí nào.\n• Sản phẩm được kiểm tra và xác nhận lỗi bởi kỹ thuật viên Kido.	CSBTBH	2025-10-20 06:43:12.3561	2025-10-20 06:43:12.3561
663bd540-b129-4aae-9e4f-9f13b141f049	Các phương thức giao hàng	Chúng tôi áp dụng 2 hình thức giao hàng linh hoạt để phù hợp với nhu cầu của khách hàng:\n\n• Mua hàng trực tiếp tại công ty hoặc cửa hàng Kido.\n• Giao hàng tận nơi (Ship hàng) thông qua các đơn vị vận chuyển chuyên nghiệp.	CSGH	2025-10-20 06:40:14.230941	2025-10-20 06:40:14.230941
6e3051e1-ea04-46fb-be7f-b41e91428411	Thanh toán tiền mặt	Quý khách thanh toán trực tiếp bằng tiền mặt tại địa chỉ cửa hàng của chúng tôi. Nhân viên sẽ kiểm tra và xác nhận giao dịch ngay tại chỗ.	CSTT	2025-10-20 04:14:41.624201	2025-10-20 06:08:33.567578
93569a63-8c44-4450-8178-096f09c0bd9d	Trường hợp được đổi / trả hàng	Kido thực hiện đổi hàng hoặc hoàn tiền cho khách hàng trong các trường hợp sau (không hoàn phí vận chuyển, trừ khi lỗi thuộc về Kido):\n\n• Không đúng chủng loại, mẫu mã như quý khách đã đặt.\n• Không đủ số lượng, thiếu phụ kiện trong đơn hàng.\n• Tình trạng hàng hóa bên ngoài bị hư hại (bể vỡ, bong tróc) trong quá trình vận chuyển.\n• Sản phẩm không đạt chất lượng: hết hạn, hết bảo hành, không hoạt động, lỗi kỹ thuật từ nhà sản xuất.	CSDTH	2025-10-20 06:45:00.906102	2025-10-20 06:45:00.906102
a462754b-5717-4afe-bd57-8928adccc2e3	Thanh toán tiền mặt	Quý khách thanh toán trực tiếp bằng tiền mặt tại địa chỉ cửa hàng của chúng tôi. Nhân viên sẽ kiểm tra và xác nhận giao dịch ngay tại chỗ.	CSTT	2025-10-20 04:07:33.268203	2025-10-20 04:07:33.268203
a7c3eddd-3e58-444d-b9f0-d9d9a83ab58b	Xử lý khiếu nại và bảo hành	Trong mọi trường hợp liên quan đến bảo hành hoặc sự cố kỹ thuật, quý khách có thể liên hệ trực tiếp với chúng tôi để được hướng dẫn thủ tục bảo hành và hỗ trợ kỹ thuật.\nNhân viên của chúng tôi sẽ hướng dẫn cụ thể và thực hiện quy trình xử lý khiếu nại theo đúng chính sách và quy định của công ty.	CSXLKN	2025-10-20 06:35:23.600488	2025-10-20 06:35:23.600488
b1869878-f526-4591-83c6-8fafe2d92f16	Trường hợp không được đổi / trả hàng	• Khách hàng muốn đổi mẫu mã, chủng loại nhưng không báo trước.\n• Sản phẩm bị hư hại do khách hàng gây ra (rách bao bì, bong tróc, bể vỡ...).\n• Khách hàng sử dụng sai hướng dẫn gây hỏng hóc sản phẩm.\n• Không gửi phiếu bảo hành hoặc chứng từ đúng quy định trong thời hạn.\n• Khách hàng đã ký nhận hàng nhưng không phản hồi trong vòng 24h.	CSDTH	2025-10-20 06:45:05.462109	2025-10-20 06:45:05.462109
b58aa5d9-2137-47dc-931d-e5151378fbc2	Thời gian bảo hành & bảo trì	Thời gian làm việc tại Trung tâm bảo hành Kido:\n\n• Thứ 2 – Thứ 7: 9h30 – 16h30\n• Chủ nhật & ngày lễ: nghỉ\n\nTrong trường hợp cần hỗ trợ ngoài giờ, quý khách có thể liên hệ trước để được sắp xếp hỗ trợ nhanh nhất.	CSBTBH	2025-10-20 06:43:33.765825	2025-10-20 06:43:33.765825
ba32a137-26de-4f85-8781-ee610ad416d9	Tiếp nhận khiếu nại	Chúng tôi tiếp nhận mọi khiếu nại liên quan đến việc sử dụng sản phẩm, dịch vụ hoặc thái độ phục vụ của nhân viên tại Kido. Mọi phản ánh từ khách hàng là cơ sở quan trọng giúp chúng tôi không ngừng hoàn thiện chất lượng dịch vụ và chăm sóc khách hàng.	CSXLKN	2025-10-20 06:35:23.600488	2025-10-20 06:35:23.600488
bd5c4070-ea40-4278-955c-b2337418308b	Chuyển khoản trước 	Quý khách chuyển khoản theo thỏa thuận hoặc hợp đồng. Sau khi xác nhận thanh toán, chúng tôi sẽ tiến hành giao hàng đúng cam kết.\n\nThông tin tài khoản sẽ đượccung cấp qua email hoặc điện thoại khi xác nhận đơn hàng.	CSTT	2025-10-20 04:15:30.418529	2025-10-20 04:30:13.292768
cb18fd6f-951e-463c-ad75-789113de155d	Quyền lợi và điều kiện bảo hành	Khách hàng mua sản phẩm tại Kido sẽ được hưởng đầy đủ quyền lợi bảo hành theo quy định của hãng sản xuất. \nKido không thay đổi chính sách gốc mà chỉ hỗ trợ thêm trong phạm vi cho phép.\n\nĐiều kiện đổi/bảo hành:\n• Sản phẩm còn nguyên vẹn, không trầy xước hoặc bị can thiệp phần cứng.\n• Giữ đầy đủ phụ kiện, thùng hộp, sách hướng dẫn, phiếu bảo hành của Kido.\n• Tem bảo hành còn nguyên vẹn, không bị rách, tẩy xóa hoặc cạo sửa.\n• Mã số Serial / Service Tag trên máy trùng khớp với phiếu bảo hành.\n• Máy không bị rơi, va đập, vào nước, chập điện hoặc chịu tác động vật lý khác.	CSBTBH	2025-10-20 06:43:21.320454	2025-10-20 06:43:21.320454
d311b030-9c7b-4290-a56f-db3a91eeaeea	Trường hợp đặc biệt & xử lý khi hết hàng đổi	Trong trường hợp không còn sản phẩm mới để đổi, Kido sẽ chủ động thương lượng cùng khách hàng theo các hướng:\n• Đổi sang dòng máy tương đương với giá trị giữ nguyên như lúc mua.\n• Nếu chọn dòng máy cao hơn, khách hàng chỉ cần bù phần chênh lệch.\n• Nếu chọn dòng máy thấp hơn, Kido sẽ hoàn lại phần chênh lệch tương ứng.	CSBTBH	2025-10-20 06:43:26.337532	2025-10-20 06:43:26.337532
d4d8c941-2213-4895-9b9d-038dd302f2e8	Điều kiện bảo hành hợp lệ	• Mã vạch và số Serial còn nguyên vẹn, trùng với thông tin trong hệ thống Kido.\n• Phiếu bảo hành hợp lệ, ghi rõ ngày tháng và model chính xác.\n• Tem bảo hành còn nguyên, không bị rách, phai hoặc tẩy xóa.\n• Máy không bị va đập, móp méo, vô nước, cháy nổ hoặc chập điện.\n• Các sản phẩm có bảo hành chính hãng, khách hàng cần liên hệ qua Kido để được hướng dẫn, tránh rách tem hoặc tranh chấp.	CSBTBH	2025-10-20 06:43:29.921768	2025-10-20 06:43:29.921768
df121b17-25d4-4072-a433-d2d98e959e18	Thời gian giải quyết khiếu nại	Thời gian xử lý khiếu nại tối đa là 03 (ba) ngày làm việc kể từ khi nhận được khiếu nại chính thức từ khách hàng.\n\nTrong trường hợp đặc biệt hoặc bất khả kháng, hai bên sẽ chủ động thương lượng để đạt được giải pháp phù hợp và đảm bảo quyền lợi cho khách hàng.	CSXLKN	2025-10-20 06:35:23.600488	2025-10-20 06:35:23.600488
53f79941-92ec-419f-9fc2-f2f344a1847f	Mục đích và phạm vi thu thập thông tin	Kido.edu.vn không bán, chia sẻ hay trao đổi thông tin cá nhân của khách hàng cho bất kỳ bên thứ ba nào khác. Tất cả dữ liệu thu thập chỉ được sử dụng trong nội bộ công ty.\n\nThông tin thu thập gồm:\n- Họ và tên\n- Địa chỉ\n- Điện thoại\n- Email\n- Tên sản phẩm, số lượng, thời gian giao nhận	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
83278e02-528e-4509-9513-96a993587351	Những người hoặc tổ chức được tiếp cận thông tin	Thông tin cá nhân có thể được chia sẻ cho các đối tượng sau (nếu cần thiết):\n- Công Ty TNHH Thương Mại Đầu Tư Xuất Nhập Khẩu Nguyễn Lê – đơn vị chủ quản Kido.\n- Các đối tác dịch vụ có ký hợp đồng thực hiện một phần dịch vụ (như giao hàng, thanh toán, kỹ thuật).	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
86a0bce0-6c54-4983-8c88-ec747a5d26e1	Đơn vị thu thập và quản lý thông tin cá nhân	Công Ty TNHH Thương Mại Đầu Tư Xuất Nhập Khẩu Nguyễn Lê\nĐịa chỉ: 1288/25A Lê Văn Lương, X. Phước Kiển, H. Nhà Bè, TP. Hồ Chí Minh\nĐiện thoại: 0789 636 979\nWebsite: Kido.edu.vn\nEmail: lytran@ichiskill.edu.vn	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
900050ba-96a2-4611-9e86-ee7bc88ac76b	Phạm vi sử dụng thông tin	Thông tin cá nhân được sử dụng trong nội bộ Kido cho các mục đích:\n- Hỗ trợ khách hàng và xử lý đơn đặt hàng.\n- Cung cấp thông tin, dịch vụ và tư vấn theo yêu cầu của khách.\n- Gửi thông báo về sản phẩm, khuyến mãi, sự kiện (khi khách hàng đăng ký nhận).\n- Quản lý tài khoản khách hàng, xác nhận giao dịch tài chính liên quan đến thanh toán trực tuyến.	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
f948f1dd-bcfc-4333-b00b-530209ed323e	Cơ chế tiếp nhận & giải quyết khiếu nại	Kido luôn coi trọng việc bảo vệ thông tin khách hàng và cam kết:\n- Không chia sẻ, bán hoặc cho thuê thông tin cá nhân cho bất kỳ tổ chức nào.\n- Chỉ sử dụng thông tin để nâng cao chất lượng dịch vụ và chăm sóc khách hàng.\n- Giải quyết các khiếu nại, tranh chấp nhanh chóng, minh bạch.\n- Chia sẻ thông tin khách hàng với cơ quan pháp luật nếu có yêu cầu chính thức.\n\nTrong mọi trường hợp, nếu bạn phát hiện thông tin bị sử dụng sai mục đích, vui lòng liên hệ ngay qua hotline: 0789 636 979 hoặc email: lytran@ichiskill.edu.vn.	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
38cdcb02-9289-4f3b-b269-070f72ae47f9	Thời gian lưu trữ thông tin	Dữ liệu cá nhân được lưu trữ trong hệ thống của Kido cho đến khi khách hàng yêu cầu xóa bỏ. Để yêu cầu, vui lòng gửi email đến: lytran@ichiskill.edu.vn	DKTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
ffaba82b-0220-4979-8e62-5f689ab59cfe	Phương tiện và công cụ để tiếp cận & chỉnh sửa thông tin	Kido không thu thập dữ liệu trực tiếp qua website. Thông tin khách hàng được ghi nhận qua email hoặc số điện thoại đặt hàng:\n- Email: lytran@ichiskill.edu.vn\n- Hotline: 0789 636 979\n\nKhách hàng có thể liên hệ qua các kênh trên để yêu cầu chỉnh sửa hoặc cập nhật dữ liệu cá nhân.	CSBMTT	2025-10-20 16:11:28.92356	2025-10-20 16:11:28.92356
0cfe02b1-f608-4390-8779-1ca2bf831115	ĐIỀU 2: Quyền sở hữu trí tuệ	Chúng tôi tôn trọng quyền sở hữu trí tuệ của các bên liên quan và yêu cầu người dùng cũng phải tôn trọng điều này.\n  Tất cả sản phẩm, dịch vụ, logo, thiết kế… trên website đều thuộc quyền sở hữu của Kido.\n  Mọi hành vi sao chép, sử dụng, chỉnh sửa hoặc khai thác trái phép đều bị nghiêm cấm nếu chưa có sự đồng ý bằng văn bản từ Kido.	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
2c6de499-4887-4534-9512-3b7ec7cf0d31	ĐIỀU 1: Một số khái niệm	<ul>\n    <li><strong>Kido.edu.vn:</strong> Website bán hàng trực tuyến các sản phẩm và dịch vụ công nghệ thông tin.</li>\n    <li><strong>Bên thứ 3:</strong> Các dịch vụ thanh toán qua Kido.edu.vn và các đối tác thanh toán khác của Kido.</li>\n  </ul>	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
321187d2-c6e4-4d94-b414-131d22775da0	ĐIỀU 4: Khiếu nại đơn hàng	Trong trường hợp khách hàng bị lừa đảo, thanh toán nhưng không nhận được hàng hoặc hàng sai mô tả,\n  vui lòng gửi email khiếu nại đến Kido. Chúng tôi sẽ tiến hành xác minh, làm việc với bên thứ ba và giải quyết theo đúng trách nhiệm của bên cung cấp dịch vụ thanh toán.	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
5674148a-d843-412e-b983-9cd08155d3c5	ĐIỀU 6: Miễn trừ trách nhiệm	<ul>\n    <li>Kido không chịu trách nhiệm nếu thông tin khách hàng bị lộ do virus, tấn công mạng hoặc sự cố từ thiết bị người dùng.</li>\n    <li>Không chịu trách nhiệm nếu việc thanh toán bị gián đoạn do lỗi hệ thống ngoài kiểm soát hoặc do bên thứ ba.</li>\n    <li>Miễn trừ trong trường hợp thiên tai, chiến tranh, khủng bố, đình công, hoặc các sự kiện bất khả kháng khác.</li>\n  </ul>	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
9d659003-2c18-4b89-86f2-63f629dfde1c	ĐIỀU 5: Trách nhiệm của Kido.edu.vn	<ul>\n    <li>Bảo mật và lưu trữ an toàn thông tin khách hàng.</li>\n    <li>Không chia sẻ hoặc mua bán dữ liệu khách hàng khi chưa có sự đồng ý.</li>\n    <li>Giải quyết thắc mắc, khiếu nại phát sinh từ lỗi hệ thống hoặc giao dịch của Kido.</li>\n    <li>Phối hợp với cơ quan chức năng khi có tố cáo, khiếu nại liên quan đến gian lận tài chính hoặc vi phạm pháp luật.</li>\n  </ul>	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
9e9d6206-4820-4b59-bb6a-fd1ea060ec2b	ĐIỀU 3: Thông tin khách hàng	<ul>\n    <li>Khi sử dụng dịch vụ, khách hàng cần cung cấp thông tin cá nhân và tài khoản để xác nhận giao dịch.</li>\n    <li><strong>Thông tin cá nhân:</strong> Được dùng để xác nhận thanh toán, hỗ trợ chăm sóc khách hàng và gửi khuyến mãi khi được khách hàng đồng ý. Mọi dữ liệu cá nhân được bảo mật tuyệt đối, chỉ tiết lộ khi có yêu cầu pháp lý.</li>\n    <li><strong>Thông tin tài khoản:</strong> Kido và các đối tác thanh toán (Visa, MasterCard…) áp dụng các biện pháp bảo mật cao nhất để đảm bảo an toàn tuyệt đối cho người dùng.</li>\n  </ul>	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
e4fac1ed-fe19-4ff7-a963-6d158bed429e	ĐIỀU 7: Trách nhiệm của khách hàng	<ul>\n    <li>Khách hàng chịu trách nhiệm về độ chính xác của thông tin cung cấp (cá nhân, tài khoản, thẻ tín dụng...). Kido có quyền hủy đơn hàng nếu phát hiện gian lận.</li>\n    <li>Khách hàng cần kiểm tra tài khoản sau khi thanh toán và thông báo sớm cho Kido khi có sự cố (trong vòng 7 ngày).</li>\n    <li>Cần chủ động cài đặt các biện pháp bảo vệ thiết bị để tránh bị tấn công hoặc nhiễm mã độc khi thanh toán.</li>\n  </ul>	DKTT	2025-10-20 16:34:59.294531	2025-10-20 16:34:59.294531
\.


--
-- TOC entry 4006 (class 0 OID 17728)
-- Dependencies: 225
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (image_id, image_url, alt_text, is_primary, product_id) FROM stdin;
\.


--
-- TOC entry 4034 (class 0 OID 18691)
-- Dependencies: 253
-- Data for Name: product_variant_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory (variant_id, stock_quantity, safety_stock, updated_at) FROM stdin;
\.


--
-- TOC entry 4039 (class 0 OID 18725)
-- Dependencies: 258
-- Data for Name: product_variant_option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option_values (variant_id, option_value_id) FROM stdin;
\.


--
-- TOC entry 4041 (class 0 OID 20062)
-- Dependencies: 260
-- Data for Name: product_variant_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_prices (price_id, variant_id, price_type, currency_code, price, start_at, end_at, created_at) FROM stdin;
\.


--
-- TOC entry 4033 (class 0 OID 17999)
-- Dependencies: 252
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (variant_id, product_id, variant_name, sku, barcode, attributes, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4010 (class 0 OID 17745)
-- Dependencies: 229
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, sku, long_description, short_description, status, price, stock_quantity, created_at, updated_at, category_id, search_vec, specs, origin, user_manual, caution_notes) FROM stdin;
\.


--
-- TOC entry 4022 (class 0 OID 17813)
-- Dependencies: 241
-- Data for Name: promotion_applicability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_applicability (applicability_id, promotion_id, product_id, category_id) FROM stdin;
\.


--
-- TOC entry 4024 (class 0 OID 17820)
-- Dependencies: 243
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, name, description, discount_type, discount_value, start_date, end_date, is_active) FROM stdin;
\.


--
-- TOC entry 4018 (class 0 OID 17791)
-- Dependencies: 237
-- Data for Name: user_profile_business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_business (user_id, company_name, tax_id, email) FROM stdin;
\.


--
-- TOC entry 4017 (class 0 OID 17786)
-- Dependencies: 236
-- Data for Name: user_profile_individual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_individual (user_id, full_name, date_of_birth) FROM stdin;
84	Nguyen Xuan Danh	2025-09-05
\.


--
-- TOC entry 4020 (class 0 OID 17797)
-- Dependencies: 239
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, email, password_hash, full_name, phone_number, role, images_url, address, customer_type, avatar_url, created_at) FROM stdin;
10	Danh	danh@gmail.com	$2b$10$TUK83pDiJczyuxwBH0ndQew16edIC8OsxudIrBFBMKHy04TJQTpOm	\N	\N	customer	\N	\N	\N	\N	2025-09-18 10:00:46.05424
84	danh0105001	danh0105010@gmail.com	\N	\N	\N	customer	\N	\N	individual	\N	2025-09-26 03:35:27.89795
9	admin	admin@gmail.com	$2b$10$C96tVNrwpgdR0wvF71zhZOD/KO1SWZRD7BfWBDaE7VLg.GW/nlA/S	\N	\N	admin	\N	\N	\N	\N	2025-09-18 07:20:15.494312
\.


--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 234
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 22, true);


--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 219
-- Name: attributes_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attributes_attribute_id_seq', 1, false);


--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 230
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_cart_item_id_seq', 23, true);


--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 232
-- Name: carts_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_cart_id_seq', 20, true);


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 9, true);


--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 249
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);


--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 254
-- Name: option_types_option_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_types_option_type_id_seq', 1, false);


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 256
-- Name: option_values_option_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_values_option_value_id_seq', 1, false);


--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 226
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 106, true);


--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 244
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 29, true);


--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 224
-- Name: product_images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_image_id_seq', 27, true);


--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_prices_price_id_seq', 1, false);


--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_variants_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variants_variant_id_seq', 1, false);


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 228
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 11, true);


--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 240
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_applicability_applicability_id_seq', 1, false);


--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 242
-- Name: promotions_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promotion_id_seq', 1, false);


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 238
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 85, true);


--
-- TOC entry 3786 (class 2606 OID 17790)
-- Name: user_profile_individual PK_059f53ecf53e772aa79eb3c57f1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "PK_059f53ecf53e772aa79eb3c57f1" PRIMARY KEY (user_id);


--
-- TOC entry 3778 (class 2606 OID 17765)
-- Name: cart_items PK_136052dba9e33c62b93c6a291f8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "PK_136052dba9e33c62b93c6a291f8" PRIMARY KEY (cart_item_id);


--
-- TOC entry 3768 (class 2606 OID 17736)
-- Name: product_images PK_2212515ba306c79f42c46a99db7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "PK_2212515ba306c79f42c46a99db7" PRIMARY KEY (image_id);


--
-- TOC entry 3780 (class 2606 OID 17773)
-- Name: carts PK_2fb47cbe0c6f182bb31c66689e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "PK_2fb47cbe0c6f182bb31c66689e9" PRIMARY KEY (cart_id);


--
-- TOC entry 3760 (class 2606 OID 17710)
-- Name: attributes PK_3225fe233475419d420a293d5d6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "PK_3225fe233475419d420a293d5d6" PRIMARY KEY (attribute_id);


--
-- TOC entry 3766 (class 2606 OID 17726)
-- Name: categories PK_51615bef2cea22812d0dcab6e18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_51615bef2cea22812d0dcab6e18" PRIMARY KEY (category_id);


--
-- TOC entry 3770 (class 2606 OID 17743)
-- Name: order_items PK_54c952fdc94b9b487ef968b4047; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_54c952fdc94b9b487ef968b4047" PRIMARY KEY (order_item_id);


--
-- TOC entry 3804 (class 2606 OID 17860)
-- Name: customer_services PK_56089dcf272f4aca67b6ce27a8b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "PK_56089dcf272f4aca67b6ce27a8b" PRIMARY KEY (id);


--
-- TOC entry 3802 (class 2606 OID 17850)
-- Name: policies PK_603e09f183df0108d8695c57e28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT "PK_603e09f183df0108d8695c57e28" PRIMARY KEY (id);


--
-- TOC entry 3784 (class 2606 OID 17785)
-- Name: addresses PK_7075006c2d82acfeb0ea8c5dce7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_7075006c2d82acfeb0ea8c5dce7" PRIMARY KEY (address_id);


--
-- TOC entry 3810 (class 2606 OID 17873)
-- Name: feedback PK_8389f9e087a57689cd5be8b2b13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT "PK_8389f9e087a57689cd5be8b2b13" PRIMARY KEY (id);


--
-- TOC entry 3812 (class 2606 OID 17982)
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- TOC entry 3790 (class 2606 OID 17807)
-- Name: users PK_96aac72f1574b88752e9fb00089; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_96aac72f1574b88752e9fb00089" PRIMARY KEY (user_id);


--
-- TOC entry 3772 (class 2606 OID 17756)
-- Name: products PK_a8940a4bf3b90bd7ac15c8f4dd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_a8940a4bf3b90bd7ac15c8f4dd9" PRIMARY KEY (product_id);


--
-- TOC entry 3788 (class 2606 OID 17795)
-- Name: user_profile_business PK_ad95ecfa0d8f92b9b3c5c025375; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "PK_ad95ecfa0d8f92b9b3c5c025375" PRIMARY KEY (user_id);


--
-- TOC entry 3800 (class 2606 OID 17840)
-- Name: orders PK_cad55b3cb25b38be94d2ce831db; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_cad55b3cb25b38be94d2ce831db" PRIMARY KEY (order_id);


--
-- TOC entry 3764 (class 2606 OID 17717)
-- Name: category_attributes PK_e135f7d323a2899937cd2a2cb7b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "PK_e135f7d323a2899937cd2a2cb7b" PRIMARY KEY (category_id, attribute_id);


--
-- TOC entry 3798 (class 2606 OID 17828)
-- Name: promotions PK_e151ef85c700deef77ec80ff13a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "PK_e151ef85c700deef77ec80ff13a" PRIMARY KEY (promotion_id);


--
-- TOC entry 3796 (class 2606 OID 17818)
-- Name: promotion_applicability PK_e76ef1dcb40f4f690c444052917; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "PK_e76ef1dcb40f4f690c444052917" PRIMARY KEY (applicability_id);


--
-- TOC entry 3782 (class 2606 OID 17775)
-- Name: carts REL_2ec1c94a977b940d85a4f498ae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "REL_2ec1c94a977b940d85a4f498ae" UNIQUE (user_id);


--
-- TOC entry 3806 (class 2606 OID 17862)
-- Name: customer_services UQ_06ef5acfc04805b8783b2885328; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_06ef5acfc04805b8783b2885328" UNIQUE (title);


--
-- TOC entry 3792 (class 2606 OID 17811)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 3808 (class 2606 OID 17864)
-- Name: customer_services UQ_c0c13d2e89510645f36044cc989; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_c0c13d2e89510645f36044cc989" UNIQUE (slug);


--
-- TOC entry 3774 (class 2606 OID 17758)
-- Name: products UQ_c44ac33a05b144dd0d9ddcf9327; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "UQ_c44ac33a05b144dd0d9ddcf9327" UNIQUE (sku);


--
-- TOC entry 3762 (class 2606 OID 17712)
-- Name: attributes UQ_e8ab1373d517dbee20df5430bb0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "UQ_e8ab1373d517dbee20df5430bb0" UNIQUE (attribute_name);


--
-- TOC entry 3794 (class 2606 OID 17809)
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- TOC entry 3828 (class 2606 OID 20730)
-- Name: product_variant_prices ex_variant_price_unique_window; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT ex_variant_price_unique_window EXCLUDE USING gist (variant_id WITH =, price_type WITH =, tsrange(start_at, COALESCE(end_at, 'infinity'::timestamp without time zone), '[)'::text) WITH &&);


--
-- TOC entry 3822 (class 2606 OID 18711)
-- Name: option_types option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types
    ADD CONSTRAINT option_types_pkey PRIMARY KEY (option_type_id);


--
-- TOC entry 3824 (class 2606 OID 18719)
-- Name: option_values option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (option_value_id);


--
-- TOC entry 3820 (class 2606 OID 18698)
-- Name: product_variant_inventory product_variant_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3826 (class 2606 OID 18729)
-- Name: product_variant_option_values product_variant_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- TOC entry 3830 (class 2606 OID 20073)
-- Name: product_variant_prices product_variant_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_pkey PRIMARY KEY (price_id);


--
-- TOC entry 3816 (class 2606 OID 18010)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3818 (class 2606 OID 18012)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 3813 (class 1259 OID 18018)
-- Name: idx_product_variants_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_product_id ON public.product_variants USING btree (product_id);


--
-- TOC entry 3814 (class 1259 OID 18019)
-- Name: idx_product_variants_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_status ON public.product_variants USING btree (status);


--
-- TOC entry 3775 (class 1259 OID 18690)
-- Name: idx_products_fts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_fts ON public.products USING gin (to_tsvector('simple'::regconfig, public.unaccent_imm((((((COALESCE(product_name, ''::character varying))::text || ' '::text) || COALESCE(short_description, ''::text)) || ' '::text) || COALESCE(long_description, ''::text)))));


--
-- TOC entry 3776 (class 1259 OID 17985)
-- Name: idx_products_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_name_trgm ON public.products USING gin (public.unaccent_imm((product_name)::text) public.gin_trgm_ops);


--
-- TOC entry 3855 (class 2620 OID 17991)
-- Name: products products_search_vec_tg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER products_search_vec_tg BEFORE INSERT OR UPDATE OF product_name, sku, short_description, long_description, specs, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3856 (class 2620 OID 17983)
-- Name: products trg_products_search_vec_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec_update BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3842 (class 2606 OID 17939)
-- Name: user_profile_individual FK_059f53ecf53e772aa79eb3c57f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "FK_059f53ecf53e772aa79eb3c57f1" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3841 (class 2606 OID 17934)
-- Name: addresses FK_0cb4a718cc49a5bc41bf4f950e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_0cb4a718cc49a5bc41bf4f950e8" FOREIGN KEY ("userUserId") REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3835 (class 2606 OID 17904)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 3840 (class 2606 OID 17929)
-- Name: carts FK_2ec1c94a977b940d85a4f498aea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "FK_2ec1c94a977b940d85a4f498aea" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3838 (class 2606 OID 17924)
-- Name: cart_items FK_30e89257a105eab7648a35c7fce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_30e89257a105eab7648a35c7fce" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3834 (class 2606 OID 17899)
-- Name: product_images FK_4f166bb8c2bfcef2498d97b4068; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "FK_4f166bb8c2bfcef2498d97b4068" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3831 (class 2606 OID 17884)
-- Name: category_attributes FK_55050a8a1b2d2f5202f226d4ac1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_55050a8a1b2d2f5202f226d4ac1" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3839 (class 2606 OID 17919)
-- Name: cart_items FK_6385a745d9e12a89b859bb25623; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_6385a745d9e12a89b859bb25623" FOREIGN KEY (cart_id) REFERENCES public.carts(cart_id) ON DELETE CASCADE;


--
-- TOC entry 3832 (class 2606 OID 17889)
-- Name: category_attributes FK_6730826326fa81ff5511cb0981a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_6730826326fa81ff5511cb0981a" FOREIGN KEY (attribute_id) REFERENCES public.attributes(attribute_id) ON DELETE CASCADE;


--
-- TOC entry 3836 (class 2606 OID 17909)
-- Name: order_items FK_9263386c35b6b242540f9493b00; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_9263386c35b6b242540f9493b00" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE RESTRICT;


--
-- TOC entry 3837 (class 2606 OID 17993)
-- Name: products FK_9a5f6868c96e0069e699f33e124; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_9a5f6868c96e0069e699f33e124" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3847 (class 2606 OID 17964)
-- Name: orders FK_a922b820eeef29ac1c6800e826a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_a922b820eeef29ac1c6800e826a" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- TOC entry 3843 (class 2606 OID 17944)
-- Name: user_profile_business FK_ad95ecfa0d8f92b9b3c5c025375; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "FK_ad95ecfa0d8f92b9b3c5c025375" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3844 (class 2606 OID 17959)
-- Name: promotion_applicability FK_bccec24fb5216b1dd58b643a8dc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_bccec24fb5216b1dd58b643a8dc" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3833 (class 2606 OID 17894)
-- Name: categories FK_de08738901be6b34d2824a1e243; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "FK_de08738901be6b34d2824a1e243" FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- TOC entry 3845 (class 2606 OID 17954)
-- Name: promotion_applicability FK_e8045fc739f5da9b5b8e2bff562; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_e8045fc739f5da9b5b8e2bff562" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3846 (class 2606 OID 17949)
-- Name: promotion_applicability FK_eb83792e55a6d9d50bcd60d2701; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_eb83792e55a6d9d50bcd60d2701" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 3848 (class 2606 OID 17969)
-- Name: orders FK_ef840932f45535891306fc3f327; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_ef840932f45535891306fc3f327" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE SET NULL;


--
-- TOC entry 3851 (class 2606 OID 18720)
-- Name: option_values option_values_option_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_option_type_id_fkey FOREIGN KEY (option_type_id) REFERENCES public.option_types(option_type_id) ON DELETE CASCADE;


--
-- TOC entry 3850 (class 2606 OID 18699)
-- Name: product_variant_inventory product_variant_inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3852 (class 2606 OID 18735)
-- Name: product_variant_option_values product_variant_option_values_option_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_option_value_id_fkey FOREIGN KEY (option_value_id) REFERENCES public.option_values(option_value_id) ON DELETE CASCADE;


--
-- TOC entry 3853 (class 2606 OID 18730)
-- Name: product_variant_option_values product_variant_option_values_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3854 (class 2606 OID 20074)
-- Name: product_variant_prices product_variant_prices_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3849 (class 2606 OID 18013)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


-- Completed on 2025-10-21 13:40:11

--
-- PostgreSQL database dump complete
--

\unrestrict ldJyZ7tajx0IqoNqqWOXfI2eYxYSeMwR76I4BZsSbCnoP2UddLbwpTcBjWL6ZR6

-- Completed on 2025-10-21 13:40:11

--
-- PostgreSQL database cluster dump complete
--

