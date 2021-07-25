USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure displays various reports of site data to site admins
--Parameters: InputValue (0- 9), 0 or no param will display info
--Results: A report is displayed to user depending on which input value was provided

CREATE OR ALTER PROCEDURE sp_view_data_reports
(
    @InputValue CHAR(2) = 0
)

AS 
BEGIN

    --Input of 0 or nothing will display report information
    IF @InputValue = 0
        BEGIN
            PRINT 'Enter a value 1-9:' + CHAR(13) +
            '1: Count of all active site users' + CHAR(13) + 
            '2: All users with Seller account' + CHAR(13) + 
            '3: All users with Collector accounts' + CHAR(13) +
            '4: Count of total transactions and sales' + CHAR(13) + 
            '5: Transaction count and sales for the current year' + CHAR(13) +
            '6: Display count of Album that is in the most User Collections' + CHAR(13) +
            '7: Display count of Album that is in the most User Wantlists' + CHAR(13) +
            '8: Display album and price that sold for the highest amount' + CHAR(13) +
            '9: Display sale counts for Albums sorted by most popular' + CHAR(13) +
            '10: Display the best selling album'
        END 

    --Display count of all site users
    IF @InputValue = 1
        BEGIN
            SELECT COUNT(UserID) AS 'Number of Active Users' FROM USERS
            WHERE ActiveFlag = 1
        END
    
    --Display all users with Seller account types
    IF @InputValue = 2
        BEGIN
            IF ((SELECT COUNT(*) FROM sellers)= 0)
                BEGIN
                    PRINT 'No active Sellers'
                END
            ELSE
                BEGIN
                    SELECT FirstName, LastName, DOB, Email, 'Seller' AS AccountType FROM sellers
                END
        END
    
    --Display all users with Collector account types
    IF @InputValue = 3
        BEGIN
            IF ((SELECT COUNT(*) FROM collectors)= 0)
                BEGIN
                    PRINT 'No active Collectors'
                END
            ELSE
                BEGIN
                    SELECT * FROM sellers
                END
        END

        --Display count of total transactions and total transaction sales since beginning
    IF @InputValue = 4
        BEGIN
            SELECT COUNT(TransID) AS 'Total Site Transactions',
            SUM(TransAmt) AS 'Total Transaction Sales' 
            FROM TRANSACTIONS
        END

    --Display transaction count and transaction sales for current year
    IF @InputValue = 5
        BEGIN
            SELECT COUNT(TransID) AS 'Year Total Transactions',
            SUM(TransAmt) AS 'Year Total Transaction Sales' 
            FROM TRANSACTIONS
            WHERE YEAR(TransDate) = YEAR(SYSDATETIME())
        END

    --Display count of Album that is in the most User Collections
    IF @InputValue = 6
        BEGIN
            SELECT c.AlbumID, a.ArtistName, a.AlbumName, a.Format, COUNT(c.AlbumID) AS CollectionCount
            FROM COLLECTIONS c
			JOIN ALBUMS a ON a.AlbumID = c.AlbumID
            GROUP BY c.AlbumID, a.ArtistName, a.AlbumName, a.Format
            HAVING COUNT(c.AlbumID) = 
                (SELECT MAX(CollectionCount) AS highest_total FROM
                    (SELECT AlbumID, COUNT(AlbumID) AS CollectionCount
                    FROM COLLECTIONS
                    GROUP BY AlbumID) AS t)
        END

    --Display count of Album that is in the most User Wantlists
    IF @InputValue = 7
        BEGIN 
            SELECT w.AlbumID,a.ArtistName, a.AlbumName, a.Format, COUNT(w.AlbumID) AS WantlistCount
            FROM WANTLISTS w
			JOIN ALBUMS a ON a.AlbumID = w.AlbumID
            GROUP BY w.AlbumID, a.AlbumName, a.ArtistName, a.Format 
            HAVING COUNT(w.AlbumID) = 
                (SELECT MAX(WantlistCount) AS highest_total FROM
                    (SELECT AlbumID, COUNT(AlbumID) AS WantlistCount
                    FROM WANTLISTS
                    GROUP BY AlbumID) AS t) 
        END
    
    --Display album and price that sold for the highest amount
    IF @InputValue = 8
        BEGIN
            SELECT TOP (1) WITH TIES
                a.ArtistName, 
                a.AlbumName, 
                a.Format,
                t.TransAmt AS HighestSale
            FROM TRANSACTIONS t JOIN
                COLLECTIONS c
                ON c.CollectionID = t.CollectionID JOIN
                ALBUMS a
                ON a.AlbumID = c.AlbumID
            ORDER BY t.TransAmt DESC
        END
    
    --Display sale counts for Albums sorted by most popular
    IF @InputValue = 9
        BEGIN
            SELECT
                a.ArtistName
                ,a.AlbumName
                ,COUNT(*) AS SaleCount
            FROM TRANSACTIONS t 
            JOIN COLLECTIONS c ON c.CollectionID = t.CollectionID
            JOIN ALBUMS a ON a.AlbumID = c.AlbumID
            GROUP BY a.AlbumName, a.ArtistName
            ORDER BY SaleCount DESC 
        END
    
    --Display the best selling album
    IF @InputValue = 10
        BEGIN
            SELECT TOP (1) WITH TIES 
                a.AlbumName, a.ArtistName, COUNT(*) AS SaleCount
            FROM TRANSACTIONS t 
            JOIN COLLECTIONS c ON c.CollectionID = t.CollectionID 
            JOIN ALBUMS a ON a.AlbumID = c.AlbumID
            GROUP BY a.AlbumName, a.ArtistName
			ORDER BY SaleCount DESC
        END
    
    IF @InputValue > 10
        BEGIN   
            PRINT 'Acceptable input is 1-10'
            RETURN
        END
END

--GRANT EXECUTE ON sp_view_data_reports TO site_admins