USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/25/2021
--Description: This stored procedure handles user transactions to purchase/sell albums
--Parameters: BuyerID, SellerID, CollectionID
--Results: Album sale transaction is completed

CREATE OR ALTER PROCEDURE sp_user_transactions
(
    @BuyerID INT
    ,@SellerID INT
    ,@CollectionID INT
)

AS
BEGIN
    BEGIN TRY

        --Set Transaction Amount
        DECLARE @TransAmt Decimal(6,2) = (SELECT Price FROM COLLECTIONS
            WHERE CollectionID = @CollectionID)

        --Check if User IDs exist and are active
        EXEC sp_check_if_user_exists @BuyerID
        EXEC sp_check_if_user_exists @SellerID

        --Check that SellerID and BuyerID are not the same 
        IF @BuyerID = @SellerID 
            BEGIN   
                RAISERROR(50038,16,1,'Error')
                RETURN
            END

        --Check if album exists in Seller IDs collection 
        IF NOT EXISTS (SELECT 1 FROM COLLECTIONS
            WHERE UserID = @SellerID
            AND CollectionID = @CollectionID)
            BEGIN
                RAISERROR(50016,16,1,'Error')
                RETURN
            END
    
        --Check if sale indicator is 'Y'
        IF NOT EXISTS (SELECT 1 FROM COLLECTIONS
            WHERE @CollectionID = CollectionID AND SaleIndicator = 'Y')
            BEGIN
                RAISERROR(50017,16,1,'Error')
                RETURN
            END

        --Check price field set
        IF @TransAmt <= 0 OR @TransAmt IS NULL
            BEGIN
                RAISERROR(50024,16,1,'Error')
                RETURN
            END

    BEGIN TRAN

        SET NOCOUNT ON;
        INSERT INTO TRANSACTIONS
        VALUES(GETDATE(), @TransAmt, @BuyerID, @SellerID, @CollectionID)
        PRINT 'Transaction successful'

       	IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				PRINT 'Transaction is unsuccessful'
				RETURN
			END
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
    END CATCH;  

END