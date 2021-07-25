USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/17/2021
--Description: This stored procedure verifies that an AlbumID is valid and exists in the database
--Parameters: AlbumID
--Results: Error thrown if Album does not exist

CREATE OR ALTER PROC sp_check_if_album_exists
(
    @AlbumID INT
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ALBUMS WHERE AlbumID = @AlbumID)
        BEGIN  
            RAISERROR(50009,16,1,'Error')
            RETURN 
        END
END