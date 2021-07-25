--This trigger runs everytime there is an update to the USERS table 
--User data is stored in the User_Profile_Change_Log table 

CREATE OR ALTER TRIGGER trg_archived_transactions
ON TRANSACTIONS
FOR DELETE
AS
BEGIN

    IF (DELETE (UserID))

    BEGIN   
        DECLARE
            @TransID INT
            ,@TransDate DATETIME
            ,@TransAmt DECIMAL(6,2)
            ,@BuyerID INT
            ,@SellerID INT
            ,@CollectionID INT

        SELECT @TransID = (SELECT TransID FROM deleted)
        SELECT @TransDate = (SELECT TransDate FROM deleted)
        SELECT @TransAmt = (SELECT TransAmt FROM deleted)
        SELECT @BuyerID = (SELECT BuyerID FROM deleted)
        SELECT @SellerID = (SELECT SellerID FROM deleted)
        SELECT @CollectionID = (SELECT CollectionID FROM deleted)

        INSERT INTO Archived_Transactions
        VALUES (@TransID, @TransDate, @TransAmt, @BuyerID, @SellerID,
            @CollectionID, GETDATE())
        
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
            END
    END
END