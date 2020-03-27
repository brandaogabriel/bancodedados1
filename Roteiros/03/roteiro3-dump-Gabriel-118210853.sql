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

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_fk_venda_farmacia_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT venda_constraint;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_fk_medicamento_farmacia_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT gerente_fk;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_fk_farmacia_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT fk_cliente_entrega;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT fk_client_cadastr;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_fk_venda_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT sede_unica;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_cpf_funcionario_tipo_funcionario_key;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_fk_func_gerente_tipo_gerente_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT bairro_constraint;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacias;
DROP TABLE public.entregas;
DROP TABLE public.clientes;
DROP TYPE public.estados;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estados; Type: TYPE; Schema: public; Owner: gabrielbrandao
--

CREATE TYPE public.estados AS ENUM (
    'AL',
    'BA',
    'CE',
    'MA',
    'PB',
    'PE',
    'PI',
    'RN',
    'SE'
);


ALTER TYPE public.estados OWNER TO gabrielbrandao;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    nome character varying(50) NOT NULL,
    idade integer NOT NULL,
    endereco character varying(20),
    endereco2 character varying(20),
    CONSTRAINT endereco_constraint CHECK ((((endereco)::text = 'residência'::text) OR ((endereco)::text = 'trabalho'::text) OR ((endereco)::text = 'outro'::text) OR (((endereco2)::text = 'residência'::text) OR ((endereco2)::text = 'trabalho'::text) OR ((endereco2)::text = 'outro'::text)))),
    CONSTRAINT idade_client_constraint CHECK ((idade >= 18))
);


ALTER TABLE public.clientes OWNER TO gabrielbrandao;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.entregas (
    id_entrega integer NOT NULL,
    fk_cliente integer,
    fk_venda integer,
    CONSTRAINT entrega_constraint CHECK ((fk_cliente <> NULL::integer))
);


ALTER TABLE public.entregas OWNER TO gabrielbrandao;

--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.farmacias (
    id_farmacia integer NOT NULL,
    nome character varying(35) NOT NULL,
    tipo_farmacia character varying(6) NOT NULL,
    endereco character varying(40) NOT NULL,
    fk_func_gerente character(16),
    tipo_gerente character varying(16),
    estado public.estados NOT NULL,
    CONSTRAINT farmacias_tipo_farmacia_check CHECK ((((tipo_farmacia)::text = 'sede'::text) OR ((tipo_farmacia)::text = 'filial'::text))),
    CONSTRAINT gerente_tipo_constraint CHECK ((((tipo_gerente)::text = 'administrador'::text) OR ((tipo_gerente)::text = 'farmacêutico'::text)))
);


ALTER TABLE public.farmacias OWNER TO gabrielbrandao;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.funcionarios (
    cpf_funcionario character(11) NOT NULL,
    nome character varying(50) NOT NULL,
    tipo_funcionario character varying(16) NOT NULL,
    fk_farmacia integer,
    fk_vendas integer,
    CONSTRAINT alocado_constraint CHECK (((fk_farmacia = NULL::integer) OR (fk_farmacia <> NULL::integer))),
    CONSTRAINT tipo_funcionario_cst CHECK ((((tipo_funcionario)::text = 'farmacêutico'::text) OR ((tipo_funcionario)::text = 'vendedor'::text) OR ((tipo_funcionario)::text = 'entregador'::text) OR ((tipo_funcionario)::text = 'caixa'::text) OR ((tipo_funcionario)::text = 'administrador'::text)))
);


ALTER TABLE public.funcionarios OWNER TO gabrielbrandao;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.medicamentos (
    id_medicamento integer NOT NULL,
    nome character varying(55) NOT NULL,
    preco numeric NOT NULL,
    caracteristica character varying(40),
    fk_medicamento_farmacia integer,
    CONSTRAINT caracteristica_constraint CHECK ((((caracteristica)::text = 'venda exclusiva com receita'::text) OR ((caracteristica)::text = NULL::text)))
);


