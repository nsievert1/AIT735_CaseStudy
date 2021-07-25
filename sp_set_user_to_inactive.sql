USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/18/2021
--Description: This stored procedure sets a UserID to inactive state
--Parameters: UserID
--Results: User set to inactive in USERS table

CREATE OR ALTER PROCEDURE [dbo].[sp_set_user_to_inactive]
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

        --Check if User is already inactive 
        IF EXISTS (SELECT 1 FROM USERS WHERE UserID = @UserID AND ActiveFlag = 0)
            BEGIN
                RAISERROR(50033,16,1,'Error')
                RETURN
            END

    BEGIN TRAN

        UPDATE USERS
        SET ActiveFlag = 0
        WHERE UserID = @UserID

        PRINT 'User' + CAST(@UserID AS CHAR(2)) + ' is now set to inactive'

        IF @@ERROR <> 0
            BEGIN  
                RAISERROR(50005,16,1,'Error')
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