USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure removes an album from a users wantlist
--Parameters: ListID, UserID
--Results: Album is removed from wantlist

CREATE OR ALTER PROCEDURE sp_remove_from_wantlist
(
    @ListID INT
    ,@UserID INT
)
AS
BEGIN

    BEGIN TRY 

        --Check that UserID exists
        EXEC sp_check_if_user_exists @UserID;

        --Validate ListID is associated with UserID
        IF NOT EXISTS (SELECT 1 FROM WANTLISTS WHERE ListID = @ListID
            AND UserID = @UserID)
            BEGIN
                RAISERROR(50029,16,1,'Error')
                RETURN
            END

    BEGIN TRAN

        SET NOCOUNT ON;
        DELETE FROM WANTLISTS WHERE ListID = @ListID
        PRINT 'Album successfully removed from wantlist of User' + CAST(@UserID AS CHAR)

         IF @@ERROR <> 0 
            BEGIN 
                RAISERROR(50030,16,1,'Error')
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