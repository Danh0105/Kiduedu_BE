--
-- PostgreSQL database cluster dump
--

-- Started on 2025-11-11 21:50:37

\restrict tzL7avlWu89jXfg7DpnvJ0rvRXchV2IHxjjRkGYKLROfhemz972hG6aGce3u9NA

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








\unrestrict tzL7avlWu89jXfg7DpnvJ0rvRXchV2IHxjjRkGYKLROfhemz972hG6aGce3u9NA

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

\restrict fD0fPZiC2JFMVV5mKPWKojgqRoihBzzm2e73VnjoSwvzAarcJZZpdxWy5Sgp21e

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-11 21:50:38

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

-- Completed on 2025-11-11 21:50:38

--
-- PostgreSQL database dump complete
--

\unrestrict fD0fPZiC2JFMVV5mKPWKojgqRoihBzzm2e73VnjoSwvzAarcJZZpdxWy5Sgp21e

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict mNaBu41gow9uaY8IPFjnh8clYfd2jtlknkfVcrjkZGaWodZyRehXQ9OAt4iNgzx

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-11 21:50:38

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
-- TOC entry 4124 (class 0 OID 0)
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
-- TOC entry 4125 (class 0 OID 0)
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
-- TOC entry 4126 (class 0 OID 0)
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
-- TOC entry 4127 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1152 (class 1247 OID 17140)
-- Name: promotions_discount_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promotions_discount_type_enum AS ENUM (
    'percentage',
    'fixed_amount'
);


ALTER TYPE public.promotions_discount_type_enum OWNER TO postgres;

--
-- TOC entry 1242 (class 1247 OID 18268)
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
-- TOC entry 1239 (class 1247 OID 18260)
-- Name: rental_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.rental_type_enum AS ENUM (
    'daily',
    'weekly',
    'monthly'
);


ALTER TYPE public.rental_type_enum OWNER TO postgres;

--
-- TOC entry 1155 (class 1247 OID 17146)
-- Name: users_customer_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_customer_type_enum AS ENUM (
    'individual',
    'business'
);


ALTER TYPE public.users_customer_type_enum OWNER TO postgres;

--
-- TOC entry 323 (class 1255 OID 18393)
-- Name: products_search_vec_tg_fn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vec_tg_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.search_vec :=
    setweight(to_tsvector('simple', public.unaccent_imm(coalesce(NEW.product_name,''))), 'A')
    || setweight(
         to_tsvector('simple',
           public.unaccent_imm(regexp_replace(coalesce(NEW.short_description,''), '<[^>]+>', ' ', 'g'))
         ),
         'B'
       )
    || setweight(
         to_tsvector('simple',
           public.unaccent_imm(regexp_replace(coalesce(NEW.long_description,''), '<[^>]+>', ' ', 'g'))
         ),
         'C'
       );
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.products_search_vec_tg_fn() OWNER TO postgres;

--
-- TOC entry 374 (class 1255 OID 17626)
-- Name: products_search_vec_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.products_search_vec_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.search_vec :=
      setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.product_name, ''))), 'A')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.short_description, ''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.long_description, ''))), 'C')
    -- || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.specs::text, ''))), 'C')  -- removed
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.origin, ''))), 'B')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.user_manual, ''))), 'D')
    || setweight(to_tsvector('simple', public.unaccent_imm(COALESCE(NEW.caution_notes, ''))), 'D');

  RETURN NEW;
END$$;


ALTER FUNCTION public.products_search_vec_update() OWNER TO postgres;

--
-- TOC entry 498 (class 1255 OID 18230)
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
-- TOC entry 405 (class 1255 OID 17152)
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
-- TOC entry 4128 (class 0 OID 0)
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
-- TOC entry 4129 (class 0 OID 0)
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
-- TOC entry 4130 (class 0 OID 0)
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
-- TOC entry 4131 (class 0 OID 0)
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
-- TOC entry 4132 (class 0 OID 0)
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
    CONSTRAINT product_variant_prices_price_type_check CHECK ((price_type = ANY (ARRAY['base'::text, 'promo'::text, 'clearance'::text])))
);


ALTER TABLE public.product_variant_prices OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 18387)
-- Name: current_variant_prices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.current_variant_prices AS
 SELECT DISTINCT ON (variant_id) variant_id,
    price,
    price_type,
    currency_code,
    start_at,
    end_at
   FROM public.product_variant_prices
  WHERE ((start_at <= now()) AND ((end_at IS NULL) OR (end_at > now())))
  ORDER BY variant_id, start_at DESC;


ALTER VIEW public.current_variant_prices OWNER TO postgres;

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
-- TOC entry 4133 (class 0 OID 0)
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
-- TOC entry 4134 (class 0 OID 0)
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
-- TOC entry 4135 (class 0 OID 0)
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
-- TOC entry 4136 (class 0 OID 0)
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
-- TOC entry 4137 (class 0 OID 0)
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
-- TOC entry 4138 (class 0 OID 0)
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
    product_id integer NOT NULL,
    option_value_id integer NOT NULL
);


ALTER TABLE public.product_variant_option_values OWNER TO postgres;

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
-- TOC entry 4139 (class 0 OID 0)
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
-- TOC entry 4140 (class 0 OID 0)
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
-- TOC entry 4141 (class 0 OID 0)
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
    image_url text,
    attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    weight_gram integer,
    length_mm integer,
    width_mm integer,
    height_mm integer,
    specs jsonb DEFAULT '{}'::jsonb NOT NULL
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
-- TOC entry 4142 (class 0 OID 0)
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
    stock_quantity integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    category_id integer NOT NULL,
    search_vec tsvector,
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
-- TOC entry 4143 (class 0 OID 0)
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
-- TOC entry 4144 (class 0 OID 0)
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
-- TOC entry 4145 (class 0 OID 0)
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
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3739 (class 2604 OID 17979)
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 17980)
-- Name: attributes attribute_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes ALTER COLUMN attribute_id SET DEFAULT nextval('public.attributes_attribute_id_seq'::regclass);


--
-- TOC entry 3742 (class 2604 OID 17981)
-- Name: cart_items cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_items_cart_item_id_seq'::regclass);


--
-- TOC entry 3743 (class 2604 OID 17982)
-- Name: carts cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN cart_id SET DEFAULT nextval('public.carts_cart_id_seq'::regclass);


--
-- TOC entry 3745 (class 2604 OID 17983)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 17984)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 17985)
-- Name: option_types option_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types ALTER COLUMN option_type_id SET DEFAULT nextval('public.option_types_option_type_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 17986)
-- Name: option_values option_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values ALTER COLUMN option_value_id SET DEFAULT nextval('public.option_values_option_value_id_seq'::regclass);


--
-- TOC entry 3756 (class 2604 OID 17987)
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- TOC entry 3757 (class 2604 OID 17988)
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- TOC entry 3764 (class 2604 OID 17989)
-- Name: product_images image_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN image_id SET DEFAULT nextval('public.product_images_image_id_seq'::regclass);


--
-- TOC entry 3769 (class 2604 OID 17990)
-- Name: product_variant_prices price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices ALTER COLUMN price_id SET DEFAULT nextval('public.product_variant_prices_price_id_seq'::regclass);


--
-- TOC entry 3801 (class 2604 OID 18357)
-- Name: product_variant_rental id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental ALTER COLUMN id SET DEFAULT nextval('public.product_variant_rental_id_seq'::regclass);


--
-- TOC entry 3800 (class 2604 OID 18350)
-- Name: product_variant_rental_prices rental_price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental_prices ALTER COLUMN rental_price_id SET DEFAULT nextval('public.product_variant_rental_prices_rental_price_id_seq'::regclass);


--
-- TOC entry 3773 (class 2604 OID 17991)
-- Name: product_variants variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN variant_id SET DEFAULT nextval('public.product_variants_variant_id_seq'::regclass);


--
-- TOC entry 3779 (class 2604 OID 17992)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3784 (class 2604 OID 17993)
-- Name: promotion_applicability applicability_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability ALTER COLUMN applicability_id SET DEFAULT nextval('public.promotion_applicability_applicability_id_seq'::regclass);


--
-- TOC entry 3785 (class 2604 OID 17994)
-- Name: promotions promotion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN promotion_id SET DEFAULT nextval('public.promotions_promotion_id_seq'::regclass);


--
-- TOC entry 3787 (class 2604 OID 17995)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4069 (class 0 OID 17826)
-- Dependencies: 219
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, full_name, phone_number, street, ward, district, city, is_default, "userUserId") FROM stdin;
\.


