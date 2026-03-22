CREATE SCHEMA [Sales];
GO

-- ============================================
-- Create Fact Table
-- ============================================
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Fact_Sales'
      AND SCHEMA_NAME(schema_id) = 'Sales'
)
BEGIN
    CREATE TABLE Sales.Fact_Sales (
        CustomerID             VARCHAR(255) NOT NULL,
        ItemID                 VARCHAR(255) NOT NULL,
        SalesOrderNumber       VARCHAR(30),
        SalesOrderLineNumber   INT,
        OrderDate              DATE,
        Quantity               INT,
        TaxAmount              FLOAT,
        UnitPrice              FLOAT,
        [Year]                 INT,
        [Month]                INT
    );
END;

-- ============================================
-- Create Customer Dimension
-- ============================================
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Dim_Customer'
      AND SCHEMA_NAME(schema_id) = 'Sales'
)
BEGIN
    CREATE TABLE Sales.Dim_Customer (
        CustomerID     VARCHAR(255) NOT NULL,
        CustomerName   VARCHAR(255) NOT NULL,
        FirstName      VARCHAR(255) NOT NULL,
        LastName       VARCHAR(255) NOT NULL,
        EmailAddress   VARCHAR(255) NOT NULL
    );
END;

ALTER TABLE Sales.Dim_Customer
ADD CONSTRAINT PK_Dim_Customer
PRIMARY KEY NONCLUSTERED (CustomerID) NOT ENFORCED;
GO

-- ============================================
-- Create Item Dimension
-- ============================================
IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'Dim_Item'
      AND SCHEMA_NAME(schema_id) = 'Sales'
)
BEGIN
    CREATE TABLE Sales.Dim_Item (
        ItemID     VARCHAR(255) NOT NULL,
        ItemName   VARCHAR(255) NOT NULL
    );
END;

ALTER TABLE Sales.Dim_Item
ADD CONSTRAINT PK_Dim_Item
PRIMARY KEY NONCLUSTERED (ItemID) NOT ENFORCED;
GO