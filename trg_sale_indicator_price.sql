CREATE TRIGGER trg_sale_indicator_price
ON COLLECTIONS
FOR INSERT
AS
BEGIN      
        DECLARE @SaleIndicator CHAR,
                @Price DECIMAL(6,2)

        SELECT @SaleIndicator = (SELECT SaleIndicator FROM inserted)
        SELECT @Price = (SELECT Price FROM inserted)

        --Check required fields are set
        IF @SaleIndicator = 'Y' AND @Price = NULL
            BEGIN
                RAISERROR(50015,16,1,'Error')
                ROLLBACK TRAN
                RETURN
            END 
END