--
-- TOC entry 4071 (class 0 OID 17833)
-- Dependencies: 221
-- Data for Name: attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attributes (attribute_id, attribute_name, value_type) FROM stdin;
\.


--
-- TOC entry 4073 (class 0 OID 17837)
-- Dependencies: 223
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (cart_item_id, quantity, cart_id, product_id) FROM stdin;
\.


--
-- TOC entry 4075 (class 0 OID 17841)
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
-- TOC entry 4077 (class 0 OID 17846)
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
20	Bàn ghế	\N	\N
\.


--
-- TOC entry 4079 (class 0 OID 17852)
-- Dependencies: 229
-- Data for Name: category_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category_attributes (category_id, attribute_id) FROM stdin;
\.


--
-- TOC entry 4080 (class 0 OID 17855)
-- Dependencies: 230
-- Data for Name: customer_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_services (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4081 (class 0 OID 17863)
-- Dependencies: 231
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, name, email, message, "createdAt") FROM stdin;
\.


--
-- TOC entry 4082 (class 0 OID 17870)
-- Dependencies: 232
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1693234567890	InitFullEavSchema1693234567890
2	1693234567890	InitFullEavSchema1693234567890
\.


--
-- TOC entry 4084 (class 0 OID 17876)
-- Dependencies: 234
-- Data for Name: option_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.option_types (option_type_id, name, "position") FROM stdin;
1	Color	1
2	Size	2
\.


--
-- TOC entry 4086 (class 0 OID 17881)
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
-- TOC entry 4088 (class 0 OID 17886)
-- Dependencies: 238
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, quantity, price_per_unit, order_id, product_id) FROM stdin;
107	1	5990000.00	30	31
108	1	5990000.00	31	30
109	1	5990000.00	32	31
\.


--
-- TOC entry 4090 (class 0 OID 17890)
-- Dependencies: 240
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, subtotal, discount_amount, total_amount, status, order_date, user_id, promotion_id) FROM stdin;
30	5990000.00	0.00	5990000.00	Pending	2025-10-27 01:15:42.387878	86	\N
31	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:35:48.97484	86	\N
32	5990000.00	0.00	5990000.00	Pending	2025-10-27 02:36:33.918068	86	\N
\.


--
-- TOC entry 4092 (class 0 OID 17899)
-- Dependencies: 242
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policies (id, title, description, slug, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 4093 (class 0 OID 17907)
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
-- TOC entry 4095 (class 0 OID 17914)
-- Dependencies: 245
-- Data for Name: product_variant_inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory (variant_id, stock_quantity, safety_stock, updated_at) FROM stdin;
\.


--
-- TOC entry 4096 (class 0 OID 17920)
-- Dependencies: 246
-- Data for Name: product_variant_option_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option_values (product_id, option_value_id) FROM stdin;
\.


--
-- TOC entry 4097 (class 0 OID 17923)
-- Dependencies: 247
-- Data for Name: product_variant_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_prices (price_id, variant_id, price_type, currency_code, price, start_at, end_at, created_at) FROM stdin;
6	8	base	VND	10990000.00	2025-11-01 00:00:00	2025-11-20 00:00:00	2025-11-11 01:32:54.592175
7	8	promo	VND	9990000.00	2025-11-20 00:00:00	2025-11-30 23:59:59	2025-11-11 01:32:54.592175
8	8	base	VND	10790000.00	2025-12-01 00:00:00	\N	2025-11-11 01:32:54.592175
9	9	base	VND	13990000.00	2025-11-01 00:00:00	2025-11-20 00:00:00	2025-11-11 01:32:54.592175
10	9	promo	VND	12990000.00	2025-11-20 00:00:00	2025-11-30 23:59:59	2025-11-11 01:32:54.592175
11	9	base	VND	13790000.00	2025-12-01 00:00:00	\N	2025-11-11 01:32:54.592175
12	10	base	VND	25990000.00	2025-11-01 00:00:00	2025-11-20 00:00:00	2025-11-11 01:32:54.592175
13	10	promo	VND	23990000.00	2025-11-20 00:00:00	2025-11-30 23:59:59	2025-11-11 01:32:54.592175
14	10	base	VND	25590000.00	2025-12-01 00:00:00	\N	2025-11-11 01:32:54.592175
15	11	base	VND	30990000.00	2025-11-01 00:00:00	2025-11-20 00:00:00	2025-11-11 01:32:54.592175
16	11	promo	VND	28990000.00	2025-11-20 00:00:00	2025-11-30 23:59:59	2025-11-11 01:32:54.592175
17	11	base	VND	30590000.00	2025-12-01 00:00:00	\N	2025-11-11 01:32:54.592175
28	12	base	VND	4990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
29	13	base	VND	6990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
30	14	base	VND	8990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
31	15	base	VND	16990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
32	16	base	VND	28990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
33	17	base	VND	22990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
34	18	base	VND	2490000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
35	19	base	VND	29990000.00	2025-11-01 00:00:00	\N	2025-11-11 13:20:56.634605
36	12	promo	VND	4690000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
37	13	promo	VND	6590000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
38	14	promo	VND	8490000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
39	15	promo	VND	15990000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
40	16	promo	VND	26990000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
41	17	promo	VND	21990000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
42	18	promo	VND	2290000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
43	19	promo	VND	27990000.00	2025-11-10 00:00:00	2025-11-30 23:59:59	2025-11-11 13:20:56.634605
\.


--
-- TOC entry 4118 (class 0 OID 18354)
-- Dependencies: 268
-- Data for Name: product_variant_rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_rental (id, rental_price_id, quantity, start_date, end_date, product_id) FROM stdin;
\.


--
-- TOC entry 4116 (class 0 OID 18347)
-- Dependencies: 266
-- Data for Name: product_variant_rental_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_rental_prices (rental_price_id, variant_rental_id, rental_type, price, deposit, start_at, end_at) FROM stdin;
\.


--
-- TOC entry 4099 (class 0 OID 17933)
-- Dependencies: 249
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variants (variant_id, product_id, variant_name, sku, barcode, status, created_at, updated_at, image_url, attributes, weight_gram, length_mm, width_mm, height_mm, specs) FROM stdin;
14	52	50 inch	TV-ICHI-A50U-50	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "LED"}	\N	\N	\N	\N	{"os": "Android TV", "hdr": ["HDR10"], "ram": {"unit": "GB", "value": 2}, "panel": "LED", "ports": ["3× HDMI 2.0", "2× USB-A", "AV in", "Optical"], "storage": {"unit": "GB", "value": 16}, "resolution": "3840 x 2160", "connectivity": ["Wi-Fi 5", "Bluetooth 5.0"], "display_size": {"unit": "inch", "value": 50}, "refresh_rate": {"unit": "Hz", "value": 60}}
15	53	55 inch	TV-ICHI-Q55PRO-55	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "QLED"}	\N	\N	\N	\N	{"hdr": ["Dolby Vision", "HDR10+"], "panel": "QLED", "ports": ["4× HDMI (eARC)", "2× USB-A", "LAN", "Optical"], "speakers": "30W, Dolby Atmos", "resolution": "3840 x 2160", "display_size": {"unit": "inch", "value": 55}, "refresh_rate": {"unit": "Hz", "value": 120}}
16	54	65 inch	TV-ICHI-M65X-65	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "MiniLED"}	\N	\N	\N	\N	{"hdr": ["Dolby Vision", "HDR10+"], "panel": "MiniLED", "ports": ["4× HDMI 2.1 (eARC)", "2× USB-A", "LAN", "Optical"], "gaming": ["VRR", "ALLM", "4K120"], "resolution": "3840 x 2160", "display_size": {"unit": "inch", "value": 65}, "refresh_rate": {"unit": "Hz", "value": 120}}
17	55	75 inch	TV-ICHI-U75P-75	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "LED"}	\N	\N	\N	\N	{"hdr": ["HDR10", "HLG"], "panel": "LED", "ports": ["3× HDMI", "2× USB-A", "LAN", "Optical"], "design": "Viền mỏng, khung kim loại", "resolution": "3840 x 2160", "display_size": {"unit": "inch", "value": 75}, "refresh_rate": {"unit": "Hz", "value": 60}}
18	56	24 inch	TV-ICHI-E24-24	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "LED"}	\N	\N	\N	\N	{"panel": "LED", "ports": ["2× HDMI", "1× USB", "AV in"], "tuner": ["DVB-T2"], "resolution": "1366 x 768", "display_size": {"unit": "inch", "value": 24}, "refresh_rate": {"unit": "Hz", "value": 60}}
19	57	55 inch	TV-ICHI-O55L-55	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "OLED"}	\N	\N	\N	\N	{"hdr": ["Dolby Vision IQ", "HDR10+"], "audio": "Dolby Atmos", "panel": "OLED", "design": "Nguyên khối, mỏng", "resolution": "3840 x 2160", "display_size": {"unit": "inch", "value": 55}, "refresh_rate": {"unit": "Hz", "value": 120}}
8	36	55 inch	TVA1-55	8931234567001	1	2025-11-11 01:25:13.197536	2025-11-11 01:25:13.197536	https://cdn11.dienmaycholon.vn/filewebdmclnew/DMCL21/Picture//Apro/Apro_product_34270/smart-tivi-qled-samsung-4k-55-inch-qa55q60d-main--44.png	{"year": 2024, "color": "Đen", "panel": "VA"}	14500	1230	715	75	{"hdr": "HDR10, HLG", "ram": "2GB", "panel": "VA", "sound": "20W Dolby Audio", "storage": "16GB", "resolution": "3840 x 2160", "display_size": "55 inch", "refresh_rate": "60Hz"}
9	36	65 inch	TVA1-65	8931234567002	1	2025-11-11 01:25:13.197536	2025-11-11 01:25:13.197536	https://cdn11.dienmaycholon.vn/filewebdmclnew/DMCL21/Picture//Apro/Apro_product_34271/smart-tivi-qled-samsung-4k-50-inch-qa50q60d-main-34271.png	{"year": 2024, "color": "Đen", "panel": "VA"}	19500	1450	840	78	{"hdr": "HDR10, HLG", "ram": "2GB", "panel": "VA", "sound": "20W Dolby Audio", "storage": "16GB", "resolution": "3840 x 2160", "display_size": "65 inch", "refresh_rate": "60Hz"}
10	37	55 inch	TVX2-55	8931234567101	1	2025-11-11 01:25:58.906903	2025-11-11 01:25:58.906903	https://cdn11.dienmaycholon.vn/filewebdmclnew/DMCL21/Picture//Apro/Apro_product_34267/smart-tivi-qled-samsung-4k-85-inch-qa85q60d-main--808.png	{"year": 2024, "color": "Đen", "panel": "OLED"}	16500	1225	710	47	{"hdr": "Dolby Vision IQ, HDR10+", "ram": "3GB", "panel": "OLED", "sound": "30W Dolby Atmos", "storage": "32GB", "resolution": "3840 x 2160", "display_size": "55 inch", "refresh_rate": "120Hz"}
11	37	65 inch	TVX2-65	8931234567102	1	2025-11-11 01:25:58.906903	2025-11-11 01:25:58.906903	https://cdn11.dienmaycholon.vn/filewebdmclnew/DMCL21/Picture//Apro/Apro_product_34269/smart-tivi-qled-samsung-4k-65-inch-qa65q60d-main--637.png	{"year": 2024, "color": "Đen", "panel": "OLED"}	21500	1445	830	49	{"hdr": "Dolby Vision IQ, HDR10+", "ram": "3GB", "panel": "OLED", "sound": "30W Dolby Atmos", "storage": "32GB", "resolution": "3840 x 2160", "display_size": "65 inch", "refresh_rate": "120Hz"}
12	50	40 inch	TV-ICHI-F40S-40	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "LED"}	\N	\N	\N	\N	{"os": "Smart TV (Lite)", "hdr": null, "ram": {"unit": "GB", "value": 1.5}, "panel": "LED", "ports": ["2× HDMI", "1× USB", "AV in", "Optical"], "tuner": ["DVB-T2"], "storage": {"unit": "GB", "value": 8}, "speakers": "16W", "resolution": "1920 x 1080", "connectivity": ["Wi-Fi", "Bluetooth"], "display_size": {"unit": "inch", "value": 40}, "refresh_rate": {"unit": "Hz", "value": 60}}
13	51	43 inch	TV-ICHI-G43U-43	\N	1	2025-11-11 13:11:27.434064	2025-11-11 13:11:27.434064	https://images.samsung.com/is/image/samsung/p6pim/vn/qa65q70dakxxv/gallery/vn-qled-tv-qa65q70dakxxv-m-t-tr--c-542467599?$Q90_1164_776_PNG$	{"year": 2024, "color": "Đen", "panel": "LED"}	\N	\N	\N	\N	{"os": "Google TV", "hdr": ["HDR10", "HLG"], "ram": {"unit": "GB", "value": 2}, "panel": "LED", "ports": ["3× HDMI 2.0", "2× USB-A", "LAN", "Optical"], "storage": {"unit": "GB", "value": 16}, "speakers": "20W, Dolby Audio", "resolution": "3840 x 2160", "connectivity": ["Wi-Fi 5", "Bluetooth 5.0", "Chromecast built-in"], "display_size": {"unit": "inch", "value": 43}, "refresh_rate": {"unit": "Hz", "value": 60}}
\.