ALTER TABLE public.medicamentos OWNER TO gabrielbrandao;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: gabrielbrandao
--

CREATE TABLE public.vendas (
    id_venda integer NOT NULL,
    valor numeric NOT NULL,
    data_venda date NOT NULL,
    fk_medicamento integer,
    fk_venda_farmacia integer,
    fk_id_cliente integer
);


ALTER TABLE public.vendas OWNER TO gabrielbrandao;

--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.clientes (id_cliente, nome, idade, endereco, endereco2) VALUES (1, 'Joaozinho', 18, 'residência', NULL);
INSERT INTO public.clientes (id_cliente, nome, idade, endereco, endereco2) VALUES (2, 'Bruno', 18, 'residência', 'trabalho');
INSERT INTO public.clientes (id_cliente, nome, idade, endereco, endereco2) VALUES (3, 'Alfredo', 23, 'residência', NULL);
INSERT INTO public.clientes (id_cliente, nome, idade, endereco, endereco2) VALUES (4, 'Max', 19, 'residência', 'trabalho');


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--



--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (1, 'Drogasil', 'filial', 'bela vista - campina grande', '23456786593     ', 'farmacêutico', 'PB');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (3, 'Farmacia do trabalhador do Brasil', 'filial', 'catole - campina grande', NULL, NULL, 'PB');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (4, 'Farmacia Dias', 'filial', 'ze pinheiro - campina grande', NULL, NULL, 'PB');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (2, 'Pague Menos', 'sede', 'centro - campina grande', '13456789054     ', 'administrador', 'PB');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (5, 'RedePharma', 'filial', 'centro - joao pessoa', NULL, NULL, 'PB');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (6, 'Baratao', 'filial', 'centro - natal', NULL, NULL, 'RN');
INSERT INTO public.farmacias (id_farmacia, nome, tipo_farmacia, endereco, fk_func_gerente, tipo_gerente, estado) VALUES (7, 'Drogaria', 'filial', 'centro - maceio', NULL, NULL, 'AL');


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.funcionarios (cpf_funcionario, nome, tipo_funcionario, fk_farmacia, fk_vendas) VALUES ('32343215432', 'Joao', 'entregador', NULL, NULL);
INSERT INTO public.funcionarios (cpf_funcionario, nome, tipo_funcionario, fk_farmacia, fk_vendas) VALUES ('54546578792', 'José', 'caixa', NULL, NULL);
INSERT INTO public.funcionarios (cpf_funcionario, nome, tipo_funcionario, fk_farmacia, fk_vendas) VALUES ('23456786593', 'Gabriel', 'farmacêutico', 1, NULL);
INSERT INTO public.funcionarios (cpf_funcionario, nome, tipo_funcionario, fk_farmacia, fk_vendas) VALUES ('78954309652', 'Carlos', 'vendedor', 2, NULL);
INSERT INTO public.funcionarios (cpf_funcionario, nome, tipo_funcionario, fk_farmacia, fk_vendas) VALUES ('13456789054', 'Bruno', 'administrador', 2, NULL);


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.medicamentos (id_medicamento, nome, preco, caracteristica, fk_medicamento_farmacia) VALUES (1, 'Paracetamol', 10.50, NULL, 1);


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: gabrielbrandao
--

INSERT INTO public.vendas (id_venda, valor, data_venda, fk_medicamento, fk_venda_farmacia, fk_id_cliente) VALUES (1, 10.50, '2020-03-26', 1, 1, 1);
INSERT INTO public.vendas (id_venda, valor, data_venda, fk_medicamento, fk_venda_farmacia, fk_id_cliente) VALUES (2, 10.50, '2020-03-27', 1, 1, NULL);


--
-- Name: bairro_constraint; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT bairro_constraint UNIQUE (endereco);


--
-- Name: clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- Name: entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id_entrega);


