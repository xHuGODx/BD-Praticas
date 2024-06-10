IF OBJECT_ID ('CONF_ESTUDANTE','U') IS NOT NULL
    DROP TABLE dbo.CONF_ESTUDANTE;
IF OBJECT_ID ('CONF_INSTITUICAO','U') IS NOT NULL
    DROP TABLE dbo.CONF_INSTITUICAO;
IF OBJECT_ID ('CONF_NAOESTUDANTE','U') IS NOT NULL
    DROP TABLE dbo.CONF_NAOESTUDANTE;
IF OBJECT_ID ('CONF_PARTICIPANTE','U') IS NOT NULL
    DROP TABLE dbo.CONF_PARTICIPANTE;
IF OBJECT_ID ('CONF_TEM','U') IS NOT NULL
    DROP TABLE dbo.CONF_TEM;
IF OBJECT_ID ('CONF_AUTOR','U') IS NOT NULL
    DROP TABLE dbo.CONF_AUTOR;
IF OBJECT_ID ('CONF_PESSOA','U') IS NOT NULL
    DROP TABLE dbo.CONF_PESSOA;
IF OBJECT_ID ('CONF_ARTIGOS','U') IS NOT NULL
    DROP TABLE dbo.CONF_ARTIGOS;



CREATE TABLE CONF_ARTIGOS(
	Número_de_registo			INT				NOT NULL,
	[Título]					VARCHAR(64)		NOT NULL,
	PRIMARY KEY(Número_de_registo)
);

CREATE TABLE CONF_PESSOA(
	[Endereco]				VARCHAR(64)				NOT NULL,
	[Nome]					VARCHAR(64)				NOT NULL,
	PRIMARY KEY([Endereco])
);

CREATE TABLE CONF_AUTOR(
	[Pessoa_Endereco]			VARCHAR(64)				NOT NULL,
	PRIMARY KEY([Pessoa_Endereco]),
	FOREIGN KEY([Pessoa_Endereco])		REFERENCES CONF_PESSOA([Endereco])
);

CREATE TABLE CONF_TEM(
	Artigos_Número_de_registo			INT						NOT NULL,
	[Autor_Endereco]						VARCHAR(64)			NOT NULL,
	PRIMARY KEY(Artigos_Número_de_registo,[Autor_Endereco]),
	FOREIGN KEY(Artigos_Número_de_registo)	REFERENCES CONF_ARTIGOS(Número_de_registo),
	FOREIGN KEY([Autor_Endereco])			REFERENCES CONF_AUTOR([Pessoa_Endereco])
);

CREATE TABLE CONF_PARTICIPANTE(
	[Pessoa_Endereco]			VARCHAR(64)				NOT NULL,
	[Data_inscr]				VARCHAR(64)				NOT NULL,
	[Morada]					VARCHAR(64)				NOT NULL,
	PRIMARY KEY([Pessoa_Endereco]),
	FOREIGN KEY ([Pessoa_Endereco])		REFERENCES CONF_PESSOA([Endereco])
);

CREATE TABLE CONF_NAOESTUDANTE(
	[Participante_Pessoa_Endereco]		VARCHAR(64)			NOT NULL,
	PRIMARY KEY([Participante_Pessoa_Endereco]),
	FOREIGN KEY([Participante_Pessoa_Endereco])	REFERENCES CONF_PARTICIPANTE([Pessoa_Endereco])
);

CREATE TABLE CONF_INSTITUICAO(
	[Endereco]					VARCHAR(64)				NOT NULL,
	[Nome]						VARCHAR(64)				NOT NULL,
	PRIMARY KEY([Endereco])
);

CREATE TABLE CONF_ESTUDANTE(
	[Participante_Pessoa_Endereco]		VARCHAR(64)			NOT NULL,
	[Instituicao_Endereco]				VARCHAR(64)			NOT NULL,
	[Comp_Loc]							VARCHAR(64)			NOT NULL,
	PRIMARY KEY([Participante_Pessoa_Endereco]),
	FOREIGN KEY([Participante_Pessoa_Endereco])	REFERENCES CONF_PARTICIPANTE([Pessoa_Endereco]),
	FOREIGN KEY([Instituicao_Endereco])			REFERENCES CONF_INSTITUICAO([Endereco])
);