--
-- TOC entry 4101 (class 0 OID 17943)
-- Dependencies: 251
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, sku, long_description, short_description, status, stock_quantity, created_at, updated_at, category_id, search_vec, origin, user_manual, caution_notes) FROM stdin;
36	Smart TV 4K Ultra HD A1	TVA1-BASE	Smart TV 4K với trợ lý giọng nói, YouTube/Netflix, Chromecast Built-in.	TV 4K giá tốt, hình đẹp, nhiều cổng kết nối.	1	50	2025-11-11 01:25:13.197536	2025-11-11 01:25:13.197536	8	'1':44C '10':174C '10w':198C '11':194C '12':117C,211C '120':213C '16':147C '2':57C,131C,179C,197C '2.0':178C '20w':196C '2160':61C '3':71C,176C '3840':59C '4':87C '4k':3A,8B,19C '5':98C,162C '5.0':164C '55':46C '6':113C '60':89C '7':129C '8':145C '9':157C 'a':182C 'a1':6A 'am':189C 'android':115C 'audio':200C 'av':183C 'bi':239 'bluetooth':163C 'bo':141C 'built':28C 'built-in':27C 'chromecast':26C 'cong':14B,172C,208C 'connectivity':149C 'dan':221 'dap':228 'de':230,235 'dep':12B 'dieu':106C,110C,124C,138C 'display':31C 'do':53C 'doc':218 'dolby':199C 'dung':225 'fi':161C 'gan':231 'gb':121C,135C 'gia':9B 'giai':55C 'giong':23C 'group':35C,49C,64C,79C,92C,104C,122C,136C,150C,168C,188C,205C 'hanh':107C,111C,125C,139C 'hd':5A 'hdmi':177C 'hdr':91C,96C 'hdr10':100C 'he':105C,109C,123C,137C 'hien':36C,50C,65C,80C,93C 'hinh':11B,42C 'hlg':101C 'huong':220 'hz':78C 'in':29C,184C 'inch':34C 'ket':15B,151C,154C,169C 'key':30C,47C,62C,74C,90C,102C,118C,132C,148C,166C,186C,201C 'khi':223 'khong':229,234 'kich':39C 'ky':219 'label':38C,52C,67C,82C,95C,108C,126C,140C,153C,171C,191C,207C 'lan':165C 'loa':192C 'long':217 'ly':22C 'man':41C 'nam':215B 'nen':69C 'nguon':206C,232 'nhiet':233 'nhieu':13B 'nho':142C 'noi':16B,24C,152C,155C,170C 'nuoc':236 'optical':185C 'order':43C,56C,70C,86C,97C,112C,128C,144C,156C,173C,193C,210C 'os':103C 'panel':63C 'phan':54C 'ports':167C 'power':202C 'quet':85C 'ram':119C,127C 'rate':76C 'refresh':75C 'resolution':48C 'size':32C 'smart':1A,17C 'so':84C 'speakers':187C 'storage':133C 'su':224 'suat':209C 'tam':68C 'tan':83C 'thanh':190C 'thi':37C,51C,66C,81C,94C 'thiet':238 'thuoc':40C 'tot':10B 'tranh':226 'tro':21C 'trong':143C 'truoc':222 'tv':2A,7B,18C,116C 'ultra':4A 'unit':33C,77C,120C,134C,203C 'usb':181C 'usb-a':180C 'va':73C,227 'value':45C,58C,72C,88C,99C,114C,130C,146C,158C,175C,195C,212C 'vao':237 'viet':214B 'voi':20C 'vui':216 'w':204C 'wi':160C 'wi-fi':159C 'x':60C 'youtube/netflix':25C	Việt Nam	Vui lòng đọc kỹ hướng dẫn trước khi sử dụng.	Tránh va đập; Không để gần nguồn nhiệt; Không để nước vào thiết bị.
37	Smart TV OLED 4K Pro X2	TVX2-BASE	Màn hình OLED tự phát sáng, màu đen sâu, hỗ trợ Dolby Vision/Atmos, Google TV.	OLED cao cấp – hình ảnh sống động, mượt mà.	1	20	2025-11-11 01:25:58.906903	2025-11-11 01:25:58.906903	8	'1':45C '1.8':134C '10':174C '11':194C '12':209C '120':90C '150':211C '2':58C,180C '2.1':178C '2160':62C '3':72C,149C '30w':196C '32':165C '3840':60C '4':88C,176C '4k':4A '5':99C '55':47C '6':116C '7':129C '8':147C '9':163C 'a':183C 'am':189C 'anh':11B 'atmos':198C 'bang':230 'bat':220 'bo':159C 'cao':8B 'cap':9B 'chac':219 'chat':232 'cong':172C,206C 'core':133C 'cpu':121C,127C 'dat':213 'de':223 'den':23C 'dien':226,235 'dieu':109C,113C,124C,142C,156C 'display':32C 'do':54C 'dolby':27C,101C,197C 'dong':13B,237 'earc':179C 'eco':221 'gb':139C,153C 'ghz':135C 'giai':56C 'google':29C,118C 'group':36C,50C,65C,80C,93C,107C,122C,140C,154C,168C,188C,203C 'hanh':110C,114C,125C,143C,157C 'hdmi':177C 'hdr':92C,97C 'hdr10':104C 'he':108C,112C,123C,141C,155C 'hien':37C,51C,66C,81C,94C 'hinh':10B,17C,43C 'ho':25C 'hoa':231 'hz':79C 'inch':35C 'iq':103C 'ket':169C 'key':31C,48C,63C,75C,91C,105C,120C,136C,150C,166C,186C,199C 'khi':236 'khong':227 'kich':40C 'kiem':225 'label':39C,53C,68C,83C,96C,111C,126C,144C,158C,171C,191C,205C 'lan':185C 'lau':228 'loa':192C 'ma':15B 'malaysia':212B 'man':16C,42C,229 'manh':233 'mat':216 'mau':22C 'mode':222 'muot':14B 'nen':70C 'nguon':204C 'nho':160C 'noi':170C 'oled':3A,7B,18C,74C 'optical':184C 'order':44C,57C,71C,87C,98C,115C,128C,146C,162C,173C,193C,208C 'os':106C 'panel':64C 'phan':55C 'phang':217 'phat':20C 'ports':167C 'power':200C 'pro':5A 'quad':132C 'quad-core':131C 'quet':86C 'ram':137C,145C 'rate':77C 'refresh':76C 'resolution':49C 'rut':234 'sang':21C 'sau':24C 'set':238 'size':33C 'smart':1A 'so':85C 'song':12B 'speakers':187C 'storage':151C 'suat':207C 'tam':69C 'tan':84C 'thanh':190C 'thi':38C,52C,67C,82C,95C 'thuoc':41C 'tiet':224 'tren':215 'tro':26C 'trong':161C 'tu':19C 'tv':2A,30C,119C,214 'unit':34C,78C,138C,152C,201C 'usb':182C 'usb-a':181C 'value':46C,59C,73C,89C,100C,117C,130C,148C,164C,175C,195C,210C 'vision':102C 'vision/atmos':28C 'vung':218 'w':202C 'x':61C 'x2':6A	Malaysia	Đặt TV trên mặt phẳng vững chắc; bật Eco Mode để tiết kiệm điện.	Không lau màn bằng hoá chất mạnh; rút điện khi dông sét.
49	Tivi LED 32\\" HD Smart ICHI S32H	TV-ICHI-S32H	Màn hình 32 inch độ phân giải HD, tấm nền LED tiết kiệm điện, tích hợp hệ điều hành thông minh với kho ứng dụng phổ biến (YouTube, Netflix). Hỗ trợ Wi-Fi, chia sẻ màn hình nhanh, loa 2x8W, chế độ bảo vệ mắt và lọc tiếng ồn hình.	32\\" HD, Smart TV, Wi-Fi, tiết kiệm điện	2	35	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'2x8w':58C '32':3A,8B,20C 'am':104 'bang':98 'bao':61C,94 'bien':44C 'cam':71 'cap':87 'chat':100 'che':59C 'chia':52C 'co':92 'dan':80 'dang':81 'danger':111 'dien':17B,31C 'dieu':35C 'do':22C,60C 'dung':42C,86 'fi':14B,51C,77 'giai':24C 'hanh':36C 'hd':4A,9B,25C 'he':34C 'hinh':19C,55C,68C 'ho':47C 'hoa':99 'hop':33C 'huong':79 'ichi':6A 'inch':21C 'ket':73 'khi':91 'kho':40C 'khoan':84 'khong':95 'kiem':16B,30C 'lau':96 'led':2A,28C 'loa':57C 'loc':65C 'man':18C,54C,97 'manh':101 'mat':63C 'mem':90 'minh':38C 'nam':70B 'nen':27C 'netflix':46C 'nguon':72,107 'nhanh':56C 'nhap':82 'nhat':88 'nhiet':108 'noi':74 'on':67C 'phan':23C,89 'pho':43C 's32h':7A 'se':53C 'smart':5A,10B 'tai':83 'tam':26C 'thap':105 'theo':78 'thong':37C,93 'tich':32C 'tieng':66C 'tiep':110 'tiet':15B,29C 'tivi':1A 'tranh':103 'tro':48C 'truc':109 'tv':11B 'ung':41C,85 'va':64C,106 've':62C 'viet':69B 'voi':39C 'warning':102 'wi':13B,50C,76 'wi-fi':12B,49C,75 'youtube':45C	Việt Nam	Cắm nguồn, kết nối Wi-Fi theo hướng dẫn > đăng nhập tài khoản ứng dụng > cập nhật phần mềm khi có thông báo.	Không lau màn bằng hoá chất mạnh (warning); tránh ẩm thấp và nguồn nhiệt trực tiếp (danger).
50	Tivi FHD 40\\" ICHI F40S Smart	TV-ICHI-F40S	Màn 40 inch Full HD, viền mỏng, CPU 4 nhân, RAM 1.5GB cho trải nghiệm mượt. Hỗ trợ Miracast/AirPlay, cổng HDMI ARC, USB phát đa định dạng.	40\\" FHD, viền mỏng, HDMI ARC	1	22	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'1.5':24C '4':21C '40':3A,7B,14C 'anh':50 'anten/hdmi':45 'arc':12B,35C 'be':67 'cai':47 'chac':70 'chan':71 'che':53 'cho':26C 'chon':52 'cong':33C 'cpu':20C 'da':38C 'dang':40C 'dat':48,65 'de':51 'dien':58 'dinh':39C 'do':54 'dong':62 'f40s':5A 'fhd':2A,8B 'full':16C 'gb':25C 'hd':17C 'hdmi':11B,34C 'hinh':49 'ho':30C 'ichi':4A 'inch':15C 'info':72 'ket':43 'khi':61 'kiem':57 'lan':42B 'man':13C 'mat':68 'miracast/airplay':32C 'mong':10B,19C 'muot':29C 'ngat':59 'nghiem':28C 'nguon':60 'nhan':22C 'noi':44 'phang':69 'phat':37C 'phim/tiet':56 'ram':23C 'rap':55 'set':63 'smart':6A 'thai':41B 'tivi':1A 'trai':27C 'tren':66 'tro':31C 'usb':36C 'vao':46 'vien':9B,18C 'warning':64	Thái Lan	Kết nối anten/HDMI, vào Cài đặt > Hình ảnh để chọn chế độ rạp phim/tiết kiệm điện.	Ngắt nguồn khi dông sét (warning); đặt trên bề mặt phẳng, chắc chắn (info).
51	Google TV 43\\" 4K ICHI G43U	TV-ICHI-G43U	Độ phân giải 4K, Google TV với trợ lý giọng nói tiếng Việt, Chromecast built-in, Dolby Audio. Hỗ trợ HDR10, giảm ánh sáng xanh.	43\\" 4K, Google TV, HDR10	12	18	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'43':3A,7B '4k':4A,8B,15C 'anh':35C 'audio':30C 'bang':48 'built':27C 'built-in':26C 'cac':61 'cai':55 'che':60 'chromecast':25C 'cua':52 'de':45,54,70 'do':12C 'dolby':29C 'dung':58,66 'g43u':6A 'giai':14C 'giam':34C 'gio':64 'giong':21C,49 'google':1A,9B,16C 'hang':53 'hdr10':11B,33C 'ho':31C 'ichi':5A 'in':28C 'info':73 'khan':67 'khe':62 'khong':59 'kiem':47 'ly':20C 'mem':69 'mic':42 'nam':39B 'nhan':40 'noi':22C,50 'nut':41 'phan':13C 'remote':44 'sang':36C 'sinh':72 'soi':68 'them':56 'thoat':63 'tieng':23C 'tim':46 'tren':43 'tro':19C,32C 'tv':2A,10B,17C 'ung':57 'vao':51 've':71 'viet':24C,38B 'voi':18C 'warning':65 'xanh':37C	Việt Nam	Nhấn nút mic trên remote để tìm kiếm bằng giọng nói; vào Cửa hàng để cài thêm ứng dụng.	Không che các khe thoát gió (warning); dùng khăn sợi mềm để vệ sinh (info).
52	Android TV 50\\" 4K UHD ICHI A50U	TV-ICHI-A50U	Tivi 50 inch 4K UHD, màu sắc sống động, bộ xử lý nâng cấp hình ảnh AI Upscale. Hỗ trợ Bluetooth 5.0 kết nối loa/tay cầm.	50\\" 4K UHD, Android TV, BT 5.0	2	12	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'10':71 '4k':4A,9B,18C '5.0':14B,36C '50':3A,8B,16C 'a50u':7A 'ai':31C 'android':1A,11B 'anh':30C 'bao':66 'bat':53 'bi':45 'bluetooth':35C,46 'bo':24C 'bt':13B 'cai':42,48 'cam':40C 'cap':28C 'cm':72 'dam':65 'dat':43,49,59 'dong':23C 'dung':56 'earc':54 'gan':60 'gio':68 'hinh':29C 'ho':33C 'ichi':6A 'inch':17C 'info':75 'ket':37C 'khong':58 'kien':52 'loa/tay':39C 'ly':26C 'malaysia':41B 'manh':63 'mat':73 'mau':20C 'nang':27C 'neu':55 'nguon':61 'noi':38C 'phu':51 'remote':50 'sac':21C 'sau':74 'song':22C 'soundbar':57 'thiet':44 'thieu':70 'thong':67 'tivi':15C 'toi':69 'tro':34C 'trong':47 'tu':62 'tv':2A,12B 'uhd':5A,10B,19C 'upscale':32C 'warning':64 'xu':25C	Malaysia	Cài đặt thiết bị Bluetooth trong Cài đặt > Remote & phụ kiện; bật eARC nếu dùng soundbar.	Không đặt gần nguồn từ mạnh (warning); đảm bảo thông gió tối thiểu 10 cm mặt sau (info).
53	Tivi QLED 55\\" 4K ICHI Q55 Pro	TV-ICHI-Q55PRO	Tấm nền QLED 55\\", dải màu rộng, độ sáng cao; hỗ trợ Dolby Vision/Atmos, 120Hz MEMC, chế độ Game thấp trễ.	55\\" QLED 4K, Dolby Vision/Atmos	1	9	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'120hz':27C '4k':4A,10B '55':3A,8B,16C 'anh':42 'bang':56 'bao':59 'bat':36,58 'burn':54 'burn-in':53 'cach':57 'cao':22C 'cap':47 'cham':69 'che':29C,37 'console':46 'dai':17C 'de':65 'dinh':50 'do':20C,30C,38 'dolby':11B,25C 'em':67 'firmware':49 'game':31C,39 'hinh':41,62 'ho':23C 'ichi':5A 'in':55 'info':63 'ket':44 'khi':43 'khong':64 'ky':51 'man':61,70 'mau':18C 'memc':28C 'nam':35B 'nen':14C 'nhat':48 'noi':45 'pro':7A 'q55':6A 'qled':2A,9B,15C 'rong':19C 'sang':21C 'tam':13C 'thap':32C 'tivi':1A 'tranh':52 'tre':33C,66 'tro':24C 'trong':40 'va':68 've':60 'viet':34B 'vision/atmos':12B,26C 'warning':71	Việt Nam	Bật chế độ Game trong Hình ảnh khi kết nối console; cập nhật firmware định kỳ.	Tránh burn-in bằng cách bật bảo vệ màn hình (info); không để trẻ em va chạm màn (warning).
54	MiniLED 65\\" 4K ICHI M65X	TV-ICHI-M65X	Đèn nền MiniLED vùng mờ cục bộ cho độ tương phản vượt trội; 4 cổng HDMI 2.1 hỗ trợ 4K120, VRR, ALLM. Hệ điều hành Google TV.	65\\" MiniLED 4K, HDMI 2.1, 4K120	12	6	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'2.1':10B,28C,44 '4':25C '4k':3A,8B '4k120':11B,31C '65':2A,6B 'allm':33C 'bat':47 'be':57 'bo':18C 'cai':50 'cao':53 'cap':42 'chan':66 'chinh':45 'cho':19C,54 'chuan':70 'chuyen':62 'co':64 'cong':26C,58 'cuc':17C 'danger':63 'dat':51 'de/treo':67 'den':12C 'di':61 'dieu':35C 'dinh':65 'do':20C 'dung':41 'google':37C 'hang':46 'hanh':36C 'hdmi':9B,27C,43 'he':34C 'ho':29C 'ichi':4A 'khi':60 'khong':56 'm65x':5A 'man':59 'miniled':1A,7B,14C 'mo':16C 'nang':52 'nen':13C 'pc/console':55 'phan':22C 'quoc':40B 'tro':30C 'troi':24C 'trong':49 'trung':39B 'tuong':21C,68 'tv':38C 'vesa':69 'vrr':32C,48 'vung':15C 'vuot':23C 'warning':71	Trung Quốc	Dùng cáp HDMI 2.1 chính hãng; bật VRR trong Cài đặt nâng cao cho PC/console.	Không bẻ cong màn khi di chuyển (danger); cố định chân đế/treo tường VESA chuẩn (warning).
55	Tivi 75\\" 4K ICHI U75 Prime	TV-ICHI-U75P	Màn lớn 75\\", viền siêu mỏng, thuật toán làm mượt chuyển động, loa 2.1 tích hợp. Hỗ trợ điều khiển nhà thông minh qua Google Home.	75\\" 4K, viền mỏng, loa 2.1	0	4	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'2':60 '2.1':12B,26C '4k':3A,8B '75':2A,7B,15C 'anh':55 'can':52 'cau':59 'chinh':53 'chuan':45 'chuyen':23C,73 'danger':67 'dat':66 'de':47 'dieu':31C 'dong':24C 'gian':51 'google':37C 'hinh':54 'ho':29C 'home':38C 'hop':28C 'ichi':4A 'khi':64,71 'khien':32C 'khong':50 'khuyen':41 'lac':70 'lam':21C 'lap':65 'len':63 'loa':11B,25C 'lon':14C 'man':13C 'minh':35C 'mong':10B,18C 'muot':22C 'nam':40B 'nghi':42 'nguoi':61 'nha':33C 'phong':57 'prime':6A 'qua':36C 'rung':69 'sieu':17C 'theo':56 'thong':34C 'thuat':19C 'tich':27C 'tivi':1A 'toan':20C 'toi':48 'tranh':68 'treo':43 'tro':30C,62 'tuong':44 'u75':5A 'uu':49 'van':72 'vesa':46 'vien':9B,16C 'viet':39B 'warning':74 'yeu':58	Việt Nam	Khuyến nghị treo tường chuẩn VESA để tối ưu không gian; cân chỉnh hình ảnh theo phòng.	Yêu cầu 2 người trở lên khi lắp đặt (danger); tránh rung lắc khi vận chuyển (warning).
56	Tivi 24\\" HD ICHI E24 Basic	TV-ICHI-E24	Mẫu cơ bản 24\\" HD, phù hợp phòng nhỏ/nhà trọ, hỗ trợ DVB-T2, 2xHDMI, 1xUSB, tiêu thụ điện thấp.	24\\" HD, DVB-T2, tiết kiệm	2	40	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'1xusb':30C '24':2A,7B,17C '2xhdmi':29C '85':59 'am':58 'ban':16C,51 'basic':6A 'bat':45 'che':46 'co':15C 'dem':52 'dien':33C,50 'do':47 'dong':43 'dung':54 'dvb':10B,27C,40 'dvb-t2':9B,26C,39 'e24':5A 'hd':3A,8B,18C 'ho':24C 'hop':20C 'ichi':4A 'kenh':38 'khong':53 'kiem':13B,49 'mau':14C 'moi':56 'nam':36B 'nen':44 'nho/nha':22C 'phong':21C 'phu':19C 'quet':37 't2':11B,28C,41 'thap':34C 'thu':32C 'tiet':12B,48 'tieu':31C 'tivi':1A 'tro':23C,25C 'trong':55 'truong':57 'tu':42 'viet':35B 'warning':60	Việt Nam	Quét kênh DVB-T2 tự động; nên bật chế độ tiết kiệm điện ban đêm.	Không dùng trong môi trường ẩm >85% (warning).
57	OLED 55\\" 4K ICHI O55 Luxe	TV-ICHI-O55L	Tivi OLED 55\\" màu đen tuyệt đối, Dolby Vision IQ, loa Dolby Atmos, thiết kế kim loại nguyên khối; hỗ trợ Apple AirPlay 2.	55\\" OLED 4K, DV IQ, Atmos	1	7	2025-11-11 07:50:43.112485	2025-11-11 07:50:43.112485	8	'2':36C '4k':3A,9B '55':2A,7B,15C 'airplay':35C 'anh':45,52 'apple':34C 'atmos':12B,25C 'bat':39,62 'bien':51 'cam':50 'dai':60 'de':46 'den':17C 'dinh':65 'doi':19C 'dolby':20C,24C,40 'dv':10B 'gio':61 'han':37B 'hinh':44 'ho':32C 'ichi':4A 'iq':11B,22C,42 'ke':27C 'khoi':31C 'kim':28C 'ky':66 'loa':23C 'loai':29C 'luxe':6A 'mau':16C 'nguyen':30C 'nhay':56 'o55':5A 'oled':1A,8B,14C,55 'phong':54 'pixel':63 'quoc':38B 'refresher':64 'sang':53 'theo':49 'thiet':26C 'tinh':59 'tivi':13C 'toi':47 'tro':33C 'trong':43 'tuyet':18C 'uu':48 'vet':58 'vision':21C,41 'voi':57 'warning':67	Hàn Quốc	Bật Dolby Vision IQ trong Hình ảnh để tối ưu theo cảm biến ánh sáng phòng.	OLED nhạy với vệt tĩnh dài giờ, bật Pixel Refresher định kỳ (warning).
\.


