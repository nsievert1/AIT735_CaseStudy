USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure retrieves all albums that are listed for sale given a valid Album ID
--Parameters: AlbumID
--Results: Only albums that have a sale indicator of Y will be displayed

CREATE OR ALTER PROCEDURE [dbo].[sp_check_for_sale_albums]
(
    @AlbumID INT
)
AS 
BEGIN

BEGIN TRY

    --Check if AlbumID exists
    EXEC sp_check_if_album_exists @AlbumID 
    
    --Check if Album is in any User Collections
    DECLARE @retVal INT
    SELECT @retVal = COUNT(*)
    FROM COLLECTIONS 
    WHERE AlbumID = @AlbumID

    IF (@retVal = 0)
        BEGIN 
            RAISERROR(50010,16,1,'Error')
            RETURN 
        END
    
    --Check if Album is listed for sale in any User collections
    SELECT @retVal = COUNT(*)
    FROM COLLECTIONS 
    WHERE AlbumID = @AlbumID AND SaleIndicator = 'Y'

    IF (@retVal = 0)
        BEGIN
            RAISERROR(50011,16,1,'Error')
            RETURN
        END

    BEGIN TRAN

        SELECT 
            c.UserID AS [User],
            a.ArtistName AS [Artist Name],
            a.AlbumName AS [Album Name],
            a.Format,
            c.SaleIndicator AS [Sale Indicator],
            c.Price
        FROM COLLECTIONS c 
        JOIN ALBUMS a ON a.AlbumID = c.AlbumID
        WHERE c.AlbumID = @AlbumID
        AND SaleIndicator = 'Y'
        ORDER BY c.Price
    
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
        ROLLBACK TRAN
END CATCH
END