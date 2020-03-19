--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 9.5.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT cascade_constraint;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT id_pk;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(50) NOT NULL,
    funcao character varying(11),
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcao_constraint CHECK (((((funcao)::text = 'LIMPEZA'::text) AND ((superior_cpf <> ''::bpchar) AND (superior_cpf IS NOT NULL))) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT nivel_constraint CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO gabrielbrandao;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.tarefas (
    id bigint,
    descricao character varying(50) NOT NULL,
    func_resp_cpf character varying(11) NOT NULL,
    prioridade integer NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT cpf_constraint CHECK ((character_length((func_resp_cpf)::text) = 11)),
    CONSTRAINT id_null_constraint CHECK ((((id = NULL::bigint) AND (status <> 'E'::bpchar)) OR ((id <> NULL::bigint) AND (status = 'E'::bpchar)) OR ((id <> NULL::bigint) AND (status <> 'E'::bpchar)))),
    CONSTRAINT prioridade_constraint CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT status_constraint CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar)))
);


ALTER TABLE public.tarefas OWNER TO gabrielbrandao;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('27345678912', '1980-01-25', 'da Silva', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('45632789513', '1980-09-11', 'Roberto', 'LIMPEZA', 'S', '27345678912');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('40028922243', '1999-03-30', 'Tony stark', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('66665478325', '1980-03-08', 'Juninho', 'LIMPEZA', 'J', '40028922243');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('23334216780', '1980-11-11', 'Marcos Glauber', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('77786543280', '1991-12-12', 'Neymar Jr', 'LIMPEZA', 'J', '23334216780');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('90908765432', '2020-01-01', 'Donald Trump', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('76548930987', '2020-01-01', 'Bolsonaro', 'LIMPEZA', 'J', '90908765432');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432109', '2010-01-01', 'Lula da Silva', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('87654321231', '2015-05-20', 'Dilma', 'LIMPEZA', 'J', '98765432109');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('23334246780', '1980-11-11', 'Marcos Glauber', 'SUP_LIMPEZA', 'S', '23334216780');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '2010-03-09', 'Carlos', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911', '2010-03-09', 'Max', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '2010-03-09', 'Max', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '2011-03-09', 'Robert', 'SUP_LIMPEZA', 'S', NULL);


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: id_pk; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT id_pk PRIMARY KEY (id);


--
-- Name: cascade_constraint; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT cascade_constraint FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE CASCADE;


--
-- Name: funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- PostgreSQL database dump complete
--