--
-- TOC entry 4103 (class 0 OID 17953)
-- Dependencies: 253
-- Data for Name: promotion_applicability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_applicability (applicability_id, promotion_id, product_id, category_id) FROM stdin;
\.


--
-- TOC entry 4105 (class 0 OID 17957)
-- Dependencies: 255
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (promotion_id, name, description, discount_type, discount_value, start_date, end_date, is_active) FROM stdin;
\.


--
-- TOC entry 4114 (class 0 OID 18233)
-- Dependencies: 264
-- Data for Name: rental_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rental_order_items (id, rental_order_id, variant_id, rental_type, price, deposit, quantity, start_date, end_date, returned_at, return_status, created_at, updated_at, variant_rental_id) FROM stdin;
\.


--
-- TOC entry 4112 (class 0 OID 18212)
-- Dependencies: 262
-- Data for Name: rental_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rental_orders (id_rental_order, user_id, total_price, total_deposit, status, note, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4107 (class 0 OID 17964)
-- Dependencies: 257
-- Data for Name: user_profile_business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_business (user_id, company_name, tax_id, email) FROM stdin;
\.


--
-- TOC entry 4108 (class 0 OID 17967)
-- Dependencies: 258
-- Data for Name: user_profile_individual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profile_individual (user_id, full_name, date_of_birth) FROM stdin;
84	Nguyen Xuan Danh	2025-09-05
86	Nguyen Danh	\N
\.


--
-- TOC entry 4109 (class 0 OID 17970)
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
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 220
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 23, true);


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 222
-- Name: attributes_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attributes_attribute_id_seq', 1, false);


