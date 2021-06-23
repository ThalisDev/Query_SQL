use cinemadb
go

--insert filmes
insert into filmes values
(16, 128),
(12, 160)
go

--insert ator
insert into atores values
('irineu'),
('robert')
go

--insert diretor
insert into diretores values
('marcao'),
('dracula')
go

--insert nacionais
insert into nacionais values
('a rosa no cume bate')
go

--insert estrangeiros
insert into estrangeiros values
('USA' ,'fish one ball cat')
go

--insert generos
insert into generos values
('comedia'),
('drama')
go

--insert cinema
insert into cinemas values
('rua do oco', 'Alpha1'),
('rua do malandro', 'Alpha2')
go

--insert sessoes
INSERT INTO [dbo].[sessoes]
           ([filmes_id]
           ,[cinemas_id]
           ,[horario]
           ,[valor]
           ,[vagas])
     VALUES
           (1, 1, '12:00:00', 25.00, 60),
		   (2, 2, '14:30:00', 50.00, 30)
GO