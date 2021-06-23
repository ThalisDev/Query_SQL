create database cinemadb
go

use cinemadb
go

create table cinemas(
	cinema_id				int				not null					primary key identity,
	endereco				varchar(100)	not null,
	filial					varchar(50)		not null
)
go

create table filmes(
	filme_id				int				not null					primary key identity,
	impropriedade			int				not null,
	tempo					int				not null
)
go

create table estrangeiros(
	estrangeiro_id			int				not null					primary key identity,
	origem					varchar(50)		not null,
	nome					varchar(80)		not null,
	FOREIGN KEY(estrangeiro_id)	REFERENCES filmes(filme_id)
)
go

create table nacionais(
	nacional_id				int				not null					primary key identity,
	nome					varchar(80)		not null,
	FOREIGN KEY(nacional_id)	REFERENCES filmes(filme_id)
)
go

create table sessoes(
	filmes_id				int				not null					references filmes(filme_id),
	cinemas_id				int				not null					references cinemas(cinema_id),
	horario					time			not null,
	valor					decimal(10,2)	not null,
	vagas					int				not null,
	primary key(filmes_id, cinemas_id)
)
go

create table atores(
	ator_id					int							not null		primary key identity,
	nome_ator				varchar(50)					not null,
	FOREIGN KEY(ator_id)	REFERENCES filmes(filme_id)
)
go

create table generos(
	genero_id				int							not null		primary key identity,
	genero					varchar(50)					not null,
	FOREIGN KEY(genero_id)	REFERENCES filmes(filme_id)
)
go

create table diretores(
	diretor_id				int							not null		primary key identity,
	nome_diretor			varchar(50)					not null,			
	foreign key(diretor_id)	references filmes(filme_id)
)
go