--
-- TOC entry 4149 (class 0 OID 0)
-- Dependencies: 224
-- Name: cart_items_cart_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_cart_item_id_seq', 23, true);


--
-- TOC entry 4150 (class 0 OID 0)
-- Dependencies: 226
-- Name: carts_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_cart_id_seq', 21, true);


--
-- TOC entry 4151 (class 0 OID 0)
-- Dependencies: 228
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 20, true);


--
-- TOC entry 4152 (class 0 OID 0)
-- Dependencies: 233
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 2, true);


--
-- TOC entry 4153 (class 0 OID 0)
-- Dependencies: 235
-- Name: option_types_option_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_types_option_type_id_seq', 1, false);


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 237
-- Name: option_values_option_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_values_option_value_id_seq', 1, false);


--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 109, true);


--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 241
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 32, true);


--
-- TOC entry 4157 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_images_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_image_id_seq', 46, true);


--
-- TOC entry 4158 (class 0 OID 0)
-- Dependencies: 248
-- Name: product_variant_prices_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_prices_price_id_seq', 43, true);


--
-- TOC entry 4159 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_variant_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_rental_id_seq', 1, false);


--
-- TOC entry 4160 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_variant_rental_prices_rental_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variant_rental_prices_rental_price_id_seq', 1, false);


