SELECT * FROM handlebarhaven_dw.factsales;

--~~~ QUESTION 1 KEY CUSTOMERS: ALL TIME STATS~~~
SELECT
	dc.Customer_ID,
    dc.Customer_Name,
    dc.Store_ID,
    dc.Store_Name,
    dc.Segment,
    dc.Country_Name,
	SUM(units_sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Cost), 2) AS Total_Cost,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct,
	ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Cost)) * 100, 1) AS Markup_Pct
FROM  
    factsales fs
INNER JOIN
	dimcustomer dc
    ON fs.CustomerKey = dc.CustomerKey
GROUP BY  
	Customer_ID, Customer_Name, Store_ID, Store_Name, Segment, Country_Name
ORDER BY  
    Gross_Profit DESC;

-- QUESTION 1 KEY CUSTOMERS: STATS BY YEAR, MONTH, SEASON, QUARTER
SELECT
    dti.TimeKey AS Date,
    dti.Year,
    CASE
        WHEN dc.Country_Region_Code = 'AU' THEN dti.Season_South
        ELSE dti.Season_North
    END AS Season,
    dti.Quarter,
    dti.Month,
    dc.Customer_ID,
    dc.Customer_Name,
    dc.Store_ID,
    dc.Store_Name,
    dc.Segment,
    dc.Country_Name,
    SUM(fs.Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Cost), 2) AS Total_Cost,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Cost)) * 100, 1) AS Markup_Pct
FROM  
    FactSales fs
INNER JOIN
    DimCustomer dc ON fs.CustomerKey = dc.CustomerKey
INNER JOIN
    DimTime dti ON fs.TimeKey = dti.TimeKey
GROUP BY  
    Date, Year, Season, Quarter, Month, 
    Customer_ID, Customer_Name, Store_ID, Store_Name, Segment, Country_Name
ORDER BY  
    Year, Quarter, Month, Gross_Profit DESC;
    
    -- VALIDATION QUERY
    SELECT
    dti.Month,
    CASE
        WHEN dc.Country_Region_Code = 'AU' THEN dti.Season_South
        ELSE dti.Season_North
    END AS Season,
    dc.Country_Region_Code,
    SUM(fs.Line_Revenue) AS Total_Revenue
FROM FactSales fs
INNER JOIN DimCustomer dc ON fs.CustomerKey = dc.CustomerKey
INNER JOIN DimTime dti ON fs.TimeKey = dti.TimeKey
GROUP BY Month, Season, Country_Region_Code
ORDER BY Month;

-- ~~~QUESTION 2 & 5 PRODUCT & CATEGORY PROFITABILITY~~~
SELECT  
	dti.TimeKey AS Date,
    dti.Year,
    CASE
		WHEN dte.territory_name = 'Australia' THEN dti.season_south
		ELSE dti.season_north
    END AS Season,
    dti.Quarter,
    dti.Month,
	dp.product_name,
	dp.category_name,
    dp.subcategory_name,
    SUM(units_sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct
FROM  
    factsales fs
INNER JOIN
    dimproduct dp
    ON fs.productkey = dp.productkey
INNER JOIN
	dimtime dti
    ON fs.timekey = dti.timekey
INNER JOIN  
    dimterritory dte
    ON fs.territorykey = dte.territorykey
GROUP BY  
    Season, Quarter, Month, Year, Date,
    dp.product_name, dp.category_name, dp.subcategory_name
ORDER BY  
    Gross_Profit;
    
-- ALL TIME
SELECT  
	dp.product_name,
	dp.category_name,
    dp.subcategory_name,
    SUM(units_sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct
FROM  
    factsales fs
INNER JOIN
    dimproduct dp
    ON fs.productkey = dp.productkey
INNER JOIN  
    dimterritory dte
    ON fs.territorykey = dte.territorykey
GROUP BY  
    dp.product_name, dp.category_name, dp.subcategory_name
ORDER BY  
    Gross_Profit;

SELECT * FROM handlebarhaven_dw.dimterritory;

-- ~~~QUESTION 3 SALES TERRITORY PROFITABILITY~~~
SELECT
--     dti.TimeKey AS Date,
--     dti.Year,
--     dti.Month,
    dte.Territory_ID,
    dte.Territory_Name,
    dte.Country,
    dte.Salesperson_ID,
    SUM(fs.Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct
FROM  
    FactSales fs
INNER JOIN
    DimTime dti ON fs.TimeKey = dti.TimeKey
INNER JOIN
    DimTerritory dte ON fs.TerritoryKey = dte.TerritoryKey
GROUP BY
--     Date, Year, Month, 
    dte.Salesperson_ID, dte.Territory_ID, dte.Territory_Name, dte.Country
ORDER BY  
--     Year, Quarter, Month, 
    Territory_ID ASC;
    
    -- VERYFIYING THAT 2024-Q2 HAS NORMAL NUMBER OF SALES ENTRIES..
SELECT
    dti.TimeKey AS Date,
    dti.Year,
    dti.Month,
    dte.Territory_ID,
    dte.Territory_Name,
    dte.Country,
    dte.Salesperson_ID,
    SUM(fs.Units_Sold) AS Total_Units_Sold,
    ROUND(SUM(fs.Line_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(fs.Line_Gross_Profit), 2) AS Gross_Profit,
    ROUND((SUM(fs.Line_Gross_Profit) / SUM(fs.Line_Revenue)) * 100, 1) AS Profit_Margin_Pct
FROM  
    FactSales fs
INNER JOIN
    DimTime dti ON fs.TimeKey = dti.TimeKey
INNER JOIN
    DimTerritory dte ON fs.TerritoryKey = dte.TerritoryKey
-- WHERE dti.TimeKey >= 20240401 -- 772 entries for Q2 2024
-- WHERE dti.TimeKey >= 20240101
-- AND dti.TimeKey <= 20240331 -- 782 entries for Q1 2024
-- WHERE dti.TimeKey >= 20231001
-- AND dti.TimeKey <= 20231231 -- 802 entries for Q4 2023
WHERE dti.TimeKey >= 20230701
AND dti.TimeKey <= 20230930 -- 790 entries for Q3 2023
GROUP BY
    Date, Year, Month, 
    dte.Salesperson_ID, dte.Territory_ID, dte.Territory_Name, dte.Country
ORDER BY  
    Year, Quarter, Month, 
    Territory_ID ASC;
