--1.1 Listar os nomes completos dos clientes atendidos pelo vendedor “Michael Blythe”.
SELECT cliente.primeironome||' '||cliente.nomedomeio||' ' ||cliente.sobrenome
FROM CLIENTE, PEDIDO,VENDEDOR 
WHERE cliente.codigo = pedido.codigocliente and vendedor.codigo=pedido.codigovendedor and vendedor.primeironome= 'Michael'
and vendedor.sobrenome='Blythe';

--1.2 Listar o número de clientes atendidos pelo vendedor “Jillian Carson”.
SELECT COUNT(*) 
FROM CLIENTE, PEDIDO,VENDEDOR 
WHERE cliente.codigo = pedido.codigocliente and vendedor.codigo=pedido.codigovendedor and vendedor.primeironome= 'Jillian'
and vendedor.sobrenome='Carson';


--1.3 Listar o código, nome e quantidade de entregas realizadas por cada transportadora.
SELECT transportadora.codigo, transportadora.nome, COUNT(pedido.codigotransportadora) as EntregasRealizadas
FROM PEDIDO, TRANSPORTADORA
WHERE pedido.codigotransportadora=transportadora.codigo and pedido.dtenvio is not NULL
group by  transportadora.nome, transportadora.codigo order by EntregasRealizadas;

--1.4 Listar o código, nome e preço do produto mais caro.
SELECT codigo ||' ' ||produto.nome||' '||produto.preco as Produto_Mais_Caro
FROM PRODUTO
WHERE produto.preco = (SELECT MAX(produto.preco) FROM produto);

--1.5 Listar o valor total de compras realizadas pela cliente “Jasmine E Clark”.
SELECT SUM(detalhespedido.quantidade * detalhespedido.precounitario )
FROM PEDIDO 
JOIN CLIENTE on cliente.codigo = pedido.codigocliente
JOIN DETALHESPEDIDO on detalhespedido.codigopedido = pedido.codigo
WHERE cliente.primeironome ='Jasmine' and cliente.nomedomeio = 'E' and cliente.sobrenome = 'Clark' ;

--1.6 Listar o código e o nome completo de todos os vendedores que não realizaram nenhuma venda.
Select vendedor.codigo, vendedor.primeironome, vendedor.nomedomeio, vendedor.sobrenome
From VENDEDOR
Where NOT EXISTS (Select *
From PEDIDO
Where pedido.codigovendedor = vendedor.codigo);

--1.7 Para os modelos de produtos que possuem descrição em mais de um idioma, listar o nome do modelo, a descrição e o idioma.

SELECT modelo.nome, descricao.descricao, idioma.nome AS Produtos_idiomas
FROM MODELO, DESCRICAO, IDIOMA
WHERE descricao.codigomodelo=modelo.codigo and descricao.siglaidioma=idioma.sigla and descricao.codigomodelo in
(SELECT descricao.codigomodelo FROM DESCRICAO GROUP BY descricao.codigomodelo HAVING COUNT(*)>1 );

--1.8 Para os clientes que já fizeram ao menos 15 pedidos, listar o nome completo e a quantidade de compras realizadas ordenada de forma decrescente.
Select cliente.primeironome,cliente.nomedomeio, cliente.sobrenome, COUNT(pedido.codigo) as Numero_Pedidos
From CLIENTE, PEDIDO
Where cliente.codigo = pedido.codigocliente
Group By cliente.primeironome,cliente.nomedomeio, cliente.sobrenome
Having COUNT(*) >= 15  ORDER BY Numero_Pedidos DESC;

--1.9 Para os clientes que compraram algum dos produtos da seguinte lista (“Road-250 Red, 58”, “Touring-1000 
-- Yellow, 50”, “Men s Bib-Shorts, S”), listar a data dos pedidos, os seus nomes, o endereço de entrega, o nome
--do produto e a quantidade comprada.
SELECT pedido.dtedido,cliente.primeironome,pedido.enderecoentrega, produto.nome, detalhespedido.quantidade
FROM CLIENTE
JOIN Pedido on cliente.codigo = pedido.codigocliente
JOIN DETALHESPEDIDO on detalhespedido.codigopedido = pedido.codigo
JOIN PRODUTO on produto.codigo = detalhespedido.codigoproduto
WHERE produto.nome = 'Road-250 Red, 58' OR produto.nome='Touring-1000 Yellow, 50' OR produto.nome ='Men s Bib-Shorts, S';

--1.10 Listar os produtos comprados (código, nome e preço) pelo cliente “Marshall M Shen” no ano de 2007.
SELECT produto.codigo, produto.nome, produto.preco
FROM CLIENTE
JOIN Pedido on cliente.codigo = pedido.codigocliente
JOIN DETALHESPEDIDO on detalhespedido.codigopedido = pedido.codigo
JOIN PRODUTO on produto.codigo = detalhespedido.codigoproduto
WHERE cliente.primeironome ='Marshall' and cliente.nomedomeio = 'M' and cliente.sobrenome = 'Shen' 
and EXTRACT(year FROM pedido.dtedido)= 2007 ;

