--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

-- Started on 2026-04-10 16:57:54

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
-- TOC entry 5011 (class 0 OID 49863)
-- Dependencies: 218
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agent (id, name, description, avatar, status, api_key, api_key_enabled, prompt, category, admin_id, tags, create_time, update_time) FROM stdin;
1	中国人口GDP数据智能体	专门处理中国人口和GDP相关数据查询分析的智能体	/avatars/china-gdp-agent.png	draft	\N	0	你是一个专业的数据分析助手，专门处理中国人口和GDP相关的数据查询。请根据用户的问题，生成准确的SQL查询语句。	数据分析	2100246635	人口数据,GDP分析,经济统计	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
4	库存管理智能体	专注于库存数据管理和供应链分析的智能体	/avatars/inventory-agent.png	draft	\N	0	你是一个库存管理专家，能够帮助用户查询库存状态、分析供应链数据。	供应链	2100246635	库存管理,供应链,物流	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
2	麦考林销售数据分析智能体	专注于麦考林公司的销售数据分析和订单业务指标计算的智能体	/avatars/sales-agent.png	offline	sk-xD2ZspOS9A0aRJwCIeNWV4Wa3Zca5Q2n	0	你是一个销售数据分析专家，能够帮助用户分析销售趋势、客户行为和业务指标。	业务分析	2100246635	销售分析,业务指标,客户分析	2026-03-25 10:10:35.177748	2026-04-01 17:38:27.939432
3	本企业财务和经营数据查询智能体	专门处理财务数据和报表分析的智能体，当前也提供了本企业的订单和收入的统计分析能力	/avatars/finance-agent.png	published	sk-hoZ1D5IH2dEUwQDafAs8PfXvPognOYEx	1	你是一个财务分析专家，专门处理财务数据查询和报表生成，当前目标是实时了解企业经营现状。	财务分析	2100246635	财务数据,报表分析,会计	2026-03-25 10:10:35.177748	2026-04-02 23:04:09.049314
\.


--
-- TOC entry 5019 (class 0 OID 49953)
-- Dependencies: 226
-- Data for Name: datasource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.datasource (id, name, type, host, port, database_name, username, password, connection_url, status, test_status, description, creator_id, create_time, update_time) FROM stdin;
1	生产环境MySQL数据库	mysql	mysql-data	3306	product_db	root	root	jdbc:mysql://mysql-data:3306/product_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true	inactive	failed	生产环境主数据库，包含核心业务数据	2100246635	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
3	product_db	h2	nl2sql_database	5432	product_db	root	root	jdbc:h2:mem:nl2sql_database;DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=true;MODE=MySQL;DB_CLOSE_ON_EXIT=FALSE	inactive	unknown	h2测试数据库，包含核心业务数据	2100246635	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
4	finance_database	postgresql	127.0.0.1	5432	nl2sql_database|finance	junphine	nl2sql_database	jdbc:postgresql://127.0.0.1:5432/nl2sql_database?currentSchema=finance	active	success	财务数据库	\N	2026-03-26 17:06:19.559613	2026-03-26 17:12:33.214057
2	数据仓库PostgreSQL	postgresql	localhost	5432	nl2sql_database|product_db	junphine	332584185	jdbc:postgresql://localhost:5432/nl2sql_database?currentSchema=product_db	inactive	success	数据仓库，用于数据分析和报表生成	2100246635	2026-03-25 10:10:35.177748	2026-03-25 14:30:35.721931
\.


--
-- TOC entry 5023 (class 0 OID 49991)
-- Dependencies: 230
-- Data for Name: agent_datasource; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agent_datasource (id, agent_id, datasource_id, is_active, create_time, update_time) FROM stdin;
4	4	1	0	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
10	2	2	1	2026-03-25 14:30:39.914048	2026-03-25 14:30:39.914048
1	1	2	1	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748
13	3	4	1	2026-03-26 17:12:40.30722	2026-03-26 17:12:40.30722
\.


--
-- TOC entry 5031 (class 0 OID 50094)
-- Dependencies: 238
-- Data for Name: agent_datasource_tables; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agent_datasource_tables (id, agent_datasource_id, table_name, create_time, update_time) FROM stdin;
1	10	categories	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
2	10	order_items	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
3	10	orders	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
4	10	product_categories	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
5	10	products	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
6	10	users	2026-03-25 14:53:18.823416	2026-03-25 14:53:18.823416
13	13	business_data_order	2026-03-26 17:25:46.598744	2026-03-26 17:25:46.598744
14	13	business_data_revenue	2026-03-26 17:25:46.598744	2026-03-26 17:25:46.598744
21	13	department_goals	2026-03-27 10:32:56.68607	2026-03-27 10:32:56.68607
\.


