USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/11/2021
--Description: This stored procedure exports 
--Parameters: 
--Results: 

CREATE OR ALTER PROCEDURE sp_export_collection_to_csv(
    @UserID INT
)
AS
BEGIN

    BEGIN TRAN

        DECLARE @UserID = 1
        INSERT INTO OPENROWSET ('Microsoft.ACE.OLEDB.12.0','Text;Database=D:\;FMT=Delimited','SELECT * FROM CollectionData.csv')
        SELECT * FROM COLLECTIONS WHERE UserID = @UserID

        IF @@ERROR <> 0 
            BEGIN 
               -- RAISERROR(50012,16,1,'Error')
                ROLLBACK TRAN
                RETURN
            END
    
    COMMIT TRAN

END
