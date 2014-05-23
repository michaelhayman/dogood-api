--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: badges_sashes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE badges_sashes (
    id integer NOT NULL,
    badge_id integer,
    sash_id integer,
    notified_user boolean DEFAULT false,
    created_at timestamp without time zone
);


--
-- Name: badges_sashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE badges_sashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badges_sashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE badges_sashes_id_seq OWNED BY badges_sashes.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name_constant text,
    colour character varying(255)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: claimed_rewards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE claimed_rewards (
    id integer NOT NULL,
    user_id integer,
    reward_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: claimed_rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claimed_rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claimed_rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE claimed_rewards_id_seq OWNED BY claimed_rewards.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    title character varying(50) DEFAULT ''::character varying,
    comment text,
    commentable_id integer,
    commentable_type character varying(255),
    user_id integer,
    role character varying(255) DEFAULT 'comments'::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entities (
    id integer NOT NULL,
    link text NOT NULL,
    link_id integer NOT NULL,
    link_type text NOT NULL,
    title text NOT NULL,
    entityable_id integer NOT NULL,
    entityable_type character varying(255) NOT NULL,
    range character varying(255)[] NOT NULL
);


--
-- Name: entities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entities_id_seq OWNED BY entities.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE follows (
    id integer NOT NULL,
    followable_id integer NOT NULL,
    followable_type character varying(255) NOT NULL,
    follower_id integer NOT NULL,
    follower_type character varying(255) NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: goods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE goods (
    id integer NOT NULL,
    caption character varying(255),
    category_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    comments_count integer DEFAULT 0,
    cached_votes_total integer DEFAULT 0,
    cached_votes_score integer DEFAULT 0,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    evidence character varying(255),
    follows_count integer DEFAULT 0,
    points integer DEFAULT 0,
    lat double precision,
    lng double precision,
    location_image character varying(255),
    location_name character varying(255),
    done boolean DEFAULT true,
    nominee_id integer
);


--
-- Name: goods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goods_id_seq OWNED BY goods.id;


--
-- Name: merit_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_actions (
    id integer NOT NULL,
    user_id integer,
    action_method character varying(255),
    action_value integer,
    had_errors boolean DEFAULT false,
    target_model character varying(255),
    target_id integer,
    processed boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: merit_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_actions_id_seq OWNED BY merit_actions.id;


--
-- Name: merit_activity_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_activity_logs (
    id integer NOT NULL,
    action_id integer,
    related_change_type character varying(255),
    related_change_id integer,
    description character varying(255),
    created_at timestamp without time zone
);


--
-- Name: merit_activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_activity_logs_id_seq OWNED BY merit_activity_logs.id;


--
-- Name: merit_score_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_score_points (
    id integer NOT NULL,
    score_id integer,
    num_points integer DEFAULT 0,
    log character varying(255),
    created_at timestamp without time zone
);


--
-- Name: merit_score_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_score_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_score_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_score_points_id_seq OWNED BY merit_score_points.id;


--
-- Name: merit_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE merit_scores (
    id integer NOT NULL,
    sash_id integer,
    category character varying(255) DEFAULT 'default'::character varying
);


--
-- Name: merit_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merit_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merit_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merit_scores_id_seq OWNED BY merit_scores.id;


--
-- Name: nominees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nominees (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(255),
    twitter_id character varying(255),
    facebook_id character varying(255),
    avatar character varying(255),
    user_id integer DEFAULT 0
);


--
-- Name: nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nominees_id_seq OWNED BY nominees.id;


--
-- Name: points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE points (
    id integer NOT NULL,
    pointable_type character varying(255) NOT NULL,
    pointable_id integer NOT NULL,
    pointable_sub_type character varying(255) NOT NULL,
    to_user_id integer NOT NULL,
    from_user_id integer,
    points integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE points_id_seq OWNED BY points.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    reportable_type character varying(255),
    reportable_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: rewards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rewards (
    id integer NOT NULL,
    title character varying(255),
    subtitle character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    cost integer DEFAULT 0,
    quantity integer DEFAULT 0,
    quantity_remaining integer DEFAULT 0,
    full_description text,
    teaser character varying(255),
    instructions text
);


--
-- Name: rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rewards_id_seq OWNED BY rewards.id;


--
-- Name: sashes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sashes (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sashes_id_seq OWNED BY sashes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: simple_hashtag_hashtaggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE simple_hashtag_hashtaggings (
    id integer NOT NULL,
    hashtag_id integer,
    hashtaggable_id integer,
    hashtaggable_type character varying(255)
);


--
-- Name: simple_hashtag_hashtaggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE simple_hashtag_hashtaggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simple_hashtag_hashtaggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE simple_hashtag_hashtaggings_id_seq OWNED BY simple_hashtag_hashtaggings.id;


--
-- Name: simple_hashtag_hashtags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE simple_hashtag_hashtags (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: simple_hashtag_hashtags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE simple_hashtag_hashtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simple_hashtag_hashtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE simple_hashtag_hashtags_id_seq OWNED BY simple_hashtag_hashtags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    avatar character varying(255),
    follows_count integer DEFAULT 0,
    full_name character varying(255),
    phone character varying(255),
    points_cache integer DEFAULT 0,
    location character varying(255),
    biography character varying(255),
    facebook_id character varying(255),
    twitter_id character varying(255),
    sash_id integer,
    level integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    votable_id integer,
    votable_type character varying(255),
    voter_id integer,
    voter_type character varying(255),
    vote_flag boolean,
    vote_scope character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY badges_sashes ALTER COLUMN id SET DEFAULT nextval('badges_sashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY claimed_rewards ALTER COLUMN id SET DEFAULT nextval('claimed_rewards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entities ALTER COLUMN id SET DEFAULT nextval('entities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods ALTER COLUMN id SET DEFAULT nextval('goods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_actions ALTER COLUMN id SET DEFAULT nextval('merit_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_activity_logs ALTER COLUMN id SET DEFAULT nextval('merit_activity_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_score_points ALTER COLUMN id SET DEFAULT nextval('merit_score_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merit_scores ALTER COLUMN id SET DEFAULT nextval('merit_scores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY nominees ALTER COLUMN id SET DEFAULT nextval('nominees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY points ALTER COLUMN id SET DEFAULT nextval('points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rewards ALTER COLUMN id SET DEFAULT nextval('rewards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sashes ALTER COLUMN id SET DEFAULT nextval('sashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY simple_hashtag_hashtaggings ALTER COLUMN id SET DEFAULT nextval('simple_hashtag_hashtaggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY simple_hashtag_hashtags ALTER COLUMN id SET DEFAULT nextval('simple_hashtag_hashtags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: badges_sashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY badges_sashes
    ADD CONSTRAINT badges_sashes_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: claimed_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY claimed_rewards
    ADD CONSTRAINT claimed_rewards_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: goods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- Name: merit_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_actions
    ADD CONSTRAINT merit_actions_pkey PRIMARY KEY (id);


--
-- Name: merit_activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_activity_logs
    ADD CONSTRAINT merit_activity_logs_pkey PRIMARY KEY (id);


--
-- Name: merit_score_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_score_points
    ADD CONSTRAINT merit_score_points_pkey PRIMARY KEY (id);


--
-- Name: merit_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY merit_scores
    ADD CONSTRAINT merit_scores_pkey PRIMARY KEY (id);


--
-- Name: nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nominees
    ADD CONSTRAINT nominees_pkey PRIMARY KEY (id);


--
-- Name: points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rewards
    ADD CONSTRAINT rewards_pkey PRIMARY KEY (id);


--
-- Name: sashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sashes
    ADD CONSTRAINT sashes_pkey PRIMARY KEY (id);


--
-- Name: simple_hashtag_hashtaggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY simple_hashtag_hashtaggings
    ADD CONSTRAINT simple_hashtag_hashtaggings_pkey PRIMARY KEY (id);


--
-- Name: simple_hashtag_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY simple_hashtag_hashtags
    ADD CONSTRAINT simple_hashtag_hashtags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: fk_followables; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_followables ON follows USING btree (followable_id, followable_type);


--
-- Name: fk_follows; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_follows ON follows USING btree (follower_id, follower_type);


--
-- Name: index_badges_sashes_on_badge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_badge_id ON badges_sashes USING btree (badge_id);


--
-- Name: index_badges_sashes_on_badge_id_and_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_badge_id_and_sash_id ON badges_sashes USING btree (badge_id, sash_id);


--
-- Name: index_badges_sashes_on_sash_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_badges_sashes_on_sash_id ON badges_sashes USING btree (sash_id);


--
-- Name: index_claimed_rewards_on_reward_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_claimed_rewards_on_reward_id ON claimed_rewards USING btree (reward_id);


--
-- Name: index_claimed_rewards_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_claimed_rewards_on_user_id ON claimed_rewards USING btree (user_id);


--
-- Name: index_comments_on_commentable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id ON comments USING btree (commentable_id);


--
-- Name: index_comments_on_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_type ON comments USING btree (commentable_type);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_goods_on_cached_votes_down; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_cached_votes_down ON goods USING btree (cached_votes_down);


--
-- Name: index_goods_on_cached_votes_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_cached_votes_score ON goods USING btree (cached_votes_score);


--
-- Name: index_goods_on_cached_votes_total; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_cached_votes_total ON goods USING btree (cached_votes_total);


--
-- Name: index_goods_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_cached_votes_up ON goods USING btree (cached_votes_up);


--
-- Name: index_goods_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_category_id ON goods USING btree (category_id);


--
-- Name: index_goods_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_goods_on_user_id ON goods USING btree (user_id);


--
-- Name: index_hashtaggings_hashtaggable_id_hashtaggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hashtaggings_hashtaggable_id_hashtaggable_type ON simple_hashtag_hashtaggings USING btree (hashtaggable_id, hashtaggable_type);


--
-- Name: index_points_on_from_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_points_on_from_user_id ON points USING btree (from_user_id);


--
-- Name: index_points_on_pointable_id_and_pointable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_points_on_pointable_id_and_pointable_type ON points USING btree (pointable_id, pointable_type);


--
-- Name: index_points_on_to_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_points_on_to_user_id ON points USING btree (to_user_id);


--
-- Name: index_reports_on_reportable_id_and_reportable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_reportable_id_and_reportable_type ON reports USING btree (reportable_id, reportable_type);


--
-- Name: index_rewards_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rewards_on_user_id ON rewards USING btree (user_id);


--
-- Name: index_simple_hashtag_hashtaggings_on_hashtag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_simple_hashtag_hashtaggings_on_hashtag_id ON simple_hashtag_hashtaggings USING btree (hashtag_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_facebook_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_facebook_id ON users USING btree (facebook_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_twitter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_twitter_id ON users USING btree (twitter_id);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_vote_scope ON votes USING btree (votable_id, votable_type, vote_scope);


--
-- Name: index_votes_on_voter_id_and_voter_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id_and_voter_type_and_vote_scope ON votes USING btree (voter_id, voter_type, vote_scope);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130807190030');

INSERT INTO schema_migrations (version) VALUES ('20130807214727');

INSERT INTO schema_migrations (version) VALUES ('20130807215243');

INSERT INTO schema_migrations (version) VALUES ('20130807215807');

INSERT INTO schema_migrations (version) VALUES ('20130807221504');

INSERT INTO schema_migrations (version) VALUES ('20130808023624');

INSERT INTO schema_migrations (version) VALUES ('20130808024311');

INSERT INTO schema_migrations (version) VALUES ('20130808024312');

INSERT INTO schema_migrations (version) VALUES ('20130808024313');

INSERT INTO schema_migrations (version) VALUES ('20130808024330');

INSERT INTO schema_migrations (version) VALUES ('20130808133319');

INSERT INTO schema_migrations (version) VALUES ('20130808154329');

INSERT INTO schema_migrations (version) VALUES ('20130808191937');

INSERT INTO schema_migrations (version) VALUES ('20130808192629');

INSERT INTO schema_migrations (version) VALUES ('20130808212447');

INSERT INTO schema_migrations (version) VALUES ('20130809121902');

INSERT INTO schema_migrations (version) VALUES ('20130811033033');

INSERT INTO schema_migrations (version) VALUES ('20130811220631');

INSERT INTO schema_migrations (version) VALUES ('20130812140724');

INSERT INTO schema_migrations (version) VALUES ('20130812150112');

INSERT INTO schema_migrations (version) VALUES ('20130814060102');

INSERT INTO schema_migrations (version) VALUES ('20130815025230');

INSERT INTO schema_migrations (version) VALUES ('20130815052040');

INSERT INTO schema_migrations (version) VALUES ('20130815080433');

INSERT INTO schema_migrations (version) VALUES ('20130815080719');

INSERT INTO schema_migrations (version) VALUES ('20130816053701');

INSERT INTO schema_migrations (version) VALUES ('20130816131023');

INSERT INTO schema_migrations (version) VALUES ('20130816221934');

INSERT INTO schema_migrations (version) VALUES ('20130817033111');

INSERT INTO schema_migrations (version) VALUES ('20130819003659');

INSERT INTO schema_migrations (version) VALUES ('20130820131446');

INSERT INTO schema_migrations (version) VALUES ('20130823140616');

INSERT INTO schema_migrations (version) VALUES ('20130825201943');

INSERT INTO schema_migrations (version) VALUES ('20130826052604');

INSERT INTO schema_migrations (version) VALUES ('20130826053938');

INSERT INTO schema_migrations (version) VALUES ('20131011132802');

INSERT INTO schema_migrations (version) VALUES ('20131011210418');

INSERT INTO schema_migrations (version) VALUES ('20131012045735');

INSERT INTO schema_migrations (version) VALUES ('20131012195133');

INSERT INTO schema_migrations (version) VALUES ('20131012200404');

INSERT INTO schema_migrations (version) VALUES ('20131013145400');

INSERT INTO schema_migrations (version) VALUES ('20131013194935');

INSERT INTO schema_migrations (version) VALUES ('20131013194936');

INSERT INTO schema_migrations (version) VALUES ('20131014164933');

INSERT INTO schema_migrations (version) VALUES ('20131017231147');

INSERT INTO schema_migrations (version) VALUES ('20131020203855');

INSERT INTO schema_migrations (version) VALUES ('20131029205903');

INSERT INTO schema_migrations (version) VALUES ('20131030220024');

INSERT INTO schema_migrations (version) VALUES ('20131123150614');

INSERT INTO schema_migrations (version) VALUES ('20131130124657');

INSERT INTO schema_migrations (version) VALUES ('20131210104019');

INSERT INTO schema_migrations (version) VALUES ('20140107101154');

INSERT INTO schema_migrations (version) VALUES ('20140110041742');

INSERT INTO schema_migrations (version) VALUES ('20140110050718');

INSERT INTO schema_migrations (version) VALUES ('20140227094632');

INSERT INTO schema_migrations (version) VALUES ('20140317000202');

INSERT INTO schema_migrations (version) VALUES ('20140317000203');

INSERT INTO schema_migrations (version) VALUES ('20140317000204');

INSERT INTO schema_migrations (version) VALUES ('20140317000205');

INSERT INTO schema_migrations (version) VALUES ('20140317000206');

INSERT INTO schema_migrations (version) VALUES ('20140317104458');

INSERT INTO schema_migrations (version) VALUES ('20140514034732');

INSERT INTO schema_migrations (version) VALUES ('20140522201324');