--
-- TOC entry 5017 (class 0 OID 49930)
-- Dependencies: 224
-- Data for Name: agent_knowledge; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agent_knowledge (id, agent_id, title, type, question, content, is_recall, embedding_status, error_msg, source_filename, file_path, file_size, file_type, splitter_type, created_time, updated_time, is_deleted, is_resource_cleaned) FROM stdin;
1	1	中国人口统计数据说明	DOCUMENT	\N	中国人口统计数据包含了历年的人口总数、性别比例、年龄结构、城乡分布等详细信息。数据来源于国家统计局，具有权威性和准确性。查询时请注意数据的时间范围和统计口径。	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
2	1	GDP数据使用指南	DOCUMENT	\N	GDP（国内生产总值）数据反映了国家经济发展水平。包含名义GDP、实际GDP、GDP增长率等指标。数据按季度和年度进行统计，支持按地区、行业进行分类查询。	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
3	1	常见查询问题	QA	\N	问：如何查询2023年的人口数据？\\n答：可以使用"SELECT * FROM population WHERE year = 2023"进行查询。\\n\\n问：如何计算GDP增长率？\\n答：GDP增长率 = (当年GDP - 上年GDP) / 上年GDP * 100%	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
4	2	销售数据字段说明	DOCUMENT	\N	销售数据表包含以下关键字段：\\n- sales_amount：销售金额\\n- customer_id：客户ID\\n- product_id：产品ID\\n- sales_date：销售日期\\n- region：销售区域\\n- sales_rep：销售代表	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
5	2	客户分析指标体系	DOCUMENT	\N	客户分析包含多个维度：\\n1. 客户价值分析：RFM模型（最近购买时间、购买频次、购买金额）\\n2. 客户生命周期：新客户、活跃客户、流失客户\\n3. 客户满意度：NPS评分、满意度调研\\n4. 客户行为分析：购买偏好、渠道偏好	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
7	4	库存管理最佳实践	DOCUMENT	\N	库存管理的核心要点：\\n1. 安全库存设置：确保不断货\\n2. ABC分类管理：重点管理A类物料\\n3. 先进先出原则：避免库存积压\\n4. 定期盘点：确保数据准确性\\n5. 供应商管理：建立稳定供应关系	1	PENDING	\N	\N	\N	\N	text	token	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	0	0
8	3	收入表和订单表的字段中文注释	DOCUMENT	\N	\N	0	COMPLETED		经营数据-ddl-utf.csv	data-agent/agent-knowledge/a9f9067c-d36b-41de-b261-833ab683b15e.csv	6848	text/csv	paragraph	2026-03-26 17:34:53.340557	2026-03-31 11:08:51.815983	0	0
6	3	财务报表模板	DOCUMENT	\N	标准财务报表包含：\\n1. 资产负债表：反映企业财务状况\\n2. 利润表：反映企业经营成果\\n3. 现金流量表：反映企业现金流动情况\\n4. 所有者权益变动表：反映股东权益变化	0	PENDING	\N	\N	\N	\N	pdf	token	2026-03-25 10:10:35.177748	2026-03-31 11:08:53.860837	0	0
\.


--
-- TOC entry 5025 (class 0 OID 50015)
-- Dependencies: 232
-- Data for Name: agent_preset_question; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agent_preset_question (id, agent_id, question, sort_order, is_active, create_time, update_time, is_recall, answer) FROM stdin;
70	3	CRO事业部2026年收入目标完成进度	1	1	2026-03-31 12:54:23.644707	2026-03-31 12:54:23.644707	0	\N
72	3	CRO新颖BB的收入	3	1	2026-03-31 12:54:23.646427	2026-03-31 12:54:23.646427	0	\N
73	3	生成CRO事业部最近12个月度收入环比增长曲线	4	1	2026-03-31 12:54:23.64738	2026-03-31 12:54:23.64738	0	\N
69	3	CRO事业部2026年订单目标完成进度	0	1	2026-03-31 12:54:23.633091	2026-03-31 12:54:29.883503	1	\nSELECT \n    SUM("order_amount_cny") AS actual_order_amount,\n    (SELECT "order_amount_target" FROM "department_goals" WHERE "department_name" = 'CRO' AND "target_year" = 2026) AS target_order_amount\nFROM "business_data_order"\nWHERE "bu_segment" = 'CRO' \n    AND "po_date" >= TO_DATE('2026/1/1', 'YYYY/MM/DD') \n    AND "po_date" <= TO_DATE('2026/12/31', 'YYYY/MM/DD');\n\t
71	3	计算CRO事业部今年的人效	2	1	2026-03-31 12:54:23.645791	2026-03-31 12:54:46.272584	1	-- 统计周期部门实际收入除以部门人员数
20	2	2025年订单目标完成进度	0	1	2026-03-26 15:24:43.741247	2026-03-26 15:24:43.741247	0	'''SQL\nSELECT SUM("total_amount") FROM "orders" WHERE "order_date" >= '2025-01-01' AND "order_date" <= '2025-12-31' AND "status" = 'completed';\n'''\n然后基于目标值1亿计算完成进度\n
21	2	2025年收入目标完成进度	1	1	2026-03-26 15:24:43.742676	2026-03-26 15:24:43.742676	0	直接返回\n‘‘‘sql\nselect 0.5\n‘’’
22	2	查看一下每个客户2025年的订单总额，按照由高到低排序	2	1	2026-03-26 15:24:43.743189	2026-03-26 15:24:43.743189	0	\N
\.


--
-- TOC entry 5013 (class 0 OID 49881)
-- Dependencies: 220
-- Data for Name: business_knowledge; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.business_knowledge (id, business_term, description, synonyms, is_recall, agent_id, created_time, updated_time, embedding_status, error_msg, is_deleted) FROM stdin;
1	Customer Satisfaction	Measures how satisfied customers are with the service or product.	customer happiness, client contentment	0	1	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	\N	\N	0
2	Net Promoter Score	A measure of the likelihood of customers recommending a company to others.	NPS, customer loyalty score	0	1	2026-03-25 10:10:35.177748	2026-03-25 10:10:35.177748	\N	\N	0
3	Customer Retention Rate	The percentage of customers who continue to use a service over a given period.	retention, customer loyalty	1	2	2026-03-25 10:10:35.177748	2026-03-25 15:19:06.312214	\N	\N	0
8	Customer Retention Rate	The percentage of customers who continue to use a service over a given period.	etention, customer loyalty	1	3	2026-03-27 10:35:30.780824	2026-03-27 10:35:37.341416	COMPLETED	\N	0
10	美国仓备库收入	出库组织为“PharmaBlock (USA), INC”，stock剔除“PBUSA Transfer”、“WC GMP Storage”和空值		1	3	2026-03-27 10:46:05.711526	2026-03-27 10:46:12.070359	COMPLETED	\N	0
11	人效指标	部门统计区间的收入总和除以部门人数		1	3	2026-03-27 11:20:13.965074	2026-03-27 11:20:17.396242	COMPLETED	\N	0
9	新颖BB收入	新颖BB当年收入包含两部分，新分子砌块+新化学实体\n（1）新分子砌块：当年首次入库、历史未入库过的PB在当年实现的收入\n（2）新化学实体：Category为“ADC BB”+“Peptide”+“TPD BB”的PB在当年实现的收入		0	3	2026-03-27 10:45:00.005571	2026-03-30 15:07:55.250211	COMPLETED	\N	0
7	部门划分字段	如果按照部门维度统计，部门选择bu_segment字段	一级部门,事业部划分	1	3	2026-03-27 10:19:54.783575	2026-03-30 15:09:57.58301	COMPLETED	\N	0
\.


