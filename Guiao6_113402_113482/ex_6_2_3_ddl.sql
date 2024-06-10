IF OBJECT_ID('Prescricao_presc_farmaco', 'U') IS NOT NULL
    DROP TABLE Prescricao_presc_farmaco;

IF OBJECT_ID('Prescricao_Prescricao', 'U') IS NOT NULL
    DROP TABLE Prescricao_Prescricao;

IF OBJECT_ID('Prescricao_farmaco', 'U') IS NOT NULL
    DROP TABLE Prescricao_farmaco;

IF OBJECT_ID('Prescricao_farmaceutica', 'U') IS NOT NULL
    DROP TABLE Prescricao_farmaceutica;

IF OBJECT_ID('Prescricao_farmacia', 'U') IS NOT NULL
    DROP TABLE Prescricao_farmacia;

IF OBJECT_ID('Prescricao_paciente', 'U') IS NOT NULL
    DROP TABLE Prescricao_paciente;

IF OBJECT_ID('Prescricao_medico', 'U') IS NOT NULL
    DROP TABLE Prescricao_medico;

CREATE TABLE Prescricao_medico(
    numSNS              INT         PRIMARY KEY NOT NULL,
    nome                VARCHAR(60) NOT NULL,
    especialidade       VARCHAR(60),                      
);

CREATE TABLE Prescricao_paciente(
    numUtente           INT         PRIMARY KEY NOT NULL,
    nome                VARCHAR(60) NOT NULL,
    dataNasc            DATE        NOT NULL,
    endereco            TEXT,
);

CREATE TABLE Prescricao_farmacia(
    nome                VARCHAR(60) PRIMARY KEY NOT NULL,
    telefone            INT         UNIQUE,
    endereco            TEXT,                      
);

CREATE TABLE Prescricao_farmaceutica(
    numReg              INT         PRIMARY KEY NOT NULL,
    nome                VARCHAR(60) UNIQUE,
    endereco            TEXT,                      
);

CREATE TABLE Prescricao_farmaco(
    numRegFarm          INT         NOT NULL REFERENCES Prescricao_farmaceutica(numReg)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    nome                VARCHAR(60) NOT NULL,
    formula             TEXT,                      
    PRIMARY KEY (numRegFarm, nome),
);

CREATE TABLE Prescricao_Prescricao(
    numPresc            INT         PRIMARY KEY NOT NULL,
    numUtente           INT         NOT NULL REFERENCES Prescricao_paciente(numUtente)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    numMedico           INT         NOT NULL REFERENCES Prescricao_medico(numSNS)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    farmacia            VARCHAR(60) REFERENCES Prescricao_farmacia(nome)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    dataProc            DATE,
);

CREATE TABLE Prescricao_presc_farmaco(
    numPresc            INT         NOT NULL REFERENCES Prescricao_Prescricao(numPresc)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    numRegFarm          INT         NOT NULL,
    nomeFarmaco         VARCHAR(60) NOT NULL,
    FOREIGN KEY (numRegFarm, nomeFarmaco) REFERENCES Prescricao_farmaco(numRegFarm, nome)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    PRIMARY KEY (numPresc, numRegFarm, nomeFarmaco),
);
