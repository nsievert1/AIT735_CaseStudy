USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/14/21
--Description: This stored procedure updates the ALBUMS table with data from an Excel spreadsheet  
--Parameters: None but spreadsheet must be on root of D:\ drive and called Album_Data.xlsx
--Results: Albums from spreadsheet are added to the ALBUMS table after passing validation

CREATE OR ALTER PROCEDURE sp_bulk_album_upload
AS
BEGIN   
        SET NOCOUNT ON
        --Load data from Excel into a temp table
        DROP TABLE IF EXISTS dbo.#AlbumsTemp;
        SELECT * INTO #AlbumsTemp
        FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
            'Excel 12.0; Database=D:\\Album_Data.xlsx;
            HDR=YES; IMEX=1', 'SELECT * FROM [Sheet1$]')

        --Validate Album duplication 
        IF EXISTS(SELECT 1 FROM  #AlbumsTemp t
		        WHERE EXISTS (SELECT 1 
                FROM ALBUMS a
                WHERE a.AlbumName = t.AlbumName AND a.Format = t.Format))
            BEGIN
                RAISERROR(50031,16,1,'Error')
                DROP TABLE #AlbumsTemp
                RETURN
            END

        --Validate Format type
        IF EXISTS (SELECT [Format]
		FROM  #AlbumsTemp t
		WHERE NOT EXISTS (SELECT 1 
                   FROM   ALBUM_FORMATS f
				   WHERE LOWER(t.Format) = LOWER(f.Format)))
            BEGIN
                RAISERROR(50008,16,1,'Error')
                RETURN
            END

        --Validate Genre
        IF EXISTS (SELECT Genre
		FROM  #AlbumsTemp t
		WHERE NOT EXISTS (SELECT 1 
                   FROM   GENRES g
				   WHERE LOWER(t.Genre) = LOWER(g.Genre)))
            BEGIN
                RAISERROR(50026,16,1,'Error')
                RETURN
            END

        BEGIN TRAN
            
            --Insert data from Temp table into ALBUMS table
            INSERT INTO ALBUMS SELECT * FROM  #AlbumsTemp
            DROP TABLE #AlbumsTemp
            PRINT 'Album(s) successfully added'

            IF @@ERROR <> 0 
                BEGIN 
                    RAISERROR(50012,16,1,'Error')
                    ROLLBACK TRAN
                    RETURN
                END
        COMMIT TRAN
END