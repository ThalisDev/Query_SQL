use cinemadb
go

-- 1 view filmes nacionais
create view v_filmes_nacionais
as
SELECT dbo.nacionais.nome, dbo.generos.genero, dbo.diretores.nome_diretor, dbo.atores.nome_ator, dbo.filmes.impropriedade, dbo.filmes.tempo
FROM     dbo.atores INNER JOIN
                  dbo.filmes ON dbo.atores.ator_id = dbo.filmes.filme_id INNER JOIN
                  dbo.diretores ON dbo.filmes.filme_id = dbo.diretores.diretor_id INNER JOIN
                  dbo.generos ON dbo.filmes.filme_id = dbo.generos.genero_id INNER JOIN
                  dbo.nacionais ON dbo.filmes.filme_id = dbo.nacionais.nacional_id
go

--teste view filmes nacionais
select * from v_filmes_nacionais
go

-- 2 view filmes internacionais
create view v_filmes_internacionais
as
SELECT dbo.estrangeiros.nome, dbo.estrangeiros.origem, dbo.generos.genero, dbo.diretores.nome_diretor, dbo.atores.nome_ator, dbo.filmes.tempo, dbo.filmes.impropriedade
FROM     dbo.atores INNER JOIN
                  dbo.filmes ON dbo.atores.ator_id = dbo.filmes.filme_id INNER JOIN
                  dbo.diretores ON dbo.filmes.filme_id = dbo.diretores.diretor_id INNER JOIN
                  dbo.estrangeiros ON dbo.filmes.filme_id = dbo.estrangeiros.estrangeiro_id INNER JOIN
                  dbo.generos ON dbo.filmes.filme_id = dbo.generos.genero_id
go

--teste view filmes internacionais
select * from v_filmes_internacionais
go

-- 3 view sessoes
create view v_sessoes
as
SELECT dbo.nacionais.nome AS nacional, dbo.estrangeiros.nome AS estrangeiro, dbo.estrangeiros.origem, dbo.cinemas.endereco, dbo.cinemas.filial, dbo.sessoes.horario, dbo.sessoes.valor, dbo.sessoes.vagas
FROM     dbo.cinemas INNER JOIN
                  dbo.sessoes ON dbo.cinemas.cinema_id = dbo.sessoes.cinemas_id CROSS JOIN
                  dbo.nacionais CROSS JOIN
                  dbo.estrangeiros
go

--teste view sessoes
select * from v_sessoes
go