--
-- TOC entry 4161 (class 0 OID 0)
-- Dependencies: 250
-- Name: product_variants_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_variants_variant_id_seq', 19, true);


--
-- TOC entry 4162 (class 0 OID 0)
-- Dependencies: 252
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 57, true);


--
-- TOC entry 4163 (class 0 OID 0)
-- Dependencies: 254
-- Name: promotion_applicability_applicability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_applicability_applicability_id_seq', 1, false);


--
-- TOC entry 4164 (class 0 OID 0)
-- Dependencies: 256
-- Name: promotions_promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_promotion_id_seq', 1, false);


--
-- TOC entry 4165 (class 0 OID 0)
-- Dependencies: 263
-- Name: rental_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rental_order_items_id_seq', 1, false);


--
-- TOC entry 4166 (class 0 OID 0)
-- Dependencies: 261
-- Name: rental_orders_id_rental_order_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rental_orders_id_rental_order_seq', 1, false);


--
-- TOC entry 4167 (class 0 OID 0)
-- Dependencies: 260
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 86, true);


--
-- TOC entry 3874 (class 2606 OID 17997)
-- Name: user_profile_individual PK_059f53ecf53e772aa79eb3c57f1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "PK_059f53ecf53e772aa79eb3c57f1" PRIMARY KEY (user_id);


