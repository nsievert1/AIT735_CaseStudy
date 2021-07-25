USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure allows users to view their transactional history
--Parameters: UserID
--Results: All past transactions shown for provided UserID

CREATE OR ALTER PROCEDURE sp_view_transactional_history
(
    @UserID INT
)

AS BEGIN

    BEGIN TRY
        --Check that UserID exists
        EXEC sp_check_if_user_exists @UserID;

        --Check that User has at least one transaction 
        IF NOT EXISTS (SELECT 1 FROM TRANSACTIONS WHERE 
            BuyerID = @UserID OR SellerID = @UserID)
            BEGIN
                RAISERROR(50025,16,1,'Error')
                RETURN
            END
        
        SELECT
			t.BuyerID
			,t.SellerID
            ,t.TransDate AS 'Transaction Date'
            ,t.TransAmt AS 'Transaction Amount'
			,a.ArtistName AS 'Artist Name'
			,a.AlbumName AS 'Album Name'
			,a.Format AS 'Album Format'
        FROM TRANSACTIONS t 
        JOIN COLLECTIONS c ON c.CollectionID = t.CollectionID
        JOIN ALBUMS a ON  a.AlbumID = c.AlbumID
        WHERE t.BuyerID = @UserID OR t.SellerID = @UserID
        ORDER BY TransDate

    END TRY
    BEGIN CATCH
        SELECT  
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  

    END CATCH
END