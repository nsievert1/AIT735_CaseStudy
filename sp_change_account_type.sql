USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure changes the Account Type of a User
--Parameters: UserID, AccountType
--Results: User Account Type is changed

CREATE OR ALTER PROCEDURE sp_change_account_type
(
    @UserID INT,
    @AccountType VARCHAR(20)
)
AS 
BEGIN

    BEGIN TRY 

        --Check if UserID is valid
        EXEC sp_check_if_user_exists @UserID;

        --Check if AccountType is valid
        IF NOT EXISTS (SELECT 1 FROM ACCOUNT_TYPES WHERE UPPER(AccountType) = UPPER(@AccountType))
            BEGIN
                RAISERROR(50001,16,1,'Error')
                RETURN
            END

        BEGIN TRAN

            SET NOCOUNT ON;
            UPDATE USERS
            SET AccountType = @AccountType
            WHERE UserID = @UserID

            PRINT 'Account Type changed to ' + @AccountType + ' for USER' + CAST(@UserID AS CHAR)
        
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