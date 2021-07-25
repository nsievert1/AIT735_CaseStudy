USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure adds an Album to a Users' collection
--Parameters: UserID, AlbumID, SaleIndicator, Price, Rating
--Results: Album added to the specified Users' collection

CREATE OR ALTER PROCEDURE sp_add_to_collection
(    
    @UserID INT
    ,@AlbumID INT
    ,@SaleIndicator CHAR
    ,@Price DECIMAL(6,2) = NULL
	,@Rating CHAR = NULL
)

AS
    --Ensure for sale albums have a price set
    IF @SaleIndicator = 'Y' AND @Price IS NULL OR @Price <= 0
        BEGIN
            RAISERROR(50021,16,1,'Error')
            RETURN
        END
BEGIN

    BEGIN TRY

        --Check that User and Album exist
        EXEC sp_check_if_user_exists @UserID;
        EXEC sp_check_if_album_exists @AlbumID;
    
        --Check if Album is already in Users collection
        IF EXISTS (SELECT 1 FROM COLLECTIONS WHERE UserID = @UserID AND AlbumID = @AlbumID)
            BEGIN
                RAISERROR(50015,16,1,'Error')
                RETURN 
            END
    
    BEGIN TRAN

        INSERT INTO COLLECTIONS (UserID, AlbumID, SaleIndicator, Price, Rating, DateAdded)
        VALUES (@UserID, @AlbumID, @SaleIndicator, @Price, @Rating, GETDATE())

        PRINT 'Album successfully added to collection of User' + CAST(@UserID AS CHAR)

	COMMIT TRAN

        IF @@ERROR <> 0 
            BEGIN 
                RAISERROR(50014,16,1,'Error')
                ROLLBACK TRAN
                RETURN
            END
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
    END CATCH;  

END