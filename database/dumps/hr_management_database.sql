--
-- PostgreSQL database dump
--

\restrict D8w2ZeUoyYxrHGe3lmYagxsqHSF7CDgMrnJgMaaMi0wmnvdLNlkgrm6U8Nx1Mqx

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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

ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_position_id_foreign;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_manager_id_foreign;
ALTER TABLE IF EXISTS ONLY public.employee_logs DROP CONSTRAINT IF EXISTS employee_logs_user_id_foreign;
ALTER TABLE IF EXISTS ONLY public.employee_logs DROP CONSTRAINT IF EXISTS employee_logs_employee_id_foreign;
DROP INDEX IF EXISTS public.unique_founder;
DROP INDEX IF EXISTS public.personal_access_tokens_tokenable_type_tokenable_id_index;
DROP INDEX IF EXISTS public.personal_access_tokens_expires_at_index;
DROP INDEX IF EXISTS public.jobs_queue_index;
DROP INDEX IF EXISTS public.employees_manager_id_index;
DROP INDEX IF EXISTS public.employees_last_salary_change_index;
DROP INDEX IF EXISTS public.employee_positions_is_active_index;
DROP INDEX IF EXISTS public.employee_logs_user_id_created_at_index;
DROP INDEX IF EXISTS public.employee_logs_employee_id_created_at_index;
DROP INDEX IF EXISTS public.employee_logs_action_created_at_index;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_unique;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY public.personal_access_tokens DROP CONSTRAINT IF EXISTS personal_access_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.jobs DROP CONSTRAINT IF EXISTS jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.job_batches DROP CONSTRAINT IF EXISTS job_batches_pkey;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_uuid_unique;
ALTER TABLE IF EXISTS ONLY public.failed_jobs DROP CONSTRAINT IF EXISTS failed_jobs_pkey;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_pkey;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_email_unique;
ALTER TABLE IF EXISTS ONLY public.employee_positions DROP CONSTRAINT IF EXISTS employee_positions_pkey;
ALTER TABLE IF EXISTS ONLY public.employee_logs DROP CONSTRAINT IF EXISTS employee_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.cache DROP CONSTRAINT IF EXISTS cache_pkey;
ALTER TABLE IF EXISTS ONLY public.cache_locks DROP CONSTRAINT IF EXISTS cache_locks_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.migrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.failed_jobs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employees ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employee_positions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employee_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.personal_access_tokens_id_seq;
DROP TABLE IF EXISTS public.personal_access_tokens;
DROP TABLE IF EXISTS public.password_reset_tokens;
DROP SEQUENCE IF EXISTS public.migrations_id_seq;
DROP TABLE IF EXISTS public.migrations;
DROP SEQUENCE IF EXISTS public.jobs_id_seq;
DROP TABLE IF EXISTS public.jobs;
DROP TABLE IF EXISTS public.job_batches;
DROP SEQUENCE IF EXISTS public.failed_jobs_id_seq;
DROP TABLE IF EXISTS public.failed_jobs;
DROP SEQUENCE IF EXISTS public.employees_id_seq;
DROP TABLE IF EXISTS public.employees;
DROP SEQUENCE IF EXISTS public.employee_positions_id_seq;
DROP TABLE IF EXISTS public.employee_positions;
DROP SEQUENCE IF EXISTS public.employee_logs_id_seq;
DROP TABLE IF EXISTS public.employee_logs;
DROP TABLE IF EXISTS public.cache_locks;
DROP TABLE IF EXISTS public.cache;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: employee_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_logs (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    user_id bigint,
    action character varying(255) NOT NULL,
    old_data json,
    new_data json,
    ip_address character varying(255),
    user_agent character varying(255),
    description text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.employee_logs OWNER TO postgres;

--
-- Name: employee_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_logs_id_seq OWNER TO postgres;

--
-- Name: employee_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_logs_id_seq OWNED BY public.employee_logs.id;


--
-- Name: employee_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_positions (
    id bigint NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    min_salary integer,
    max_salary integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.employee_positions OWNER TO postgres;

--
-- Name: employee_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_positions_id_seq OWNER TO postgres;

--
-- Name: employee_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_positions_id_seq OWNED BY public.employee_positions.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    salary integer,
    position_id bigint,
    manager_id bigint,
    is_founder boolean DEFAULT false NOT NULL,
    hire_date date NOT NULL,
    phone character varying(255),
    address text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    last_salary_change timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT check_manager_required CHECK (((is_founder = true) OR (manager_id IS NOT NULL))),
    CONSTRAINT employees_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'terminated'::character varying])::text[])))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
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
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: employee_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_logs ALTER COLUMN id SET DEFAULT nextval('public.employee_logs_id_seq'::regclass);


