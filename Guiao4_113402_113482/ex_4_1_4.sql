IF OBJECT_ID ('MED_VENDE','U') IS NOT NULL
    DROP TABLE dbo.MED_VENDE;
IF OBJECT_ID ('MED_FARMACIA','U') IS NOT NULL
    DROP TABLE dbo.MED_FARMACIA;
IF OBJECT_ID ('MED_PRODUZ','U') IS NOT NULL
    DROP TABLE dbo.MED_PRODUZ;
IF OBJECT_ID ('MED_TEM','U') IS NOT NULL
    DROP TABLE dbo.MED_TEM;
IF OBJECT_ID ('MED_FARMACO','U') IS NOT NULL
    DROP TABLE dbo.MED_FARMACO;
IF OBJECT_ID ('MED_FARMACEUTICA','U') IS NOT NULL
    DROP TABLE dbo.MED_FARMACEUTICA;
IF OBJECT_ID ('MED_PRESCRICAO','U') IS NOT NULL
    DROP TABLE dbo.MED_PRESCRICAO;
IF OBJECT_ID ('MED_PACIENTE','U') IS NOT NULL
    DROP TABLE dbo.MED_PACIENTE;
IF OBJECT_ID ('MED_MEDICO','U') IS NOT NULL
    DROP TABLE dbo.MED_MEDICO;
IF OBJECT_ID ('MED_ESPECIALIDADE','U') IS NOT NULL
    DROP TABLE dbo.MED_ESPECIALIDADE;

CREATE TABLE MED_ESPECIALIDADE(
	Código				INT						NOT NULL,
	SNS					INT						NOT NULL,
	PRIMARY KEY(Código)
);

CREATE TABLE MED_MEDICO(
	SNS							INT						NOT NULL,
	Nome						VARCHAR(64)				NOT NULL,
	Especialidade_código		INT						NOT NULL,
	PRIMARY KEY(SNS),
	FOREIGN KEY(Especialidade_código)	REFERENCES MED_ESPECIALIDADE(Código)
);

CREATE TABLE MED_PACIENTE(
	Número_de_utente			INT				NOT NULL,
	[Nome]						VARCHAR(64)		NOT NULL,
	[Data_de_nascimento]		INT				NOT NULL,
	[Endereço]					VARCHAR(64)		NOT NULL,
	PRIMARY KEY(Número_de_utente)
);

CREATE TABLE MED_PRESCRICAO(
	Número					INT					NOT NULL,
	[Data]					INT					NOT NULL,
	Paciente_numero			INT					NOT NULL,
	Médico_SNS				INT					NOT NULL,
	PRIMARY KEY(Número),
	FOREIGN KEY(Paciente_numero)	REFERENCES MED_PACIENTE(Número_de_utente),
	FOREIGN KEY(Médico_SNS)			REFERENCES MED_MEDICO(SNS)
);

CREATE TABLE MED_FARMACEUTICA(
	Número_de_registo_nacional				INT				NOT NULL,
	Telefone								INT				NOT NULL,
	[Endereco]								VARCHAR(64)		NOT NULL,
	[Nome]									VARCHAR(64)		NOT NULL,
	PRIMARY KEY(Número_de_registo_nacional),
	UNIQUE([Endereco])
);

CREATE TABLE MED_FARMACO(
	[Fórmula]					VARCHAR(64)				NOT NULL,
	[Nome comercial]			VARCHAR(65)				NOT NULL,
	Farmacêutica_Nmr			INT						NOT NULL,
	PRIMARY KEY([Fórmula],Farmacêutica_Nmr),
	FOREIGN KEY(Farmacêutica_Nmr)		REFERENCES MED_FARMACEUTICA(Número_de_registo_nacional)
);

CREATE TABLE MED_TEM(
	Prescricao_Número				INT				NOT NULL,
	[Fármaco_fórmula]				VARCHAR(64)		NOT NULL,
	Fármaco_farmacêutica_Nmr		INT				NOT NULL,
	PRIMARY KEY(Prescricao_Número,[Fármaco_fórmula],Fármaco_farmacêutica_Nmr),
	FOREIGN KEY(Prescricao_Número)								REFERENCES MED_PRESCRICAO(Número),
	FOREIGN KEY([Fármaco_fórmula],Fármaco_farmacêutica_Nmr)		REFERENCES MED_FARMACO([Fórmula],Farmacêutica_Nmr)
);

CREATE TABLE MED_PRODUZ(
	[Fármaco_fórmula]				VARCHAR(64)				NOT NULL,
	Farmacêutica_Nmr				INT						NOT NULL,
	Fármaco_farmacêutica_Nmr		INT						NOT NULL,
	PRIMARY KEY([Fármaco_fórmula],Farmacêutica_Nmr, Fármaco_farmacêutica_Nmr),
	FOREIGN KEY([Fármaco_fórmula],Fármaco_farmacêutica_Nmr)		REFERENCES MED_FARMACO([Fórmula],Farmacêutica_Nmr),
	FOREIGN KEY(Farmacêutica_Nmr)		REFERENCES MED_FARMACEUTICA(Número_de_registo_nacional)
);

CREATE TABLE MED_FARMACIA(
	NIF						INT					NOT NULL,
	[Nome]					VARCHAR(64)			NOT NULL,
	[Endereco]				VARCHAR(64)			NOT NULL,
	Telefone				INT					NOT NULL,
	PRIMARY KEY(NIF),
	UNIQUE([Endereco])
);

CREATE TABLE MED_VENDE(
	[Fármaco_fórmula]				VARCHAR(64)			NOT NULL,
	Farmaco_Farmacêutica_Nmr		INT					NOT NULL,
	Farmácia_NIF					INT					NOT NULL,
	PRIMARY KEY([Fármaco_fórmula],Farmaco_Farmacêutica_Nmr,Farmácia_NIF),
	FOREIGN KEY([Fármaco_fórmula],Farmaco_Farmacêutica_Nmr)	REFERENCES MED_FARMACO([Fórmula],Farmacêutica_Nmr),
	FOREIGN KEY(Farmácia_NIF)								REFERENCES MED_FARMACIA(NIF)
);