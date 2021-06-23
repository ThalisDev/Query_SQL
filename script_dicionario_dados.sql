use cinemadb
go

SELECT
   
  S.name as 'Schema',

  T.name as Tabela,

  C.name as Coluna,

  TY.name as Tipo,

  C.max_length as 'Tamanho M�ximo', -- Tamanho em bytes, para nvarchar normalmente se divide este valor por 2

  C.precision as 'Precis�o', -- Para tipos numeric e decimal (tamanho)

  C.scale as 'Escala' -- Para tipos numeric e decimal (n�meros ap�s a virgula)

FROM sys.columns C

INNER JOIN sys.tables T

  ON T.object_id = C.object_id

INNER JOIN sys.types TY

  ON TY.user_type_id = C.user_type_id

LEFT JOIN sys.schemas S
  
  on T.schema_id = S.schema_id