--
-- TOC entry 5026 (class 0 OID 50035)
-- Dependencies: 233
-- Data for Name: chat_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chat_session (id, agent_id, title, status, is_pinned, user_id, create_time, update_time) FROM stdin;
\.


--
-- TOC entry 5028 (class 0 OID 50056)
-- Dependencies: 235
-- Data for Name: chat_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chat_message (id, session_id, role, content, message_type, metadata, create_time) FROM stdin;
\.


--
-- TOC entry 5021 (class 0 OID 49970)
-- Dependencies: 228
-- Data for Name: logical_relation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.logical_relation (id, datasource_id, source_table_name, source_column_name, target_table_name, target_column_name, relation_type, description, is_deleted, created_time, updated_time) FROM stdin;
1	4	business_data_order	bu_segment	department_goals	department_id			0	2026-03-30 15:12:40.641289	2026-03-31 11:01:50.306381
2	4	business_data_revenue	bu_segment	department_goals	department_id			0	2026-03-30 15:12:40.641289	2026-03-31 11:01:50.306381
\.


--
-- TOC entry 5033 (class 0 OID 50109)
-- Dependencies: 240
-- Data for Name: model_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.model_config (id, provider, base_url, api_key, model_name, temperature, is_active, max_tokens, model_type, completions_path, embeddings_path, created_time, updated_time, is_deleted, proxy_enabled, proxy_host, proxy_port, proxy_username, proxy_password) FROM stdin;
2	qwen	https://dashscope.aliyuncs.com/compatible-mode	sk-c255b2d0e7954c479f78d7c146248305	text-embedding-v4	0.00	1	2000	EMBEDDING			2026-03-25 13:49:27.080627	2026-03-25 14:08:32.400764	0	0	\N	\N	\N	\N
3	openai	http://121.89.85.118:8000	pharmablockprivate@2jksadhasdad	qwen3-32b	0.00	0	2000	CHAT			2026-03-30 11:16:34.699159	2026-03-30 11:18:15.985067	0	0	\N	\N	\N	\N
1	qwen	https://dashscope.aliyuncs.com/compatible-mode	sk-c255b2d0e7954c479f78d7c146248305	qwen-plus	0.00	1	2000	CHAT			2026-03-25 13:43:51.203711	2026-03-30 11:28:36.250428	0	0	\N	\N	\N	\N
\.


