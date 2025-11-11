--
-- PostgreSQL database cluster dump
--

-- Started on 2025-11-10 21:41:55

\restrict Va0A3qH4ZMQurUCS8dhfbR8qgRXS9YmHz2mMMPYy2lz8CbZXVZGjZorTsFifakL

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








\unrestrict Va0A3qH4ZMQurUCS8dhfbR8qgRXS9YmHz2mMMPYy2lz8CbZXVZGjZorTsFifakL

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

\restrict vk7ywko82Op2kCkqpwCHC2TbHyqH9mpMm7SalsoQT5gBIB4pjfGsUvVBBaTdLSy

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-10 21:41:55

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

-- Completed on 2025-11-10 21:41:55

--
-- PostgreSQL database dump complete
--

\unrestrict vk7ywko82Op2kCkqpwCHC2TbHyqH9mpMm7SalsoQT5gBIB4pjfGsUvVBBaTdLSy

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict nHAySW0fk7bCYYeCzDKpgUSXSsyTTMAp0Qgiq0ZgdWGacIOSqSwTD41cag67gGm

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-10 21:41:56

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
-- TOC entry 4113 (class 0 OID 0)
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
-- TOC entry 4114 (class 0 OID 0)
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
-- TOC entry 4115 (class 0 OID 0)
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
-- TOC entry 4116 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1150 (class 1247 OID 17140)
-- Name: promotions_discount_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promotions_discount_type_enum AS ENUM (
    'percentage',
    'fixed_amount'
);


ALTER TYPE public.promotions_discount_type_enum OWNER TO postgres;

--
-- TOC entry 1240 (class 1247 OID 18268)
-- Name: rental_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rental_status_enum AS ENUM (
    'pending',
    'active',
    'completed',
    'cancelled'
);


ALTER TYPE public.rental_status_enum OWNER TO postgres;

--
-- TOC entry 1237 (class 1247 OID 18260)
-- Name: rental_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rental_type_enum AS ENUM (
    'daily',
    'weekly',
    'monthly'
);


ALTER TYPE public.rental_type_enum OWNER TO postgres;

--
-- TOC entry 1153 (class 1247 OID 17146)
-- Name: users_customer_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_customer_type_enum AS ENUM (
    'individual',
    'business'
);


ALTER TYPE public.users_customer_type_enum OWNER TO postgres;

--
-- TOC entry 372 (class 1255 OID 17626)
-- Name: products_search_vec_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vec_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.search_vec :=
      setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.product_name,''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.short_description,''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.long_description,''))), 'C')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.specs::text,''))), 'C')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.origin,''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.user_manual,''))), 'D')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.caution_notes,''))), 'D');
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.products_search_vec_update() OWNER TO postgres;

--
-- TOC entry 496 (class 1255 OID 18230)
-- Name: trg_set_timestamp_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_set_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_set_timestamp_updated_at() OWNER TO postgres;

--
-- TOC entry 403 (class 1255 OID 17152)
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
-- TOC entry 219 (class 1259 OID 17826)
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
-- TOC entry 220 (class 1259 OID 17832)
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
-- TOC entry 4117 (class 0 OID 0)
-- Dependencies: 220
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;


--
-- TOC entry 221 (class 1259 OID 17833)
-- Name: attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attributes (
    attribute_id integer NOT NULL,
    attribute_name character varying(100) NOT NULL,
    value_type character varying(20) NOT NULL
);


ALTER TABLE public.attributes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17836)
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
-- TOC entry 4118 (class 0 OID 0)
-- Dependencies: 222
-- Name: attributes_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attributes_attribute_id_seq OWNED BY public.attributes.attribute_id;


--
-- TOC entry 223 (class 1259 OID 17837)
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
-- TOC entry 224 (class 1259 OID 17840)
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
-- TOC entry 4119 (class 0 OID 0)
-- Dependencies: 224
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_cart_item_id_seq OWNED BY public.cart_items.cart_item_id;


--
-- TOC entry 225 (class 1259 OID 17841)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    cart_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17845)
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
-- TOC entry 4120 (class 0 OID 0)
-- Dependencies: 226
-- Name: carts_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_cart_id_seq OWNED BY public.carts.cart_id;


--
-- TOC entry 227 (class 1259 OID 17846)
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
-- TOC entry 228 (class 1259 OID 17851)
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
-- TOC entry 4121 (class 0 OID 0)
-- Dependencies: 228
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- TOC entry 229 (class 1259 OID 17852)
-- Name: category_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category_attributes (
    category_id integer NOT NULL,
    attribute_id integer NOT NULL
);


ALTER TABLE public.category_attributes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17855)
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
-- TOC entry 231 (class 1259 OID 17863)
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
-- TOC entry 232 (class 1259 OID 17870)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17875)
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
-- TOC entry 4122 (class 0 OID 0)
-- Dependencies: 233
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 234 (class 1259 OID 17876)
-- Name: option_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_types (
    option_type_id integer NOT NULL,
    name character varying(100) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.option_types OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17880)
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
-- TOC entry 4123 (class 0 OID 0)
-- Dependencies: 235
-- Name: option_types_option_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_types_option_type_id_seq OWNED BY public.option_types.option_type_id;


