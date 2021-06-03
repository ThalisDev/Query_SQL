use ConsultasSQL

select * from aproveitamentos

update aproveitamentos set apr_ano = 2020

-- Join --
-- 1. --
Select d.dis_nome   Disciplina, ap.alu_rm    Aluno,
       ap.apr_ano   Ano,		ap.apr_sem   Semestre,
	   ap.apr_nota  Nota,       ap.apr_falta Faltas,
	   (1 - ap.apr_falta*1.0/d.dis_ch)*100   Frequencia
from aproveitamentos ap, disciplinas d
where ap.dis_codigo = d.dis_codigo


-- 2.--
Select d.dis_nome   Disciplina, ap.alu_rm    Aluno,
       ap.apr_ano   Ano,		ap.apr_sem   Semestre,
	   ap.apr_nota  Nota,       ap.apr_falta Faltas,
	   convert (decimal(5,2), (1 - ap.apr_falta*1.0/d.dis_ch)*100)   Frequencia
from aproveitamentos ap, disciplinas d
where ap.dis_codigo = d.dis_codigo

go
create view v_notas
as
	Select d.dis_nome   Disciplina, ap.alu_rm    Aluno,
		   ap.apr_ano   Ano,		ap.apr_sem   Semestre,
		   ap.apr_nota  Nota,       ap.apr_falta Faltas,
		   convert (decimal(5,2), (1 - ap.apr_falta*1.0/d.dis_ch)*100)   Frequencia
	from aproveitamentos ap, disciplinas d
	where ap.dis_codigo = d.dis_codigo

go

-- Teste --
select * from v_notas

select * from v_notas
where Aluno = 1

select * from v_notas
where Aluno = 2

select Disciplina, Ano,	Semestre, Nota, Faltas, Frequencia from v_notas
where Aluno = 2


-- 3. --

go
create view desempenho
as
	Select a.alu_nome  Aluno,   d.dis_nome  Disciplina, p.prf_nome    Professor,
		   ap.apr_ano  Ano,	    ap.apr_sem  Semestre,   ap.apr_nota   Nota,  
		   ap.apr_falta Faltas, (1 - ap.apr_falta*1.0/d.dis_ch)*100 Frequencia
	from alunos a, aproveitamentos ap, disciplinas d, professores p
	where 
		a.alu_rm = ap.alu_rm		 and
		ap.dis_codigo = d.dis_codigo and
		d.prf_codigo = p.prf_codigo
go

-- Teste -- 
select * from desempenho


-- Funções de agregação --

-- 4. --

select avg(ap.apr_nota)  Media_Nota,  avg(ap.apr_falta) Media_Falta, 
       max(ap.apr_nota)  Maior_Nota,  min(ap.apr_nota) Menor_Nota,
	   max(ap.apr_falta) Maior_Falta, min(ap.apr_falta) Menor_falta,
	   count(*) QTD, sum (ap.apr_nota)/count(*) Media2
from aproveitamentos ap

-- Media Geral
select avg(ap.apr_nota) Media_Geral
from aproveitamentos ap

-- Media do aluno do 1
select avg(ap.apr_nota) Media
from aproveitamentos ap
where alu_rm = 1

-- Media da disciplina 1
select avg(ap.apr_nota) Media, count(*) Qtd,
       max(ap.apr_nota) Maior
from aproveitamentos ap
where dis_codigo = 1

-- Media das notas dos alunos 1 or 3
select avg(ap.apr_nota) Media
from aproveitamentos ap
where alu_rm = 1 or alu_rm = 3

-- Media dos alunos aprovados (nota >= 6 e freq >= 75)

select avg(ap.apr_nota) Media 
from aproveitamentos ap, disciplinas d
where 
    ap.dis_codigo = d.dis_codigo and
	apr_nota >= 6 and
    (1 - ap.apr_falta*1.0/d.dis_ch)*100 >= 75
      

-- Media dos alunos reprovados (nota < 6 ou freq < 75)

select avg(ap.apr_nota) Media 
from aproveitamentos ap, disciplinas d
where 
    ap.dis_codigo = d.dis_codigo and
	(apr_nota < 6 or
    (1 - ap.apr_falta*1.0/d.dis_ch)*100 < 75)
      

-- Group by --

-- Duas premissas:
-- a) no select nunca terá um op relacional
-- b) no where  nunca terá uma função de agregação
-- c) todas as colunas da seleção (select) que estiver junto com uma função 
-- de agregação devem ser colocadas no group by


select alu_rm RM, avg(ap.apr_nota) Media
from aproveitamentos ap
group by alu_rm

select a.alu_rm RM, a.alu_nome Aluno, avg(ap.apr_nota) Media
from aproveitamentos ap, alunos a
where ap.alu_rm = a.alu_rm
group by a.alu_rm, a.alu_nome -- grupo de cada aluno

