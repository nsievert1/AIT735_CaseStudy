CREATE TABLE USERS(
    UserID INT NOT NULL IDENTITY,
    FirstName NVARCHAR(30) NOT NULL,
    MiddleName NVARCHAR(30),
    LastName NVARCHAR(50) NOT NULL,
    StreetAddress NVARCHAR(30) NOT NULL,
    City NVARCHAR(30) NOT NULL,
    State NCHAR(2),
    PostalCode NCHAR(5) NOT NULL,
    DOB DATE NOT NULL,
    Email NVARCHAR(320) NOT NULL,
    PhoneNumber NVARCHAR(10),
    AccountType NVARCHAR(20) NOT NULL DEFAULT 'COLLECTOR',
    ActiveFlag BIT NOT NULL DEFAULT 'Y',
    PRIMARY KEY (UserID),
    UNIQUE (Email, PhoneNumber),
    CONSTRAINT CHK_phone CHECK (PhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CHK_email CHECK (Email LIKE '%___@___%'),
    CONSTRAINT CHK_dob CHECK (DOB >= '1/1/1910' AND DOB <= GETDATE()),
    CONSTRAINT CHK_State CHECK ([State] LIKE '[A-Z][A-Z]'),
    CONSTRAINT CHK_PostalCode CHECK (PostalCode LIKE '[0-9][0-9][0-9][0-9][0-9]')

);

CREATE TABLE COLLECTIONS(
    CollectionID INT NOT NULL IDENTITY,
    UserID INT NOT NULL,
    AlbumID INT NOT NULL,
    SaleIndicator CHAR NOT NULL DEFAULT 'N',
    Price DECIMAL(6,2), 
    Rating CHAR,
    DateAdded DATETIME NOT NULL,
    PRIMARY KEY (CollectionID),
    FOREIGN KEY (UserID) REFERENCES USERS(UserID),
    FOREIGN KEY (AlbumID) REFERENCES ALBUMS(AlbumID),
    CONSTRAINT CHK_rating CHECK (Rating LIKE '[1-5]'),
    CONSTRAINT CHK_Price CHECK (Price > 0),
    CONSTRAINT CHK_Indicator CHECK (SaleIndicator IN ('Y', 'N'))

);

CREATE TABLE ALBUMS(
    AlbumID INT NOT NULL IDENTITY,
    ArtistName VARCHAR(50) NOT NULL,
    AlbumName VARCHAR(50) NOT NULL,
    RecordLabel VARCHAR(50),
    ReleaseYear CHAR(4) NOT NULL,
    Genre VARCHAR(20),
    Format VARCHAR(20) NOT NULL,
    PRIMARY KEY (AlbumID)
);

CREATE TABLE WANTLISTS(
    ListID INT NOT NULL IDENTITY,
    UserID INT NOT NULL,
    AlbumID INT NOT NULL,
    DateAdded DATETIME,
    PRIMARY KEY (ListID),
    FOREIGN KEY (UserID) REFERENCES USERS(UserID),
    FOREIGN KEY (AlbumID) REFERENCES ALBUMS(AlbumID)
);

CREATE TABLE TRANSACTIONS(
    TransID INT NOT NULL IDENTITY,
    TransDate DATETIME NOT NULL DEFAULT GETDATE(),
    TransAmt DECIMAL(6,2),
    BuyerID INT NOT NULL,
    SellerID INT NOT NULL,
    CollectionID INT NOT NULL,
    PRIMARY KEY (TransID),
    FOREIGN KEY (CollectionID) REFERENCES COLLECTIONS(CollectionID),
    FOREIGN KEY (BuyerID) REFERENCES USERS(UserID),
    FOREIGN KEY (SellerID) REFERENCES USERS(UserID)
); 

CREATE TABLE ACCOUNT_TYPES(
    AccountCode CHAR NOT NULL,
    AccountType VARCHAR(20) NOT NULL,
    PRIMARY KEY (AccountCode)
);

CREATE TABLE ALBUM_FORMATS(
    FormatCode CHAR(2) NOT NULL,
    Format VARCHAR(20) NOT NULL,
    PRIMARY KEY (FormatCode)
);

CREATE TABLE User_Profile_Change_Log(
    UserID INT,
    UserFirstLastName VARCHAR(MAX),
    PreviousAddress VARCHAR(30),
    PreviousCity VARCHAR(30),
    PreviousState CHAR(2),
    PreviousPostalCode CHAR(5),
    PreviousEmail VARCHAR(320),
    PreviousPhone VARCHAR(10),
    NewAddress VARCHAR(30),
    NewCity VARCHAR(30),
    NewState CHAR(2),
    NewPostalCode CHAR(5),
    NewEmail VARCHAR(320),
    NewPhone VARCHAR(10),
    Username VARCHAR(20),
    DateChanged DATETIME
);

CREATE TABLE GENRES(
    Genre VARCHAR(20)
);

CREATE TABLE Account_Deletion_Log(
    UserID INT,
    DateDeleted DATETIME,
    Username NVARCHAR(20),
    UserFirstLastName NVARCHAR(MAX),
    UserAddress NVARCHAR (30),
    UserCity NVARCHAR(30),
    UserState NCHAR(2),
    UserPostalCode NCHAR(5),
    UserDOB DATE,
    UserEmail NVARCHAR(320),
    UserPhone NVARCHAR(10),
    UserAccountType NVARCHAR(20),
    CompletedTransactions INT
)


CREATE TABLE Archived_Transactions(
    TransID INT
    ,TransDate DATETIME
    ,TransAmt DECIMAL(6,2)
    ,BuyerID INT
    ,SellerID INT
    ,CollectionID INT
    ,DateDeleted DATETIME
)