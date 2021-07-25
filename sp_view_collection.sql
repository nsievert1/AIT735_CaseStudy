USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/17/2021
--Description: This stored procedure displays a Users' COLLECTION given a valid UserID
--Parameters: UserID
--Results: Collection is displayed with data joined from ALBUMS and COLLECTIONS table

CREATE OR ALTER PROCEDURE [dbo].[sp_view_collection]
(
    @UserID INT
)
AS
BEGIN
    
    BEGIN TRY

        --Check if UserID exists
        EXEC sp_check_if_user_exists @UserID;
    
        --Check that User has albums added to their collection
        IF NOT EXISTS (SELECT 1 FROM COLLECTIONS WHERE UserID = @UserID)
            BEGIN 
                RAISERROR(50004,16,1,'Error')
                RETURN
            END

            SELECT
                a.ArtistName AS 'Artist Name'
                ,a.AlbumName AS 'Album Name'
                ,a.RecordLabel AS 'Record Label'
                ,a.ReleaseYear AS 'Release Year'
                ,a.Genre AS 'Genre'
                ,a.Format AS 'Album Format'
                ,c.SaleIndicator AS 'Sale Indicator'
                ,c.Price AS 'Price'
                ,c.Rating AS 'Rating'
                ,c.DateAdded AS 'Date Added to Collection'
            FROM COLLECTIONS c 
            JOIN ALBUMS a ON a.AlbumID = c.AlbumID
            WHERE c.UserID = @UserID
            ORDER BY a.ArtistName

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
    END CATCH;  
END