--
-- TOC entry 5015 (class 0 OID 49906)
-- Dependencies: 222
-- Data for Name: semantic_model; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.semantic_model (id, agent_id, datasource_id, table_name, column_name, business_name, synonyms, business_description, column_comment, data_type, status, created_time, updated_time) FROM stdin;
266	3	4	business_data_order	seq_no	序号	\N	\N	\N	未知	1	2026-03-31 02:26:37.175601	2026-03-31 02:26:37.175601
267	3	4	business_data_order	po_date	PO Date	\N	\N	\N	未知	1	2026-03-31 02:26:37.178609	2026-03-31 02:26:37.178609
268	3	4	business_data_order	order_progress	Order Progress	\N	\N	\N	未知	1	2026-03-31 02:26:37.181839	2026-03-31 02:26:37.181839
269	3	4	business_data_order	doc_status	Doc. Status	\N	\N	\N	未知	1	2026-03-31 02:26:37.18565	2026-03-31 02:26:37.18565
270	3	4	business_data_order	product_type	Product Type	\N	\N	\N	未知	1	2026-03-31 02:26:37.189103	2026-03-31 02:26:37.189103
271	3	4	business_data_order	type_code	Type Code	\N	\N	\N	未知	1	2026-03-31 02:26:37.192689	2026-03-31 02:26:37.192689
272	3	4	business_data_order	quality_requirement	Quality Requirement	\N	\N	\N	未知	1	2026-03-31 02:26:37.196581	2026-03-31 02:26:37.196581
273	3	4	business_data_order	invoice_no	Invoice#	\N	\N	\N	未知	1	2026-03-31 02:26:37.200313	2026-03-31 02:26:37.200313
274	3	4	business_data_order	customer_name	Customer	\N	\N	\N	未知	1	2026-03-31 02:26:37.203304	2026-03-31 02:26:37.203304
275	3	4	business_data_order	product_code	PB#	\N	\N	\N	未知	1	2026-03-31 02:26:37.206584	2026-03-31 02:26:37.206584
276	3	4	business_data_order	qty	Qty	\N	\N	\N	未知	1	2026-03-31 02:26:37.209673	2026-03-31 02:26:37.209673
277	3	4	business_data_order	unit	Unit	\N	\N	\N	未知	1	2026-03-31 02:26:37.212205	2026-03-31 02:26:37.212205
278	3	4	business_data_order	currency	Currency	\N	\N	\N	未知	1	2026-03-31 02:26:37.214807	2026-03-31 02:26:37.214807
279	3	4	business_data_order	price_tax_inclusive	Tax-inclusive Price	\N	\N	\N	未知	1	2026-03-31 02:26:37.218329	2026-03-31 02:26:37.218329
280	3	4	business_data_order	stock_out_status	Stock Out Status	\N	\N	\N	未知	1	2026-03-31 02:26:37.221499	2026-03-31 02:26:37.221499
281	3	4	business_data_order	stock_availability	Stock Availability	\N	\N	\N	未知	1	2026-03-31 02:26:37.224084	2026-03-31 02:26:37.224084
282	3	4	business_data_order	so_due_date	S.O. Due Date	\N	\N	\N	未知	1	2026-03-31 02:26:37.226675	2026-03-31 02:26:37.226675
283	3	4	business_data_order	shipout_date	Shipout Date	\N	\N	\N	未知	1	2026-03-31 02:26:37.229296	2026-03-31 02:26:37.229296
284	3	4	business_data_order	express_no	Express No.	\N	\N	\N	未知	1	2026-03-31 02:26:37.231999	2026-03-31 02:26:37.231999
285	3	4	business_data_order	reserved_flag	Reserved Flag	\N	\N	\N	未知	1	2026-03-31 02:26:37.234588	2026-03-31 02:26:37.234588
286	3	4	business_data_order	sales_person	Sales Person	\N	\N	\N	未知	1	2026-03-31 02:26:37.237353	2026-03-31 02:26:37.237353
287	3	4	business_data_order	sales_group	Sales Group	\N	\N	\N	未知	1	2026-03-31 02:26:37.239899	2026-03-31 02:26:37.239899
288	3	4	business_data_order	unit_price_per_g	Unit Price-G	\N	\N	\N	未知	1	2026-03-31 02:26:37.242946	2026-03-31 02:26:37.242946
289	3	4	business_data_order	transfer_flag	Transfer	\N	\N	\N	未知	1	2026-03-31 02:26:37.245594	2026-03-31 02:26:37.245594
290	3	4	business_data_order	accum_return_notice_qty	Accumulated Return Notice Qty	\N	\N	\N	未知	1	2026-03-31 02:26:37.248294	2026-03-31 02:26:37.248294
167	3	4	business_data_revenue	seq_no	序号	\N	\N	\N	未知	1	2026-03-31 02:26:31.348929	2026-03-31 02:26:31.348929
168	3	4	business_data_revenue	sales_order_no	销售订单号	\N	\N	\N	未知	1	2026-03-31 02:26:36.894644	2026-03-31 02:26:36.894644
169	3	4	business_data_revenue	order_date	订单日期	\N	\N	\N	未知	1	2026-03-31 02:26:36.898242	2026-03-31 02:26:36.898242
170	3	4	business_data_revenue	customer_name	客户	\N	\N	\N	未知	1	2026-03-31 02:26:36.90144	2026-03-31 02:26:36.90144
171	3	4	business_data_revenue	product_code	PB	\N	\N	\N	未知	1	2026-03-31 02:26:36.906714	2026-03-31 02:26:36.906714
172	3	4	business_data_revenue	cas_no	CAS	\N	\N	\N	未知	1	2026-03-31 02:26:36.910021	2026-03-31 02:26:36.910021
173	3	4	business_data_revenue	nanjing_stock_g	南京库存G	\N	\N	\N	未知	1	2026-03-31 02:26:36.912711	2026-03-31 02:26:36.912711
174	3	4	business_data_revenue	order_qty	订单数量	\N	\N	\N	未知	1	2026-03-31 02:26:36.915764	2026-03-31 02:26:36.915764
175	3	4	business_data_revenue	unit	单位	\N	\N	\N	未知	1	2026-03-31 02:26:36.919306	2026-03-31 02:26:36.919306
176	3	4	business_data_revenue	order_amount	订单总额	\N	\N	\N	未知	1	2026-03-31 02:26:36.922446	2026-03-31 02:26:36.922446
177	3	4	business_data_revenue	currency	币别	\N	\N	\N	未知	1	2026-03-31 02:26:36.924939	2026-03-31 02:26:36.924939
178	3	4	business_data_revenue	delivery_batch_no	出库批号	\N	\N	\N	未知	1	2026-03-31 02:26:36.927518	2026-03-31 02:26:36.927518
179	3	4	business_data_revenue	outstock_qty	出库数量	\N	\N	\N	未知	1	2026-03-31 02:26:36.930113	2026-03-31 02:26:36.930113
180	3	4	business_data_revenue	outstock_unit	出库单位	\N	\N	\N	未知	1	2026-03-31 02:26:36.932881	2026-03-31 02:26:36.932881
181	3	4	business_data_revenue	outstock_amount	出库金额	\N	\N	\N	未知	1	2026-03-31 02:26:36.935335	2026-03-31 02:26:36.935335
182	3	4	business_data_revenue	outstock_date	出库日期	\N	\N	\N	未知	1	2026-03-31 02:26:36.939747	2026-03-31 02:26:36.939747
183	3	4	business_data_revenue	rd_team	研发小组	\N	\N	\N	未知	1	2026-03-31 02:26:36.943105	2026-03-31 02:26:36.943105
184	3	4	business_data_revenue	rd_owner	研发人员	\N	\N	\N	未知	1	2026-03-31 02:26:36.946176	2026-03-31 02:26:36.946176
185	3	4	business_data_revenue	requester	请购人	\N	\N	\N	未知	1	2026-03-31 02:26:36.94926	2026-03-31 02:26:36.94926
186	3	4	business_data_revenue	dept_name	部门	\N	\N	\N	未知	1	2026-03-31 02:26:36.951835	2026-03-31 02:26:36.951835
187	3	4	business_data_revenue	po_no	PO	\N	\N	\N	未知	1	2026-03-31 02:26:36.954544	2026-03-31 02:26:36.954544
188	3	4	business_data_revenue	order_leadtime_serial	订单交期	\N	\N	\N	未知	1	2026-03-31 02:26:36.956984	2026-03-31 02:26:36.956984
189	3	4	business_data_revenue	due_date	DueDate	\N	\N	\N	未知	1	2026-03-31 02:26:36.959548	2026-03-31 02:26:36.959548
190	3	4	business_data_revenue	production_date	生产日期	\N	\N	\N	未知	1	2026-03-31 02:26:36.962004	2026-03-31 02:26:36.962004
191	3	4	business_data_revenue	instock_date	入库日期	\N	\N	\N	未知	1	2026-03-31 02:26:36.964648	2026-03-31 02:26:36.964648
192	3	4	business_data_revenue	outstock_org	出库组织	\N	\N	\N	未知	1	2026-03-31 02:26:36.967168	2026-03-31 02:26:36.967168
193	3	4	business_data_revenue	platform	平台	\N	\N	\N	未知	1	2026-03-31 02:26:36.969801	2026-03-31 02:26:36.969801
194	3	4	business_data_revenue	registration_date	注册日期	\N	\N	\N	未知	1	2026-03-31 02:26:36.972371	2026-03-31 02:26:36.972371
195	3	4	business_data_revenue	product_name_en	英文名称	\N	\N	\N	未知	1	2026-03-31 02:26:36.974984	2026-03-31 02:26:36.974984
196	3	4	business_data_revenue	structure_category	Category	\N	\N	\N	未知	1	2026-03-31 02:26:36.977511	2026-03-31 02:26:36.977511
197	3	4	business_data_revenue	product_name_cn	中文名称	\N	\N	\N	未知	1	2026-03-31 02:26:36.980288	2026-03-31 02:26:36.980288
198	3	4	business_data_revenue	fin_product_category	产品分类-财务口径	\N	\N	\N	未知	1	2026-03-31 02:26:36.982899	2026-03-31 02:26:36.982899
199	3	4	business_data_revenue	promotion_type	Promotion	\N	\N	\N	未知	1	2026-03-31 02:26:36.985506	2026-03-31 02:26:36.985506
200	3	4	business_data_revenue	barcode	Barcode	\N	\N	\N	未知	1	2026-03-31 02:26:36.988121	2026-03-31 02:26:36.988121
201	3	4	business_data_revenue	outsourcing_site	委外场地	\N	\N	\N	未知	1	2026-03-31 02:26:36.990649	2026-03-31 02:26:36.990649
202	3	4	business_data_revenue	disclosure_scale	披露量级	\N	\N	\N	未知	1	2026-03-31 02:26:36.993516	2026-03-31 02:26:36.993516
203	3	4	business_data_revenue	wo_outsource_site	工单委外场地	\N	\N	\N	未知	1	2026-03-31 02:26:36.996723	2026-03-31 02:26:36.996723
204	3	4	business_data_revenue	cdmo_platform_customer_flag	CDMO平台客户	\N	\N	\N	未知	1	2026-03-31 02:26:36.999491	2026-03-31 02:26:36.999491
205	3	4	business_data_revenue	apply_outsource_site	委外申请委外场地	\N	\N	\N	未知	1	2026-03-31 02:26:37.002129	2026-03-31 02:26:37.002129
206	3	4	business_data_revenue	material_biz_type	物料业务分类	\N	\N	\N	未知	1	2026-03-31 02:26:37.004769	2026-03-31 02:26:37.004769
207	3	4	business_data_revenue	belonging_platform	所属平台	\N	\N	\N	未知	1	2026-03-31 02:26:37.007506	2026-03-31 02:26:37.007506
208	3	4	business_data_revenue	manufacturing_order_no	MO	\N	\N	\N	未知	1	2026-03-31 02:26:37.010095	2026-03-31 02:26:37.010095
209	3	4	business_data_revenue	product_org	生产组织	\N	\N	\N	未知	1	2026-03-31 02:26:37.012794	2026-03-31 02:26:37.012794
210	3	4	business_data_revenue	country	Country	\N	\N	\N	未知	1	2026-03-31 02:26:37.015519	2026-03-31 02:26:37.015519
211	3	4	business_data_revenue	consignee_country	收货方国家	\N	\N	\N	未知	1	2026-03-31 02:26:37.0185	2026-03-31 02:26:37.0185
212	3	4	business_data_revenue	logistics_status	物流状态	\N	\N	\N	未知	1	2026-03-31 02:26:37.020991	2026-03-31 02:26:37.020991
213	3	4	business_data_revenue	tracking_no	物流单号	\N	\N	\N	未知	1	2026-03-31 02:26:37.023523	2026-03-31 02:26:37.023523
214	3	4	business_data_revenue	sales_person	SalesPerson	\N	\N	\N	未知	1	2026-03-31 02:26:37.026005	2026-03-31 02:26:37.026005
215	3	4	business_data_revenue	sales_dept	SaleDepts	\N	\N	\N	未知	1	2026-03-31 02:26:37.029344	2026-03-31 02:26:37.029344
216	3	4	business_data_revenue	sales_group	SalesGroup	\N	\N	\N	未知	1	2026-03-31 02:26:37.031949	2026-03-31 02:26:37.031949
217	3	4	business_data_revenue	business_type	BusinessType	\N	\N	\N	未知	1	2026-03-31 02:26:37.034402	2026-03-31 02:26:37.034402
218	3	4	business_data_revenue	consignment_flag	代保管	\N	\N	\N	未知	1	2026-03-31 02:26:37.03747	2026-03-31 02:26:37.03747
219	3	4	business_data_revenue	material_group	物料分组	\N	\N	\N	未知	1	2026-03-31 02:26:37.040056	2026-03-31 02:26:37.040056
220	3	4	business_data_revenue	agreement_effective_date	协议生效日期	\N	\N	\N	未知	1	2026-03-31 02:26:37.043366	2026-03-31 02:26:37.043366
221	3	4	business_data_revenue	customer_type	客户类型	\N	\N	\N	未知	1	2026-03-31 02:26:37.045931	2026-03-31 02:26:37.045931
222	3	4	business_data_revenue	region	Region	\N	\N	\N	未知	1	2026-03-31 02:26:37.048434	2026-03-31 02:26:37.048434
223	3	4	business_data_revenue	collab_qty	协同QTY	\N	\N	\N	未知	1	2026-03-31 02:26:37.050903	2026-03-31 02:26:37.050903
224	3	4	business_data_revenue	collab_receipt_qty	协同入库数量	\N	\N	\N	未知	1	2026-03-31 02:26:37.053437	2026-03-31 02:26:37.053437
225	3	4	business_data_revenue	collab_profit_amt	协同利润金额	\N	\N	\N	未知	1	2026-03-31 02:26:37.055898	2026-03-31 02:26:37.055898
226	3	4	business_data_revenue	fpur_order_qty	FPURORDERQTY	\N	\N	\N	未知	1	2026-03-31 02:26:37.058763	2026-03-31 02:26:37.058763
227	3	4	business_data_revenue	ring_category	RingCategory	\N	\N	\N	未知	1	2026-03-31 02:26:37.061521	2026-03-31 02:26:37.061521
228	3	4	business_data_revenue	stock_availability	Stock Availability	\N	\N	\N	未知	1	2026-03-31 02:26:37.064075	2026-03-31 02:26:37.064075
229	3	4	business_data_revenue	series_major_class	系列所属大类	\N	\N	\N	未知	1	2026-03-31 02:26:37.066697	2026-03-31 02:26:37.066697
230	3	4	business_data_revenue	stock_location	Stock	\N	\N	\N	未知	1	2026-03-31 02:26:37.069379	2026-03-31 02:26:37.069379
231	3	4	business_data_revenue	project_type	项目类型	\N	\N	\N	未知	1	2026-03-31 02:26:37.071976	2026-03-31 02:26:37.071976
232	3	4	business_data_revenue	customer_tier	客户等级	\N	\N	\N	未知	1	2026-03-31 02:26:37.074833	2026-03-31 02:26:37.074833
233	3	4	business_data_revenue	project_phase	Project Phase	\N	\N	\N	未知	1	2026-03-31 02:26:37.077472	2026-03-31 02:26:37.077472
234	3	4	business_data_revenue	shipped_amount_cny_tax	出库含税金额（人民币）	\N	\N	\N	未知	1	2026-03-31 02:26:37.080211	2026-03-31 02:26:37.080211
235	3	4	business_data_revenue	revenue	收入	\N	\N	\N	未知	1	2026-03-31 02:26:37.082864	2026-03-31 02:26:37.082864
236	3	4	business_data_revenue	cost	成本	\N	\N	\N	未知	1	2026-03-31 02:26:37.085381	2026-03-31 02:26:37.085381
237	3	4	business_data_revenue	gross_margin_rate	毛利率	\N	\N	\N	未知	1	2026-03-31 02:26:37.088028	2026-03-31 02:26:37.088028
238	3	4	business_data_revenue	bu_segment	事业部划分	\N	\N	\N	未知	1	2026-03-31 02:26:37.090804	2026-03-31 02:26:37.090804
239	3	4	business_data_revenue	is_switzerland_revenue	是否瑞士收入	\N	\N	\N	未知	1	2026-03-31 02:26:37.093697	2026-03-31 02:26:37.093697
240	3	4	business_data_revenue	dept_level2	二级部门	\N	\N	\N	未知	1	2026-03-31 02:26:37.096561	2026-03-31 02:26:37.096561
241	3	4	business_data_revenue	dept_level3	三级部门	\N	\N	\N	未知	1	2026-03-31 02:26:37.100171	2026-03-31 02:26:37.100171
242	3	4	business_data_revenue	biz_type_spot_vs_mo	业务类型（现货or生产订单）	\N	\N	\N	未知	1	2026-03-31 02:26:37.102759	2026-03-31 02:26:37.102759
243	3	4	business_data_revenue	customer_short_name	客户简称	\N	\N	\N	未知	1	2026-03-31 02:26:37.105957	2026-03-31 02:26:37.105957
244	3	4	business_data_revenue	is_key_customer	是否重点客户	\N	\N	\N	未知	1	2026-03-31 02:26:37.108822	2026-03-31 02:26:37.108822
245	3	4	business_data_revenue	is_us_hub_revenue	是否美国仓备库收入	\N	\N	\N	未知	1	2026-03-31 02:26:37.111858	2026-03-31 02:26:37.111858
246	3	4	business_data_revenue	is_novel_bb	是否新颖BB	\N	\N	\N	未知	1	2026-03-31 02:26:37.114769	2026-03-31 02:26:37.114769
247	3	4	business_data_revenue	flag_new_mbb	其中：新分子砌块	\N	\N	\N	未知	1	2026-03-31 02:26:37.118402	2026-03-31 02:26:37.118402
248	3	4	business_data_revenue	flag_new_nce	其中：新化学实体	\N	\N	\N	未知	1	2026-03-31 02:26:37.1215	2026-03-31 02:26:37.1215
249	3	4	business_data_revenue	ext_supplier_revenue_contrib	是否外部供应商对收入贡献	\N	\N	\N	未知	1	2026-03-31 02:26:37.124284	2026-03-31 02:26:37.124284
250	3	4	business_data_revenue	dept_level2_alt	二级部门.1	\N	\N	\N	未知	1	2026-03-31 02:26:37.127122	2026-03-31 02:26:37.127122
251	3	4	business_data_revenue	dept_level3_alt	三级部门.1	\N	\N	\N	未知	1	2026-03-31 02:26:37.13025	2026-03-31 02:26:37.13025
252	3	4	business_data_revenue	is_tech_service	是否技术服务	\N	\N	\N	未知	1	2026-03-31 02:26:37.133153	2026-03-31 02:26:37.133153
253	3	4	business_data_revenue	delivery_lead_days	交付时间	\N	\N	\N	未知	1	2026-03-31 02:26:37.136047	2026-03-31 02:26:37.136047
254	3	4	business_data_revenue	customer_attribution_adj	调整客户归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.139384	2026-03-31 02:26:37.139384
255	3	4	business_data_revenue	is_large_product	是否大产品	\N	\N	\N	未知	1	2026-03-31 02:26:37.142446	2026-03-31 02:26:37.142446
256	3	4	business_data_revenue	late_stage_project_flag	后期项目	\N	\N	\N	未知	1	2026-03-31 02:26:37.145342	2026-03-31 02:26:37.145342
257	3	4	business_data_revenue	customer_group_l1	一级客户分组	\N	\N	\N	未知	1	2026-03-31 02:26:37.148325	2026-03-31 02:26:37.148325
258	3	4	business_data_revenue	customer_tier_alt	客户等级.1	\N	\N	\N	未知	1	2026-03-31 02:26:37.151582	2026-03-31 02:26:37.151582
259	3	4	business_data_revenue	prd_owner	PRD归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.154996	2026-03-31 02:26:37.154996
260	3	4	business_data_revenue	ring_series_owner	环系列归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.157701	2026-03-31 02:26:37.157701
261	3	4	business_data_revenue	new_modality_flag	New Modality业务	\N	\N	\N	未知	1	2026-03-31 02:26:37.160583	2026-03-31 02:26:37.160583
262	3	4	business_data_revenue	dp_business_flag	DP业务	\N	\N	\N	未知	1	2026-03-31 02:26:37.163746	2026-03-31 02:26:37.163746
263	3	4	business_data_revenue	order_kind_compound_vs_service	区分订单类型 - 化合物/技术服务	\N	\N	\N	未知	1	2026-03-31 02:26:37.166593	2026-03-31 02:26:37.166593
264	3	4	business_data_revenue	mo_production_cycle_days	生产订单生产周期	\N	\N	\N	未知	1	2026-03-31 02:26:37.169588	2026-03-31 02:26:37.169588
265	3	4	business_data_revenue	mo_ship_cycle_days	生产订单发货周期	\N	\N	\N	未知	1	2026-03-31 02:26:37.172637	2026-03-31 02:26:37.172637
291	3	4	business_data_order	collection_terms	Collection Terms	\N	\N	\N	未知	1	2026-03-31 02:26:37.250804	2026-03-31 02:26:37.250804
292	3	4	business_data_order	base_currency	Base Currency	\N	\N	\N	未知	1	2026-03-31 02:26:37.254196	2026-03-31 02:26:37.254196
293	3	4	business_data_order	pur_prod_status	Purchasing/Producing Status	\N	\N	\N	未知	1	2026-03-31 02:26:37.257282	2026-03-31 02:26:37.257282
294	3	4	business_data_order	delivery_status	发货状态	\N	\N	\N	未知	1	2026-03-31 02:26:37.259857	2026-03-31 02:26:37.259857
295	3	4	business_data_order	category	Category	\N	\N	\N	未知	1	2026-03-31 02:26:37.262454	2026-03-31 02:26:37.262454
296	3	4	business_data_order	material_biz_group	物料业务分组	\N	\N	\N	未知	1	2026-03-31 02:26:37.265011	2026-03-31 02:26:37.265011
297	3	4	business_data_order	disclosure_scale	披露量级	\N	\N	\N	未知	1	2026-03-31 02:26:37.267643	2026-03-31 02:26:37.267643
298	3	4	business_data_order	latest_progress_date	最新项目进度单日期	\N	\N	\N	未知	1	2026-03-31 02:26:37.270231	2026-03-31 02:26:37.270231
299	3	4	business_data_order	related_pm	关联PM	\N	\N	\N	未知	1	2026-03-31 02:26:37.272917	2026-03-31 02:26:37.272917
300	3	4	business_data_order	include_in_calc_flag	用于计算	\N	\N	\N	未知	1	2026-03-31 02:26:37.275761	2026-03-31 02:26:37.275761
301	3	4	business_data_order	accum_cash_in	累计确认收款金额	\N	\N	\N	未知	1	2026-03-31 02:26:37.279003	2026-03-31 02:26:37.279003
302	3	4	business_data_order	accum_ar_push	累计下推应收金额	\N	\N	\N	未知	1	2026-03-31 02:26:37.282167	2026-03-31 02:26:37.282167
303	3	4	business_data_order	project_status	项目状态	\N	\N	\N	未知	1	2026-03-31 02:26:37.284672	2026-03-31 02:26:37.284672
304	3	4	business_data_order	stock_nanjing	南京库存	\N	\N	\N	未知	1	2026-03-31 02:26:37.287215	2026-03-31 02:26:37.287215
305	3	4	business_data_order	stock_usa	美国库存	\N	\N	\N	未知	1	2026-03-31 02:26:37.289692	2026-03-31 02:26:37.289692
306	3	4	business_data_order	stock_available	可用库存	\N	\N	\N	未知	1	2026-03-31 02:26:37.292296	2026-03-31 02:26:37.292296
307	3	4	business_data_order	ring_category	Ring Category	\N	\N	\N	未知	1	2026-03-31 02:26:37.295659	2026-03-31 02:26:37.295659
308	3	4	business_data_order	project_phase_type	Project Phase Type	\N	\N	\N	未知	1	2026-03-31 02:26:37.298943	2026-03-31 02:26:37.298943
309	3	4	business_data_order	customer_tier	客户等级	\N	\N	\N	未知	1	2026-03-31 02:26:37.3019	2026-03-31 02:26:37.3019
310	3	4	business_data_order	late_stage_project	后期项目	\N	\N	\N	未知	1	2026-03-31 02:26:37.304447	2026-03-31 02:26:37.304447
311	3	4	business_data_order	month	月份	\N	\N	\N	未知	1	2026-03-31 02:26:37.307238	2026-03-31 02:26:37.307238
312	3	4	business_data_order	customer_group_l1	一级客户分组	\N	\N	\N	未知	1	2026-03-31 02:26:37.310615	2026-03-31 02:26:37.310615
313	3	4	business_data_order	dp_business	DP业务	\N	\N	\N	未知	1	2026-03-31 02:26:37.313291	2026-03-31 02:26:37.313291
314	3	4	business_data_order	order_amount_cny	人民币订单金额	\N	\N	\N	未知	1	2026-03-31 02:26:37.316236	2026-03-31 02:26:37.316236
315	3	4	business_data_order	order_region	订单归属区域	\N	\N	\N	未知	1	2026-03-31 02:26:37.319494	2026-03-31 02:26:37.319494
316	3	4	business_data_order	customer_attribution_adj	调整客户归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.322256	2026-03-31 02:26:37.322256
317	3	4	business_data_order	quantity	数量	\N	\N	\N	未知	1	2026-03-31 02:26:37.325274	2026-03-31 02:26:37.325274
318	3	4	business_data_order	bu_segment	事业部划分	\N	\N	\N	未知	1	2026-03-31 02:26:37.328346	2026-03-31 02:26:37.328346
319	3	4	business_data_order	customer_short_name	客户简称	\N	\N	\N	未知	1	2026-03-31 02:26:37.331248	2026-03-31 02:26:37.331248
320	3	4	business_data_order	is_important_customer	是否重要客户	\N	\N	\N	未知	1	2026-03-31 02:26:37.334219	2026-03-31 02:26:37.334219
321	3	4	business_data_order	is_new_key_customer	是否为新增重点客户	\N	\N	\N	未知	1	2026-03-31 02:26:37.336983	2026-03-31 02:26:37.336983
322	3	4	business_data_order	is_potential_new_customer	是否为潜力新客户	\N	\N	\N	未知	1	2026-03-31 02:26:37.340021	2026-03-31 02:26:37.340021
323	3	4	business_data_order	is_large_product	是否大产品	\N	\N	\N	未知	1	2026-03-31 02:26:37.343283	2026-03-31 02:26:37.343283
324	3	4	business_data_order	late_stage_project_alt	后期项目.1	\N	\N	\N	未知	1	2026-03-31 02:26:37.346397	2026-03-31 02:26:37.346397
325	3	4	business_data_order	customer_tier_alt	客户等级.1	\N	\N	\N	未知	1	2026-03-31 02:26:37.349637	2026-03-31 02:26:37.349637
326	3	4	business_data_order	prd_owner	PRD归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.352699	2026-03-31 02:26:37.352699
327	3	4	business_data_order	new_modality	New Modality业务	\N	\N	\N	未知	1	2026-03-31 02:26:37.35554	2026-03-31 02:26:37.35554
328	3	4	business_data_order	order_kind_compound_vs_service	区分订单类型 - 化合物/技术服务	\N	\N	\N	未知	1	2026-03-31 02:26:37.358947	2026-03-31 02:26:37.358947
329	3	4	business_data_order	rnd_status	在研状态	\N	\N	\N	未知	1	2026-03-31 02:26:37.362116	2026-03-31 02:26:37.362116
330	3	4	business_data_order	spot_vs_mo	现货/生产订单	\N	\N	\N	未知	1	2026-03-31 02:26:37.364959	2026-03-31 02:26:37.364959
331	3	4	business_data_order	done_not_shipped	是否已完工未发货	\N	\N	\N	未知	1	2026-03-31 02:26:37.368007	2026-03-31 02:26:37.368007
332	3	4	business_data_order	ring_series_owner	环系列归属	\N	\N	\N	未知	1	2026-03-31 02:26:37.370915	2026-03-31 02:26:37.370915
\.


