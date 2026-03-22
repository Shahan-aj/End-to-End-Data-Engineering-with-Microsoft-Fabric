CREATE PROCEDURE Sales.LoadDataFromStagingLakehouse (@OrderYear INT)
AS
BEGIN

    -- ============================================
    -- Load data into the Customer dimension table
    -- ============================================
    INSERT INTO Sales.Dim_Customer (
        CustomerID,
        CustomerName,
        FirstName,
        LastName,
        EmailAddress
    )
    SELECT DISTINCT
        CustomerName,
        CustomerName,
        FirstName,
        LastName,
        EmailAddress
    FROM Sales.staging_salesdata
    WHERE YEAR(OrderDate) = @OrderYear
      AND NOT EXISTS (
            SELECT 1
            FROM Sales.Dim_Customer dc
            WHERE dc.CustomerName = staging_salesdata.CustomerName
              AND dc.EmailAddress = staging_salesdata.EmailAddress
      );

    -- ============================================
    -- Load data into the Item dimension table
    -- ============================================
    INSERT INTO Sales.Dim_Item (
        ItemID,
        ItemName
    )
    SELECT DISTINCT
        Item,
        Item
    FROM Sales.staging_salesdata
    WHERE YEAR(OrderDate) = @OrderYear
      AND NOT EXISTS (
            SELECT 1
            FROM Sales.Dim_Item di
            WHERE di.ItemName = staging_salesdata.Item
      );

    -- ============================================
    -- Load data into the Sales fact table
    -- ============================================
    INSERT INTO Sales.Fact_Sales (
        CustomerID,
        ItemID,
        SalesOrderNumber,
        SalesOrderLineNumber,
        OrderDate,
        Quantity,
        TaxAmount,
        UnitPrice,
        [Year],
        [Month]
    )
    SELECT
        CustomerName,
        Item,
        SalesOrderNumber,
        CAST(SalesOrderLineNumber AS INT),
        CAST(OrderDate AS DATE),
        CAST(Quantity AS INT),
        CAST(TaxAmount AS FLOAT),
        CAST(UnitPrice AS FLOAT),
        [Year],
        [Month]
    FROM Sales.staging_salesdata
    WHERE YEAR(OrderDate) = @OrderYear;

END;