USE [AIT735]
GO
/****** Object:  Trigger [dbo].[trg_profile_change_log]    Script Date: 7/25/2021 5:19:18 PM ******/
--This trigger runs everytime there is an update to the USERS table 
--User data is stored in the User_Profile_Change_Log table 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER [dbo].[trg_profile_change_log]
ON [dbo].[USERS]
FOR UPDATE
AS
BEGIN

    IF (UPDATE (StreetAddress) OR UPDATE (City) OR UPDATE (State) OR UPDATE (PostalCode)
    OR UPDATE (Email) OR UPDATE (PhoneNumber)) 
    BEGIN
        DECLARE @old_address VARCHAR(30),
                @new_address VARCHAR(30),
                @old_city VARCHAR(30),
                @new_city VARCHAR(30),
                @old_state CHAR(2),
                @new_state CHAR(2),
                @old_postal_code CHAR(5),
                @new_postal_code CHAR(5),
                @old_email VARCHAR(320),
                @new_email VARCHAR(320),
                @old_phone VARCHAR(10),
                @new_phone VARCHAR(10),
                @userid INT,
                @UserFirstLastName VARCHAR(MAX)

        SELECT @old_address = (SELECT StreetAddress FROM deleted)
		SELECT @old_city = (SELECT City FROM deleted)
		SELECT @old_state = (SELECT State FROM deleted)
		SELECT @old_postal_code = (SELECT PostalCode FROM deleted)
        SELECT @old_email = (SELECT Email FROM deleted)
        SELECT @old_phone = (SELECT PhoneNumber FROM deleted)

        SELECT @new_address = (SELECT StreetAddress FROM inserted)
		SELECT @new_city = (SELECT City FROM inserted)
		SELECT @new_state = (SELECT State FROM inserted)
		SELECT @new_postal_code = (SELECT PostalCode FROM inserted)
        SELECT @new_email = (SELECT Email FROM inserted)
        SELECT @new_phone = (SELECT PhoneNumber FROM inserted)

        SELECT @userid = (SELECT UserID FROM inserted)
		SELECT @UserFirstLastName = ((SELECT CONCAT(FirstName, ' ', LastName) FROM USERS
                        WHERE UserID = @userid))
    
        INSERT INTO User_Profile_Change_Log VALUES(@userid, @UserFirstLastName, @old_address, @old_city, @old_state,
        @old_postal_code, @old_email, @old_phone, @new_address, @new_city, @new_state, @new_postal_code,
        @new_email, @new_phone, SUSER_NAME(), GETDATE())

        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
            END
    END
END