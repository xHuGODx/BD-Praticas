IF OBJECT_ID('aluguer_aluguer', 'U') IS NOT NULL
    DROP TABLE aluguer_aluguer

IF OBJECT_ID('aluguer_Veiculo', 'U') IS NOT NULL
    DROP TABLE aluguer_Veiculo

IF OBJECT_ID('aluguer_balcao', 'U') IS NOT NULL
    DROP TABLE aluguer_balcao

IF OBJECT_ID('aluguer_Cliente', 'U') IS NOT NULL
    DROP TABLE aluguer_Cliente

IF OBJECT_ID('aluguer_Similaridade', 'U') IS NOT NULL
    DROP TABLE aluguer_Similaridade

IF OBJECT_ID('aluguer_Pesado', 'U') IS NOT NULL
    DROP TABLE aluguer_Pesado

IF OBJECT_ID('aluguer_Ligeiro', 'U') IS NOT NULL
    DROP TABLE aluguer_Ligeiro

IF OBJECT_ID('aluguer_TipoVeiculo', 'U') IS NOT NULL
    DROP TABLE aluguer_TipoVeiculo
    
CREATE TABLE aluguer_TipoVeiculo(
    codigo int NOT NULL,
    tem_arcondicionado varchar(3) NOT NULL,
    designacao varchar(50) NOT NULL,

    PRIMARY KEY (codigo),
)

CREATE TABLE aluguer_Ligeiro(
    TV_codigo int NOT NULL,
    numlugares int NOT NULL,
    portas int NOT NULL,
    Combustivel varchar(10) NOT NULL,

    PRIMARY KEY (TV_codigo),
    FOREIGN KEY (TV_codigo) REFERENCES aluguer_TipoVeiculo(codigo),
)

CREATE TABLE aluguer_Pesado(
    TV_codigo int NOT NULL,
    peso int NOT NULL,
    passageiros int NOT NULL,

    PRIMARY KEY (TV_codigo),
    FOREIGN KEY (TV_codigo) REFERENCES aluguer_TipoVeiculo(codigo),
)

CREATE TABLE aluguer_Similaridade(
    TV_codigo1 int NOT NULL,
    TV_codigo2 int NOT NULL,

    PRIMARY KEY (TV_codigo1, TV_codigo2),
    FOREIGN KEY (TV_codigo1) REFERENCES aluguer_TipoVeiculo(codigo),
    FOREIGN KEY (TV_codigo2) REFERENCES aluguer_TipoVeiculo(codigo),
)

CREATE TABLE aluguer_Cliente(
    NIF int NOT NULL,
    numCarta int NOT NULL,
    endereco varchar(50) NOT NULL,
    nome varchar(50) NOT NULL,

    PRIMARY KEY (NIF),
)

CREATE TABLE aluguer_balcao(
    numero int NOT NULL,
    endereco varchar(50) NOT NULL,
    nome varchar(50) NOT NULL,

    PRIMARY KEY (numero),
)

CREATE TABLE aluguer_Veiculo(
    matricula varchar(10) NOT NULL,
    TV_codigo int NOT NULL,
    ano int NOT NULL,
    marca varchar(50) NOT NULL,

    PRIMARY KEY (matricula),
    FOREIGN KEY (TV_codigo) REFERENCES aluguer_TipoVeiculo(codigo),
)

CREATE TABLE aluguer_aluguer(
    numero int NOT NULL,
    [data] date NOT NULL,
    duracao int NOT NULL,
    veiculo_matricula varchar(10) NOT NULL,
    cliente_NIF int NOT NULL,
    balcao_numero int NOT NULL,

    PRIMARY KEY (numero),
    FOREIGN KEY (veiculo_matricula) REFERENCES aluguer_Veiculo(matricula),
    FOREIGN KEY (cliente_NIF) REFERENCES aluguer_Cliente(NIF),
    FOREIGN KEY (balcao_numero) REFERENCES aluguer_balcao(numero),
)