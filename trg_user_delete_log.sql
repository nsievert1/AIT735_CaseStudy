--This triggers run whenever a User is deleted. Their profile information and completed transaction count is stored n a log table

CREATE OR ALTER TRIGGER trg_user_delete_log
ON USERS
FOR DELETE
AS
BEGIN

        DECLARE
            @UserID INT
            ,@UserFirstLastName NVARCHAR(MAX)
            ,@UserAddress NVARCHAR (30)
            ,@UserCity NVARCHAR(30)
            ,@UserState NCHAR(2)
            ,@UserPostalCode NCHAR(5)
            ,@UserDOB DATE
            ,@UserEmail NVARCHAR(320)
            ,@UserPhone NVARCHAR(10)
            ,@UserAccountType NVARCHAR(20)
            ,@CompletedTransactions INT

        SELECT @UserID = (SELECT UserID FROM deleted)
		SELECT @UserFirstLastName = (SELECT CONCAT(FirstName, ' ', LastName) FROM deleted)
		SELECT @UserAddress = (SELECT UserAddress FROM deleted)
		SELECT @UserCity = (SELECT UserCity FROM deleted)
        SELECT @UserState = (SELECT UserState FROM deleted)
        SELECT @UserPostalCode = (SELECT UserPostalCode FROM deleted)
        SELECT @UserDOB = (SELECT UserDOB FROM deleted)
        SELECT @UserEmail = (SELECT UserEmail FROM deleted)
        SELECT @UserPhone = (SELECT UserPhone FROM deleted)
        SELECT @UserAccountType = (SELECT UserAccountType FROM deleted)
        SELECT @CompletedTransactions = (SELECT COUNT(TransID) FROM TRANSACTIONS
                                            WHERE BuyerID = @UserID OR SellerID = @UserID)

        INSERT INTO Account_Deletion_Log
        VALUES(@UserID, GETDATE(), SUSER_NAME(), @UserFirstLastName, @UserAddress, @UserCity, @UserState, @UserPostalCode,
        @UserDOB, @UserEmail, @UserPhone, @UserAccountType, @CompletedTransactions)

        IF @@ERROR <> 0 --OR @@ROWCOUNT > 1
            BEGIN
                ROLLBACK TRAN
            END
    END
END