--
-- TOC entry 236 (class 1259 OID 17881)
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
-- TOC entry 237 (class 1259 OID 17885)
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
-- TOC entry 4124 (class 0 OID 0)
-- Dependencies: 237
-- Name: option_values_option_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_values_option_value_id_seq OWNED BY public.option_values.option_value_id;


--
-- TOC entry 238 (class 1259 OID 17886)
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
-- TOC entry 239 (class 1259 OID 17889)
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
-- TOC entry 4125 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- TOC entry 240 (class 1259 OID 17890)
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
-- TOC entry 241 (class 1259 OID 17898)
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
-- TOC entry 4126 (class 0 OID 0)
-- Dependencies: 241
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- TOC entry 242 (class 1259 OID 17899)
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
-- TOC entry 243 (class 1259 OID 17907)
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
-- TOC entry 244 (class 1259 OID 17913)
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
-- TOC entry 4127 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_images_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_images_image_id_seq OWNED BY public.product_images.image_id;


--
-- TOC entry 245 (class 1259 OID 17914)
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
-- TOC entry 246 (class 1259 OID 17920)
-- Name: product_variant_option_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option_values (
    variant_id integer NOT NULL,
    option_value_id integer NOT NULL
);


ALTER TABLE public.product_variant_option_values OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17923)
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
-- TOC entry 248 (class 1259 OID 17932)
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
-- TOC entry 4128 (class 0 OID 0)
-- Dependencies: 248
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variant_prices_price_id_seq OWNED BY public.product_variant_prices.price_id;


--
-- TOC entry 268 (class 1259 OID 18354)
-- Name: product_variant_rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_rental (
    id integer NOT NULL,
    rental_price_id integer,
    quantity integer,
    start_date date,
    end_date date,
    product_id integer
);


ALTER TABLE public.product_variant_rental OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 18353)
-- Name: product_variant_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_variant_rental_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_rental_id_seq OWNER TO postgres;

--
-- TOC entry 4129 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_variant_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variant_rental_id_seq OWNED BY public.product_variant_rental.id;


--
-- TOC entry 266 (class 1259 OID 18347)
-- Name: product_variant_rental_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_rental_prices (
    rental_price_id integer NOT NULL,
    variant_rental_id integer NOT NULL,
    rental_type character varying(50),
    price numeric(12,2),
    deposit numeric(12,2),
    start_at timestamp without time zone,
    end_at timestamp without time zone
);


ALTER TABLE public.product_variant_rental_prices OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 18346)
-- Name: product_variant_rental_prices_rental_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_variant_rental_prices_rental_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_rental_prices_rental_price_id_seq OWNER TO postgres;

--
-- TOC entry 4130 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_variant_rental_prices_rental_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variant_rental_prices_rental_price_id_seq OWNED BY public.product_variant_rental_prices.rental_price_id;


--
-- TOC entry 249 (class 1259 OID 17933)
-- Name: product_variants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variants (
    variant_id integer NOT NULL,
    product_id integer NOT NULL,
    variant_name character varying(255) NOT NULL,
    sku character varying(50),
    barcode character varying(64),
    status integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    image_url text
);


ALTER TABLE public.product_variants OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17942)
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
-- TOC entry 4131 (class 0 OID 0)
-- Dependencies: 250
-- Name: product_variants_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_variants_variant_id_seq OWNED BY public.product_variants.variant_id;


--
-- TOC entry 251 (class 1259 OID 17943)
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
-- TOC entry 252 (class 1259 OID 17952)
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
-- TOC entry 4132 (class 0 OID 0)
-- Dependencies: 252
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 253 (class 1259 OID 17953)
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
-- TOC entry 254 (class 1259 OID 17956)
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
-- TOC entry 4133 (class 0 OID 0)
-- Dependencies: 254
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotion_applicability_applicability_id_seq OWNED BY public.promotion_applicability.applicability_id;


--
-- TOC entry 255 (class 1259 OID 17957)
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
-- TOC entry 256 (class 1259 OID 17963)
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
-- TOC entry 4134 (class 0 OID 0)
-- Dependencies: 256
-- Name: promotions_promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_promotion_id_seq OWNED BY public.promotions.promotion_id;


