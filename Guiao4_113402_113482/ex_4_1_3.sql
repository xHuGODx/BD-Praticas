CREATE TABLE Stocks_TipoDeFornecedor(
	Codigo int NOT NULL,
	Designacao varchar(20) NOT NULL,
	PRIMARY KEY (Codigo),
);

CREATE TABLE Stocks_CondicoesDePagamento(
	Codigo int NOT NULL,
	Descricao varchar(100) NOT NULL,	
	Prazo varchar(10) NOT NULL,
	PRIMARY KEY (Codigo),
);

CREATE TABLE Stocks_Fornecedor(
	NIF int NOT NULL,
	Nome varchar(30) NOT NULL,
	Morada varchar(30) NOT NULL,
	Email varchar(20) NOT NULL,
	FAX varchar(30) NOT NULL,
	CodgioTipoFornecedor int NOT NULL,
	CodgioCondicoesPagamento int NOT NULL,

	PRIMARY KEY(NIF),
	FOREIGN KEY(CodgioTipoFornecedor) REFERENCES Stocks_TipoDeFornecedor (Codigo),
	FOREIGN KEY(CodgioCondicoesPagamento) REFERENCES Stocks_CondicoesDePagamento (Codigo),
);

CREATE TABLE Stocks_Encomenda (
	Numero int NOT NULL,
	DataE varchar(12) NOT NULL,
	FornecedorNIF int  NOT NULL,

	PRIMARY KEY(Numero),
	FOREIGN KEY(FornecedorNIF) REFERENCES Stocks_Fornecedor (NIF),
);

CREATE TABLE Stocks_Item(
	ID int NOT NULL,
	Quantidade int NOT NULL,
	Encomenda_num int NOT NULL,

	PRIMARY KEY(ID),
	FOREIGN KEY(Encomenda_num) REFERENCES  Stocks_Encomenda (Numero),
);

CREATE TABLE Stock_Produto(
	Codigo int NOT NULL,
	Nome varchar(20) NOT NULL,
	TaxaIVA int NOT NULL,
	Preco int NOT NULL,
	Quantidade int NOT NULL,
	ItemID int NOT NULL,

	PRIMARY KEY(Codigo),
	FOREIGN KEY(ItemID) REFERENCES Stocks_Item (ID),
);
