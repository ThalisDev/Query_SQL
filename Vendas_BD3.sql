create database Vendas_BD
go

use Vendas_BD
go


create table pessoas
(
	id		int				not	null	primary	key identity,
	nome	varchar(50)		not null,
	cpf		varchar(14)		not null	unique,
	status	int					null,
	check	(status in (1,2,3,4))
)
go

create table clientes
(
	pessoa_id	int				not null	primary key references pessoas,
	renda		decimal(10,2)	not null,
	credito     decimal(10,2)   not null,
	check       (renda   >= 500),
	check		(credito >= 100)
)
go

create table vendedores
(
	pessoa_id	int				not null	primary key references pessoas,
	salario		decimal(10,2)	not null,
	check		(salario >= 1000)
)
go

create table pedidos
(
	id			int				not null	primary key identity,
	data		datetime		not null,
	status		int,
	valor		decimal(10,2),
	cliente_id	int				not null references clientes,
	vendedor_id int				not null references vendedores,
	check		(status between 1 and 10),
	check       (valor >= 0)
)
go

create table produtos
(
	id			int				not null primary key identity,
	descricao	varchar(50)		not null,
	estoque		int				not null,
	valor		decimal(10,2)	not null,
	status		int,
	check (status >= 1 and status <= 5)
)
go

create table itens_pedidos
(
	pedido_id	int				not null references pedidos,
	produto_id  int				not null references produtos,
	qtd			int				not null,
	valor		decimal(10,2)   not null,
	primary key (pedido_id, produto_id) -- chave primária composta
)
go

----------------------------------------------------
-- DML --
----------------------------------------------------
-- DML: insert, update, select e delete --

insert into produtos values ('Lápis', 100, 1.5, 1)
insert into produtos(descricao, estoque, valor) values ('Caneta', 100, 2)
insert into produtos values 
('Caderno' , 100, 15,  1), 
('Borracha', 100, 3,   1), 
('Regua'   , 100, 5.5, 1)

update produtos set 
       estoque = 95, status = 2
where id = 2

select * from produtos where valor >= 5
select * from produtos where status = 2 or valor >= 5
select * from produtos where descricao = 'Caderno'
select * from produtos where descricao like '%a%'
select * from produtos where descricao like 'C%'
select * from produtos where descricao like '_a_e%'
select * from produtos where valor between 3 and 10 -- [3 10]
select * from produtos where valor >= 3 and valor <= 10
select descricao Produto, estoque 'Estoque Disponvível' from produtos
select descricao Produto, estoque [Estoque Disponvível] from produtos
select 58976.645/8326.65*pi() Resultado
select Sqrt(16) R
select upper(descricao) Produto from produtos
select p.*, p.estoque * p.valor Faturamento from produtos p

select count(*) Qtd from produtos

select avg(valor) Média_Preco, max(valor) Maior_Valor, min(valor) Menor_Valor, count(*) Qtd, 
       sum(estoque) Unidades, sum (estoque * valor) Total
from produtos

insert into produtos values ('Leite', 100, 5, 1)
delete from produtos where id = 6
select * from produtos where id in (1,3,5)
select * from produtos where id = 1 or id = 3 or id = 5

-----------------------------------------------------------------
insert into pessoas values ('Batman', '1010', 1)
insert into pessoas values ('Mulher Gato', '2020', 1)
insert into pessoas values ('Robin', '3030', 2)
insert into pessoas values ('Homem Aranha', '4040', 1)

insert into clientes values (2, 5000, 2000)
insert into clientes values (4, 4000, 1500)

insert into vendedores values (1, 1500)
insert into vendedores values (3, 1300)

select * from pessoas
select * from clientes   -- 2 e 4
select * from vendedores -- 1 e 3

insert into pedidos (data, cliente_id, vendedor_id) values (getdate(), 4, 1)
insert into pedidos (data, cliente_id, vendedor_id) values (getdate(), 4, 3)

select * from pedidos
select * from itens_pedidos
select * from produtos


-- N:N -- Pedido 1
insert into pedidos (data, cliente_id, vendedor_id) values (getdate(), 2, 1)

insert into itens_pedidos values (1, 4, 3, 3)
insert into itens_pedidos values (1, 5, 40, 5.3)
insert into itens_pedidos values (1, 1, 10, 1.5)

update produtos set estoque = estoque - 3  where id = 4
update produtos set estoque = estoque - 40 where id = 5 
update produtos set estoque = estoque - 10 where id = 1

-- N:N -- Pedido 2
insert into pedidos (data, cliente_id, vendedor_id) values (getdate(), 2, 3)

insert into itens_pedidos values (2, 3, 2, 15)
insert into itens_pedidos values (2, 4, 5, 3)

update produtos set estoque = estoque - 2 where id = 3
update produtos set estoque = estoque - 5 where id = 4

select sum(qtd * valor) from itens_pedidos where pedido_id = 1  -- 236
select sum(qtd * valor) from itens_pedidos where pedido_id = 2  -- 45

select * from pedidos
update pedidos set status = 2, valor = 236 where id = 1
update pedidos set status = 2, valor = 45 where id = 2

select * from pessoas
select * from clientes
select * from vendedores
select * from produtos
select * from pedidos
select * from itens_pedidos

/* ----------------------------------------------
16/03:
	- Procedures
	- Views
------------------------------------------------ */