--
-- TOC entry 264 (class 1259 OID 18233)
-- Name: rental_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rental_order_items (
    id integer NOT NULL,
    rental_order_id integer NOT NULL,
    variant_id integer NOT NULL,
    rental_type character varying(20),
    price numeric(12,2) NOT NULL,
    deposit numeric(12,2) DEFAULT 0 NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    start_date date,
    end_date date,
    returned_at date,
    return_status character varying(20),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    variant_rental_id integer,
    CONSTRAINT chk_rental_item_dates CHECK (((start_date IS NULL) OR (end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT chk_rental_item_deposit_nonneg CHECK ((deposit >= (0)::numeric)),
    CONSTRAINT chk_rental_item_price_nonneg CHECK ((price >= (0)::numeric)),
    CONSTRAINT chk_rental_item_qty_pos CHECK ((quantity > 0))
);


ALTER TABLE public.rental_order_items OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 18232)
-- Name: rental_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rental_order_items ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rental_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 262 (class 1259 OID 18212)
-- Name: rental_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rental_orders (
    id_rental_order integer NOT NULL,
    user_id integer NOT NULL,
    total_price numeric(12,2) DEFAULT 0 NOT NULL,
    total_deposit numeric(12,2) DEFAULT 0 NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying NOT NULL,
    note text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rental_orders OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 18211)
-- Name: rental_orders_id_rental_order_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rental_orders ALTER COLUMN id_rental_order ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rental_orders_id_rental_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 257 (class 1259 OID 17964)
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
-- TOC entry 258 (class 1259 OID 17967)
-- Name: user_profile_individual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profile_individual (
    user_id integer NOT NULL,
    full_name character varying(50) NOT NULL,
    date_of_birth date
);


ALTER TABLE public.user_profile_individual OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 17970)
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
-- TOC entry 260 (class 1259 OID 17978)
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
-- TOC entry 4135 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3734 (class 2604 OID 17979)
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- TOC entry 3736 (class 2604 OID 17980)
-- Name: attributes attribute_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes ALTER COLUMN attribute_id SET DEFAULT nextval('public.attributes_attribute_id_seq'::regclass);


--
-- TOC entry 3737 (class 2604 OID 17981)
-- Name: cart_items cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_items_cart_item_id_seq'::regclass);


--
-- TOC entry 3738 (class 2604 OID 17982)
-- Name: carts cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN cart_id SET DEFAULT nextval('public.carts_cart_id_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 17983)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 17984)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3747 (class 2604 OID 17985)
-- Name: option_types option_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types ALTER COLUMN option_type_id SET DEFAULT nextval('public.option_types_option_type_id_seq'::regclass);


--
-- TOC entry 3749 (class 2604 OID 17986)
-- Name: option_values option_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values ALTER COLUMN option_value_id SET DEFAULT nextval('public.option_values_option_value_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 17987)
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 17988)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 3759 (class 2604 OID 17989)
-- Name: product_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN image_id SET DEFAULT nextval('public.product_images_image_id_seq'::regclass);


--
-- TOC entry 3764 (class 2604 OID 17990)
-- Name: product_variant_prices price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices ALTER COLUMN price_id SET DEFAULT nextval('public.product_variant_prices_price_id_seq'::regclass);


--
-- TOC entry 3794 (class 2604 OID 18357)
-- Name: product_variant_rental id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental ALTER COLUMN id SET DEFAULT nextval('public.product_variant_rental_id_seq'::regclass);


--
-- TOC entry 3793 (class 2604 OID 18350)
-- Name: product_variant_rental_prices rental_price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental_prices ALTER COLUMN rental_price_id SET DEFAULT nextval('public.product_variant_rental_prices_rental_price_id_seq'::regclass);


--
-- TOC entry 3768 (class 2604 OID 17991)
-- Name: product_variants variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN variant_id SET DEFAULT nextval('public.product_variants_variant_id_seq'::regclass);


--
-- TOC entry 3772 (class 2604 OID 17992)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3777 (class 2604 OID 17993)
-- Name: promotion_applicability applicability_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability ALTER COLUMN applicability_id SET DEFAULT nextval('public.promotion_applicability_applicability_id_seq'::regclass);


--
-- TOC entry 3778 (class 2604 OID 17994)
-- Name: promotions promotion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promotion_id SET DEFAULT nextval('public.promotions_promotion_id_seq'::regclass);


--
-- TOC entry 3780 (class 2604 OID 17995)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4058 (class 0 OID 17826)
-- Dependencies: 219
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId") FROM stdin;
\.


--
-- TOC entry 4060 (class 0 OID 17833)
-- Dependencies: 221
-- Data for Name: attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attributes (attribute_id, attribute_name, value_type) FROM stdin;
\.


--
-- TOC entry 4062 (class 0 OID 17837)
-- Dependencies: 223
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (cart_item_id, quantity, cart_id, product_id) FROM stdin;
\.


--
-- TOC entry 4064 (class 0 OID 17841)
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
-- TOC entry 4066 (class 0 OID 17846)
-- Dependencies: 227
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name, description, parent_category_id) FROM stdin;
8	Tivi	\N	\N
9	LG	\N	8
12	Simplehome 	\N	8
13	Robot	\N	\N
14	STEM 	\N	\N
15	Laptob	\N	\N
16	Tablet	\N	\N
17	Máy bàn 	\N	\N
18	Kệ trưng bày 	\N	\N
19	Tấm năng lượng mặt trời và tích trữ.	\N	\N
20	Bàn ghế	\N	\N
\.


--
-- TOC entry 4068 (class 0 OID 17852)
-- Dependencies: 229
-- Data for Name: category_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_attributes (category_id, attribute_id) FROM stdin;
\.


--
-- TOC entry 4069 (class 0 OID 17855)
-- Dependencies: 230
-- Data for Name: customer_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_services (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4070 (class 0 OID 17863)
-- Dependencies: 231
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, name, email, message, "createdAt") FROM stdin;
\.


--
-- TOC entry 4071 (class 0 OID 17870)
-- Dependencies: 232
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1693234567890	InitFullEavSchema1693234567890
2	1693234567890	InitFullEavSchema1693234567890
\.


--
-- TOC entry 4073 (class 0 OID 17876)
-- Dependencies: 234
-- Data for Name: option_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_types (option_type_id, name, "position") FROM stdin;
1	Color	1
2	Size	2
\.


--
-- TOC entry 4075 (class 0 OID 17881)
-- Dependencies: 236
-- Data for Name: option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_values (option_value_id, option_type_id, value, "position") FROM stdin;
1	1	Red	1
2	1	Blue	2
3	1	Green	3
4	2	S	1
5	2	M	2
6	2	L	3
\.


--
-- TOC entry 4077 (class 0 OID 17886)
-- Dependencies: 238
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) FROM stdin;
107	1	5990000.00	30	31
108	1	5990000.00	31	30
109	1	5990000.00	32	31
\.