--
-- TOC entry 3814 (class 2606 OID 17999)
-- Name: cart_items PK_136052dba9e33c62b93c6a291f8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "PK_136052dba9e33c62b93c6a291f8" PRIMARY KEY (cart_item_id);


--
-- TOC entry 3844 (class 2606 OID 18001)
-- Name: product_images PK_2212515ba306c79f42c46a99db7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT "PK_2212515ba306c79f42c46a99db7" PRIMARY KEY (image_id);


--
-- TOC entry 3816 (class 2606 OID 18003)
-- Name: carts PK_2fb47cbe0c6f182bb31c66689e9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "PK_2fb47cbe0c6f182bb31c66689e9" PRIMARY KEY (cart_id);


--
-- TOC entry 3810 (class 2606 OID 18005)
-- Name: attributes PK_3225fe233475419d420a293d5d6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "PK_3225fe233475419d420a293d5d6" PRIMARY KEY (attribute_id);


--
-- TOC entry 3820 (class 2606 OID 18007)
-- Name: categories PK_51615bef2cea22812d0dcab6e18; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_51615bef2cea22812d0dcab6e18" PRIMARY KEY (category_id);


--
-- TOC entry 3838 (class 2606 OID 18009)
-- Name: order_items PK_54c952fdc94b9b487ef968b4047; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "PK_54c952fdc94b9b487ef968b4047" PRIMARY KEY (order_item_id);


--
-- TOC entry 3824 (class 2606 OID 18011)
-- Name: customer_services PK_56089dcf272f4aca67b6ce27a8b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "PK_56089dcf272f4aca67b6ce27a8b" PRIMARY KEY (id);


--
-- TOC entry 3842 (class 2606 OID 18013)
-- Name: policies PK_603e09f183df0108d8695c57e28; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT "PK_603e09f183df0108d8695c57e28" PRIMARY KEY (id);


--
-- TOC entry 3808 (class 2606 OID 18015)
-- Name: addresses PK_7075006c2d82acfeb0ea8c5dce7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "PK_7075006c2d82acfeb0ea8c5dce7" PRIMARY KEY (address_id);


--
-- TOC entry 3830 (class 2606 OID 18017)
-- Name: feedback PK_8389f9e087a57689cd5be8b2b13; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT "PK_8389f9e087a57689cd5be8b2b13" PRIMARY KEY (id);


--
-- TOC entry 3832 (class 2606 OID 18019)
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- TOC entry 3876 (class 2606 OID 18021)
-- Name: users PK_96aac72f1574b88752e9fb00089; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_96aac72f1574b88752e9fb00089" PRIMARY KEY (user_id);


--
-- TOC entry 3863 (class 2606 OID 18023)
-- Name: products PK_a8940a4bf3b90bd7ac15c8f4dd9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "PK_a8940a4bf3b90bd7ac15c8f4dd9" PRIMARY KEY (product_id);


--
-- TOC entry 3872 (class 2606 OID 18025)
-- Name: user_profile_business PK_ad95ecfa0d8f92b9b3c5c025375; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "PK_ad95ecfa0d8f92b9b3c5c025375" PRIMARY KEY (user_id);


--
-- TOC entry 3840 (class 2606 OID 18027)
-- Name: orders PK_cad55b3cb25b38be94d2ce831db; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "PK_cad55b3cb25b38be94d2ce831db" PRIMARY KEY (order_id);


--
-- TOC entry 3822 (class 2606 OID 18029)
-- Name: category_attributes PK_e135f7d323a2899937cd2a2cb7b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "PK_e135f7d323a2899937cd2a2cb7b" PRIMARY KEY (category_id, attribute_id);


--
-- TOC entry 3870 (class 2606 OID 18031)
-- Name: promotions PK_e151ef85c700deef77ec80ff13a; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "PK_e151ef85c700deef77ec80ff13a" PRIMARY KEY (promotion_id);


--
-- TOC entry 3868 (class 2606 OID 18033)
-- Name: promotion_applicability PK_e76ef1dcb40f4f690c444052917; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "PK_e76ef1dcb40f4f690c444052917" PRIMARY KEY (applicability_id);


--
-- TOC entry 3818 (class 2606 OID 18035)
-- Name: carts REL_2ec1c94a977b940d85a4f498ae; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "REL_2ec1c94a977b940d85a4f498ae" UNIQUE (user_id);


--
-- TOC entry 3826 (class 2606 OID 18037)
-- Name: customer_services UQ_06ef5acfc04805b8783b2885328; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_06ef5acfc04805b8783b2885328" UNIQUE (title);


--
-- TOC entry 3878 (class 2606 OID 18039)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 3828 (class 2606 OID 18041)
-- Name: customer_services UQ_c0c13d2e89510645f36044cc989; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_services
    ADD CONSTRAINT "UQ_c0c13d2e89510645f36044cc989" UNIQUE (slug);


--
-- TOC entry 3865 (class 2606 OID 18043)
-- Name: products UQ_c44ac33a05b144dd0d9ddcf9327; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "UQ_c44ac33a05b144dd0d9ddcf9327" UNIQUE (sku);


--
-- TOC entry 3812 (class 2606 OID 18045)
-- Name: attributes UQ_e8ab1373d517dbee20df5430bb0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "UQ_e8ab1373d517dbee20df5430bb0" UNIQUE (attribute_name);


--
-- TOC entry 3880 (class 2606 OID 18047)
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- TOC entry 3851 (class 2606 OID 18049)
-- Name: product_variant_prices ex_variant_price_unique_window; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT ex_variant_price_unique_window EXCLUDE USING gist (variant_id WITH =, price_type WITH =, tsrange(start_at, COALESCE(end_at, 'infinity'::timestamp without time zone), '[)'::text) WITH &&);


--
-- TOC entry 3834 (class 2606 OID 18051)
-- Name: option_types option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_types
    ADD CONSTRAINT option_types_pkey PRIMARY KEY (option_type_id);


--
-- TOC entry 3836 (class 2606 OID 18053)
-- Name: option_values option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (option_value_id);


--
-- TOC entry 3846 (class 2606 OID 18055)
-- Name: product_variant_inventory product_variant_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3849 (class 2606 OID 18057)
-- Name: product_variant_option_values product_variant_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_pkey PRIMARY KEY (product_id, option_value_id);


--
-- TOC entry 3853 (class 2606 OID 18059)
-- Name: product_variant_prices product_variant_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_pkey PRIMARY KEY (price_id);


--
-- TOC entry 3889 (class 2606 OID 18359)
-- Name: product_variant_rental product_variant_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT product_variant_rental_pkey PRIMARY KEY (id);


--
-- TOC entry 3887 (class 2606 OID 18352)
-- Name: product_variant_rental_prices product_variant_rental_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental_prices
    ADD CONSTRAINT product_variant_rental_prices_pkey PRIMARY KEY (rental_price_id);


--
-- TOC entry 3859 (class 2606 OID 18061)
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_id);


--
-- TOC entry 3861 (class 2606 OID 18063)
-- Name: product_variants product_variants_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_sku_key UNIQUE (sku);


--
-- TOC entry 3883 (class 2606 OID 18223)
-- Name: rental_orders rental_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT rental_orders_pkey PRIMARY KEY (id_rental_order);


--
-- TOC entry 3854 (class 1259 OID 18383)
-- Name: idx_product_variants_barcode; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_barcode ON public.product_variants USING btree (barcode);


--
-- TOC entry 3855 (class 1259 OID 18064)
-- Name: idx_product_variants_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_product_id ON public.product_variants USING btree (product_id);


--
-- TOC entry 3856 (class 1259 OID 18382)
-- Name: idx_product_variants_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_sku ON public.product_variants USING btree (sku);


--
-- TOC entry 3857 (class 1259 OID 18065)
-- Name: idx_product_variants_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_product_variants_status ON public.product_variants USING btree (status);


--
-- TOC entry 3847 (class 1259 OID 18375)
-- Name: idx_pvov_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pvov_product_id ON public.product_variant_option_values USING btree (product_id);


--
-- TOC entry 3884 (class 1259 OID 18256)
-- Name: idx_rental_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_item_order_id ON public.rental_order_items USING btree (rental_order_id);


