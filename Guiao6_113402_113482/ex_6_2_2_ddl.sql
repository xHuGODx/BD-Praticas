IF OBJECT_ID('GestStocksITEM', 'U') IS NOT NULL
    DROP TABLE ITEM

IF OBJECT_ID('GestStocksENCOMENDA', 'U') IS NOT NULL
    DROP TABLE ENCOMENDA

IF OBJECT_ID('GestStocksFORNECEDOR', 'U') IS NOT NULL
    DROP TABLE FORNECEDOR

IF OBJECT_ID('GestStocksTIPO_FORNECEDOR', 'U') IS NOT NULL
    DROP TABLE TIPO_FORNECEDOR

IF OBJECT_ID('GestStocksPRODUTO', 'U') IS NOT NULL
    DROP TABLE PRODUTO

CREATE TABLE GestStocksPRODUTO(
    Codigo      CHAR(5) NOT NULL,
    Nome        VARCHAR(30) NOT NULL,
    Preco       DECIMAL(3, 1),
    Iva         INT,
    Unidades    INT,

    PRIMARY KEY (Codigo)
);

CREATE TABLE GestStocksTIPO_FORNECEDOR(
    Codigo          CHAR(3) NOT NULL,
    Designacao      VARCHAR(30),

    PRIMARY KEY (Codigo)
);

CREATE TABLE GestStocksFORNECEDOR(
    Nif         CHAR(9) NOT NULL,
    Nome        VARCHAR(15) NOT NULL,
    Fax         CHAR(9),
    Endereco    VARCHAR(30),
    CondPag     INT,
    Tipo        CHAR(3) NOT NULL,

    PRIMARY KEY (Nif),
    FOREIGN KEY (Tipo) REFERENCES TIPO_FORNECEDOR(Codigo)
);

CREATE TABLE GestStocksENCOMENDA(
    Numero         INT NOT NULL,
    [Data]          DATE NOT NULL,
    Fornecedor      CHAR(9) NOT NULL,

    PRIMARY KEY (Numero),
    FOREIGN KEY (Fornecedor) REFERENCES FORNECEDOR(Nif)
);

CREATE TABLE GestStocksITEM(
    numEnc      INT NOT NULL,
    codProd     CHAR(5) NOT NULL,
    Unidades    INT,

    PRIMARY KEY (numEnc, codProd),
    FOREIGN KEY (numEnc) REFERENCES ENCOMENDA(Numero),
    FOREIGN KEY (codProd) REFERENCES PRODUTO(Codigo)
);