--
-- TOC entry 4079 (class 0 OID 17890)
-- Dependencies: 240
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) FROM stdin;
30	5990000.00	0.00	5990000.00	Pending	2025-10-27 01:15:42.387878	86	\N
31	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:35:48.97484	86	\N
32	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:36:33.918068	86	\N
\.


--
-- TOC entry 4081 (class 0 OID 17899)
-- Dependencies: 242
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policies (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4082 (class 0 OID 17907)
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
-- TOC entry 4084 (class 0 OID 17914)
-- Dependencies: 245
-- Data for Name: product_variant_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory (variant_id, stock_quantity, safety_stock, updated_at) FROM stdin;
\.


--
-- TOC entry 4085 (class 0 OID 17920)
-- Dependencies: 246
-- Data for Name: product_variant_option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option_values (variant_id, option_value_id) FROM stdin;
4	1
4	4
5	1
5	5
6	2
6	5
7	3
7	6
\.


--
-- TOC entry 4086 (class 0 OID 17923)
-- Dependencies: 247
-- Data for Name: product_variant_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_prices (price_id, variant_id, price_type, currency_code, price, start_at, end_at, created_at) FROM stdin;
2	2	retail	VND	129000.00	2025-11-10 02:56:28.529266	\N	2025-11-10 02:56:28.529266
3	2	sale	VND	119000.00	2025-11-10 02:56:28.529266	2025-11-17 02:56:28.529266	2025-11-10 02:56:28.529266
4	3	retail	VND	129000.00	2025-11-10 09:35:11.057018	\N	2025-11-10 09:35:11.057018
\.


--
-- TOC entry 4107 (class 0 OID 18354)
-- Dependencies: 268
-- Data for Name: product_variant_rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_rental (id, rental_price_id, quantity, start_date, end_date, product_id) FROM stdin;
\.


--
-- TOC entry 4105 (class 0 OID 18347)
-- Dependencies: 266
-- Data for Name: product_variant_rental_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_rental_prices (rental_price_id, variant_rental_id, rental_type, price, deposit, start_at, end_at) FROM stdin;
\.


--
-- TOC entry 4088 (class 0 OID 17933)
-- Dependencies: 249
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (variant_id, product_id, variant_name, sku, barcode, status, created_at, updated_at, image_url) FROM stdin;
3	34	Áo thun − Đen / L	TSHIRT-101-BLK-L	8931234500002	1	2025-11-10 02:53:00.27783	2025-11-10 02:53:00.27783	\N
2	34	Áo thun − Xanh / M	TSHIRT-101-BLU-M	8931234500001	1	2025-11-10 02:53:00.27783	2025-11-10 02:53:00.27783	https://cdn11.dienmaycholon.vn/filewebdmclnew/DMCL21/Picture//Apro/Apro_product_34452/quat-de-ban-co-sac-tich-dien-perfect-pfqb2150-main-34452.png
4	34	Rio T-Shirt - Red - S	RIO-RED-S	111111	1	2025-11-10 07:16:47.069167	2025-11-10 07:16:47.069167	https://example.com/images/red-s.jpg
5	34	Rio T-Shirt - Red - M	RIO-RED-M	111112	1	2025-11-10 07:16:47.069167	2025-11-10 07:16:47.069167	https://example.com/images/red-m.jpg
6	34	Rio T-Shirt - Blue - M	RIO-BLUE-M	111113	1	2025-11-10 07:16:47.069167	2025-11-10 07:16:47.069167	https://example.com/images/blue-m.jpg
7	34	Rio T-Shirt - Green - L	RIO-GREEN-L	111114	1	2025-11-10 07:16:47.069167	2025-11-10 07:16:47.069167	https://example.com/images/green-l.jpg
\.


--
-- TOC entry 4090 (class 0 OID 17943)
-- Dependencies: 251
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, sku, long_description, short_description, status, price, stock_quantity, created_at, updated_at, category_id, search_vec, specs, origin, user_manual, caution_notes) FROM stdin;
34	Quạt Mini USB để bàn	QUAT-MINI-001	Quạt để bàn chạy USB, gió mạnh, ít tiếng ồn.	Quạt mini USB	1	129000.00	50	2025-11-10 02:51:19.251967	2025-11-10 02:51:19.251967	9	'12cm':20C '5w':24C 'am':40 'ban':5A,11C 'bat':33 'cam':27 'chay':12C 'color':21C 'cong':34 'day':28 'de':4A,10C,37 'gan':38 'gio':14C 'it':16C 'khong':36 'manh':15C 'mini':2A,7B 'nam':26B 'nguon':31 'noi':39 'on':18C 'power':23C 'quat':1A,6B,9C 'size':19C 'tac':35 'tieng':17C 'uot':41 'usb':3A,8B,13C,29 'va':32 'vao':30 'viet':25B 'white':22C	{"size": "12cm", "color": "white", "power": "5W"}	Việt Nam	Cắm dây USB vào nguồn và bật công tắc.	Không để gần nơi ẩm ướt.
\.


