CREATE TABLE Cliente
(
Codigo decimal,
Tratamento VARCHAR(8),
Primeironome VARCHAR(50)NOT NULL,
Nomedomeio VARCHAR(50),
Sobrenome VARCHAR(50)NOT NULL,
Sufixo VARCHAR(10),
Senha VARCHAR(128) NOT NULL
);
ALTER TABLE Cliente ADD PRIMARY KEY (Codigo);
CREATE TABLE Endereco
(
Id decimal,
Logradouro  VARCHAR(60)NOT NULL,
Complemento VARCHAR(60),
Cidade VARCHAR(30)NOT NULL,
Estado VARCHAR(50)NOT NULL,
Pais VARCHAR(50)NOT NULL,
codigopostal VARCHAR(15)NOT NULL
);
ALTER TABLE Endereco ADD PRIMARY KEY (Id);

CREATE TABLE Clienteendereco
(
Codigocliente decimal,
Idenredeco decimal,
tipoendereco VARCHAR(50)
);
ALTER TABLE Clienteendereco ADD PRIMARY KEY (Codigocliente, Idenredeco);
ALTER TABLE Clienteendereco
ADD CONSTRAINT fk_Cliente
   FOREIGN KEY (Codigocliente)
   REFERENCES Cliente (Codigo);
   
ALTER TABLE Clienteendereco
ADD CONSTRAINT fk_Endereco
   FOREIGN KEY (Idenredeco)
   REFERENCES Endereco (Id);
   
CREATE TABLE Modelo
(
Codigo decimal,
Nome VARCHAR(50)NOT NULL
);
ALTER TABLE Modelo ADD PRIMARY KEY (Codigo);

CREATE TABLE Categoria
(
Codigo decimal,
Nome VARCHAR(50)NOT NULL,
categoriaprincipal decimal
);
ALTER TABLE Categoria ADD PRIMARY KEY (Codigo);
ALTER TABLE Categoria
ADD CONSTRAINT fk_Categoria
   FOREIGN KEY (categoriaprincipal)
   REFERENCES Categoria (Codigo);


CREATE TABLE Produto
(
Código VARCHAR(15),
Nome VARCHAR(50)NOT NULL,
Cor VARCHAR(15),
Custoproducao decimal NOT NULL,
Preco decimal NOT NULL,
Tamanho VARCHAR(5),
Peso decimal,
Codigomodelo decimal,
Codigocategoria decimal,
Dtiniciovenda TIMESTAMP,
dtfimvenda TIMESTAMP
);
ALTER TABLE Produto ADD PRIMARY KEY (Código); 
   
ALTER TABLE Produto
ADD CONSTRAINT fk_Modelo 
   FOREIGN KEY (Codigomodelo)
   REFERENCES Modelo(Codigo); 
   
ALTER TABLE Produto
ADD CONSTRAINT fk_Categoria1
   FOREIGN KEY (Codigocategoria)
   REFERENCES Categoria (Codigo);
   
CREATE TABLE Vendedor
(
Código decimal,
Primeironome VARCHAR(50)NOT NULL,
Nomedomeio VARCHAR(50),
Sobrenome VARCHAR(50)NOT NULL,
Senha VARCHAR(128)NOT NULL,
Dtnascimento TIMESTAMP NOT NULL,
Dtcontratacao TIMESTAMP NOT NULL,
Sexo VARCHAR(1),
Quota decimal,
Bonus decimal,
Comissao decimal
);
ALTER TABLE Vendedor ADD PRIMARY KEY (Código); 

CREATE TABLE Transportadora
(
Codigo decimal PRIMARY KEY,
Nome VARCHAR(50)NOT NULL,
Taxabase decimal,
Taxaenvio decimal
);

CREATE TABLE Idioma
(
sigla VARCHAR(6),
Nome VARCHAR(50) NOT NULL
);
ALTER TABLE Idioma ADD PRIMARY KEY (sigla); 

CREATE TABLE Descricao
(
Codigo decimal,
Descricao VARCHAR(600),
Codigomodelo decimal,
siglaidioma VARCHAR(6)
);
ALTER TABLE Descricao ADD PRIMARY KEY (Codigo); 

ALTER TABLE Descricao --nome da tabela
ADD CONSTRAINT fk_Modelo1  -- nome do constraint
   FOREIGN KEY (Codigomodelo) --nome da key na tabela filha
   REFERENCES Modelo (Codigo); -- tabela pai e nome da key

ALTER TABLE Descricao 
ADD CONSTRAINT fk_Idioma
   FOREIGN KEY (siglaidioma)
   REFERENCES Idioma (sigla);
   
CREATE TABLE Pedido
(
Codigo decimal,
Dtedido TIMESTAMP NOT NULL,
Dtenvio TIMESTAMP,
Dtrecebimento TIMESTAMP,
Codigocliente decimal NOT NULL,
Contacliente VARCHAR(15),
Numerocartaocredito decimal,
Codigoconfirmacao VARCHAR(15),
Codigovendedor decimal,
Imposto decimal,
Enderecofatura decimal,
Enderecoentrega decimal,
codigotransportadora decimal
);

ALTER TABLE Pedido ADD PRIMARY KEY (Codigo); 

ALTER TABLE Pedido --nome da tabela
ADD CONSTRAINT fk_Vendedor  -- nome do constraint pai
   FOREIGN KEY (Codigovendedor) --nome da key na tabela filha
   REFERENCES Vendedor (Código); -- tabela pai e nome da key

ALTER TABLE Pedido 
ADD CONSTRAINT fk_Cliente1
   FOREIGN KEY (Codigocliente)
   REFERENCES Cliente (Codigo);

ALTER TABLE Pedido --nome da tabela
ADD CONSTRAINT fk_Transportadora  -- nome do constraint pai
   FOREIGN KEY (Codigotransportadora) --nome da key na tabela filha
   REFERENCES Transportadora (Codigo); -- tabela pai e nome da key

ALTER TABLE Pedido 
ADD CONSTRAINT fk_Endereco2
   FOREIGN KEY (Enderecofatura)
   REFERENCES Endereco(Id);
   
ALTER TABLE Pedido 
ADD CONSTRAINT fk_Endereco1
   FOREIGN KEY (Enderecoentrega)
   REFERENCES Endereco(Id);

CREATE TABLE Detalhespedido
(
Codigopedido decimal,
Codigoproduto VARCHAR(15),
Quantidade decimal NOT NULL,
Precounitario decimal NOT NULL,
desconto decimal
);
ALTER TABLE Detalhespedido ADD PRIMARY KEY (Codigopedido, Codigoproduto); 

ALTER TABLE Detalhespedido --nome da tabela
ADD CONSTRAINT fk_Pedido  -- nome do constraint pai
   FOREIGN KEY (Codigopedido) --nome da key na tabela filha
   REFERENCES Pedido (Codigo); -- tabela pai e nome da key

ALTER TABLE Detalhespedido 
ADD CONSTRAINT fk_Produto
   FOREIGN KEY (Codigoproduto)
   REFERENCES Produto (Código);