--1.11 Listar o nome e o preço do produto mais comprado pela cliente “Jennifer Taylor”, e a quantidade de vezes em que foi comprado.

SELECT produto.nome, produto.preco, COUNT(produto.codigo) as Vezes_Comprado
FROM PRODUTO, DETALHESPEDIDO,  PEDIDO, CLIENTE 
where  produto.codigo = detalhespedido.codigoproduto and  
pedido.codigo = detalhespedido.codigopedido and cliente.codigo = pedido.codigocliente
and cliente.primeironome = 'Jennifer' and  cliente.sobrenome = 'Taylor'
group by produto.nome,produto.preco
having count(produto.codigo)=(select max(counting)
FROM (SELECT P.nome, P.preco,count(P.codigo) counting
FROM PRODUTO P, DETALHESPEDIDO D, PEDIDO PD, CLIENTE C
WHERE P.codigo = D.codigoproduto and PD.codigo = D.codigopedido and C.codigo = PD.codigocliente
and C.primeironome = 'Jennifer' and  C.sobrenome = 'Taylor'
group by P.nome,P.preco));

--1.12 Para os pedidos em que o endereço de fatura é diferente do endereço de entrega, listar o nome completo do
-- cliente que recebeu o pedido, mas não realizou o pedido.
SELECT cliente.primeironome, cliente.nomedomeio, cliente.sobrenome
FROM CLIENTE
JOIN clienteendereco on clienteendereco.codigocliente = cliente.codigo
JOIN endereco E1 on E1.id = clienteendereco.idendereco
JOIN PEDIDO on pedido.enderecoentrega = E1.id 
JOIN Endereco E2 on pedido.enderecofatura = E2.id
WHERE pedido.enderecoentrega <> pedido.enderecofatura ;


--1.13 Listar o nome completo, a quota definida e o total de vendas dos vendedores que atingiram sua quota de
-- vendas no primeiro bimestre (janeiro e fevereiro) de 2006.
SELECT vendedor.primeironome, vendedor.nomedomeio, vendedor.sobrenome, vendedor.quota
FROM vendedor, (SELECT vendedor.codigo cod, SUM(detalhespedido.quantidade*detalhespedido.precounitario) quota  
FROM detalhespedido  JOIN pedido on detalhespedido.codigopedido = pedido.codigo 
JOIN vendedor on vendedor.codigo = pedido.codigovendedor
WHERE EXTRACT (year FROM pedido.dtedido) = 2006 AND EXTRACT(MONTH FROM pedido.dtedido) BETWEEN 1 AND 6 GROUP BY vendedor.codigo) Dadosquota
WHERE Dadosquota.cod = vendedor.codigo AND vendedor.quota < = Dadosquota.quota;

--1.14 Para os clientes que compraram a mesma quantidade de produtos, listar seus nomes completos, o código
-- de seus pedidos e a quantidade de itens comprados.
SELECT Cliente.primeironome || NVL2(Cliente.nomedomeio,' ' || Cliente.nomedomeio, null) || ' ' || Cliente.sobrenome nome, Pedido.codigo, Detalhespedido.quantidade
FROM Detalhespedido 
JOIN Pedido on Detalhespedido.codigopedido = Pedido.codigo 
JOIN Cliente on Pedido.codigocliente = Cliente.codigo
WHERE Detalhespedido.quantidade in (SELECT De.quantidade FROM Detalhespedido De GROUP BY De.quantidade HAVING count(*)>1);

--1.15 Listar todos os clientes que também compraram todos os produtos comprados pelo cliente “Lucas B Ross”.
SELECT cliente.primeironome || NVL2(cliente.nomedomeio,' ' || cliente.nomedomeio, null) || ' ' || cliente.sobrenome nome
FROM DETALHESPEDIDO
JOIN PEDIDO on detalhespedido.codigopedido = pedido.codigo 
JOIN Produto  on produto.codigo = detalhespedido.codigoproduto 
JOIN Cliente on cliente.codigo = pedido.codigocliente
WHERE produto.codigo in
(SELECT produto.codigo FROM Detalhespedido 
JOIN Pedido on detalhespedido.codigopedido = pedido.codigo 
JOIN Produto on produto.codigo = detalhespedido.codigoproduto 
JOIN Cliente on cliente.codigo = pedido.codigocliente
WHERE cliente.primeironome = 'Lucas' AND cliente.nomedomeio = 'B' AND cliente.sobrenome = 'Ross')
GROUP BY cliente.primeironome, cliente.nomedomeio, cliente.sobrenome;

--SELECT * FROM PRODUTO WHERE  codigo = 'BK-R50B-52';
--SELECT * FROM DETALHESPEDIDO WHERE  codigoproduto = 'BK-R50B-52';