--
-- TOC entry 4092 (class 0 OID 17953)
-- Dependencies: 253
-- Data for Name: promotion_applicability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_applicability (applicability_id, promotion_id, product_id, category_id) FROM stdin;
\.


--
-- TOC entry 4094 (class 0 OID 17957)
-- Dependencies: 255
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, name, description, discount_type, discount_value, start_date, end_date, is_active) FROM stdin;
\.


--
-- TOC entry 4103 (class 0 OID 18233)
-- Dependencies: 264
-- Data for Name: rental_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rental_order_items (id, rental_order_id, variant_id, rental_type, price, deposit, quantity, start_date, end_date, returned_at, return_status, created_at, updated_at, variant_rental_id) FROM stdin;
\.


--
-- TOC entry 4101 (class 0 OID 18212)
-- Dependencies: 262
-- Data for Name: rental_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rental_orders (id_rental_order, user_id, total_price, total_deposit, status, note, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4096 (class 0 OID 17964)
-- Dependencies: 257
-- Data for Name: user_profile_business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_business (user_id, company_name, tax_id, email) FROM stdin;
\.


--
-- TOC entry 4097 (class 0 OID 17967)
-- Dependencies: 258
-- Data for Name: user_profile_individual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_individual (user_id, full_name, date_of_birth) FROM stdin;
84	Nguyen Xuan Danh	2025-09-05
86	Nguyen Danh	\N
\.


--
-- TOC entry 4098 (class 0 OID 17970)
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
-- TOC entry 4136 (class 0 OID 0)
-- Dependencies: 220
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 23, true);


--
-- TOC entry 4137 (class 0 OID 0)
-- Dependencies: 222
-- Name: attributes_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attributes_attribute_id_seq', 1, false);


--
-- TOC entry 4138 (class 0 OID 0)
-- Dependencies: 224
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_cart_item_id_seq', 23, true);


--
-- TOC entry 4139 (class 0 OID 0)
-- Dependencies: 226
-- Name: carts_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_cart_id_seq', 21, true);


--
-- TOC entry 4140 (class 0 OID 0)
-- Dependencies: 228
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 20, true);


--
-- TOC entry 4141 (class 0 OID 0)
-- Dependencies: 233
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);


--
-- TOC entry 4142 (class 0 OID 0)
-- Dependencies: 235
-- Name: option_types_option_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_types_option_type_id_seq', 1, false);


--
-- TOC entry 4143 (class 0 OID 0)
-- Dependencies: 237
-- Name: option_values_option_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_values_option_value_id_seq', 1, false);


--
-- TOC entry 4144 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 109, true);


--
-- TOC entry 4145 (class 0 OID 0)
-- Dependencies: 241
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 32, true);


--
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_image_id_seq', 46, true);


--
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 248
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_prices_price_id_seq', 4, true);


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_variant_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_rental_id_seq', 1, false);


--
-- TOC entry 4149 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_variant_rental_prices_rental_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_rental_prices_rental_price_id_seq', 1, false);


--
-- TOC entry 4150 (class 0 OID 0)
-- Dependencies: 250
-- Name: product_variants_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variants_variant_id_seq', 7, true);


--
-- TOC entry 4151 (class 0 OID 0)
-- Dependencies: 252
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 34, true);


--
-- TOC entry 4152 (class 0 OID 0)
-- Dependencies: 254
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_applicability_applicability_id_seq', 1, false);


--
-- TOC entry 4153 (class 0 OID 0)
-- Dependencies: 256
-- Name: promotions_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promotion_id_seq', 1, false);


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 263
-- Name: rental_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rental_order_items_id_seq', 1, false);


--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 261
-- Name: rental_orders_id_rental_order_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rental_orders_id_rental_order_seq', 1, false);


