USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/17/2021
--Description: This stored procedure verifies that a User ID is valid and exists in the database
--Parameters: UserID
--Results: Error thrown if user does not exist

CREATE OR ALTER PROC sp_check_if_user_exists
(
    @UserID INT
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM USERS WHERE UserID = @UserID)
        BEGIN  
            RAISERROR(50013,16,1,'Error')
            RETURN 
        END
     IF NOT EXISTS (SELECT 1 FROM USERS WHERE UserID = @UserID and ActiveFlag = 1)
        BEGIN
            RAISERROR(50036,16,1,'Error')
            RETURN
        END
    RETURN
END