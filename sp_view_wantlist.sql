USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Description: This stored procedure displays a Users' WANTLIST given a valid UserID
--Parameters: UserID
--Results: Wantlist is displayed with data joined from ALBUMS and COLLECTIONS table

CREATE OR ALTER PROCEDURE [dbo].[sp_view_wantlist]
( 
    @UserID INT
)
AS
BEGIN
    BEGIN TRY
    --Validate UserID is valid
    EXEC sp_check_if_user_exists @UserID;

    --Validate the user has albums in their wantlist
    IF NOT EXISTS (SELECT 1 FROM WANTLISTS WHERE UserID = @UserID)
        BEGIN 
            RAISERROR(50006,16,1,'Error')
            RETURN
        END

    SELECT
        a.ArtistName,
        a.AlbumName,
        a.Format
    FROM WANTLISTS w 
    JOIN ALBUMS a ON a.AlbumID = w.AlbumID
    WHERE UserID = @UserID
    ORDER BY a.ArtistName
    
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