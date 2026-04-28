--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

-- Started on 2026-04-10 16:58:56

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--




--
-- TOC entry 218 (class 1259 OID 49863)
-- Name: agent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    avatar text,
    status character varying(50) DEFAULT 'draft'::character varying,
    api_key character varying(255) DEFAULT NULL::character varying,
    api_key_enabled smallint DEFAULT 0,
    prompt text,
    category character varying(100),
    admin_id bigint,
    tags text,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE agent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.agent IS '智能体表';


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.name IS '智能体名称';


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.description IS '智能体描述';


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.avatar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.avatar IS '头像URL';


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.status IS '状态：draft-待发布，published-已发布，offline-已下线';


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.api_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.api_key IS '访问 API Key，格式 sk-xxx';


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.api_key_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.api_key_enabled IS 'API Key 是否启用：0-禁用，1-启用';


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.prompt; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.prompt IS '自定义Prompt配置';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.category; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.category IS '分类';


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.admin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.admin_id IS '管理员ID';


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.tags IS '标签，逗号分隔';


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.create_time IS '创建时间';


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN agent.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent.update_time IS '更新时间';


--
-- TOC entry 230 (class 1259 OID 49991)
-- Name: agent_datasource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_datasource (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    datasource_id integer NOT NULL,
    is_active smallint DEFAULT 0,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE agent_datasource; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.agent_datasource IS '智能体数据源关联表';


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN agent_datasource.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource.agent_id IS '智能体ID';


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN agent_datasource.datasource_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource.datasource_id IS '数据源ID';


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN agent_datasource.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource.is_active IS '是否启用：0-禁用，1-启用';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN agent_datasource.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource.create_time IS '创建时间';


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN agent_datasource.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource.update_time IS '更新时间';


--
-- TOC entry 229 (class 1259 OID 49990)
-- Name: agent_datasource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agent_datasource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 229
-- Name: agent_datasource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agent_datasource_id_seq OWNED BY public.agent_datasource.id;


--
-- TOC entry 238 (class 1259 OID 50094)
-- Name: agent_datasource_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_datasource_tables (
    id integer NOT NULL,
    agent_datasource_id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE agent_datasource_tables; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.agent_datasource_tables IS '某个智能体某个数据源所选中的数据表';


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN agent_datasource_tables.agent_datasource_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource_tables.agent_datasource_id IS '智能体数据源ID';


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN agent_datasource_tables.table_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource_tables.table_name IS '数据表名';


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN agent_datasource_tables.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource_tables.create_time IS '创建时间';


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN agent_datasource_tables.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_datasource_tables.update_time IS '更新时间';


--
-- TOC entry 237 (class 1259 OID 50093)
-- Name: agent_datasource_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agent_datasource_tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 237
-- Name: agent_datasource_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agent_datasource_tables_id_seq OWNED BY public.agent_datasource_tables.id;


--
-- TOC entry 217 (class 1259 OID 49862)
-- Name: agent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 217
-- Name: agent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agent_id_seq OWNED BY public.agent.id;


--
-- TOC entry 224 (class 1259 OID 49930)
-- Name: agent_knowledge; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_knowledge (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    question text,
    content text,
    is_recall integer DEFAULT 1,
    embedding_status character varying(20) DEFAULT NULL::character varying,
    error_msg character varying(255) DEFAULT NULL::character varying,
    source_filename character varying(500) DEFAULT NULL::character varying,
    file_path character varying(500) DEFAULT NULL::character varying,
    file_size bigint,
    file_type character varying(255) DEFAULT NULL::character varying,
    splitter_type character varying(50) DEFAULT 'token'::character varying,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted integer DEFAULT 0,
    is_resource_cleaned integer DEFAULT 0
);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE agent_knowledge; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.agent_knowledge IS '智能体知识表';


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.id IS '主键ID, 用于内部关联';


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.agent_id IS '关联的智能体ID';


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.title IS '知识的标题 (用户定义, 用于在UI上展示和识别)';


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.type IS '知识类型: DOCUMENT-文档, QA-问答, FAQ-常见问题';


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.question; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.question IS '问题 (仅当type为QA或FAQ时使用)';


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.content IS '知识内容 (对于QA/FAQ是答案; 对于DOCUMENT, 此字段通常为空)';


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.is_recall; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.is_recall IS '业务状态: 1=召回, 0=非召回';


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.embedding_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.embedding_status IS '向量化状态：PENDING待处理，PROCESSING处理中，COMPLETED已完成，FAILED失败';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.error_msg; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.error_msg IS '操作失败的错误信息';


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.source_filename; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.source_filename IS '上传时的原始文件名';


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.file_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.file_path IS '文件在服务器上的物理存储路径';


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.file_size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.file_size IS '文件大小 (字节)';


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.file_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.file_type IS '文件类型（pdf,md,markdown,doc等）';


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.splitter_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.splitter_type IS '分块策略类型：token, recursive, sentence, semantic';


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.created_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.created_time IS '创建时间';


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.updated_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.updated_time IS '更新时间';


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.is_deleted IS '逻辑删除字段，0=未删除, 1=已删除';


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN agent_knowledge.is_resource_cleaned; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_knowledge.is_resource_cleaned IS '0=物理资源（文件和向量）未清理, 1=物理资源已清理';


--
-- TOC entry 223 (class 1259 OID 49929)
-- Name: agent_knowledge_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agent_knowledge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 223
-- Name: agent_knowledge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agent_knowledge_id_seq OWNED BY public.agent_knowledge.id;


--
-- TOC entry 232 (class 1259 OID 50015)
-- Name: agent_preset_question; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_preset_question (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    question text NOT NULL,
    sort_order integer DEFAULT 0,
    is_active smallint DEFAULT 0,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_recall smallint DEFAULT 0 NOT NULL,
    answer text
);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE agent_preset_question; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.agent_preset_question IS '智能体预设问题表';


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.agent_id IS '智能体ID';


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.question; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.question IS '预设问题内容';


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.sort_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.sort_order IS '排序顺序';


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.is_active IS '是否启用：0-禁用，1-启用';


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.create_time IS '创建时间';


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.update_time IS '更新时间';


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.is_recall; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.is_recall IS '是否召回';


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN agent_preset_question.answer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.agent_preset_question.answer IS '答案';


--
-- TOC entry 231 (class 1259 OID 50014)
-- Name: agent_preset_question_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agent_preset_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 231
-- Name: agent_preset_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agent_preset_question_id_seq OWNED BY public.agent_preset_question.id;


--
-- TOC entry 220 (class 1259 OID 49881)
-- Name: business_knowledge; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_knowledge (
    id integer NOT NULL,
    business_term character varying(255) NOT NULL,
    description text,
    synonyms text,
    is_recall integer DEFAULT 1,
    agent_id integer NOT NULL,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    embedding_status character varying(20) DEFAULT NULL::character varying,
    error_msg character varying(255) DEFAULT NULL::character varying,
    is_deleted integer DEFAULT 0
);


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE business_knowledge; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.business_knowledge IS '业务知识表';


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.business_term; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.business_term IS '业务名词';


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.description IS '描述';


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.synonyms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.synonyms IS '同义词，逗号分隔';


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.is_recall; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.is_recall IS '是否召回：0-不召回，1-召回';


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.agent_id IS '关联的智能体ID';


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.created_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.created_time IS '创建时间';


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.updated_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.updated_time IS '更新时间';


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.embedding_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.embedding_status IS '向量化状态：PENDING待处理，PROCESSING处理中，COMPLETED已完成，FAILED失败';


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.error_msg; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.error_msg IS '操作失败的错误信息';


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN business_knowledge.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.business_knowledge.is_deleted IS '逻辑删除：0-未删除，1-已删除';


--
-- TOC entry 219 (class 1259 OID 49880)
-- Name: business_knowledge_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.business_knowledge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_knowledge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.business_knowledge_id_seq OWNED BY public.business_knowledge.id;


--
-- TOC entry 235 (class 1259 OID 50056)
-- Name: chat_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_message (
    id integer NOT NULL,
    session_id character varying(36) NOT NULL,
    role character varying(20) NOT NULL,
    content text NOT NULL,
    message_type character varying(50) DEFAULT 'text'::character varying,
    metadata jsonb,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE chat_message; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chat_message IS '聊天消息表';


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.session_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.session_id IS '会话ID';


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.role; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.role IS '角色：user-用户，assistant-助手，system-系统';


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.content IS '消息内容';


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.message_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.message_type IS '消息类型：text-文本，sql-SQL查询，result-查询结果，error-错误';


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.metadata IS '元数据（JSON格式）';


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN chat_message.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_message.create_time IS '创建时间';


--
-- TOC entry 234 (class 1259 OID 50055)
-- Name: chat_message_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 234
-- Name: chat_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_message_id_seq OWNED BY public.chat_message.id;


--
-- TOC entry 233 (class 1259 OID 50035)
-- Name: chat_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_session (
    id character varying(36) NOT NULL,
    agent_id integer NOT NULL,
    title character varying(255) DEFAULT '新对话'::character varying,
    status character varying(50) DEFAULT 'active'::character varying,
    is_pinned smallint DEFAULT 0,
    user_id bigint,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE chat_session; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.chat_session IS '聊天会话表';


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.id IS '会话ID（UUID）';


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.agent_id IS '智能体ID';


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.title IS '会话标题';


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.status IS '状态：active-活跃，archived-归档，deleted-已删除';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.is_pinned; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.is_pinned IS '是否置顶：0-否，1-是';


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.user_id IS '用户ID';


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.create_time IS '创建时间';


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN chat_session.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.chat_session.update_time IS '更新时间';


--
-- TOC entry 226 (class 1259 OID 49953)
-- Name: datasource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasource (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    host character varying(255) NOT NULL,
    port integer NOT NULL,
    database_name character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    connection_url character varying(1000),
    status character varying(50) DEFAULT 'inactive'::character varying,
    test_status character varying(50) DEFAULT 'unknown'::character varying,
    description text,
    creator_id bigint,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE datasource; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.datasource IS '数据源表';


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.name IS '数据源名称';


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.type IS '数据源类型：mysql, postgresql';


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.host; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.host IS '主机地址';


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.port IS '端口号';


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.database_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.database_name IS '数据库名称';


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.username; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.username IS '用户名';


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.password; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.password IS '密码（加密存储）';


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.connection_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.connection_url IS '完整连接URL';


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.status IS '状态：active-启用，inactive-禁用';


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.test_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.test_status IS '连接测试状态：success-成功，failed-失败，unknown-未知';


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.description IS '描述';


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.creator_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.creator_id IS '创建者ID';


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.create_time IS '创建时间';


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN datasource.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.datasource.update_time IS '更新时间';


--
-- TOC entry 225 (class 1259 OID 49952)
-- Name: datasource_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datasource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 225
-- Name: datasource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datasource_id_seq OWNED BY public.datasource.id;


--
-- TOC entry 228 (class 1259 OID 49970)
-- Name: logical_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logical_relation (
    id integer NOT NULL,
    datasource_id integer NOT NULL,
    source_table_name character varying(100) NOT NULL,
    source_column_name character varying(100) NOT NULL,
    target_table_name character varying(100) NOT NULL,
    target_column_name character varying(100) NOT NULL,
    relation_type character varying(20) DEFAULT NULL::character varying,
    description character varying(500) DEFAULT NULL::character varying,
    is_deleted smallint DEFAULT 0,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE logical_relation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.logical_relation IS '逻辑外键配置表';


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.id IS '主键ID';


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.datasource_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.datasource_id IS '关联的数据源ID';


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.source_table_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.source_table_name IS '主表名 (例如 t_order)';


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.source_column_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.source_column_name IS '主表字段名 (例如 buyer_uid)';


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.target_table_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.target_table_name IS '关联表名 (例如 t_user)';


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.target_column_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.target_column_name IS '关联表字段名 (例如 id)';


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.relation_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.relation_type IS '关系类型: 1:1, 1:N, N:1 (辅助LLM理解数据基数，可选)';


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.description IS '业务描述: 存入Prompt中帮助LLM理解 (例如: 订单表通过buyer_uid关联用户表id)';


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.is_deleted IS '逻辑删除: 0-未删除, 1-已删除';


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.created_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.created_time IS '创建时间';


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN logical_relation.updated_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.logical_relation.updated_time IS '更新时间';


--
-- TOC entry 227 (class 1259 OID 49969)
-- Name: logical_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.logical_relation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 227
-- Name: logical_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.logical_relation_id_seq OWNED BY public.logical_relation.id;


--
-- TOC entry 240 (class 1259 OID 50109)
-- Name: model_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.model_config (
    id integer NOT NULL,
    provider character varying(255) NOT NULL,
    base_url character varying(255) NOT NULL,
    api_key character varying(255) NOT NULL,
    model_name character varying(255) NOT NULL,
    temperature numeric(10,2) DEFAULT 0.00,
    is_active smallint DEFAULT '0'::smallint,
    max_tokens integer DEFAULT 2000,
    model_type character varying(20) DEFAULT 'CHAT'::character varying NOT NULL,
    completions_path character varying(255) DEFAULT NULL::character varying,
    embeddings_path character varying(255) DEFAULT NULL::character varying,
    created_time timestamp without time zone,
    updated_time timestamp without time zone,
    is_deleted integer DEFAULT 0,
    proxy_enabled smallint DEFAULT '0'::smallint,
    proxy_host character varying(255) DEFAULT NULL::character varying,
    proxy_port integer,
    proxy_username character varying(255) DEFAULT NULL::character varying,
    proxy_password character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE model_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.model_config IS '模型配置表';


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.provider; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.provider IS '厂商标识 (方便前端展示回显，实际调用主要靠 baseUrl)';


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.base_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.base_url IS '关键配置';


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.api_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.api_key IS 'API密钥';


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.model_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.model_name IS '模型名称';


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.temperature; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.temperature IS '温度参数';


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.is_active IS '是否激活';


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.max_tokens; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.max_tokens IS '输出响应最大令牌数';


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.model_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.model_type IS '模型类型 (CHAT/EMBEDDING)';


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.completions_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.completions_path IS 'Chat模型专用。附加到 Base URL 的路径。例如OpenAi的/v1/chat/completions';


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.embeddings_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.embeddings_path IS '嵌入模型专用。附加到 Base URL 的路径。';


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.created_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.created_time IS '创建时间';


--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.updated_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.updated_time IS '更新时间';


--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.is_deleted IS '0=未删除, 1=已删除';


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.proxy_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.proxy_enabled IS '是否启用代理：0-禁用，1-启用';


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.proxy_host; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.proxy_host IS '代理主机地址';


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.proxy_port; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.proxy_port IS '代理端口';


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.proxy_username; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.proxy_username IS '代理用户名（可选）';


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN model_config.proxy_password; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.model_config.proxy_password IS '代理密码（可选）';


--
-- TOC entry 239 (class 1259 OID 50108)
-- Name: model_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.model_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 239
-- Name: model_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.model_config_id_seq OWNED BY public.model_config.id;


--
-- TOC entry 222 (class 1259 OID 49906)
-- Name: semantic_model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.semantic_model (
    id integer NOT NULL,
    agent_id integer NOT NULL,
    datasource_id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    column_name character varying(255) DEFAULT ''::character varying NOT NULL,
    business_name character varying(255) DEFAULT ''::character varying NOT NULL,
    synonyms text,
    business_description text,
    column_comment character varying(255) DEFAULT NULL::character varying,
    data_type character varying(255) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE semantic_model; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.semantic_model IS '语义模型表';


--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.agent_id IS '关联的智能体ID';


--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.datasource_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.datasource_id IS '关联的数据源ID';


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.table_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.table_name IS '关联的表名';


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.column_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.column_name IS '数据库中的物理字段名 (例如: csat_score)';


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.business_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.business_name IS '业务名/别名 (例如: 客户满意度分数)';


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.synonyms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.synonyms IS '业务名的同义词 (例如: 满意度,客户评分)';


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.business_description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.business_description IS '业务描述 (用于向LLM解释字段的业务含义)';


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.column_comment; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.column_comment IS '数据库中的物理字段的原始注释';


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.data_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.data_type IS '物理数据类型 (例如: int, varchar(20))';


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.status IS '0 停用 1 启用';


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.created_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.created_time IS '创建时间';


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN semantic_model.updated_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.semantic_model.updated_time IS '更新时间';


--
-- TOC entry 221 (class 1259 OID 49905)
-- Name: semantic_model_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.semantic_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 221
-- Name: semantic_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.semantic_model_id_seq OWNED BY public.semantic_model.id;


--
-- TOC entry 236 (class 1259 OID 50075)
-- Name: user_prompt_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_prompt_config (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    prompt_type character varying(100) NOT NULL,
    agent_id integer,
    system_prompt text NOT NULL,
    enabled smallint DEFAULT 1,
    description text,
    priority integer DEFAULT 0,
    display_order integer DEFAULT 0,
    create_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    creator character varying(255)
);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE user_prompt_config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.user_prompt_config IS '用户Prompt配置表';


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.id IS '配置ID（UUID）';


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.name IS '配置名称';


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.prompt_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.prompt_type IS 'Prompt类型（如report-generator, planner等）';


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.agent_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.agent_id IS '关联的智能体ID，为空表示全局配置';


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.system_prompt; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.system_prompt IS '用户自定义系统Prompt内容';


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.enabled IS '是否启用该配置：0-禁用，1-启用';


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.description IS '配置描述';


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.priority; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.priority IS '配置优先级，数字越大优先级越高';


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.display_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.display_order IS '配置显示顺序，数字越小越靠前';


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.create_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.create_time IS '创建时间';


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.update_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.update_time IS '更新时间';


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN user_prompt_config.creator; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_prompt_config.creator IS '创建者';


--
-- TOC entry 4788 (class 2604 OID 49866)
-- Name: agent id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent ALTER COLUMN id SET DEFAULT nextval('public.agent_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 49994)
-- Name: agent_datasource id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource ALTER COLUMN id SET DEFAULT nextval('public.agent_datasource_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 50097)
-- Name: agent_datasource_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource_tables ALTER COLUMN id SET DEFAULT nextval('public.agent_datasource_tables_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 49933)
-- Name: agent_knowledge id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_knowledge ALTER COLUMN id SET DEFAULT nextval('public.agent_knowledge_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 50018)
-- Name: agent_preset_question id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_preset_question ALTER COLUMN id SET DEFAULT nextval('public.agent_preset_question_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 49884)
-- Name: business_knowledge id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_knowledge ALTER COLUMN id SET DEFAULT nextval('public.business_knowledge_id_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 50059)
-- Name: chat_message id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message ALTER COLUMN id SET DEFAULT nextval('public.chat_message_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 49956)
-- Name: datasource id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasource ALTER COLUMN id SET DEFAULT nextval('public.datasource_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 49973)
-- Name: logical_relation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logical_relation ALTER COLUMN id SET DEFAULT nextval('public.logical_relation_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 50112)
-- Name: model_config id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_config ALTER COLUMN id SET DEFAULT nextval('public.model_config_id_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 49909)
-- Name: semantic_model id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.semantic_model ALTER COLUMN id SET DEFAULT nextval('public.semantic_model_id_seq'::regclass);


--
-- TOC entry 4904 (class 2606 OID 49999)
-- Name: agent_datasource agent_datasource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource
    ADD CONSTRAINT agent_datasource_pkey PRIMARY KEY (id);


--
-- TOC entry 4936 (class 2606 OID 50101)
-- Name: agent_datasource_tables agent_datasource_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource_tables
    ADD CONSTRAINT agent_datasource_tables_pkey PRIMARY KEY (id);


--
-- TOC entry 4889 (class 2606 OID 49948)
-- Name: agent_knowledge agent_knowledge_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_knowledge
    ADD CONSTRAINT agent_knowledge_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 49875)
-- Name: agent agent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 50026)
-- Name: agent_preset_question agent_preset_question_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_preset_question
    ADD CONSTRAINT agent_preset_question_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 49894)
-- Name: business_knowledge business_knowledge_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_knowledge
    ADD CONSTRAINT business_knowledge_pkey PRIMARY KEY (id);


--
-- TOC entry 4922 (class 2606 OID 50065)
-- Name: chat_message chat_message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT chat_message_pkey PRIMARY KEY (id);


--
-- TOC entry 4915 (class 2606 OID 50044)
-- Name: chat_session chat_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_session
    ADD CONSTRAINT chat_session_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 49964)
-- Name: datasource datasource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasource
    ADD CONSTRAINT datasource_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 49982)
-- Name: logical_relation logical_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logical_relation
    ADD CONSTRAINT logical_relation_pkey PRIMARY KEY (id);


--
-- TOC entry 4939 (class 2606 OID 50127)
-- Name: model_config model_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_config
    ADD CONSTRAINT model_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4887 (class 2606 OID 49920)
-- Name: semantic_model semantic_model_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.semantic_model
    ADD CONSTRAINT semantic_model_pkey PRIMARY KEY (id);


--
-- TOC entry 4934 (class 2606 OID 50086)
-- Name: user_prompt_config user_prompt_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_prompt_config
    ADD CONSTRAINT user_prompt_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4872 (class 1259 OID 49879)
-- Name: idx_agent_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_admin_id ON public.agent USING btree (admin_id);


--
-- TOC entry 4873 (class 1259 OID 49878)
-- Name: idx_agent_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_category ON public.agent USING btree (category);


--
-- TOC entry 4905 (class 1259 OID 50001)
-- Name: idx_agent_datasource_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_datasource_agent_id ON public.agent_datasource USING btree (agent_id);


--
-- TOC entry 4906 (class 1259 OID 50002)
-- Name: idx_agent_datasource_datasource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_datasource_datasource_id ON public.agent_datasource USING btree (datasource_id);


--
-- TOC entry 4907 (class 1259 OID 50003)
-- Name: idx_agent_datasource_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_datasource_is_active ON public.agent_datasource USING btree (is_active);


--
-- TOC entry 4890 (class 1259 OID 49949)
-- Name: idx_agent_knowledge_agent_id_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_knowledge_agent_id_status ON public.agent_knowledge USING btree (agent_id, is_recall);


--
-- TOC entry 4891 (class 1259 OID 49950)
-- Name: idx_agent_knowledge_embedding_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_knowledge_embedding_status ON public.agent_knowledge USING btree (embedding_status);


--
-- TOC entry 4892 (class 1259 OID 49951)
-- Name: idx_agent_knowledge_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_knowledge_is_deleted ON public.agent_knowledge USING btree (is_deleted);


--
-- TOC entry 4874 (class 1259 OID 49876)
-- Name: idx_agent_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_name ON public.agent USING btree (name);


--
-- TOC entry 4911 (class 1259 OID 50027)
-- Name: idx_agent_preset_question_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_preset_question_agent_id ON public.agent_preset_question USING btree (agent_id);


--
-- TOC entry 4912 (class 1259 OID 50029)
-- Name: idx_agent_preset_question_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_preset_question_is_active ON public.agent_preset_question USING btree (is_active);


--
-- TOC entry 4913 (class 1259 OID 50028)
-- Name: idx_agent_preset_question_sort_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_preset_question_sort_order ON public.agent_preset_question USING btree (sort_order);


--
-- TOC entry 4875 (class 1259 OID 49877)
-- Name: idx_agent_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_status ON public.agent USING btree (status);


--
-- TOC entry 4878 (class 1259 OID 49896)
-- Name: idx_business_knowledge_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_knowledge_agent_id ON public.business_knowledge USING btree (agent_id);


--
-- TOC entry 4879 (class 1259 OID 49895)
-- Name: idx_business_knowledge_business_term; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_knowledge_business_term ON public.business_knowledge USING btree (business_term);


--
-- TOC entry 4880 (class 1259 OID 49898)
-- Name: idx_business_knowledge_embedding_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_knowledge_embedding_status ON public.business_knowledge USING btree (embedding_status);


--
-- TOC entry 4881 (class 1259 OID 49899)
-- Name: idx_business_knowledge_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_knowledge_is_deleted ON public.business_knowledge USING btree (is_deleted);


--
-- TOC entry 4882 (class 1259 OID 49897)
-- Name: idx_business_knowledge_is_recall; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_knowledge_is_recall ON public.business_knowledge USING btree (is_recall);


--
-- TOC entry 4923 (class 1259 OID 50069)
-- Name: idx_chat_message_create_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_message_create_time ON public.chat_message USING btree (create_time);


--
-- TOC entry 4924 (class 1259 OID 50068)
-- Name: idx_chat_message_message_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_message_message_type ON public.chat_message USING btree (message_type);


--
-- TOC entry 4925 (class 1259 OID 50067)
-- Name: idx_chat_message_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_message_role ON public.chat_message USING btree (role);


--
-- TOC entry 4926 (class 1259 OID 50066)
-- Name: idx_chat_message_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_message_session_id ON public.chat_message USING btree (session_id);


--
-- TOC entry 4916 (class 1259 OID 50045)
-- Name: idx_chat_session_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_agent_id ON public.chat_session USING btree (agent_id);


--
-- TOC entry 4917 (class 1259 OID 50049)
-- Name: idx_chat_session_create_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_create_time ON public.chat_session USING btree (create_time);


--
-- TOC entry 4918 (class 1259 OID 50048)
-- Name: idx_chat_session_is_pinned; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_is_pinned ON public.chat_session USING btree (is_pinned);


--
-- TOC entry 4919 (class 1259 OID 50047)
-- Name: idx_chat_session_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_status ON public.chat_session USING btree (status);


--
-- TOC entry 4920 (class 1259 OID 50046)
-- Name: idx_chat_session_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chat_session_user_id ON public.chat_session USING btree (user_id);


--
-- TOC entry 4895 (class 1259 OID 49968)
-- Name: idx_datasource_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_datasource_creator_id ON public.datasource USING btree (creator_id);


--
-- TOC entry 4896 (class 1259 OID 49965)
-- Name: idx_datasource_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_datasource_name ON public.datasource USING btree (name);


--
-- TOC entry 4897 (class 1259 OID 49967)
-- Name: idx_datasource_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_datasource_status ON public.datasource USING btree (status);


--
-- TOC entry 4898 (class 1259 OID 49966)
-- Name: idx_datasource_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_datasource_type ON public.datasource USING btree (type);


--
-- TOC entry 4899 (class 1259 OID 49983)
-- Name: idx_logical_relation_datasource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_logical_relation_datasource_id ON public.logical_relation USING btree (datasource_id);


--
-- TOC entry 4900 (class 1259 OID 49984)
-- Name: idx_logical_relation_source_table; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_logical_relation_source_table ON public.logical_relation USING btree (datasource_id, source_table_name);


--
-- TOC entry 4883 (class 1259 OID 49921)
-- Name: idx_semantic_model_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_semantic_model_agent_id ON public.semantic_model USING btree (agent_id);


--
-- TOC entry 4884 (class 1259 OID 49922)
-- Name: idx_semantic_model_business_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_semantic_model_business_name ON public.semantic_model USING btree (business_name);


--
-- TOC entry 4885 (class 1259 OID 49923)
-- Name: idx_semantic_model_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_semantic_model_status ON public.semantic_model USING btree (status);


--
-- TOC entry 4927 (class 1259 OID 50088)
-- Name: idx_user_prompt_config_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_agent_id ON public.user_prompt_config USING btree (agent_id);


--
-- TOC entry 4928 (class 1259 OID 50090)
-- Name: idx_user_prompt_config_create_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_create_time ON public.user_prompt_config USING btree (create_time);


--
-- TOC entry 4929 (class 1259 OID 50092)
-- Name: idx_user_prompt_config_display_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_display_order ON public.user_prompt_config USING btree (display_order);


--
-- TOC entry 4930 (class 1259 OID 50089)
-- Name: idx_user_prompt_config_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_enabled ON public.user_prompt_config USING btree (enabled);


--
-- TOC entry 4931 (class 1259 OID 50087)
-- Name: idx_user_prompt_config_prompt_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_prompt_type ON public.user_prompt_config USING btree (prompt_type);


--
-- TOC entry 4932 (class 1259 OID 50091)
-- Name: idx_user_prompt_config_type_enabled_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_prompt_config_type_enabled_priority ON public.user_prompt_config USING btree (prompt_type, agent_id, enabled, priority DESC);


--
-- TOC entry 4908 (class 1259 OID 50000)
-- Name: uk_agent_datasource; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_agent_datasource ON public.agent_datasource USING btree (agent_id, datasource_id);


--
-- TOC entry 4937 (class 1259 OID 50102)
-- Name: uk_agent_datasource_tables_agent_datasource_id_table_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_agent_datasource_tables_agent_datasource_id_table_name ON public.agent_datasource_tables USING btree (agent_datasource_id, table_name);


--
-- TOC entry 4943 (class 2606 OID 50004)
-- Name: agent_datasource fk_agent_datasource_agent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource
    ADD CONSTRAINT fk_agent_datasource_agent FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 50009)
-- Name: agent_datasource fk_agent_datasource_datasource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource
    ADD CONSTRAINT fk_agent_datasource_datasource FOREIGN KEY (datasource_id) REFERENCES public.datasource(id) ON DELETE CASCADE;


--
-- TOC entry 4948 (class 2606 OID 50103)
-- Name: agent_datasource_tables fk_agent_datasource_tables_agent_datasource_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_datasource_tables
    ADD CONSTRAINT fk_agent_datasource_tables_agent_datasource_id FOREIGN KEY (agent_datasource_id) REFERENCES public.agent_datasource(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4945 (class 2606 OID 50030)
-- Name: agent_preset_question fk_agent_preset_question_agent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_preset_question
    ADD CONSTRAINT fk_agent_preset_question_agent FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 4940 (class 2606 OID 49900)
-- Name: business_knowledge fk_business_knowledge_agent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_knowledge
    ADD CONSTRAINT fk_business_knowledge_agent FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 4947 (class 2606 OID 50070)
-- Name: chat_message fk_chat_message_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_message
    ADD CONSTRAINT fk_chat_message_session FOREIGN KEY (session_id) REFERENCES public.chat_session(id) ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 50050)
-- Name: chat_session fk_chat_session_agent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_session
    ADD CONSTRAINT fk_chat_session_agent FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 49985)
-- Name: logical_relation fk_logical_relation_datasource; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logical_relation
    ADD CONSTRAINT fk_logical_relation_datasource FOREIGN KEY (datasource_id) REFERENCES public.datasource(id) ON DELETE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 49924)
-- Name: semantic_model fk_semantic_model_agent; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.semantic_model
    ADD CONSTRAINT fk_semantic_model_agent FOREIGN KEY (agent_id) REFERENCES public.agent(id) ON DELETE CASCADE;


-- Completed on 2026-04-10 16:58:57

CREATE TABLE IF NOT EXISTS public.data_class
(
    id character varying(64) COLLATE pg_catalog."default" NOT NULL,
    name character varying(64) COLLATE pg_catalog."default" NOT NULL,
    indexed boolean NOT NULL DEFAULT false,
    stored boolean NOT NULL DEFAULT false,
    keyword boolean NOT NULL DEFAULT false,
    CONSTRAINT data_class_pkey PRIMARY KEY (id)
);

--
-- PostgreSQL database dump complete
--

