CREATE OR ALTER TRIGGER trg_remove_from_wantlist
ON COLLECTIONS
FOR UPDATE
AS
BEGIN

    IF UPDATE UserID
        BEGIN

            DECLARE 

                @NewUserID INT
                ,@OldUserID INT
                ,@CollectionID INT
                
                SELECT @NewUserID (SELECT UserID FROM inserted)
                SELECT @OldUserID (SELECT UserID FROM deleted)

                IF EXISTS (SELECT @NewUserID FROM WANTLISTS
                    WHERE Collection)


                
                    