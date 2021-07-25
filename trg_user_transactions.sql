--This trigger runs every time data is inserted into TRANSACTIONS 
--The COLLECTIONS table is updated to reflect the transaction 
CREATE OR ALTER TRIGGER trg_user_transactions
ON TRANSACTIONS
FOR INSERT
AS
BEGIN
    DECLARE 
        @CollectionID INT
        ,@BuyerID INT
        ,@SellerID INT

    SELECT @CollectionID = (SELECT CollectionID FROM inserted)
    SELECT @BuyerID = (SELECT BuyerID FROM inserted)
    SELECT @SellerID = (SELECT SellerID FROM inserted)

    
    UPDATE COLLECTIONS
    SET UserID = @BuyerID, SaleIndicator = 'N', Price = NULL, 
    Rating = NULL, DateAdded = GETDATE()
    WHERE CollectionID = @CollectionID

    PRINT 'Album added to collection of User' + CAST(@BuyerID AS CHAR) 

    IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRAN
        END
END