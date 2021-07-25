USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/14/21
--Description: This stored procedure adds a new User to the database
--Parameters: FirstName, MiddleName, LastName, StreetAddress, City, State, PostalCode, DOB, Email, PhoneNumber, AccountType
--Results: User will be added to the database after validation is successful

CREATE OR ALTER PROCEDURE sp_add_user
(
    @FirstName VARCHAR(30)
    ,@MiddleName VARCHAR(30)
    ,@LastName VARCHAR(50)
    ,@StreetAddress VARCHAR(30)
    ,@City VARCHAR(30)
    ,@State CHAR(2)
    ,@PostalCode CHAR(5)
    ,@DOB DATE
    ,@Email VARCHAR(320)
    ,@PhoneNumber VARCHAR(20)
    ,@AccountType VARCHAR(20)
    ,@ActiveFlag BIT = 1
)
AS 
BEGIN

    --Check that User does not already exist
    IF EXISTS (SELECT 1 FROM USERS WHERE UPPER(LastName) = UPPER(@LastName) AND
        DOB = @DOB AND UPPER(Email) = UPPER(@Email))
        BEGIN
            RAISERROR(50002,16,1,'Error')
            RETURN
        END

    --Validate Account Type is valid
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT_TYPES WHERE UPPER(AccountType) = UPPER(@AccountType))
        BEGIN 
            RAISERROR(50001,16,1,'Error')
            RETURN
        END

    BEGIN TRAN

        INSERT INTO USERS (FirstName, MiddleName, LastName, StreetAddress, City, [State], PostalCode,
        DOB,Email, PhoneNumber, AccountType, ActiveFlag)
        VALUES (@FirstName, @MiddleName, @LastName, @StreetAddress, @City, @State, @PostalCode,
        @DOB, @Email, @PhoneNumber, @AccountType, @ActiveFlag)
        PRINT 'User added successfully'

        IF @@ERROR <> 0 
            BEGIN 
                RAISERROR(50003,16,1,'Error')
                ROLLBACK TRAN
                RETURN
            END
    COMMIT TRAN
END