--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 86, true);


--
-- TOC entry 3864 (class 2606 OID 17997)
-- Name: user_profile_individual PK_059f53ecf53e772aa79eb3c57f1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "PK_059f53ecf53e772aa79eb3c57f1" PRIMARY KEY (user_id);


--
-- TOC entry 3807 (class 2606 OID 17999)
-- Name: cart_items PK_136052dba9e33c62b93c6a291f8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "PK_136052dba9e33c62b93c6a291f8" PRIMARY KEY (cart_item_id);


--
-- TOC entry 3837 (class 2606 OID 18001)
-- Name: product_images PK_2212515ba306c79f42c46a99db7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "PK_2212515ba306c79f42c46a99db7" PRIMARY KEY (image_id);


--
-- TOC entry 3809 (class 2606 OID 18003)
-- Name: carts PK_2fb47cbe0c6f182bb31c66689e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "PK_2fb47cbe0c6f182bb31c66689e9" PRIMARY KEY (cart_id);


--
-- TOC entry 3803 (class 2606 OID 18005)
-- Name: attributes PK_3225fe233475419d420a293d5d6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "PK_3225fe233475419d420a293d5d6" PRIMARY KEY (attribute_id);


--
-- TOC entry 3813 (class 2606 OID 18007)
-- Name: categories PK_51615bef2cea22812d0dcab6e18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_51615bef2cea22812d0dcab6e18" PRIMARY KEY (category_id);


--
-- TOC entry 3831 (class 2606 OID 18009)
-- Name: order_items PK_54c952fdc94b9b487ef968b4047; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_54c952fdc94b9b487ef968b4047" PRIMARY KEY (order_item_id);


--
-- TOC entry 3817 (class 2606 OID 18011)
-- Name: customer_services PK_56089dcf272f4aca67b6ce27a8b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "PK_56089dcf272f4aca67b6ce27a8b" PRIMARY KEY (id);


--
-- TOC entry 3835 (class 2606 OID 18013)
-- Name: policies PK_603e09f183df0108d8695c57e28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT "PK_603e09f183df0108d8695c57e28" PRIMARY KEY (id);


--
-- TOC entry 3801 (class 2606 OID 18015)
-- Name: addresses PK_7075006c2d82acfeb0ea8c5dce7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_7075006c2d82acfeb0ea8c5dce7" PRIMARY KEY (address_id);


--
-- TOC entry 3823 (class 2606 OID 18017)
-- Name: feedback PK_8389f9e087a57689cd5be8b2b13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT "PK_8389f9e087a57689cd5be8b2b13" PRIMARY KEY (id);


--
-- TOC entry 3825 (class 2606 OID 18019)
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- TOC entry 3866 (class 2606 OID 18021)
-- Name: users PK_96aac72f1574b88752e9fb00089; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_96aac72f1574b88752e9fb00089" PRIMARY KEY (user_id);


--
-- TOC entry 3853 (class 2606 OID 18023)
-- Name: products PK_a8940a4bf3b90bd7ac15c8f4dd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_a8940a4bf3b90bd7ac15c8f4dd9" PRIMARY KEY (product_id);


--
-- TOC entry 3862 (class 2606 OID 18025)
-- Name: user_profile_business PK_ad95ecfa0d8f92b9b3c5c025375; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "PK_ad95ecfa0d8f92b9b3c5c025375" PRIMARY KEY (user_id);


--
-- TOC entry 3833 (class 2606 OID 18027)
-- Name: orders PK_cad55b3cb25b38be94d2ce831db; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_cad55b3cb25b38be94d2ce831db" PRIMARY KEY (order_id);


--
-- TOC entry 3815 (class 2606 OID 18029)
-- Name: category_attributes PK_e135f7d323a2899937cd2a2cb7b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "PK_e135f7d323a2899937cd2a2cb7b" PRIMARY KEY (category_id, attribute_id);


--
-- TOC entry 3860 (class 2606 OID 18031)
-- Name: promotions PK_e151ef85c700deef77ec80ff13a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "PK_e151ef85c700deef77ec80ff13a" PRIMARY KEY (promotion_id);


--
-- TOC entry 3858 (class 2606 OID 18033)
-- Name: promotion_applicability PK_e76ef1dcb40f4f690c444052917; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "PK_e76ef1dcb40f4f690c444052917" PRIMARY KEY (applicability_id);


--
-- TOC entry 3811 (class 2606 OID 18035)
-- Name: carts REL_2ec1c94a977b940d85a4f498ae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "REL_2ec1c94a977b940d85a4f498ae" UNIQUE (user_id);


--
-- TOC entry 3819 (class 2606 OID 18037)
-- Name: customer_services UQ_06ef5acfc04805b8783b2885328; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_06ef5acfc04805b8783b2885328" UNIQUE (title);


--
-- TOC entry 3868 (class 2606 OID 18039)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 3821 (class 2606 OID 18041)
-- Name: customer_services UQ_c0c13d2e89510645f36044cc989; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_c0c13d2e89510645f36044cc989" UNIQUE (slug);