--
-- Name: farmacias_fk_func_gerente_tipo_gerente_key; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_fk_func_gerente_tipo_gerente_key UNIQUE (fk_func_gerente, tipo_gerente);


--
-- Name: farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id_farmacia);


--
-- Name: funcionarios_cpf_funcionario_tipo_funcionario_key; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_cpf_funcionario_tipo_funcionario_key UNIQUE (cpf_funcionario, tipo_funcionario);


--
-- Name: funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf_funcionario);


--
-- Name: medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id_medicamento);


--
-- Name: sede_unica; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT sede_unica EXCLUDE USING gist (tipo_farmacia WITH =) WHERE (((tipo_farmacia)::text = 'sede'::text));


--
-- Name: vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id_venda);


--
-- Name: entregas_fk_venda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_fk_venda_fkey FOREIGN KEY (fk_venda) REFERENCES public.vendas(id_venda);


--
-- Name: fk_client_cadastr; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_client_cadastr FOREIGN KEY (fk_id_cliente) REFERENCES public.clientes(id_cliente);


--
-- Name: fk_cliente_entrega; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT fk_cliente_entrega FOREIGN KEY (fk_cliente) REFERENCES public.clientes(id_cliente);


--
-- Name: funcionarios_fk_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_fk_farmacia_fkey FOREIGN KEY (fk_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: gerente_fk; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT gerente_fk FOREIGN KEY (fk_func_gerente, tipo_gerente) REFERENCES public.funcionarios(cpf_funcionario, tipo_funcionario);


--
-- Name: medicamentos_fk_medicamento_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_fk_medicamento_farmacia_fkey FOREIGN KEY (fk_medicamento_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: venda_constraint; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT venda_constraint FOREIGN KEY (fk_medicamento) REFERENCES public.medicamentos(id_medicamento) ON DELETE RESTRICT;


--
-- Name: vendas_fk_venda_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabrielbrandao
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_fk_venda_farmacia_fkey FOREIGN KEY (fk_venda_farmacia) REFERENCES public.farmacias(id_farmacia);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--



-- As tabelas já estao povoadas com os requisitos estabelicidos (eu espero) para o roteiro. Abaixo segue alguns comandos que não sao executados, visto as 
-- restrições de constraint

/* Erros  */

-- Cadastrando uma farmacia que nao seja sede ou filial - Deve retornar erro de constraint 
INSERT INTO farmacias VALUES (6, 'RedePharma', 'casa', 'centro - joao pessoa', NULL, NULL, 'PB');

-- Cadastrando um funcionario que nao seja do tipo farmaceutico, vendedor, entregador, caixa ou administrador - Deve retornar erro de constraint tipo_funcionario_cst
INSERT INTO funcionarios VALUES('54546767890', 'Juliano', 'balconista', NULL, NULL);

-- Deletando um medicamento que esta relacionado a alguma venda - Deve retornar erro de constraint venda_constraint
DELETE FROM medicamentos WHERE id_medicamento = 1;

-- Cadastrando clientes menores de 18 anos - Deve retornar erro de constraint idade_client_constraint
INSERT INTO clientes VALUES (3, 'Carlos Alberto', 17, 'residência', NULL);

-- Cadastrando uma farmacia no mesmo bairro de outra - Deve retornar erro de constraint bairro_constraint
INSERT INTO farmacias VALUES (8, 'DrugStore', 'filial', 'centro - maceio', NULL, NULL, 'AL');

-- Cadastrando uma farmacia, porém que ja tem sede - Deve retornar erro de constraint sede_unica
INSERT INTO farmacias VALUES (9, 'Pague menos', 'sede', 'malvinas - campina grande', NULL, NULL, 'PB');

-- Cadastrando uma farmacia que nao pertece a um dos estados do nordeste - Deve retornar erro de constraint de tipo enum
INSERT INTO farmacias VALUES (10, 'Farmacia Nacional', 'filial', 'centro - sao paulo', NULL, NULL, 'SP');

