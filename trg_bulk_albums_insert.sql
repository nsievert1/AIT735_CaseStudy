--This trigger runs when data is inserted into the ALBUMS table 
--
CREATE OR ALTER TRIGGER trg_bulk_album_insert
ON ALBUMS
FOR INSERT
AS
BEGIN
			DECLARE @AlbumName VARCHAR(50),
					@Format VARCHAR(20)


			SELECT @AlbumName = (SELECT AlbumName FROM inserted)
			SELECT @Format = (SELECT Format FROM inserted)

			IF EXISTS (SELECT TOP 1 COUNT(*)
			FROM ALBUMS
			WHERE UPPER(AlbumName) = UPPER(@AlbumName)
			AND UPPER(FORMAT) = UPPER(@Format))
				BEGIN
					RAISERROR(50007,16,1,'Error')
					ROLLBACK TRAN
				END

			IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRAN
				END
END


CREATE OR ALTER TRIGGER trg_bulk_album_insert
ON ALBUMS
FOR INSERT OR UPDATE
AS
BEGIN

			DECLARE --@ExistingAlbumName VARCHAR(50),
					@NewAlbumName VARCHAR(50),
					--@ExistingFormat VARCHAR(20),
					@NewFormat VARCHAR(20)

			--SELECT @ExistingAlbumName = (SELECT AlbumName FROM ALBUMS)
			SELECT @NewAlbumName = (SELECT AlbumName FROM inserted)
			--SELECT @ExistingFormat = (SELECT Format FROM ALBUMS)
			SELECT @NewFormat = (SELECT Format FROM inserted)

			WHILE (@NewAlbumName <> NULL)
			BEGIN
				SELECT @NewFormat = (SELECT Format FROM inserted WHERE AlbumName = @AlbumName)



END
