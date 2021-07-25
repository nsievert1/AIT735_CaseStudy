USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure updates entries in a Collection
--Parameters: CollectionID, SaleIndicator, Rating, Price
--Results: Entries updated for a given CollectionID

CREATE OR ALTER PROCEDURE sp_update_collection
(
    @CollectionID INT
    ,@SaleIndicator CHAR = 'N'
    ,@Price DECIMAL(6,2) = NULL
    ,@Rating CHAR = NULL    
)

AS
    --Check that if SaleIndicator is 'Y', a valid price is set
    IF @SaleIndicator = 'Y' AND @Price IS NULL OR @Price <= 0
        BEGIN
            RAISERROR(50021,16,1,'Error')
            RETURN
        END

BEGIN

    --Check that owner of CollectionID is a Seller if updating SaleIndicator to Y
    DECLARE @UserID INT= (SELECT UserID FROM COLLECTIONS
        WHERE CollectionID = @CollectionID)
    IF NOT EXISTS(SELECT 1 FROM USERS WHERE UserID = @UserID AND
        AccountType = 'SELLER') AND @SaleIndicator = 'Y'
        BEGIN
            RAISERROR(50032,16,1,'Error')
            RETURN
        END

    --Check that CollectionID is valid
    IF NOT EXISTS (SELECT 1 FROM COLLECTIONS WHERE CollectionID = @CollectionID)
        BEGIN
            RAISERROR(50022,16,1,'Error')
            RETURN
        END

    BEGIN TRAN

        SET NOCOUNT ON
        UPDATE COLLECTIONS
        SET SaleIndicator = @SaleIndicator
            ,Rating = @Rating
            ,Price = @Price 
        WHERE CollectionID = @CollectionID

        PRINT 'Collection' + CAST(@CollectionID AS CHAR(2)) + ' successfully updated'

        IF @@ERROR <> 0 
            BEGIN 
                RAISERROR(50023,16,1,'Error')
                ROLLBACK TRAN
                RETURN
            END
    COMMIT TRAN
END