--
-- TOC entry 3885 (class 1259 OID 18257)
-- Name: idx_rental_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_item_variant_id ON public.rental_order_items USING btree (variant_id);


--
-- TOC entry 3881 (class 1259 OID 18229)
-- Name: idx_rental_orders_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rental_orders_user_id ON public.rental_orders USING btree (user_id);


--
-- TOC entry 3866 (class 1259 OID 18066)
-- Name: products_search_vec_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_search_vec_idx ON public.products USING gin (search_vec);


--
-- TOC entry 3920 (class 2620 OID 18394)
-- Name: products products_search_vec_tg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER products_search_vec_tg BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_tg_fn();


--
-- TOC entry 3921 (class 2620 OID 18395)
-- Name: products trg_products_search_vec; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec BEFORE INSERT OR UPDATE OF product_name, short_description, long_description, origin, user_manual, caution_notes ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3922 (class 2620 OID 18069)
-- Name: products trg_products_search_vec_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_search_vec_update BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.products_search_vec_update();


--
-- TOC entry 3924 (class 2620 OID 18258)
-- Name: rental_order_items trg_rental_order_items_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rental_order_items_set_updated_at BEFORE UPDATE ON public.rental_order_items FOR EACH ROW EXECUTE FUNCTION public.trg_set_timestamp_updated_at();


--
-- TOC entry 3923 (class 2620 OID 18231)
-- Name: rental_orders trg_rental_orders_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rental_orders_set_updated_at BEFORE UPDATE ON public.rental_orders FOR EACH ROW EXECUTE FUNCTION public.trg_set_timestamp_updated_at();


--
-- TOC entry 3913 (class 2606 OID 18070)
-- Name: user_profile_individual FK_059f53ecf53e772aa79eb3c57f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_individual
    ADD CONSTRAINT "FK_059f53ecf53e772aa79eb3c57f1" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3890 (class 2606 OID 18075)
-- Name: addresses FK_0cb4a718cc49a5bc41bf4f950e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT "FK_0cb4a718cc49a5bc41bf4f950e8" FOREIGN KEY ("userUserId") REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3898 (class 2606 OID 18080)
-- Name: order_items FK_145532db85752b29c57d2b7b1f1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "FK_145532db85752b29c57d2b7b1f1" FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 3893 (class 2606 OID 18085)
-- Name: carts FK_2ec1c94a977b940d85a4f498aea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT "FK_2ec1c94a977b940d85a4f498aea" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3891 (class 2606 OID 18090)
-- Name: cart_items FK_30e89257a105eab7648a35c7fce; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_30e89257a105eab7648a35c7fce" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3895 (class 2606 OID 18100)
-- Name: category_attributes FK_55050a8a1b2d2f5202f226d4ac1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_55050a8a1b2d2f5202f226d4ac1" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3892 (class 2606 OID 18105)
-- Name: cart_items FK_6385a745d9e12a89b859bb25623; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT "FK_6385a745d9e12a89b859bb25623" FOREIGN KEY (cart_id) REFERENCES public.carts(cart_id) ON DELETE CASCADE;


--
-- TOC entry 3896 (class 2606 OID 18110)
-- Name: category_attributes FK_6730826326fa81ff5511cb0981a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category_attributes
    ADD CONSTRAINT "FK_6730826326fa81ff5511cb0981a" FOREIGN KEY (attribute_id) REFERENCES public.attributes(attribute_id) ON DELETE CASCADE;


--
-- TOC entry 3908 (class 2606 OID 18120)
-- Name: products FK_9a5f6868c96e0069e699f33e124; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "FK_9a5f6868c96e0069e699f33e124" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3899 (class 2606 OID 18125)
-- Name: orders FK_a922b820eeef29ac1c6800e826a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_a922b820eeef29ac1c6800e826a" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- TOC entry 3912 (class 2606 OID 18130)
-- Name: user_profile_business FK_ad95ecfa0d8f92b9b3c5c025375; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profile_business
    ADD CONSTRAINT "FK_ad95ecfa0d8f92b9b3c5c025375" FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3909 (class 2606 OID 18135)
-- Name: promotion_applicability FK_bccec24fb5216b1dd58b643a8dc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_bccec24fb5216b1dd58b643a8dc" FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 3894 (class 2606 OID 18140)
-- Name: categories FK_de08738901be6b34d2824a1e243; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "FK_de08738901be6b34d2824a1e243" FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- TOC entry 3910 (class 2606 OID 18145)
-- Name: promotion_applicability FK_e8045fc739f5da9b5b8e2bff562; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_e8045fc739f5da9b5b8e2bff562" FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3911 (class 2606 OID 18150)
-- Name: promotion_applicability FK_eb83792e55a6d9d50bcd60d2701; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_applicability
    ADD CONSTRAINT "FK_eb83792e55a6d9d50bcd60d2701" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE CASCADE;


--
-- TOC entry 3900 (class 2606 OID 18155)
-- Name: orders FK_ef840932f45535891306fc3f327; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "FK_ef840932f45535891306fc3f327" FOREIGN KEY (promotion_id) REFERENCES public.promotions(promotion_id) ON DELETE SET NULL;


--
-- TOC entry 3914 (class 2606 OID 18329)
-- Name: rental_orders fk_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT fk_customer FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3916 (class 2606 OID 18246)
-- Name: rental_order_items fk_rental_item_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_order_items
    ADD CONSTRAINT fk_rental_item_order FOREIGN KEY (rental_order_id) REFERENCES public.rental_orders(id_rental_order) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3917 (class 2606 OID 18370)
-- Name: rental_order_items fk_rental_order_items_variant_rental; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_order_items
    ADD CONSTRAINT fk_rental_order_items_variant_rental FOREIGN KEY (variant_rental_id) REFERENCES public.product_variant_rental(id) ON DELETE CASCADE;


--
-- TOC entry 3915 (class 2606 OID 18224)
-- Name: rental_orders fk_rental_orders_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental_orders
    ADD CONSTRAINT fk_rental_orders_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3918 (class 2606 OID 18365)
-- Name: product_variant_rental fk_rentals_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT fk_rentals_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3901 (class 2606 OID 18165)
-- Name: product_variant_inventory fk_variant_inventory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT fk_variant_inventory FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3905 (class 2606 OID 18175)
-- Name: product_variant_prices fk_variant_price; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT fk_variant_price FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id);


--
-- TOC entry 3897 (class 2606 OID 18180)
-- Name: option_values option_values_option_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_values
    ADD CONSTRAINT option_values_option_type_id_fkey FOREIGN KEY (option_type_id) REFERENCES public.option_types(option_type_id) ON DELETE CASCADE;


--
-- TOC entry 3902 (class 2606 OID 18185)
-- Name: product_variant_inventory product_variant_inventory_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory
    ADD CONSTRAINT product_variant_inventory_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3903 (class 2606 OID 18190)
-- Name: product_variant_option_values product_variant_option_values_option_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT product_variant_option_values_option_value_id_fkey FOREIGN KEY (option_value_id) REFERENCES public.option_values(option_value_id) ON DELETE CASCADE;


--
-- TOC entry 3906 (class 2606 OID 18200)
-- Name: product_variant_prices product_variant_prices_variant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_prices
    ADD CONSTRAINT product_variant_prices_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.product_variants(variant_id) ON DELETE CASCADE;


--
-- TOC entry 3919 (class 2606 OID 18360)
-- Name: product_variant_rental product_variant_rental_rental_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_rental
    ADD CONSTRAINT product_variant_rental_rental_price_id_fkey FOREIGN KEY (rental_price_id) REFERENCES public.product_variant_rental_prices(rental_price_id) ON DELETE CASCADE;


--
-- TOC entry 3907 (class 2606 OID 18205)
-- Name: product_variants product_variants_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- TOC entry 3904 (class 2606 OID 18376)
-- Name: product_variant_option_values pvov_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option_values
    ADD CONSTRAINT pvov_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2025-11-11 21:50:40

--
-- PostgreSQL database dump complete
--

\unrestrict mNaBu41gow9uaY8IPFjnh8clYfd2jtlknkfVcrjkZGaWodZyRehXQ9OAt4iNgzx

-- Completed on 2025-11-11 21:50:40

--
-- PostgreSQL database cluster dump complete
--

