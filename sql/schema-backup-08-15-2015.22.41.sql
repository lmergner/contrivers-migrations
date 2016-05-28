--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.writing_to_writing DROP CONSTRAINT writing_to_writing_response_id_fkey;
ALTER TABLE ONLY public.writing_to_writing DROP CONSTRAINT writing_to_writing_respondee_id_fkey;
ALTER TABLE ONLY public.tag_to_writing DROP CONSTRAINT tag_to_writing_writing_id_fkey;
ALTER TABLE ONLY public.tag_to_writing DROP CONSTRAINT tag_to_writing_tag_id_fkey;
ALTER TABLE ONLY public.review DROP CONSTRAINT review_id_fkey;
ALTER TABLE ONLY public.image_to_writing DROP CONSTRAINT image_to_writing_writing_id_fkey;
ALTER TABLE ONLY public.image_to_writing DROP CONSTRAINT image_to_writing_image_id_fkey;
ALTER TABLE ONLY public.book DROP CONSTRAINT book_review_id_fkey;
ALTER TABLE ONLY public.author_to_writing DROP CONSTRAINT author_to_writing_writing_id_fkey;
ALTER TABLE ONLY public.author_to_writing DROP CONSTRAINT author_to_writing_author_id_fkey;
ALTER TABLE ONLY public.article DROP CONSTRAINT article_id_fkey;
DROP TRIGGER ts_update ON public.writing;
DROP INDEX public.tsvector_idx;
ALTER TABLE ONLY public.writing_to_writing DROP CONSTRAINT writing_to_writing_pkey;
ALTER TABLE ONLY public.writing DROP CONSTRAINT writing_pkey;
ALTER TABLE ONLY public.template DROP CONSTRAINT template_pkey;
ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_name_key;
ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
ALTER TABLE ONLY public.key_value DROP CONSTRAINT key_value_pkey;
ALTER TABLE ONLY public.issue DROP CONSTRAINT issue_pkey;
ALTER TABLE ONLY public.issue DROP CONSTRAINT issue_issue_num_key;
ALTER TABLE ONLY public.image DROP CONSTRAINT image_pkey;
ALTER TABLE ONLY public.book DROP CONSTRAINT book_pkey;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_twitter_key;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_pkey;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_email_key;
ALTER TABLE ONLY public.article DROP CONSTRAINT article_pkey;
ALTER TABLE ONLY public.admin DROP CONSTRAINT admin_pkey;
ALTER TABLE public.writing ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.template ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.tag ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.issue ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.image ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.book ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.author ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.admin ALTER COLUMN id DROP DEFAULT;
DROP TABLE public.writing_to_writing;
DROP SEQUENCE public.writing_id_seq;
DROP TABLE public.writing;
DROP SEQUENCE public.template_id_seq;
DROP TABLE public.template;
DROP TABLE public.tag_to_writing;
DROP SEQUENCE public.tag_id_seq;
DROP TABLE public.tag;
DROP TABLE public.review;
DROP TABLE public.key_value;
DROP SEQUENCE public.issue_id_seq;
DROP TABLE public.issue;
DROP TABLE public.image_to_writing;
DROP SEQUENCE public.image_id_seq;
DROP TABLE public.image;
DROP SEQUENCE public.book_id_seq;
DROP TABLE public.book;
DROP TABLE public.author_to_writing;
DROP SEQUENCE public.author_id_seq;
DROP TABLE public.author;
DROP TABLE public.article;
DROP TABLE public.alembic_version;
DROP SEQUENCE public.admin_id_seq;
DROP TABLE public.admin;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin (
    id integer NOT NULL,
    username character varying,
    password character varying
);


--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_id_seq OWNED BY admin.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: article; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE article (
    id integer NOT NULL
);


--
-- Name: author; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    name character varying,
    email character varying NOT NULL,
    twitter character varying,
    bio character varying,
    hidden boolean
);


--
-- Name: author_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE author_id_seq OWNED BY author.id;


--
-- Name: author_to_writing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE author_to_writing (
    writing_id integer,
    author_id integer
);


--
-- Name: book; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE book (
    id integer NOT NULL,
    title character varying,
    subtitle character varying,
    author character varying,
    publisher character varying,
    city character varying,
    year integer,
    isbn_10 integer,
    isbn_13 character varying,
    pages integer,
    price double precision,
    review_id integer
);


--
-- Name: book_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE book_id_seq OWNED BY book.id;


--
-- Name: image; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE image (
    id integer NOT NULL,
    filename character varying,
    url character varying,
    expired boolean
);


--
-- Name: image_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_id_seq OWNED BY image.id;


--
-- Name: image_to_writing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE image_to_writing (
    image_id integer,
    writing_id integer
);


--
-- Name: issue; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue (
    id integer NOT NULL,
    issue_num integer,
    theme character varying
);


--
-- Name: issue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_id_seq OWNED BY issue.id;


