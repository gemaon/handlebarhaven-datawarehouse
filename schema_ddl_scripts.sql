CREATE TABLE [DimCustomer] (
    [CustomerKey] INT IDENTITY(1,1) PRIMARY KEY,
    [Customer_ID] SMALLINT,
    [Customer_Name] NVARCHAR(100),
    [Store_ID] SMALLINT,
    [Store_Name] NVARCHAR(100),
    [Segment] NVARCHAR(50),
    [Country_Region_Code] NVARCHAR(50),
    [Country_Name] NVARCHAR(50)
);

CREATE TABLE [DimSupplier] (
    [SupplierKey] INT IDENTITY(1,1) PRIMARY KEY,
    [Supplier_ID] INT NOT NULL,
    [Supplier_Name] NVARCHAR(100),
    [Address] NVARCHAR(200),
    [City] NVARCHAR(100),
    [Country] NVARCHAR(100)
);

CREATE TABLE [DimProduct] (
    [ProductKey] INT IDENTITY(1,1) PRIMARY KEY,
    [Product_ID] NVARCHAR(50),
    [Product_Name] NVARCHAR(50),
    [Category_ID] SMALLINT,
    [Category_Name] NVARCHAR(50),
    [Subcategory_ID] SMALLINT,
    [Subcategory_Name] NVARCHAR(50),
    [Standard_Cost] DECIMAL(19,4),
    [List_Price] DECIMAL(19,4)
);

CREATE TABLE [DimTime] (
    [TimeKey] INT PRIMARY KEY,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    [DayOfWeek_Num] INT,
    [DayOfWeek_Name] NVARCHAR(10),
    [Season_North] NVARCHAR(10),
    [Season_South] NVARCHAR(10)
);

CREATE TABLE [DimTerritory] (
    [TerritoryKey] INT IDENTITY(1,1) PRIMARY KEY,
    [Territory_ID] smallint,
    [Territory_Name] nvarchar(50),
    [Country] nvarchar(50),
    [Salesperson_ID] smallint
);

CREATE TABLE FactSales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    -- Foreign Keys
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    SupplierKey INT NOT NULL,
    TerritoryKey INT NOT NULL,
    TimeKey INT NOT NULL,
    -- Degenerate Dimensions
    Order_ID NVARCHAR(50) NOT NULL,
    Order_Line_ID SMALLINT NOT NULL,
    -- Unit Values
    Unit_Price DECIMAL(19,4) NOT NULL,
    Unit_Cost DECIMAL(19,4) NOT NULL,
    Unit_List_Price DECIMAL(19,4) NOT NULL,
    -- Additive Measures
    Units_Sold SMALLINT NOT NULL,
    Line_Revenue DECIMAL(19,4) NOT NULL,
    Line_Cost DECIMAL(19,4) NOT NULL,
    Line_Gross_Profit DECIMAL(19,4) NOT NULL
);
