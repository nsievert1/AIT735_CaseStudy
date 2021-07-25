USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/17/2021
--Description: This stored procedure adds an Album to a User's Wantlist
--Parameters: UserID, AlbumID
--Results: Album added to the specified Users wantlist

CREATE OR ALTER PROCEDURE sp_add_to_wantlist
(
    @UserID INT
    ,@AlbumID INT
)
AS
BEGIN

    BEGIN TRY

        --Check that UserID and AlbumID are valid
        EXEC sp_check_if_user_exists @UserID;
        EXEC sp_check_if_album_exists @AlbumID;

        --Check if album is already in User's wantlist
        IF EXISTS (SELECT 1 FROM WANTLISTS WHERE UserID = @UserID
            AND AlbumID = @AlbumID)
            BEGIN
                RAISERROR(50028,16,1,'Error')
                RETURN
            END

    BEGIN TRAN

        INSERT INTO WANTLISTS (UserID, AlbumID, DateAdded)
        VALUES (@UserID, @AlbumID, GETDATE())

        PRINT 'Album successfully added to wantlist of User' + CAST(@UserID AS CHAR)

         IF @@ERROR <> 0 
            BEGIN 
                RAISERROR(50027,16,1,'Error')
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