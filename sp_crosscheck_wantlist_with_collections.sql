USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/20/2021
--Description: This stored procedure retrieves all albums that are listed for sale that are in a provided Users's wantlist
--Parameters: UserID
--Results: Show albums that are in User's wantlist that are listed for sale in Collections table. If no albums in wantlist are for sale, a message will display


CREATE OR ALTER PROCEDURE [dbo].[sp_crosscheck_wantlist_with_collections]
(
    @UserID INT  
)
AS
BEGIN

    BEGIN TRY
        --Check that User exists
        EXEC sp_check_if_user_exists @UserID;

        --Check that User has any items in their wantlist
        IF NOT EXISTS (SELECT 1 FROM WANTLISTS WHERE UserID = @UserID)
            BEGIN
                RAISERROR(50006,16,1,'Error')
                RETURN
            END

        BEGIN TRAN
            SET NOCOUNT ON
            DROP TABLE IF EXISTS #WantlistTemp
            SELECT AlbumID INTO #WantlistTemp FROM WANTLISTS WHERE UserID = @UserID

            IF EXISTS(SELECT 1 FROM #WantlistTemp t 
		        JOIN COLLECTIONS c ON t.AlbumID = c.AlbumID
                JOIN ALBUMS a ON a.AlbumID = c.AlbumID
		        WHERE SaleIndicator = 'Y') 
            SELECT 
			    c.UserID AS 'Seller'
                ,a.ArtistName AS 'Artist Name'
                ,a.AlbumName AS 'Album Name'
                ,c.Price AS 'Sale Price'
			    ,a.Format AS 'Album Format'
		    FROM COLLECTIONS c
		        JOIN #WantlistTemp t ON t.AlbumID = c.AlbumID
                JOIN ALBUMS a ON a.AlbumID = c.AlbumID
		        WHERE SaleIndicator = 'Y'
            ELSE
                RAISERROR(50039,16,1,'Error')
        DROP TABLE #WantlistTemp;
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