--
-- TOC entry 5029 (class 0 OID 50075)
-- Dependencies: 236
-- Data for Name: user_prompt_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_prompt_config (id, name, prompt_type, agent_id, system_prompt, enabled, description, priority, display_order, create_time, update_time, creator) FROM stdin;
eb5dd85d-890e-43a4-90c1-c67ee14683cd	订单目标值	report-generator	2	2025年订单目标值是1000万，2026年订单目标值是2000万	1		0	0	2026-03-26 14:08:21.19123	2026-03-26 14:08:21.19123	user
\.


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 229
-- Name: agent_datasource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agent_datasource_id_seq', 13, true);


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 237
-- Name: agent_datasource_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agent_datasource_tables_id_seq', 24, true);


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 217
-- Name: agent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agent_id_seq', 4, true);


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 223
-- Name: agent_knowledge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agent_knowledge_id_seq', 9, true);


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 231
-- Name: agent_preset_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agent_preset_question_id_seq', 73, true);


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_knowledge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.business_knowledge_id_seq', 11, true);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 234
-- Name: chat_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chat_message_id_seq', 1083, true);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 225
-- Name: datasource_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.datasource_id_seq', 4, true);


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 227
-- Name: logical_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.logical_relation_id_seq', 2, true);


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 239
-- Name: model_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.model_config_id_seq', 3, true);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 221
-- Name: semantic_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.semantic_model_id_seq', 332, true);


-- Completed on 2026-04-10 16:57:54

--
-- PostgreSQL database dump complete
--

