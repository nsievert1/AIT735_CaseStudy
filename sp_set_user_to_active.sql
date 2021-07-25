USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/18/2021
--Description: This stored procedure sets a UserID to active state
--Parameters: UserID
--Results: User set to active in USERS table

CREATE OR ALTER PROCEDURE [dbo].[sp_set_user_to_active]
(
    @UserID INT
)
AS 
BEGIN

    BEGIN TRY

        --Check that UserID exists
        IF NOT EXISTS (SELECT 1 FROM USERS WHERE UserID = @UserID)
        BEGIN  
            RAISERROR(50013,16,1,'Error')
            RETURN 
        END

        --Check if User is already active 
        IF EXISTS (SELECT 1 FROM USERS WHERE UserID = @UserID AND ActiveFlag = 1)
            BEGIN
                RAISERROR(50034,16,1,'Error')
                RETURN
            END

    BEGIN TRAN

        UPDATE USERS
        SET ActiveFlag = 1
        WHERE UserID = @UserID

        PRINT 'User' + CAST(@UserID AS CHAR(2)) + ' is now set to active state'

        IF @@ERROR <> 0
            BEGIN  
                RAISERROR(50035,16,1,'Error')
                ROLLBACK TRAN
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

END CATCH
END