--
-- TOC entry 3855 (class 2606 OID 18043)
-- Name: products UQ_c44ac33a05b144dd0d9ddcf9327; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "UQ_c44ac33a05b144dd0d9ddcf9327" UNIQUE (sku);


--
-- TOC entry 3805 (class 2606 OID 18045)
-- Name: attributes UQ_e8ab1373d517dbee20df5430bb0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "UQ_e8ab1373d517dbee20df5430bb0" UNIQUE (attribute_name);


--
-- TOC entry 3870 (class 2606 OID 18047)
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- TOC entry 3843 (class 2606 OID 18049)
-- Name: product_variant_prices ex_variant_price_unique_window; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT ex_variant_price_unique_window EXCLUDE USING gist (variant_id WITH =, price_type WITH =, tsrange(start_at, COALESCE(end_at, 'infinity'::timestamp without time zone), '[)'::text) WITH &&);


--
-- TOC entry 3827 (class 2606 OID 18051)
-- Name: option_types option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types
    ADD CONSTRAINT option_types_pkey PRIMARY KEY (option_type_id);


--
-- TOC entry 3829 (class 2606 OID 18053)
-- Name: option_values option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (option_value_id);


--
-- TOC entry 3839 (class 2606 OID 18055)
-- Name: product_variant_inventory product_variant_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3841 (class 2606 OID 18057)
-- Name: product_variant_option_values product_variant_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- TOC entry 3845 (class 2606 OID 18059)
-- Name: product_variant_prices product_variant_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_pkey PRIMARY KEY (price_id);


--
-- TOC entry 3879 (class 2606 OID 18359)
-- Name: product_variant_rental product_variant_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT product_variant_rental_pkey PRIMARY KEY (id);


--
-- TOC entry 3877 (class 2606 OID 18352)
-- Name: product_variant_rental_prices product_variant_rental_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental_prices
    ADD CONSTRAINT product_variant_rental_prices_pkey PRIMARY KEY (rental_price_id);


--
-- TOC entry 3849 (class 2606 OID 18061)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3851 (class 2606 OID 18063)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 3873 (class 2606 OID 18223)
-- Name: rental_orders rental_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT rental_orders_pkey PRIMARY KEY (id_rental_order);


--
-- TOC entry 3846 (class 1259 OID 18064)
-- Name: idx_product_variants_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_product_id ON public.product_variants USING btree (product_id);


--
-- TOC entry 3847 (class 1259 OID 18065)
-- Name: idx_product_variants_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_status ON public.product_variants USING btree (status);


--
-- TOC entry 3874 (class 1259 OID 18256)
-- Name: idx_rental_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_item_order_id ON public.rental_order_items USING btree (rental_order_id);


--
-- TOC entry 3875 (class 1259 OID 18257)
-- Name: idx_rental_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_item_variant_id ON public.rental_order_items USING btree (variant_id);


--
-- TOC entry 3871 (class 1259 OID 18229)
-- Name: idx_rental_orders_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_orders_user_id ON public.rental_orders USING btree (user_id);


--
-- TOC entry 3856 (class 1259 OID 18066)
-- Name: products_search_vec_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_search_vec_idx ON public.products USING gin (search_vec);


--
-- TOC entry 3910 (class 2620 OID 18067)
-- Name: products products_search_vec_tg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER products_search_vec_tg BEFORE INSERT OR UPDATE OF product_name, sku, short_description, long_description, specs, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3911 (class 2620 OID 18068)
-- Name: products trg_products_search_vec; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec BEFORE INSERT OR UPDATE OF product_name, sku, short_description, long_description, specs, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3912 (class 2620 OID 18069)
-- Name: products trg_products_search_vec_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec_update BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3914 (class 2620 OID 18258)
-- Name: rental_order_items trg_rental_order_items_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rental_order_items_set_updated_at BEFORE UPDATE ON public.rental_order_items FOR EACH ROW EXECUTE FUNCTION public.trg_set_timestamp_updated_at();


--
-- TOC entry 3913 (class 2620 OID 18231)
-- Name: rental_orders trg_rental_orders_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rental_orders_set_updated_at BEFORE UPDATE ON public.rental_orders FOR EACH ROW EXECUTE FUNCTION public.trg_set_timestamp_updated_at();


--
-- TOC entry 3903 (class 2606 OID 18070)
-- Name: user_profile_individual FK_059f53ecf53e772aa79eb3c57f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "FK_059f53ecf53e772aa79eb3c57f1" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3880 (class 2606 OID 18075)
-- Name: addresses FK_0cb4a718cc49a5bc41bf4f950e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_0cb4a718cc49a5bc41bf4f950e8" FOREIGN KEY ("userUserId") REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3888 (class 2606 OID 18080)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 3883 (class 2606 OID 18085)
-- Name: carts FK_2ec1c94a977b940d85a4f498aea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "FK_2ec1c94a977b940d85a4f498aea" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3881 (class 2606 OID 18090)
-- Name: cart_items FK_30e89257a105eab7648a35c7fce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_30e89257a105eab7648a35c7fce" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3885 (class 2606 OID 18100)
-- Name: category_attributes FK_55050a8a1b2d2f5202f226d4ac1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_55050a8a1b2d2f5202f226d4ac1" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3882 (class 2606 OID 18105)
-- Name: cart_items FK_6385a745d9e12a89b859bb25623; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_6385a745d9e12a89b859bb25623" FOREIGN KEY (cart_id) REFERENCES public.carts(cart_id) ON DELETE CASCADE;