select dis_codigo, avg(ap.apr_nota) Media, count(*) Qtd, 
       max(ap.apr_nota) Maior_Nota, min(ap.apr_nota) Menor_Nota
from aproveitamentos ap
group by dis_codigo -- grupo de cada disciplina

select ap.apr_nota Nota, count(*) Qtd
from aproveitamentos ap
group by ap.apr_nota
order by
    Nota desc --asc, 

select * from aproveitamentos
order by alu_rm asc, dis_codigo desc

-- Having --

-- Media geral --
select avg(ap.apr_nota) Media_Geral
from aproveitamentos ap

-- Media do aluno 1 --
select avg(ap.apr_nota) Media
from aproveitamentos ap
where ap.alu_rm = 1

-- Media da disciplina 3 --
select avg(ap.apr_nota) Media
from aproveitamentos ap
where ap.dis_codigo = 3

-- Media dos alunos 1 or 3 (notas juntas)
select avg(ap.apr_nota) Media
from aproveitamentos ap
where ap.alu_rm in (1,3)

select alu_rm, avg(ap.apr_nota) Media
from aproveitamentos ap
where ap.alu_rm in (1,3)
group by alu_rm


-- Consultar a média de cada aluno. Apresente o rm e a média somente dos alunos
-- com média maior ou igual a 6.5
select alu_rm, avg(ap.apr_nota) Media
from aproveitamentos ap
group by alu_rm
having
   avg(ap.apr_nota) >= 6.5
order by 
    Media desc


-- Consultar a média de cada aluno. Apresente o rm e a média somente dos alunos
-- com média maior ou igual a 8.5. Considere somente as notas acima de 4.
-- Ordene a saída pela média em ordem descrecente.

select alu_rm, avg(ap.apr_nota) Media
from aproveitamentos ap
where ap.apr_nota > 4
group by alu_rm
having
   avg(ap.apr_nota) >= 8.5
order by 
    Media desc


-- Consultar a média de cada aluno. Apresente o rm e a média somente dos alunos
-- com média maior que 8.5. Considere somente aprovados.
-- Ordene a saída pela média em ordem descrecente.

select alu_rm, avg(ap.apr_nota) Media, count(*) QTD
from aproveitamentos ap, disciplinas d
where ap.apr_nota >= 6 and (1 - ap.apr_falta*1.0/d.dis_ch)*100 >= 75 and
      ap.dis_codigo = d.dis_codigo
group by alu_rm
having
   avg(ap.apr_nota) > 8.5
order by 
    Media desc


-- Consultar a media de cada aluno. Apresente: rm, nome e a media.
-- Ordene a saída pela média em ordem descrecente. 

select a.alu_rm RM, a.alu_nome Aluno, avg(ap.apr_nota) Media
from alunos a, aproveitamentos ap, disciplinas d
where 
      a.alu_rm = ap.alu_rm    and
      ap.dis_codigo = d.dis_codigo
group by 
    a.alu_rm, a.alu_nome
order by Media desc



-- Consultar a media de cada aluno. Apresente: rm, nome e a media somente dos alunos com média
-- superior a 6. Ordene a saída pela média em ordem descrecente. 

select a.alu_rm RM, a.alu_nome Aluno, avg(ap.apr_nota) Media
from alunos a, aproveitamentos ap, disciplinas d
where 
      a.alu_rm = ap.alu_rm    and
      ap.dis_codigo = d.dis_codigo 
group by 
    a.alu_rm, a.alu_nome
having 
     avg(ap.apr_nota) > 6
order by Media desc



-- Consultar a media de cada aluno. Apresente: rm, nome e a media somente dos alunos com média
-- superior a 6. Considere somente as notas entre 4 e 8.
-- Ordene a saída pela média em ordem descrecente. 

select a.alu_rm RM, a.alu_nome Aluno, avg(ap.apr_nota) Media
from alunos a, aproveitamentos ap, disciplinas d
where 
      a.alu_rm      = ap.alu_rm    and
      ap.dis_codigo = d.dis_codigo and
	  ap.apr_nota between 4 and 8
group by 
    a.alu_rm, a.alu_nome
having 
     avg(ap.apr_nota) > 6
order by Media desc


-- Consulta a média de cada disciplina. Apresente o codigo da disciplina e a media. Considere
-- somente os alunos reprovados por nota.

select d.dis_codigo, avg(ap.apr_nota) Media
from aproveitamentos ap, disciplinas d
where ap.apr_nota < 6 and (1 - ap.apr_falta*1.0/d.dis_ch)*100 >= 75 and
      ap.dis_codigo = d.dis_codigo
group by d.dis_codigo




-- Join, left join, full join, right join, inner join --

select * 
from aproveitamentos ap, disciplinas d
where ap.dis_codigo = d.dis_codigo

select * 
from aproveitamentos ap inner join disciplinas d 
on ap.dis_codigo = d.dis_codigo


