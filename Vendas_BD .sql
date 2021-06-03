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


-- Cadastrar de Produto --
go
create procedure cadProd
(
	@descricao varchar(50), @estoque int, @valor decimal(10,2)
)
as
begin
    insert into produtos values (@descricao, @estoque, @valor, 1)
end
go

-- Teste --
exec cadProd 'Apontador', 1000, 3
go

exec cadProd 'Estojo', 50, 7
go
exec cadProd 'Bolsa', 10, 70
go

-- Cadastrar Cliente --

go
create procedure cadCli
(
	@nome varchar(50), @cpf varchar(14), @renda money
)
as
begin
	insert into pessoas  values (@nome, @cpf, 1)
	insert into clientes values (@@IDENTITY, @renda, @renda*0.25)
end
go

-- Teste --
exec cadCli 'Home de Ferro', '5555', 5000
go

-- Cadastrar Vendedor --

go	
create procedure cadVen
(
	@nome varchar(50), @cpf varchar(14), @salario money
)
as
begin
	insert into pessoas    values (@nome, @cpf, 1)  ---6 
	insert into vendedores values (@@IDENTITY, @salario)
end
go

-- Teste --
exec cadVen 'Super Foca', '6666', 1750
go


-- Cadastrar Pedido --
go
create procedure cadPed
(
	@cliente int, @vendedor int
)
as
begin
	insert into pedidos (data, cliente_id, vendedor_id) values (getDate(), @cliente, @vendedor)
end
go

-- Teste --
exec cadPed 2,1
go
exec cadPed 4,3
go

-- CadItem --
go
create procedure cadItem
(
	@pedido int, @produto int, @qtd int, @valor money
)
as
begin
	insert into itens_pedidos values (@pedido, @produto, @qtd, @valor)
end
go

-- Teste -- 
exec cadItem 5, 1, 2, 1.5
go
exec cadItem 5, 3, 5, 15
go
exec cadItem 5, 5, 10, 5.5
go

-------------------------------------------------------------
-- Procedures para autualização (updates)
-------------------------------------------------------------

go
create procedure baixarEstoque (@id int, @qtd_vendida int)
as
begin
    if @qtd_vendida > 0
		update produtos set estoque = estoque - @qtd_vendida
		where id = @id and estoque >= @qtd_vendida
end
go

-- Teste --
exec baixarEstoque 5, 3
go
exec baixarEstoque 5, -3000
go

-- Alteração do Cliente --

-- id, nome, cpf, status, renda
go
create procedure altCli
(
	@id int, @nome varchar(50), @cpf varchar(14), @status int, @renda money
)
as
begin
	update pessoas set nome = @nome, cpf = @cpf, status = @status
	where id = @id

	update clientes set renda = @renda, credito = @renda * 0.25
	where pessoa_id = @id
end
go

-- Teste --
exec altCli 5, 'Homem de Ferro', '5555', 1, 3000
go

-- Alteração de Pedido --

go
create procedure calcTotal (@pedido int)
as
begin
	declare @total money 
	set @total = (select sum (qtd * valor) from itens_pedidos
                  where pedido_id = @pedido)

    update pedidos set
	       status = 2,
		   valor = @total
	where id = @pedido    
end
go

-- Teste --
exec calcTotal 5
go

-- Alteração Item --
go
create procedure altItem (@pedido int, @produto int, @qtd int)
as
begin
	declare @preco money
	select @preco = valor from produtos where id = @produto

	update itens_pedidos set 
	         qtd = @qtd, valor = @preco
	where pedido_id = @pedido and produto_id = @produto

end
go
-- Teste --

exec altItem 2,3, 4
go
exec altItem 5,5,20
go

select * from pessoas
select * from clientes
select * from vendedores
select * from pedidos
select * from itens_pedidos

-------------------------
-- Alterar a procedure que insere o item: baixar o estoque, buscar preço do produto
-- Views
--------------------------
-- Novo projeto






