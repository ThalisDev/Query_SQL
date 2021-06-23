CREATE PROCEDURE MasteroperationsFilme	  (@id           int,  
                                          @improriedade  int,  
                                          @tempo		 int,  
                                          @nome_diretor  varchar(50),  
                                          @nome_ator     varchar(50),
										  @genero		 varchar(50),
										  @nome_filme    varchar(50),
										  @origem_filme  varchar(50),
										  @NaEs	 int, --tipo 1 igual nacional, tipo 0 igual estrangeiro
                                          @StatementType NVARCHAR(20) = '')  
AS  
  BEGIN  
      IF @StatementType = 'Insert'  
        BEGIN

			SET IDENTITY_INSERT filmes ON
            INSERT INTO filmes (filme_id, impropriedade, tempo)

						 VALUES( @id,  
                         @improriedade,  
                         @tempo)

		   SET IDENTITY_INSERT diretores ON
		   INSERT INTO diretores(diretor_id, nome_diretor)

						 VALUES( @id,
						 @nome_diretor)

		   SET IDENTITY_INSERT atores ON
		   INSERT INTO atores(ator_id, nome_ator)

						 VALUES( @id,  
						@nome_ator)

		   SET IDENTITY_INSERT generos ON
		   INSERT INTO generos(genero_id,genero)

						 VALUES( @id,  
						@genero)

		 SET IDENTITY_INSERT nacionais ON
		 IF @NaEs = 1
			INSERT INTO nacionais (nacional_id, nome)
				VALUES (@id, @nome_filme)
		 ELSE
		    SET IDENTITY_INSERT estrangeiros ON
			INSERT INTO estrangeiros(estrangeiro_id, origem, nome)
				VALUES (@id, @origem_filme ,@nome_filme)
        END  
  
      IF @StatementType = 'Select'  
        BEGIN  
            SELECT *  
            FROM   filmes, diretores, atores, generos, nacionais, estrangeiros  
        END  
  
      IF @StatementType = 'Update'  
        BEGIN  
            UPDATE filmes  
            SET    impropriedade = @improriedade,  
                   tempo = @tempo
            WHERE  filme_id = @id  

            UPDATE diretores  
            SET    nome_diretor = @nome_diretor  
            WHERE  diretor_id = @id

            UPDATE atores  
            SET    nome_ator = @nome_ator  
            WHERE  ator_id = @id
			
            UPDATE generos  
            SET    genero = @genero
            WHERE  genero_id = @id
			
		    IF @NaEs = 1
				UPDATE nacionais  
				SET    nome = @nome_filme
				WHERE  nacional_id = @id

		    ELSE
				UPDATE estrangeiros 
				SET    nome = @genero,
					   origem = @origem_filme
				WHERE  estrangeiro_id = @id
        END 
		
      ELSE IF @StatementType = 'Delete'  
        BEGIN  
            DELETE FROM filmes  
            WHERE filme_id = @id
			
			DELETE FROM atores  
            WHERE ator_id = @id  

			DELETE FROM generos  
            WHERE genero_id = @id
			
            DELETE FROM estrangeiros  
            WHERE estrangeiro_id = @id
		
            DELETE FROM nacionais  
            WHERE nacional_id = @id

            DELETE FROM diretores  
            WHERE diretor_id = @id  			
        END  
  END 

-- Teste de execução
execute MasteroperationsFilme 3, 16, 160, 'robert', 'marcos', 'comedia', 'ora Pois', 'Portugal', 1, 'Delete'
go