--
-- Name: key_value; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE key_value (
    key character varying NOT NULL,
    value json
);


--
-- Name: review; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE review (
    id integer NOT NULL
);


--
-- Name: tag; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag (
    id integer NOT NULL,
    name character varying
);


--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_id_seq OWNED BY tag.id;


--
-- Name: tag_to_writing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_to_writing (
    writing_id integer,
    tag_id integer
);


--
-- Name: template; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE template (
    id integer NOT NULL,
    filename character varying NOT NULL,
    html character varying NOT NULL
);


--
-- Name: template_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE template_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE template_id_seq OWNED BY template.id;


--
-- Name: writing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE writing (
    id integer NOT NULL,
    type character varying NOT NULL,
    create_date timestamp with time zone NOT NULL,
    last_edited_date timestamp with time zone,
    publish_date timestamp with time zone,
    title character varying NOT NULL,
    text character varying,
    summary character varying,
    hidden boolean NOT NULL,
    featured boolean NOT NULL,
    issue_id integer,
    tsvector tsvector
);


--
-- Name: writing_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE writing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: writing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE writing_id_seq OWNED BY writing.id;


--
-- Name: writing_to_writing; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE writing_to_writing (
    response_id integer NOT NULL,
    respondee_id integer NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin ALTER COLUMN id SET DEFAULT nextval('admin_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('author_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY book ALTER COLUMN id SET DEFAULT nextval('book_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY image ALTER COLUMN id SET DEFAULT nextval('image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue ALTER COLUMN id SET DEFAULT nextval('issue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag ALTER COLUMN id SET DEFAULT nextval('tag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY template ALTER COLUMN id SET DEFAULT nextval('template_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY writing ALTER COLUMN id SET DEFAULT nextval('writing_id_seq'::regclass);


--
-- Name: admin_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: article_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- Name: author_email_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_email_key UNIQUE (email);


--
-- Name: author_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- Name: author_twitter_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_twitter_key UNIQUE (twitter);


--
-- Name: book_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- Name: image_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: issue_issue_num_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue
    ADD CONSTRAINT issue_issue_num_key UNIQUE (issue_num);


--
-- Name: issue_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue
    ADD CONSTRAINT issue_pkey PRIMARY KEY (id);


--
-- Name: key_value_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY key_value
    ADD CONSTRAINT key_value_pkey PRIMARY KEY (key);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: tag_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_name_key UNIQUE (name);


--
-- Name: tag_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: template_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- Name: writing_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY writing
    ADD CONSTRAINT writing_pkey PRIMARY KEY (id);


--
-- Name: writing_to_writing_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY writing_to_writing
    ADD CONSTRAINT writing_to_writing_pkey PRIMARY KEY (response_id, respondee_id);


--
-- Name: tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tsvector_idx ON writing USING gin (tsvector);


--
-- Name: ts_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_update BEFORE INSERT OR UPDATE ON writing FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsvector', 'pg_catalog.english', 'title', 'text');


--
-- Name: article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article
    ADD CONSTRAINT article_id_fkey FOREIGN KEY (id) REFERENCES writing(id);


--
-- Name: author_to_writing_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY author_to_writing
    ADD CONSTRAINT author_to_writing_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(id);


--
-- Name: author_to_writing_writing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY author_to_writing
    ADD CONSTRAINT author_to_writing_writing_id_fkey FOREIGN KEY (writing_id) REFERENCES writing(id);


--
-- Name: book_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book
    ADD CONSTRAINT book_review_id_fkey FOREIGN KEY (review_id) REFERENCES review(id);


--
-- Name: image_to_writing_image_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_to_writing
    ADD CONSTRAINT image_to_writing_image_id_fkey FOREIGN KEY (image_id) REFERENCES image(id);


--
-- Name: image_to_writing_writing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_to_writing
    ADD CONSTRAINT image_to_writing_writing_id_fkey FOREIGN KEY (writing_id) REFERENCES writing(id);


--
-- Name: review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_id_fkey FOREIGN KEY (id) REFERENCES writing(id);


--
-- Name: tag_to_writing_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_to_writing
    ADD CONSTRAINT tag_to_writing_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tag(id);


--
-- Name: tag_to_writing_writing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_to_writing
    ADD CONSTRAINT tag_to_writing_writing_id_fkey FOREIGN KEY (writing_id) REFERENCES writing(id);


--
-- Name: writing_to_writing_respondee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writing_to_writing
    ADD CONSTRAINT writing_to_writing_respondee_id_fkey FOREIGN KEY (respondee_id) REFERENCES writing(id);


--
-- Name: writing_to_writing_response_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writing_to_writing
    ADD CONSTRAINT writing_to_writing_response_id_fkey FOREIGN KEY (response_id) REFERENCES writing(id);


--
-- PostgreSQL database dump complete
--

