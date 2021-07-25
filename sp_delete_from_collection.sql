USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Description: This stored procedure deletes an Album from a User's Collection
--Parameters: UserID, CollectionID
--Results: Album deleted from a User's collection

CREATE OR ALTER PROCEDURE [dbo].[sp_delete_from_collection]
(
    @UserID INT
    ,@CollectionID INT
)
AS
BEGIN

    BEGIN TRY
    --Check UserID exists
    EXEC sp_check_if_user_exists @UserID;
    
    --Check that CollectionID exists
    IF NOT EXISTS (SELECT 1 FROM COLLECTIONS WHERE CollectionID = @CollectionID)
        BEGIN
            RAISERROR(50022,16,1,'Error')
            RETURN
        END

    --Check that CollectionID is associated with UserID
    IF NOT EXISTS (SELECT 1 FROM COLLECTIONS WHERE UserID = @UserID
        AND CollectionID = @CollectionID)
        BEGIN
            RAISERROR(50019,16,1,'Error')
            RETURN
        END

    BEGIN TRAN
        SET NOCOUNT ON;
        DELETE FROM COLLECTIONS
        WHERE UserID = @UserID 
        AND CollectionID = @CollectionID

        PRINT 'Album successfully removed from collection'

        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
            END
    COMMIT TRANSACTION
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