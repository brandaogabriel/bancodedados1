
CREATE TABLE automovel(
	placa char(7) PRIMARY KEY NOT NULL,
	modelo varchar(40),
	ano integer,
	cor varchar(10)
);

CREATE TABLE segurado(
	cpf char(11) PRIMARY KEY NOT NULL,
	nome varchar(30),
	endereco varchar(30),
	genero char(1)
);

CREATE TABLE perito(
	perito_id integer PRIMARY KEY NOT NULL,
	nome varchar(40),
	telefone char(11)
);

-- Uma oficina tem relação com um reparo
CREATE TABLE oficina(
	cnpj char(11) PRIMARY KEY NOT NULL,
	nome_fantasia varchar(40),
	endereco varchar(45),
	telefone char(11),
	reparos integer
);


-- Um seguro tem relação com um segurado. 
CREATE TABLE seguro(
	apolice integer PRIMARY KEY NOT NULL,
	data_inicio date,
	data_experiacao date,
	segurado char(11) REFERENCES segurado(cpf)
);

-- Um sinistro tem um automovel foreign key, ou seja, tem relação com um carro. 
CREATE TABLE sinistro(
	sinistro_id integer PRIMARY KEY NOT NULL,
	automovel char(7) REFERENCES automovel(placa),
	data_sinistro date
);

-- Uma pericia tem relação com autor da pericia bem como o sinistro. 
CREATE TABLE pericia(
	pericia_id integer PRIMARY KEY NOT NULL,
	perito integer REFERENCES perito(perito_id),
	sinistro integer REFERENCES sinistro(sinistro_id),
	data_pericia date
);

-- Um reparo tem relação com um carro. 
CREATE TABLE reparo(
	reparo_id integer PRIMARY KEY NOT NULL,
	automovel char(7) REFERENCES automovel(placa),
	reparo_custo numeric,
	data_reparo date
);

ALTER TABLE oficina ADD CONSTRAINT oficina_reparos_fkey FOREIGN KEY (reparos) REFERENCES reparo(reparo_id);

DROP TABLE automovel, segurado, perito, oficina, seguro, sinistro, pericia, reparo;

-- Poderia ter as tabelas de emplooyes que teriam todos os funcionarios da oficina, peritos, mecanicos, etc. 