--
-- TOC entry 3886 (class 2606 OID 18110)
-- Name: category_attributes FK_6730826326fa81ff5511cb0981a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_6730826326fa81ff5511cb0981a" FOREIGN KEY (attribute_id) REFERENCES public.attributes(attribute_id) ON DELETE CASCADE;


--
-- TOC entry 3898 (class 2606 OID 18120)
-- Name: products FK_9a5f6868c96e0069e699f33e124; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_9a5f6868c96e0069e699f33e124" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3889 (class 2606 OID 18125)
-- Name: orders FK_a922b820eeef29ac1c6800e826a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_a922b820eeef29ac1c6800e826a" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- TOC entry 3902 (class 2606 OID 18130)
-- Name: user_profile_business FK_ad95ecfa0d8f92b9b3c5c025375; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "FK_ad95ecfa0d8f92b9b3c5c025375" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3899 (class 2606 OID 18135)
-- Name: promotion_applicability FK_bccec24fb5216b1dd58b643a8dc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_bccec24fb5216b1dd58b643a8dc" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3884 (class 2606 OID 18140)
-- Name: categories FK_de08738901be6b34d2824a1e243; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "FK_de08738901be6b34d2824a1e243" FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- TOC entry 3900 (class 2606 OID 18145)
-- Name: promotion_applicability FK_e8045fc739f5da9b5b8e2bff562; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_e8045fc739f5da9b5b8e2bff562" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3901 (class 2606 OID 18150)
-- Name: promotion_applicability FK_eb83792e55a6d9d50bcd60d2701; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_eb83792e55a6d9d50bcd60d2701" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 3890 (class 2606 OID 18155)
-- Name: orders FK_ef840932f45535891306fc3f327; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_ef840932f45535891306fc3f327" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE SET NULL;


--
-- TOC entry 3904 (class 2606 OID 18329)
-- Name: rental_orders fk_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT fk_customer FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3906 (class 2606 OID 18246)
-- Name: rental_order_items fk_rental_item_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_order_items
    ADD CONSTRAINT fk_rental_item_order FOREIGN KEY (rental_order_id) REFERENCES public.rental_orders(id_rental_order) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3907 (class 2606 OID 18370)
-- Name: rental_order_items fk_rental_order_items_variant_rental; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_order_items
    ADD CONSTRAINT fk_rental_order_items_variant_rental FOREIGN KEY (variant_rental_id) REFERENCES public.product_variant_rental(id) ON DELETE CASCADE;


--
-- TOC entry 3905 (class 2606 OID 18224)
-- Name: rental_orders fk_rental_orders_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT fk_rental_orders_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3908 (class 2606 OID 18365)
-- Name: product_variant_rental fk_rentals_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT fk_rentals_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3891 (class 2606 OID 18165)
-- Name: product_variant_inventory fk_variant_inventory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT fk_variant_inventory FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3895 (class 2606 OID 18175)
-- Name: product_variant_prices fk_variant_price; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT fk_variant_price FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3887 (class 2606 OID 18180)
-- Name: option_values option_values_option_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_option_type_id_fkey FOREIGN KEY (option_type_id) REFERENCES public.option_types(option_type_id) ON DELETE CASCADE;


--
-- TOC entry 3892 (class 2606 OID 18185)
-- Name: product_variant_inventory product_variant_inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3893 (class 2606 OID 18190)
-- Name: product_variant_option_values product_variant_option_values_option_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_option_value_id_fkey FOREIGN KEY (option_value_id) REFERENCES public.option_values(option_value_id) ON DELETE CASCADE;


--
-- TOC entry 3894 (class 2606 OID 18195)
-- Name: product_variant_option_values product_variant_option_values_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3896 (class 2606 OID 18200)
-- Name: product_variant_prices product_variant_prices_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3909 (class 2606 OID 18360)
-- Name: product_variant_rental product_variant_rental_rental_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT product_variant_rental_rental_price_id_fkey FOREIGN KEY (rental_price_id) REFERENCES public.product_variant_rental_prices(rental_price_id) ON DELETE CASCADE;


--
-- TOC entry 3897 (class 2606 OID 18205)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


-- Completed on 2025-11-10 21:41:57

--
-- PostgreSQL database dump complete
--

\unrestrict nHAySW0fk7bCYYeCzDKpgUSXSsyTTMAp0Qgiq0ZgdWGacIOSqSwTD41cag67gGm

-- Completed on 2025-11-10 21:41:57

--
-- PostgreSQL database cluster dump complete
--

