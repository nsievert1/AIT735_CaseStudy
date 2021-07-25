USE [AIT735]
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--Updated on: 07/05/2021
--Description: This stored procedure displays various reports of site data to site admins
--Parameters: InputValue (0- 5), 0 or no param will display info
--Results: A report is displayed to user depending on which input value was provided

CREATE OR ALTER PROCEDURE sp_test
(
    @InputValue CHAR = 0
)

AS 
BEGIN

    SELECT

        CASE @InputValue
        WHEN 1 THEN SELECT COUNT(UserID) AS 'Number of Users' FROM USERS
        WHEN 2 THEN SELECT * FROM sellers
        ELSE 'Input not valid'
        END
END


    --Input of 0 or nothing will display report information
    IF @InputValue = 0
        BEGIN
            PRINT 'Enter a value 1-5:' + CHAR(13) +
            '1: Count of all site users' + CHAR(13) + 
            '2: All users with Seller account' + CHAR(13) + 
            '3: All users with Collector accounts' + CHAR(13) +
            '4: Count of total transactions and sales' + CHAR(13) + 
            '5: Transaction count and sales for the current year' + CHAR(13) +
            '6: Display count of Album that is in the most User Collections' + CHAR(13) +
            '7: Display count of Album that is in the most User Wantlists'
        END

    --Display count of all site users
    IF @InputValue = 1
        BEGIN
            SELECT COUNT(UserID) AS 'Number of Users' FROM USERS
        END
    
    --Display all users with Seller account types
    IF @InputValue = 2
        BEGIN
            SELECT * FROM sellers
            --IF @@ROWCOUNT = 0 PRINT 'No Sellers'
        END
    
    --Display all users with Collector account types
    IF @InputValue = 3
        BEGIN
            SELECT * FROM collector
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
            SELECT AlbumID, COUNT(AlbumID) AS CollectionCount
            FROM COLLECTIONS
            GROUP BY AlbumID 
            HAVING COUNT(AlbumID) = 
                (SELECT MAX(CollectionCount) AS highest_total FROM
                    (SELECT AlbumID, COUNT(AlbumID) AS CollectionCount
                    FROM COLLECTIONS
                    GROUP BY AlbumID) AS t)
        END

    --Display count of Album that is in the most User Wantlists
    IF @InputValue = 7
        BEGIN 
            SELECT AlbumID, COUNT(AlbumID) AS WantlistCount
            FROM WANTLISTS
            GROUP BY AlbumID 
            HAVING COUNT(AlbumID) = 
                (SELECT MAX(WantlistCount) AS highest_total FROM
                    (SELECT AlbumID, COUNT(AlbumID) AS WantlistCount
                    FROM WANTLISTS
                    GROUP BY AlbumID) AS t) 

        END

    --Top selling album
    IF @InputValue = 7
        BEGIN
        
        END
    --Most expensive record


END

--GRANT EXECUTE ON sp_view_data_reports TO site_admins