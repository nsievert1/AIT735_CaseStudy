USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure adds an Album to the database
--Parameters: ArtistName, AlbumName, RecordLabel, ReleaseYear, Genre, Format
--Results: Album added to the database after validation is satisified

CREATE OR ALTER PROCEDURE sp_add_album
(
    @ArtistName VARCHAR(50)
    ,@AlbumName VARCHAR(50)
    ,@RecordLabel VARCHAR(50)
    ,@ReleaseYear CHAR(4)
    ,@Genre VARCHAR(20)
    ,@Format VARCHAR(20)
)
AS
BEGIN 

    BEGIN TRY

        --Validate Album duplication 
        IF EXISTS (SELECT 1 FROM ALBUMS WHERE UPPER(ArtistName) = UPPER(@ArtistName)
            AND UPPER(AlbumName) = UPPER(@AlbumName) AND UPPER(Format) = UPPER(@Format))
            BEGIN  
                RAISERROR(50007,16,1,'Error')
                RETURN 
            END
    
        --Validate Format type
        IF NOT EXISTS (SELECT 1 FROM ALBUM_FORMATS WHERE UPPER(Format) = UPPER(@Format))
            BEGIN
                RAISERROR(50008,16,1,'Error')
                RETURN
            END

        --Validate Genre
        IF NOT EXISTS (SELECT 1 FROM Genres WHERE UPPER(Genre) = UPPER(@Genre))
            BEGIN
                RAISERROR(50026,16,1,'Error')
                RETURN
            END

        BEGIN TRAN
            INSERT INTO ALBUMS (ArtistName, AlbumName, RecordLabel, ReleaseYear, Genre, [Format])
            VALUES (@ArtistName, @AlbumName, @RecordLabel, @ReleaseYear, @Genre, @Format)
            PRINT 'Album successfully added'

        COMMIT TRAN
    END TRY

    BEGIN CATCH
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage; 

	    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
        
    END CATCH
END