--
-- Name: employee_positions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions ALTER COLUMN id SET DEFAULT nextval('public.employee_positions_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: employee_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_logs (id, employee_id, user_id, action, old_data, new_data, ip_address, user_agent, description, created_at, updated_at) FROM stdin;
1	1	\N	created	\N	{"name":"Founder Employee","email":"erwin.orn@example.net","salary":3153000,"position_id":22,"manager_id":null,"is_founder":true,"hire_date":"2020-05-11T00:00:00.000000Z","phone":"234-450-1465","address":"465 Avis Squares Apt. 990\\nKoeppside, MO 56507","status":"active","last_salary_change":"2024-12-03T04:50:15.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":1}	127.0.0.1	Symfony	System created employee Founder Employee	2025-09-25 06:52:33	2025-09-25 06:52:33
2	2	\N	created	\N	{"name":"Manager sit","email":"kertzmann.coleman@example.net","salary":2161000,"position_id":9,"manager_id":1,"is_founder":false,"hire_date":"2021-02-23T00:00:00.000000Z","phone":"+1-336-672-9180","address":"8363 Matteo Village\\nLeoraview, IA 80965-3302","status":"active","last_salary_change":"2025-06-03T03:24:09.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":2}	127.0.0.1	Symfony	System created employee Manager sit	2025-09-25 06:52:33	2025-09-25 06:52:33
3	3	\N	created	\N	{"name":"Manager aut","email":"joany.welch@example.com","salary":1770000,"position_id":8,"manager_id":1,"is_founder":false,"hire_date":"2022-05-10T00:00:00.000000Z","phone":"650-936-2855","address":"4499 Valentine Terrace\\nWaelchifort, IA 81974-0165","status":"active","last_salary_change":"2025-04-07T14:47:11.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":3}	127.0.0.1	Symfony	System created employee Manager aut	2025-09-25 06:52:33	2025-09-25 06:52:33
4	4	\N	created	\N	{"name":"Manager repellendus","email":"mtorp@example.com","salary":2259000,"position_id":19,"manager_id":1,"is_founder":false,"hire_date":"2023-08-27T00:00:00.000000Z","phone":"1-947-438-8097","address":"5572 Vern Well Suite 790\\nPort Ryleighview, CO 46779-0840","status":"active","last_salary_change":"2025-02-23T16:30:01.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":4}	127.0.0.1	Symfony	System created employee Manager repellendus	2025-09-25 06:52:33	2025-09-25 06:52:33
5	5	\N	created	\N	{"name":"Manager optio","email":"mathias81@example.com","salary":1718000,"position_id":21,"manager_id":1,"is_founder":false,"hire_date":"2020-11-02T00:00:00.000000Z","phone":"520-729-0158","address":"2388 Hirthe Valley Apt. 988\\nWest Cathryn, OH 62279-4284","status":"active","last_salary_change":"2024-10-23T10:26:09.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":5}	127.0.0.1	Symfony	System created employee Manager optio	2025-09-25 06:52:33	2025-09-25 06:52:33
6	6	\N	created	\N	{"name":"Manager amet","email":"maurice08@example.net","salary":2375000,"position_id":1,"manager_id":1,"is_founder":false,"hire_date":"2022-10-09T00:00:00.000000Z","phone":"(470) 612-7125","address":"5439 Gonzalo Greens Apt. 611\\nGottliebborough, AZ 30166","status":"active","last_salary_change":"2025-09-10T13:06:09.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":6}	127.0.0.1	Symfony	System created employee Manager amet	2025-09-25 06:52:33	2025-09-25 06:52:33
7	7	\N	created	\N	{"name":"Angeline Wunsch V","email":"camilla.wintheiser@example.org","salary":2351000,"position_id":19,"manager_id":1,"is_founder":false,"hire_date":"2023-04-17T00:00:00.000000Z","phone":"+1-320-984-0562","address":"279 Mafalda Canyon Apt. 157\\nSkilesmouth, SC 41435","status":"active","last_salary_change":"2025-08-06T00:37:46.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":7}	127.0.0.1	Symfony	System created employee Angeline Wunsch V	2025-09-25 06:52:33	2025-09-25 06:52:33
8	8	\N	created	\N	{"name":"Greyson Johns PhD","email":"fberge@example.org","salary":1314000,"position_id":1,"manager_id":6,"is_founder":false,"hire_date":"2023-11-20T00:00:00.000000Z","phone":"+1 (817) 521-4161","address":"14602 Marge Rapids Apt. 348\\nLake Agnesstad, NV 35595-6813","status":"active","last_salary_change":"2025-01-14T18:10:57.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":8}	127.0.0.1	Symfony	System created employee Greyson Johns PhD	2025-09-25 06:52:33	2025-09-25 06:52:33
9	9	\N	created	\N	{"name":"Raegan Sawayn","email":"keyshawn75@example.net","salary":1934000,"position_id":13,"manager_id":2,"is_founder":false,"hire_date":"2025-06-04T00:00:00.000000Z","phone":"+14707133238","address":"7908 Graham Fort Suite 528\\nWilkinsonhaven, LA 40903","status":"inactive","last_salary_change":"2025-06-28T09:07:21.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":9}	127.0.0.1	Symfony	System created employee Raegan Sawayn	2025-09-25 06:52:33	2025-09-25 06:52:33
10	10	\N	created	\N	{"name":"Marvin Schowalter","email":"izabella74@example.com","salary":1666000,"position_id":11,"manager_id":5,"is_founder":false,"hire_date":"2025-05-18T00:00:00.000000Z","phone":"1-718-327-5530","address":"48118 Dan Walk\\nStevieberg, VT 10864-0520","status":"inactive","last_salary_change":"2024-11-18T20:59:43.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":10}	127.0.0.1	Symfony	System created employee Marvin Schowalter	2025-09-25 06:52:33	2025-09-25 06:52:33
11	11	\N	created	\N	{"name":"Murphy Bayer","email":"dickinson.malika@example.com","salary":2227000,"position_id":22,"manager_id":4,"is_founder":false,"hire_date":"2022-12-15T00:00:00.000000Z","phone":"1-563-956-7040","address":"774 Crooks Walks\\nWildermanville, SC 84917","status":"inactive","last_salary_change":"2025-04-13T16:15:34.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":11}	127.0.0.1	Symfony	System created employee Murphy Bayer	2025-09-25 06:52:33	2025-09-25 06:52:33
12	12	\N	created	\N	{"name":"Berneice Stanton","email":"ustokes@example.com","salary":2346000,"position_id":24,"manager_id":5,"is_founder":false,"hire_date":"2024-09-01T00:00:00.000000Z","phone":"1-941-844-2804","address":"421 Esta Shores Suite 651\\nHettingerberg, DE 08124","status":"active","last_salary_change":"2025-07-19T00:10:47.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":12}	127.0.0.1	Symfony	System created employee Berneice Stanton	2025-09-25 06:52:33	2025-09-25 06:52:33
13	13	\N	created	\N	{"name":"Prof. Glen Cormier","email":"yoberbrunner@example.net","salary":1530000,"position_id":13,"manager_id":3,"is_founder":false,"hire_date":"2024-10-06T00:00:00.000000Z","phone":"(332) 768-1722","address":"462 Freda Mountain\\nHaagside, OK 20093","status":"inactive","last_salary_change":"2024-10-06T12:23:28.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":13}	127.0.0.1	Symfony	System created employee Prof. Glen Cormier	2025-09-25 06:52:33	2025-09-25 06:52:33
14	14	\N	created	\N	{"name":"Dr. Granville Rohan Jr.","email":"block.eldora@example.com","salary":711000,"position_id":15,"manager_id":5,"is_founder":false,"hire_date":"2023-05-13T00:00:00.000000Z","phone":"+1-220-431-5162","address":"626 Cornelius Path Apt. 461\\nWittingview, AZ 50074-7676","status":"active","last_salary_change":"2025-07-05T22:58:26.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":14}	127.0.0.1	Symfony	System created employee Dr. Granville Rohan Jr.	2025-09-25 06:52:33	2025-09-25 06:52:33
15	15	\N	created	\N	{"name":"Prof. Alice Koelpin","email":"colton.fritsch@example.org","salary":2090000,"position_id":2,"manager_id":5,"is_founder":false,"hire_date":"2025-06-02T00:00:00.000000Z","phone":"603-225-6248","address":"7125 Faustino Corners\\nNew Rafaela, LA 74206-0955","status":"inactive","last_salary_change":"2025-05-30T18:09:39.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":15}	127.0.0.1	Symfony	System created employee Prof. Alice Koelpin	2025-09-25 06:52:33	2025-09-25 06:52:33
16	16	\N	created	\N	{"name":"Prof. Norval Stroman I","email":"sydnie20@example.org","salary":2384000,"position_id":9,"manager_id":6,"is_founder":false,"hire_date":"2025-07-04T00:00:00.000000Z","phone":"410.429.8351","address":"4079 Bulah Station Apt. 539\\nSouth Edmund, CA 67174","status":"active","last_salary_change":"2025-03-06T10:50:39.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":16}	127.0.0.1	Symfony	System created employee Prof. Norval Stroman I	2025-09-25 06:52:33	2025-09-25 06:52:33
17	17	\N	created	\N	{"name":"Damion Mante","email":"tyrel12@example.net","salary":955000,"position_id":19,"manager_id":1,"is_founder":false,"hire_date":"2025-05-19T00:00:00.000000Z","phone":"1-551-831-0340","address":"70721 Justina Gateway Apt. 690\\nNew Loyce, WA 07639-7906","status":"active","last_salary_change":"2025-06-04T06:39:17.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":17}	127.0.0.1	Symfony	System created employee Damion Mante	2025-09-25 06:52:33	2025-09-25 06:52:33
18	18	\N	created	\N	{"name":"Jennie Doyle","email":"frunolfsson@example.com","salary":1313000,"position_id":21,"manager_id":6,"is_founder":false,"hire_date":"2024-03-11T00:00:00.000000Z","phone":"336-899-0700","address":"708 Celestine Points Apt. 387\\nEast Bailee, KS 93753","status":"active","last_salary_change":"2024-12-12T23:57:14.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":18}	127.0.0.1	Symfony	System created employee Jennie Doyle	2025-09-25 06:52:33	2025-09-25 06:52:33
19	19	\N	created	\N	{"name":"Ms. Kaylah Hamill III","email":"kub.leonie@example.org","salary":1936000,"position_id":12,"manager_id":4,"is_founder":false,"hire_date":"2024-02-03T00:00:00.000000Z","phone":"+1-856-691-4446","address":"54086 Orn Canyon Suite 874\\nWest Reymundostad, DE 79656-8334","status":"active","last_salary_change":"2024-10-11T23:44:04.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":19}	127.0.0.1	Symfony	System created employee Ms. Kaylah Hamill III	2025-09-25 06:52:33	2025-09-25 06:52:33
20	20	\N	created	\N	{"name":"Chelsey Harvey","email":"mkling@example.net","salary":2408000,"position_id":20,"manager_id":2,"is_founder":false,"hire_date":"2024-11-10T00:00:00.000000Z","phone":"(540) 804-4123","address":"62327 Stroman Isle Suite 954\\nLake Harveytown, MT 88363-4297","status":"active","last_salary_change":"2025-07-18T16:09:42.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":20}	127.0.0.1	Symfony	System created employee Chelsey Harvey	2025-09-25 06:52:33	2025-09-25 06:52:33
21	21	\N	created	\N	{"name":"Nigel Ebert","email":"dina.jakubowski@example.net","salary":1377000,"position_id":3,"manager_id":6,"is_founder":false,"hire_date":"2024-02-21T00:00:00.000000Z","phone":"1-623-604-1478","address":"21618 Celestino Run\\nSouth Derek, WV 89085","status":"active","last_salary_change":"2025-03-23T20:52:08.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":21}	127.0.0.1	Symfony	System created employee Nigel Ebert	2025-09-25 06:52:33	2025-09-25 06:52:33
22	22	\N	created	\N	{"name":"Miss Eulah Labadie","email":"pjones@example.net","salary":712000,"position_id":18,"manager_id":1,"is_founder":false,"hire_date":"2024-06-03T00:00:00.000000Z","phone":"425.266.4192","address":"529 Towne Walks\\nShadview, NV 04681","status":"inactive","last_salary_change":"2025-01-05T19:12:42.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":22}	127.0.0.1	Symfony	System created employee Miss Eulah Labadie	2025-09-25 06:52:33	2025-09-25 06:52:33
23	23	\N	created	\N	{"name":"Delta Marvin","email":"weissnat.kirstin@example.net","salary":2084000,"position_id":5,"manager_id":6,"is_founder":false,"hire_date":"2024-11-19T00:00:00.000000Z","phone":"+1 (404) 690-4914","address":"9781 Kitty Mills\\nNew Archibald, MD 75614-6967","status":"active","last_salary_change":"2025-03-29T09:56:46.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":23}	127.0.0.1	Symfony	System created employee Delta Marvin	2025-09-25 06:52:33	2025-09-25 06:52:33
24	24	\N	created	\N	{"name":"Warren Grimes","email":"karlie88@example.org","salary":2294000,"position_id":24,"manager_id":1,"is_founder":false,"hire_date":"2024-03-14T00:00:00.000000Z","phone":"1-878-846-4459","address":"78445 Baumbach Haven Apt. 659\\nSouth Kaceyport, UT 06124","status":"active","last_salary_change":"2025-08-03T06:39:40.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":24}	127.0.0.1	Symfony	System created employee Warren Grimes	2025-09-25 06:52:33	2025-09-25 06:52:33
25	25	\N	created	\N	{"name":"Miss Lea Emard","email":"kellen.frami@example.org","salary":1088000,"position_id":25,"manager_id":2,"is_founder":false,"hire_date":"2024-07-12T00:00:00.000000Z","phone":"+1-936-786-9406","address":"38646 Romaine Hills Suite 872\\nShannamouth, SD 69631-0651","status":"active","last_salary_change":"2025-01-04T23:55:50.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":25}	127.0.0.1	Symfony	System created employee Miss Lea Emard	2025-09-25 06:52:33	2025-09-25 06:52:33
26	26	\N	created	\N	{"name":"Prof. Otto Bode","email":"jocelyn.jakubowski@example.org","salary":2087000,"position_id":16,"manager_id":6,"is_founder":false,"hire_date":"2024-04-16T00:00:00.000000Z","phone":"+19716870319","address":"974 Carole Pine\\nHelmerton, OK 67430","status":"inactive","last_salary_change":"2024-09-26T01:46:02.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":26}	127.0.0.1	Symfony	System created employee Prof. Otto Bode	2025-09-25 06:52:33	2025-09-25 06:52:33
27	27	\N	created	\N	{"name":"Bruce Thiel","email":"brice69@example.net","salary":917000,"position_id":3,"manager_id":5,"is_founder":false,"hire_date":"2023-01-22T00:00:00.000000Z","phone":"551.736.0138","address":"4539 Sawayn Wall\\nCecilemouth, IA 98354-4008","status":"active","last_salary_change":"2025-03-23T11:28:03.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":27}	127.0.0.1	Symfony	System created employee Bruce Thiel	2025-09-25 06:52:33	2025-09-25 06:52:33
28	28	\N	created	\N	{"name":"Prof. Ervin Welch III","email":"fmiller@example.com","salary":626000,"position_id":21,"manager_id":4,"is_founder":false,"hire_date":"2023-09-20T00:00:00.000000Z","phone":"+1-469-383-7182","address":"3039 Medhurst Mountains\\nSouth Bernie, PA 38553-2311","status":"active","last_salary_change":"2025-08-14T07:01:41.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":28}	127.0.0.1	Symfony	System created employee Prof. Ervin Welch III	2025-09-25 06:52:33	2025-09-25 06:52:33
29	29	\N	created	\N	{"name":"Tiara Stracke","email":"senger.tamara@example.org","salary":2424000,"position_id":10,"manager_id":5,"is_founder":false,"hire_date":"2025-06-11T00:00:00.000000Z","phone":"442-213-9624","address":"294 Moriah Brooks Apt. 485\\nKatherynhaven, WV 75445","status":"active","last_salary_change":"2024-10-14T18:10:53.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":29}	127.0.0.1	Symfony	System created employee Tiara Stracke	2025-09-25 06:52:33	2025-09-25 06:52:33
30	30	\N	created	\N	{"name":"Maxwell Hansen I","email":"olehner@example.org","salary":1509000,"position_id":16,"manager_id":4,"is_founder":false,"hire_date":"2025-04-19T00:00:00.000000Z","phone":"(640) 339-3827","address":"7075 Osinski Parkways Apt. 739\\nWest Elisabeth, ND 04633","status":"active","last_salary_change":"2025-01-27T08:23:03.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":30}	127.0.0.1	Symfony	System created employee Maxwell Hansen I	2025-09-25 06:52:33	2025-09-25 06:52:33
31	31	\N	created	\N	{"name":"Greg Nikolaus DDS","email":"predovic.kylee@example.com","salary":1882000,"position_id":20,"manager_id":1,"is_founder":false,"hire_date":"2024-06-11T00:00:00.000000Z","phone":"1-940-210-0471","address":"458 Wilderman Hill Apt. 069\\nReeseborough, UT 70170-9349","status":"active","last_salary_change":"2025-03-07T08:56:13.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":31}	127.0.0.1	Symfony	System created employee Greg Nikolaus DDS	2025-09-25 06:52:33	2025-09-25 06:52:33
32	32	\N	created	\N	{"name":"Randal Bartoletti Sr.","email":"maxie72@example.org","salary":1730000,"position_id":10,"manager_id":2,"is_founder":false,"hire_date":"2024-07-12T00:00:00.000000Z","phone":"+1-614-846-7046","address":"61647 Lynch Run\\nNew Burnice, FL 14620-4499","status":"inactive","last_salary_change":"2024-11-20T18:57:39.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":32}	127.0.0.1	Symfony	System created employee Randal Bartoletti Sr.	2025-09-25 06:52:33	2025-09-25 06:52:33
33	33	\N	created	\N	{"name":"Miss Meggie Bahringer","email":"casper.freida@example.net","salary":2431000,"position_id":6,"manager_id":6,"is_founder":false,"hire_date":"2025-08-22T00:00:00.000000Z","phone":"+1-310-222-9315","address":"4081 Bartell Parkway\\nPort Tressa, CO 58289","status":"active","last_salary_change":"2025-06-09T10:14:41.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":33}	127.0.0.1	Symfony	System created employee Miss Meggie Bahringer	2025-09-25 06:52:33	2025-09-25 06:52:33
34	34	\N	created	\N	{"name":"Ladarius Macejkovic","email":"wkulas@example.org","salary":1145000,"position_id":21,"manager_id":6,"is_founder":false,"hire_date":"2022-10-30T00:00:00.000000Z","phone":"+1.351.263.5573","address":"73358 Lang Street Suite 152\\nAvistown, MI 18406","status":"active","last_salary_change":"2024-11-26T21:41:40.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":34}	127.0.0.1	Symfony	System created employee Ladarius Macejkovic	2025-09-25 06:52:33	2025-09-25 06:52:33
35	35	\N	created	\N	{"name":"Miss Alvina Koch","email":"gdenesik@example.net","salary":1534000,"position_id":1,"manager_id":5,"is_founder":false,"hire_date":"2025-06-17T00:00:00.000000Z","phone":"360-304-1378","address":"1892 Adams Track\\nNorth Jaeden, NH 22692","status":"active","last_salary_change":"2024-12-17T07:01:55.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":35}	127.0.0.1	Symfony	System created employee Miss Alvina Koch	2025-09-25 06:52:33	2025-09-25 06:52:33
36	36	\N	created	\N	{"name":"Ms. Yvette Thiel","email":"cthompson@example.org","salary":670000,"position_id":25,"manager_id":5,"is_founder":false,"hire_date":"2023-03-26T00:00:00.000000Z","phone":"+1.302.739.9229","address":"697 Gordon Lodge Apt. 210\\nEast Florenciotown, LA 76480-4130","status":"active","last_salary_change":"2024-11-30T17:45:17.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":36}	127.0.0.1	Symfony	System created employee Ms. Yvette Thiel	2025-09-25 06:52:33	2025-09-25 06:52:33
37	37	\N	created	\N	{"name":"Fleta Macejkovic","email":"bret.mills@example.org","salary":1355000,"position_id":25,"manager_id":4,"is_founder":false,"hire_date":"2023-06-22T00:00:00.000000Z","phone":"+1 (361) 814-2902","address":"6934 Collier Circle Apt. 253\\nLake Anita, VT 49053-3844","status":"inactive","last_salary_change":"2024-11-06T02:58:24.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":37}	127.0.0.1	Symfony	System created employee Fleta Macejkovic	2025-09-25 06:52:33	2025-09-25 06:52:33
38	38	\N	created	\N	{"name":"Dr. Hobart Ritchie DDS","email":"verla89@example.net","salary":1597000,"position_id":9,"manager_id":6,"is_founder":false,"hire_date":"2025-04-05T00:00:00.000000Z","phone":"(678) 738-2068","address":"255 Reichel Streets\\nSouth Novella, NC 43377-7270","status":"active","last_salary_change":"2024-10-20T14:02:41.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":38}	127.0.0.1	Symfony	System created employee Dr. Hobart Ritchie DDS	2025-09-25 06:52:33	2025-09-25 06:52:33
39	39	\N	created	\N	{"name":"Bette Cremin PhD","email":"yritchie@example.org","salary":2267000,"position_id":25,"manager_id":2,"is_founder":false,"hire_date":"2023-01-13T00:00:00.000000Z","phone":"+18453902154","address":"171 Destiny Port Suite 024\\nWehnerchester, LA 64753","status":"active","last_salary_change":"2025-01-10T15:43:19.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":39}	127.0.0.1	Symfony	System created employee Bette Cremin PhD	2025-09-25 06:52:33	2025-09-25 06:52:33
40	40	\N	created	\N	{"name":"Prof. Jackie Nicolas Jr.","email":"ugorczany@example.com","salary":1916000,"position_id":17,"manager_id":4,"is_founder":false,"hire_date":"2023-08-16T00:00:00.000000Z","phone":"272-540-4076","address":"386 Gerlach Junction Suite 392\\nEast Dinabury, NC 07799","status":"active","last_salary_change":"2025-02-27T12:02:41.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":40}	127.0.0.1	Symfony	System created employee Prof. Jackie Nicolas Jr.	2025-09-25 06:52:33	2025-09-25 06:52:33
41	41	\N	created	\N	{"name":"Taylor Howe Jr.","email":"cmayert@example.net","salary":2317000,"position_id":7,"manager_id":6,"is_founder":false,"hire_date":"2025-07-16T00:00:00.000000Z","phone":"(425) 658-7116","address":"58616 Bruen Flats Apt. 462\\nSouth Jeaniehaven, FL 39400-4753","status":"active","last_salary_change":"2025-07-22T23:26:28.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":41}	127.0.0.1	Symfony	System created employee Taylor Howe Jr.	2025-09-25 06:52:33	2025-09-25 06:52:33
42	42	\N	created	\N	{"name":"Rod Stamm","email":"effertz.declan@example.com","salary":2017000,"position_id":9,"manager_id":3,"is_founder":false,"hire_date":"2023-01-16T00:00:00.000000Z","phone":"(229) 441-6887","address":"95461 Skiles Plaza Suite 803\\nLake Camylle, MD 73604","status":"active","last_salary_change":"2025-03-24T20:01:18.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":42}	127.0.0.1	Symfony	System created employee Rod Stamm	2025-09-25 06:52:33	2025-09-25 06:52:33
43	43	\N	created	\N	{"name":"Santina Towne","email":"bruen.elenora@example.org","salary":2471000,"position_id":3,"manager_id":2,"is_founder":false,"hire_date":"2024-03-06T00:00:00.000000Z","phone":"442-846-9975","address":"88889 Davis Oval\\nRobbiefort, IN 76738-4432","status":"inactive","last_salary_change":"2025-09-01T10:57:54.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":43}	127.0.0.1	Symfony	System created employee Santina Towne	2025-09-25 06:52:33	2025-09-25 06:52:33
44	44	\N	created	\N	{"name":"Mr. Eusebio McDermott Jr.","email":"raynor.brenna@example.com","salary":1302000,"position_id":4,"manager_id":1,"is_founder":false,"hire_date":"2023-09-25T00:00:00.000000Z","phone":"+1-480-559-0620","address":"375 Schowalter Street Apt. 208\\nNorth Arvidhaven, FL 00302","status":"active","last_salary_change":"2025-06-07T02:17:41.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":44}	127.0.0.1	Symfony	System created employee Mr. Eusebio McDermott Jr.	2025-09-25 06:52:33	2025-09-25 06:52:33
45	45	\N	created	\N	{"name":"Bettye Wunsch","email":"karley.glover@example.com","salary":1102000,"position_id":22,"manager_id":4,"is_founder":false,"hire_date":"2023-02-19T00:00:00.000000Z","phone":"1-947-910-4846","address":"915 Cayla Valleys Suite 233\\nWest Kacieville, WY 47559-2143","status":"inactive","last_salary_change":"2024-11-20T17:01:11.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":45}	127.0.0.1	Symfony	System created employee Bettye Wunsch	2025-09-25 06:52:33	2025-09-25 06:52:33
46	46	\N	created	\N	{"name":"Prof. Kaya Windler","email":"kling.frederick@example.com","salary":1005000,"position_id":12,"manager_id":3,"is_founder":false,"hire_date":"2023-01-03T00:00:00.000000Z","phone":"(626) 433-1160","address":"723 Bernhard Dale\\nWest Fritz, AZ 31678-3219","status":"active","last_salary_change":"2025-06-09T11:53:01.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":46}	127.0.0.1	Symfony	System created employee Prof. Kaya Windler	2025-09-25 06:52:33	2025-09-25 06:52:33
47	47	\N	created	\N	{"name":"Eleonore Gorczany MD","email":"margarita96@example.com","salary":932000,"position_id":1,"manager_id":3,"is_founder":false,"hire_date":"2025-06-15T00:00:00.000000Z","phone":"+1-719-223-1430","address":"50067 Wiegand Mews\\nNorth Idellashire, NH 69495-7596","status":"active","last_salary_change":"2025-04-05T15:38:43.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":47}	127.0.0.1	Symfony	System created employee Eleonore Gorczany MD	2025-09-25 06:52:33	2025-09-25 06:52:33
48	48	\N	created	\N	{"name":"Isabelle Gleichner","email":"aaron.kub@example.com","salary":2353000,"position_id":6,"manager_id":3,"is_founder":false,"hire_date":"2025-03-21T00:00:00.000000Z","phone":"+1.412.496.1151","address":"36724 Steuber Walk Suite 804\\nSouth Maybellechester, DE 82869","status":"active","last_salary_change":"2025-06-27T18:46:28.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":48}	127.0.0.1	Symfony	System created employee Isabelle Gleichner	2025-09-25 06:52:33	2025-09-25 06:52:33
49	49	\N	created	\N	{"name":"Ms. Tania Emard DVM","email":"murphy.gaylord@example.org","salary":1442000,"position_id":22,"manager_id":6,"is_founder":false,"hire_date":"2023-10-28T00:00:00.000000Z","phone":"+1.941.525.5856","address":"94791 Glover Mall\\nBrandohaven, MN 23751","status":"active","last_salary_change":"2025-08-18T20:46:35.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":49}	127.0.0.1	Symfony	System created employee Ms. Tania Emard DVM	2025-09-25 06:52:33	2025-09-25 06:52:33
50	50	\N	created	\N	{"name":"Mrs. Elenora Haag IV","email":"olson.fidel@example.org","salary":1619000,"position_id":7,"manager_id":5,"is_founder":false,"hire_date":"2022-11-13T00:00:00.000000Z","phone":"+1.520.391.0177","address":"6477 Vesta Lane\\nPort Randal, KY 00255-9265","status":"active","last_salary_change":"2025-07-24T13:51:03.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":50}	127.0.0.1	Symfony	System created employee Mrs. Elenora Haag IV	2025-09-25 06:52:33	2025-09-25 06:52:33
51	51	\N	created	\N	{"name":"Miss Kaia Feeney I","email":"vstokes@example.net","salary":1512000,"position_id":17,"manager_id":6,"is_founder":false,"hire_date":"2024-01-10T00:00:00.000000Z","phone":"951.202.3262","address":"138 Tony Well Apt. 172\\nWest Enochview, HI 53064","status":"active","last_salary_change":"2025-09-06T12:03:07.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":51}	127.0.0.1	Symfony	System created employee Miss Kaia Feeney I	2025-09-25 06:52:33	2025-09-25 06:52:33
52	52	\N	created	\N	{"name":"Miss Imelda Fay","email":"austen98@example.net","salary":2473000,"position_id":11,"manager_id":6,"is_founder":false,"hire_date":"2024-11-09T00:00:00.000000Z","phone":"507.297.1102","address":"56404 Hirthe Parkway\\nWest Susan, MO 19434-0302","status":"inactive","last_salary_change":"2024-10-06T09:23:14.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":52}	127.0.0.1	Symfony	System created employee Miss Imelda Fay	2025-09-25 06:52:33	2025-09-25 06:52:33
53	53	\N	created	\N	{"name":"Dr. Thea Heidenreich IV","email":"moshe95@example.com","salary":690000,"position_id":5,"manager_id":6,"is_founder":false,"hire_date":"2024-01-25T00:00:00.000000Z","phone":"+1-559-492-7686","address":"687 Kutch Glen\\nTillmanland, GA 77399","status":"inactive","last_salary_change":"2025-04-26T05:01:02.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":53}	127.0.0.1	Symfony	System created employee Dr. Thea Heidenreich IV	2025-09-25 06:52:33	2025-09-25 06:52:33
54	54	\N	created	\N	{"name":"Chelsey Quigley I","email":"treutel.mason@example.net","salary":1284000,"position_id":23,"manager_id":3,"is_founder":false,"hire_date":"2025-05-01T00:00:00.000000Z","phone":"+1 (765) 237-5524","address":"121 Katelynn Turnpike Apt. 473\\nLake Gayle, PA 34652-8508","status":"active","last_salary_change":"2024-11-09T07:48:05.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":54}	127.0.0.1	Symfony	System created employee Chelsey Quigley I	2025-09-25 06:52:33	2025-09-25 06:52:33
55	55	\N	created	\N	{"name":"Nikita Halvorson","email":"crussel@example.net","salary":2472000,"position_id":15,"manager_id":5,"is_founder":false,"hire_date":"2024-10-14T00:00:00.000000Z","phone":"+1-714-430-4943","address":"12291 Jacinto Valley Suite 741\\nDenesikbury, VA 85172-1388","status":"active","last_salary_change":"2025-02-05T20:11:45.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":55}	127.0.0.1	Symfony	System created employee Nikita Halvorson	2025-09-25 06:52:33	2025-09-25 06:52:33
56	56	\N	created	\N	{"name":"Lenora Batz","email":"alexys79@example.net","salary":1163000,"position_id":9,"manager_id":4,"is_founder":false,"hire_date":"2023-01-30T00:00:00.000000Z","phone":"478.404.8623","address":"4509 Wilkinson Plains\\nEast Courtney, OH 10652","status":"active","last_salary_change":"2025-03-22T18:34:02.000000Z","updated_at":"2025-09-25T06:52:33.000000Z","created_at":"2025-09-25T06:52:33.000000Z","id":56}	127.0.0.1	Symfony	System created employee Lenora Batz	2025-09-25 06:52:33	2025-09-25 06:52:33
\.


--
-- Data for Name: employee_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_positions (id, title, description, min_salary, max_salary, is_active, created_at, updated_at) FROM stdin;
1	Engineer	Et natus assumenda sequi corporis aperiam iste.	1122000	1848000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
2	Mathematical Technician	Deserunt voluptatem ratione omnis voluptatum assumenda alias natus pariatur.	1519000	2252000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
3	Agricultural Crop Farm Manager	Itaque non aut ducimus corporis. Et totam velit ad qui consequatur officiis vitae.	2187000	2643000	f	2025-09-25 06:52:33	2025-09-25 06:52:33
4	Highway Maintenance Worker	Non dicta ratione veritatis deleniti qui consequuntur aut.	1194000	1813000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
5	Structural Iron and Steel Worker	Nostrum corrupti voluptates harum voluptas officiis ipsam ut.	634000	1089000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
6	Webmaster	Voluptas libero eos est quasi sequi et. Dignissimos reprehenderit sed error blanditiis et.	1606000	2365000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
7	Wellhead Pumper	Aliquid accusantium nobis ex tempore cumque. Consequatur aut est est expedita accusamus vitae odit.	672000	1356000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
8	Truck Driver	Nihil facilis consequatur dolorem dolorem iure.	2125000	2864000	f	2025-09-25 06:52:33	2025-09-25 06:52:33
9	Pipelayer	Occaecati voluptatem est nostrum.	1699000	2261000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
10	Jewelry Model OR Mold Makers	Explicabo harum aut laboriosam et velit commodi. Mollitia explicabo omnis voluptatem.	2099000	2867000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
11	Tile Setter OR Marble Setter	Est ea ut numquam consequatur odit dolor vel.	1986000	2404000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
12	City	Eius necessitatibus sequi voluptas odit nesciunt temporibus quis tenetur.	610000	1369000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
13	Motorboat Mechanic	Voluptatem accusamus voluptatem dolor est reprehenderit iste qui ipsam.	1047000	1308000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
14	Typesetting Machine Operator	Sed nesciunt vel aut culpa consequatur. Recusandae praesentium possimus harum omnis qui neque.	2347000	3069000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
15	Fitter	Id quis pariatur doloribus non id et.	979000	1413000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
16	Animal Trainer	Mollitia amet amet reprehenderit ut non. Officiis optio voluptas laborum iste tenetur quisquam.	1331000	1600000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
17	Night Shift	Ullam qui ratione pariatur est perspiciatis asperiores neque.	1596000	2269000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
18	Electrical Parts Reconditioner	Ut omnis consequuntur iste non. Illum delectus dolor voluptas vitae quo.	1598000	2216000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
19	Tile Setter OR Marble Setter	Dolorum expedita voluptatem voluptatem ex omnis ipsam.	2256000	2894000	f	2025-09-25 06:52:33	2025-09-25 06:52:33
20	Recreational Vehicle Service Technician	Quia impedit laboriosam voluptatem fuga voluptas culpa. Id reprehenderit qui qui occaecati incidunt voluptate.	1439000	1909000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
21	Obstetrician	Aliquam aut adipisci autem voluptatum hic autem. Explicabo quis iste magnam ut.	1016000	1763000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
22	Food Preparation	Molestiae et eaque fugiat. At similique deserunt maiores fugiat quibusdam.	2348000	2728000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
23	Lathe Operator	Iure quos rerum id cumque sed tempora.	1498000	2098000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
24	Personal Care Worker	Eligendi eligendi ut molestiae voluptate incidunt eligendi. Rem quam dolore consequatur harum dolor.	1888000	2151000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
25	Radiologic Technician	Eligendi quod expedita recusandae odit quia. Molestias sapiente alias itaque autem quas autem veritatis est.	1244000	1884000	t	2025-09-25 06:52:33	2025-09-25 06:52:33
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, name, email, salary, position_id, manager_id, is_founder, hire_date, phone, address, status, last_salary_change, created_at, updated_at, deleted_at) FROM stdin;
1	Founder Employee	erwin.orn@example.net	3153000	22	\N	t	2020-05-11	234-450-1465	465 Avis Squares Apt. 990\nKoeppside, MO 56507	active	2024-12-03 04:50:15	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
2	Manager sit	kertzmann.coleman@example.net	2161000	9	1	f	2021-02-23	+1-336-672-9180	8363 Matteo Village\nLeoraview, IA 80965-3302	active	2025-06-03 03:24:09	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
3	Manager aut	joany.welch@example.com	1770000	8	1	f	2022-05-10	650-936-2855	4499 Valentine Terrace\nWaelchifort, IA 81974-0165	active	2025-04-07 14:47:11	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
4	Manager repellendus	mtorp@example.com	2259000	19	1	f	2023-08-27	1-947-438-8097	5572 Vern Well Suite 790\nPort Ryleighview, CO 46779-0840	active	2025-02-23 16:30:01	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
5	Manager optio	mathias81@example.com	1718000	21	1	f	2020-11-02	520-729-0158	2388 Hirthe Valley Apt. 988\nWest Cathryn, OH 62279-4284	active	2024-10-23 10:26:09	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
6	Manager amet	maurice08@example.net	2375000	1	1	f	2022-10-09	(470) 612-7125	5439 Gonzalo Greens Apt. 611\nGottliebborough, AZ 30166	active	2025-09-10 13:06:09	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
7	Angeline Wunsch V	camilla.wintheiser@example.org	2351000	19	1	f	2023-04-17	+1-320-984-0562	279 Mafalda Canyon Apt. 157\nSkilesmouth, SC 41435	active	2025-08-06 00:37:46	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
8	Greyson Johns PhD	fberge@example.org	1314000	1	6	f	2023-11-20	+1 (817) 521-4161	14602 Marge Rapids Apt. 348\nLake Agnesstad, NV 35595-6813	active	2025-01-14 18:10:57	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
9	Raegan Sawayn	keyshawn75@example.net	1934000	13	2	f	2025-06-04	+14707133238	7908 Graham Fort Suite 528\nWilkinsonhaven, LA 40903	inactive	2025-06-28 09:07:21	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
10	Marvin Schowalter	izabella74@example.com	1666000	11	5	f	2025-05-18	1-718-327-5530	48118 Dan Walk\nStevieberg, VT 10864-0520	inactive	2024-11-18 20:59:43	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
11	Murphy Bayer	dickinson.malika@example.com	2227000	22	4	f	2022-12-15	1-563-956-7040	774 Crooks Walks\nWildermanville, SC 84917	inactive	2025-04-13 16:15:34	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
12	Berneice Stanton	ustokes@example.com	2346000	24	5	f	2024-09-01	1-941-844-2804	421 Esta Shores Suite 651\nHettingerberg, DE 08124	active	2025-07-19 00:10:47	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
13	Prof. Glen Cormier	yoberbrunner@example.net	1530000	13	3	f	2024-10-06	(332) 768-1722	462 Freda Mountain\nHaagside, OK 20093	inactive	2024-10-06 12:23:28	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
14	Dr. Granville Rohan Jr.	block.eldora@example.com	711000	15	5	f	2023-05-13	+1-220-431-5162	626 Cornelius Path Apt. 461\nWittingview, AZ 50074-7676	active	2025-07-05 22:58:26	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
15	Prof. Alice Koelpin	colton.fritsch@example.org	2090000	2	5	f	2025-06-02	603-225-6248	7125 Faustino Corners\nNew Rafaela, LA 74206-0955	inactive	2025-05-30 18:09:39	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
16	Prof. Norval Stroman I	sydnie20@example.org	2384000	9	6	f	2025-07-04	410.429.8351	4079 Bulah Station Apt. 539\nSouth Edmund, CA 67174	active	2025-03-06 10:50:39	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
17	Damion Mante	tyrel12@example.net	955000	19	1	f	2025-05-19	1-551-831-0340	70721 Justina Gateway Apt. 690\nNew Loyce, WA 07639-7906	active	2025-06-04 06:39:17	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
18	Jennie Doyle	frunolfsson@example.com	1313000	21	6	f	2024-03-11	336-899-0700	708 Celestine Points Apt. 387\nEast Bailee, KS 93753	active	2024-12-12 23:57:14	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
19	Ms. Kaylah Hamill III	kub.leonie@example.org	1936000	12	4	f	2024-02-03	+1-856-691-4446	54086 Orn Canyon Suite 874\nWest Reymundostad, DE 79656-8334	active	2024-10-11 23:44:04	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
20	Chelsey Harvey	mkling@example.net	2408000	20	2	f	2024-11-10	(540) 804-4123	62327 Stroman Isle Suite 954\nLake Harveytown, MT 88363-4297	active	2025-07-18 16:09:42	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
21	Nigel Ebert	dina.jakubowski@example.net	1377000	3	6	f	2024-02-21	1-623-604-1478	21618 Celestino Run\nSouth Derek, WV 89085	active	2025-03-23 20:52:08	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
22	Miss Eulah Labadie	pjones@example.net	712000	18	1	f	2024-06-03	425.266.4192	529 Towne Walks\nShadview, NV 04681	inactive	2025-01-05 19:12:42	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
23	Delta Marvin	weissnat.kirstin@example.net	2084000	5	6	f	2024-11-19	+1 (404) 690-4914	9781 Kitty Mills\nNew Archibald, MD 75614-6967	active	2025-03-29 09:56:46	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
24	Warren Grimes	karlie88@example.org	2294000	24	1	f	2024-03-14	1-878-846-4459	78445 Baumbach Haven Apt. 659\nSouth Kaceyport, UT 06124	active	2025-08-03 06:39:40	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
25	Miss Lea Emard	kellen.frami@example.org	1088000	25	2	f	2024-07-12	+1-936-786-9406	38646 Romaine Hills Suite 872\nShannamouth, SD 69631-0651	active	2025-01-04 23:55:50	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
26	Prof. Otto Bode	jocelyn.jakubowski@example.org	2087000	16	6	f	2024-04-16	+19716870319	974 Carole Pine\nHelmerton, OK 67430	inactive	2024-09-26 01:46:02	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
27	Bruce Thiel	brice69@example.net	917000	3	5	f	2023-01-22	551.736.0138	4539 Sawayn Wall\nCecilemouth, IA 98354-4008	active	2025-03-23 11:28:03	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
28	Prof. Ervin Welch III	fmiller@example.com	626000	21	4	f	2023-09-20	+1-469-383-7182	3039 Medhurst Mountains\nSouth Bernie, PA 38553-2311	active	2025-08-14 07:01:41	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
29	Tiara Stracke	senger.tamara@example.org	2424000	10	5	f	2025-06-11	442-213-9624	294 Moriah Brooks Apt. 485\nKatherynhaven, WV 75445	active	2024-10-14 18:10:53	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
30	Maxwell Hansen I	olehner@example.org	1509000	16	4	f	2025-04-19	(640) 339-3827	7075 Osinski Parkways Apt. 739\nWest Elisabeth, ND 04633	active	2025-01-27 08:23:03	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
31	Greg Nikolaus DDS	predovic.kylee@example.com	1882000	20	1	f	2024-06-11	1-940-210-0471	458 Wilderman Hill Apt. 069\nReeseborough, UT 70170-9349	active	2025-03-07 08:56:13	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
32	Randal Bartoletti Sr.	maxie72@example.org	1730000	10	2	f	2024-07-12	+1-614-846-7046	61647 Lynch Run\nNew Burnice, FL 14620-4499	inactive	2024-11-20 18:57:39	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
33	Miss Meggie Bahringer	casper.freida@example.net	2431000	6	6	f	2025-08-22	+1-310-222-9315	4081 Bartell Parkway\nPort Tressa, CO 58289	active	2025-06-09 10:14:41	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
34	Ladarius Macejkovic	wkulas@example.org	1145000	21	6	f	2022-10-30	+1.351.263.5573	73358 Lang Street Suite 152\nAvistown, MI 18406	active	2024-11-26 21:41:40	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
35	Miss Alvina Koch	gdenesik@example.net	1534000	1	5	f	2025-06-17	360-304-1378	1892 Adams Track\nNorth Jaeden, NH 22692	active	2024-12-17 07:01:55	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
36	Ms. Yvette Thiel	cthompson@example.org	670000	25	5	f	2023-03-26	+1.302.739.9229	697 Gordon Lodge Apt. 210\nEast Florenciotown, LA 76480-4130	active	2024-11-30 17:45:17	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
37	Fleta Macejkovic	bret.mills@example.org	1355000	25	4	f	2023-06-22	+1 (361) 814-2902	6934 Collier Circle Apt. 253\nLake Anita, VT 49053-3844	inactive	2024-11-06 02:58:24	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
38	Dr. Hobart Ritchie DDS	verla89@example.net	1597000	9	6	f	2025-04-05	(678) 738-2068	255 Reichel Streets\nSouth Novella, NC 43377-7270	active	2024-10-20 14:02:41	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
39	Bette Cremin PhD	yritchie@example.org	2267000	25	2	f	2023-01-13	+18453902154	171 Destiny Port Suite 024\nWehnerchester, LA 64753	active	2025-01-10 15:43:19	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
40	Prof. Jackie Nicolas Jr.	ugorczany@example.com	1916000	17	4	f	2023-08-16	272-540-4076	386 Gerlach Junction Suite 392\nEast Dinabury, NC 07799	active	2025-02-27 12:02:41	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
41	Taylor Howe Jr.	cmayert@example.net	2317000	7	6	f	2025-07-16	(425) 658-7116	58616 Bruen Flats Apt. 462\nSouth Jeaniehaven, FL 39400-4753	active	2025-07-22 23:26:28	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
42	Rod Stamm	effertz.declan@example.com	2017000	9	3	f	2023-01-16	(229) 441-6887	95461 Skiles Plaza Suite 803\nLake Camylle, MD 73604	active	2025-03-24 20:01:18	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
43	Santina Towne	bruen.elenora@example.org	2471000	3	2	f	2024-03-06	442-846-9975	88889 Davis Oval\nRobbiefort, IN 76738-4432	inactive	2025-09-01 10:57:54	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
44	Mr. Eusebio McDermott Jr.	raynor.brenna@example.com	1302000	4	1	f	2023-09-25	+1-480-559-0620	375 Schowalter Street Apt. 208\nNorth Arvidhaven, FL 00302	active	2025-06-07 02:17:41	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
45	Bettye Wunsch	karley.glover@example.com	1102000	22	4	f	2023-02-19	1-947-910-4846	915 Cayla Valleys Suite 233\nWest Kacieville, WY 47559-2143	inactive	2024-11-20 17:01:11	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
46	Prof. Kaya Windler	kling.frederick@example.com	1005000	12	3	f	2023-01-03	(626) 433-1160	723 Bernhard Dale\nWest Fritz, AZ 31678-3219	active	2025-06-09 11:53:01	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
47	Eleonore Gorczany MD	margarita96@example.com	932000	1	3	f	2025-06-15	+1-719-223-1430	50067 Wiegand Mews\nNorth Idellashire, NH 69495-7596	active	2025-04-05 15:38:43	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
48	Isabelle Gleichner	aaron.kub@example.com	2353000	6	3	f	2025-03-21	+1.412.496.1151	36724 Steuber Walk Suite 804\nSouth Maybellechester, DE 82869	active	2025-06-27 18:46:28	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
49	Ms. Tania Emard DVM	murphy.gaylord@example.org	1442000	22	6	f	2023-10-28	+1.941.525.5856	94791 Glover Mall\nBrandohaven, MN 23751	active	2025-08-18 20:46:35	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
50	Mrs. Elenora Haag IV	olson.fidel@example.org	1619000	7	5	f	2022-11-13	+1.520.391.0177	6477 Vesta Lane\nPort Randal, KY 00255-9265	active	2025-07-24 13:51:03	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
51	Miss Kaia Feeney I	vstokes@example.net	1512000	17	6	f	2024-01-10	951.202.3262	138 Tony Well Apt. 172\nWest Enochview, HI 53064	active	2025-09-06 12:03:07	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
52	Miss Imelda Fay	austen98@example.net	2473000	11	6	f	2024-11-09	507.297.1102	56404 Hirthe Parkway\nWest Susan, MO 19434-0302	inactive	2024-10-06 09:23:14	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
53	Dr. Thea Heidenreich IV	moshe95@example.com	690000	5	6	f	2024-01-25	+1-559-492-7686	687 Kutch Glen\nTillmanland, GA 77399	inactive	2025-04-26 05:01:02	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
54	Chelsey Quigley I	treutel.mason@example.net	1284000	23	3	f	2025-05-01	+1 (765) 237-5524	121 Katelynn Turnpike Apt. 473\nLake Gayle, PA 34652-8508	active	2024-11-09 07:48:05	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
55	Nikita Halvorson	crussel@example.net	2472000	15	5	f	2024-10-14	+1-714-430-4943	12291 Jacinto Valley Suite 741\nDenesikbury, VA 85172-1388	active	2025-02-05 20:11:45	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
56	Lenora Batz	alexys79@example.net	1163000	9	4	f	2023-01-30	478.404.8623	4509 Wilkinson Plains\nEast Courtney, OH 10652	active	2025-03-22 18:34:02	2025-09-25 06:52:33	2025-09-25 06:52:33	\N
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2025_09_23_135702_create_personal_access_tokens_table	1
5	2025_09_23_135728_create_employee_positions_table	1
6	2025_09_23_135729_create_employees_table	1
7	2025_09_24_224303_create_employee_logs_table	1
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
1	Test User	test@example.com	2025-09-25 06:52:33	$2y$12$/E19i8bkhMYz6yrD2VxzP.eSUs2LRZRw3YjT4WjD876sp2hw/jDqG	sI6tC13rWV	2025-09-25 06:52:33	2025-09-25 06:52:33
\.


