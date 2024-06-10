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
	C�digo				INT						NOT NULL,
	SNS					INT						NOT NULL,
	PRIMARY KEY(C�digo)
);

CREATE TABLE MED_MEDICO(
	SNS							INT						NOT NULL,
	Nome						VARCHAR(64)				NOT NULL,
	Especialidade_c�digo		INT						NOT NULL,
	PRIMARY KEY(SNS),
	FOREIGN KEY(Especialidade_c�digo)	REFERENCES MED_ESPECIALIDADE(C�digo)
);

CREATE TABLE MED_PACIENTE(
	N�mero_de_utente			INT				NOT NULL,
	[Nome]						VARCHAR(64)		NOT NULL,
	[Data_de_nascimento]		INT				NOT NULL,
	[Endere�o]					VARCHAR(64)		NOT NULL,
	PRIMARY KEY(N�mero_de_utente)
);

CREATE TABLE MED_PRESCRICAO(
	N�mero					INT					NOT NULL,
	[Data]					INT					NOT NULL,
	Paciente_numero			INT					NOT NULL,
	M�dico_SNS				INT					NOT NULL,
	PRIMARY KEY(N�mero),
	FOREIGN KEY(Paciente_numero)	REFERENCES MED_PACIENTE(N�mero_de_utente),
	FOREIGN KEY(M�dico_SNS)			REFERENCES MED_MEDICO(SNS)
);

CREATE TABLE MED_FARMACEUTICA(
	N�mero_de_registo_nacional				INT				NOT NULL,
	Telefone								INT				NOT NULL,
	[Endereco]								VARCHAR(64)		NOT NULL,
	[Nome]									VARCHAR(64)		NOT NULL,
	PRIMARY KEY(N�mero_de_registo_nacional),
	UNIQUE([Endereco])
);

CREATE TABLE MED_FARMACO(
	[F�rmula]					VARCHAR(64)				NOT NULL,
	[Nome comercial]			VARCHAR(65)				NOT NULL,
	Farmac�utica_Nmr			INT						NOT NULL,
	PRIMARY KEY([F�rmula],Farmac�utica_Nmr),
	FOREIGN KEY(Farmac�utica_Nmr)		REFERENCES MED_FARMACEUTICA(N�mero_de_registo_nacional)
);

CREATE TABLE MED_TEM(
	Prescricao_N�mero				INT				NOT NULL,
	[F�rmaco_f�rmula]				VARCHAR(64)		NOT NULL,
	F�rmaco_farmac�utica_Nmr		INT				NOT NULL,
	PRIMARY KEY(Prescricao_N�mero,[F�rmaco_f�rmula],F�rmaco_farmac�utica_Nmr),
	FOREIGN KEY(Prescricao_N�mero)								REFERENCES MED_PRESCRICAO(N�mero),
	FOREIGN KEY([F�rmaco_f�rmula],F�rmaco_farmac�utica_Nmr)		REFERENCES MED_FARMACO([F�rmula],Farmac�utica_Nmr)
);

CREATE TABLE MED_PRODUZ(
	[F�rmaco_f�rmula]				VARCHAR(64)				NOT NULL,
	Farmac�utica_Nmr				INT						NOT NULL,
	F�rmaco_farmac�utica_Nmr		INT						NOT NULL,
	PRIMARY KEY([F�rmaco_f�rmula],Farmac�utica_Nmr, F�rmaco_farmac�utica_Nmr),
	FOREIGN KEY([F�rmaco_f�rmula],F�rmaco_farmac�utica_Nmr)		REFERENCES MED_FARMACO([F�rmula],Farmac�utica_Nmr),
	FOREIGN KEY(Farmac�utica_Nmr)		REFERENCES MED_FARMACEUTICA(N�mero_de_registo_nacional)
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
	[F�rmaco_f�rmula]				VARCHAR(64)			NOT NULL,
	Farmaco_Farmac�utica_Nmr		INT					NOT NULL,
	Farm�cia_NIF					INT					NOT NULL,
	PRIMARY KEY([F�rmaco_f�rmula],Farmaco_Farmac�utica_Nmr,Farm�cia_NIF),
	FOREIGN KEY([F�rmaco_f�rmula],Farmaco_Farmac�utica_Nmr)	REFERENCES MED_FARMACO([F�rmula],Farmac�utica_Nmr),
	FOREIGN KEY(Farm�cia_NIF)								REFERENCES MED_FARMACIA(NIF)
);