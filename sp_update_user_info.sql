USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/20/21
--Description: This stored procedure updates a Users' address, email and/or phone number given a valid UserID. Pass null for values you don't wish to update.
--Parameters: UserID, new_address, new_city, new_state, new_postalcode, new_email, new_phone
--Results: One or more pieces of User information will be updated in the database

CREATE OR ALTER PROCEDURE [dbo].[sp_update_user_info]
(
    @UserID INT
    ,@new_address VARCHAR(50) = NULL
    ,@new_city VARCHAR(30) = NULL
    ,@new_state CHAR(20) = NULL
    ,@new_postalCode CHAR(5) = NULL
    ,@new_email VARCHAR(320) = NULL
    ,@new_phone VARCHAR(10)= NULL
)
AS
BEGIN

    BEGIN TRY

        --Check that UserID exists
        EXEC sp_check_if_user_exists @UserID;

        BEGIN TRAN

            SET NOCOUNT ON;
            UPDATE USERS
            SET 
                StreetAddress = ISNULL(@new_address, StreetAddress), 
                City = ISNULL(@new_city, City), 
                [State] = ISNULL(@new_state, [State]),
                PostalCode = ISNULL(@new_postalCode, PostalCode),
                Email = ISNULL(@new_email, Email),
                PhoneNumber = ISNULL(@new_phone, PhoneNumber)
            WHERE UserID = @UserID AND (@new_address IS NOT NULL OR @new_city IS NOT NULL OR
                @new_state IS NOT NULL OR @new_postalCode IS NOT NULL OR @new_email IS NOT NULL OR 
                @new_phone IS NOT NULL)
            
            PRINT 'User information updated'

            IF @@ERROR <> 0
                BEGIN
                    RAISERROR(50037,16,1,'Error')
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