--
-- Name: employee_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_logs_id_seq', 56, true);


--
-- Name: employee_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_positions_id_seq', 25, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 56, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 7, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: employee_logs employee_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_logs
    ADD CONSTRAINT employee_logs_pkey PRIMARY KEY (id);


--
-- Name: employee_positions employee_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions
    ADD CONSTRAINT employee_positions_pkey PRIMARY KEY (id);


--
-- Name: employees employees_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_unique UNIQUE (email);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: employee_logs_action_created_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_logs_action_created_at_index ON public.employee_logs USING btree (action, created_at);


--
-- Name: employee_logs_employee_id_created_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_logs_employee_id_created_at_index ON public.employee_logs USING btree (employee_id, created_at);


--
-- Name: employee_logs_user_id_created_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_logs_user_id_created_at_index ON public.employee_logs USING btree (user_id, created_at);


--
-- Name: employee_positions_is_active_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_positions_is_active_index ON public.employee_positions USING btree (is_active);


--
-- Name: employees_last_salary_change_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employees_last_salary_change_index ON public.employees USING btree (last_salary_change);


--
-- Name: employees_manager_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employees_manager_id_index ON public.employees USING btree (manager_id);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: unique_founder; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_founder ON public.employees USING btree (is_founder) WHERE (is_founder = true);


--
-- Name: employee_logs employee_logs_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_logs
    ADD CONSTRAINT employee_logs_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: employee_logs employee_logs_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_logs
    ADD CONSTRAINT employee_logs_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: employees employees_manager_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_foreign FOREIGN KEY (manager_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: employees employees_position_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_foreign FOREIGN KEY (position_id) REFERENCES public.employee_positions(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict D8w2ZeUoyYxrHGe3lmYagxsqHSF7CDgMrnJgMaaMi0wmnvdLNlkgrm6U8Nx1Mqx

