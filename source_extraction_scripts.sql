-- 1. DIMCUSTOMER SOURCE QUERY
SELECT  
    c.Customer_ID,
    c.First_Name,
    c.Last_Name,
    c.Store_ID,
    COALESCE(c.Store_Name, 'Unknown') AS Store_Name,
    c.Person_Type AS Segment,
    COALESCE(s.Country_Region_Code, 'Unknown') AS Country_Region_Code,
    COALESCE(crc.Country_Name, 'Unknown') AS Country_Name
FROM
    customers c 
LEFT JOIN
    customer_address ca
    ON c.Address_ID = ca.Address_ID
LEFT JOIN 
    state s 
    ON ca.State_Province_ID = s.State_ProvinceID
LEFT JOIN 
    country_region_codes crc
    ON s.Country_Region_Code = crc.Country_Code
ORDER BY c.Customer_ID ASC;

-- 2. DIMSUPPLIER SOURCE QUERY
SELECT	
	Supplier_ID,
	Supplier_Name,
	Address,
	City,
	Country
FROM suppliers

-- 3. DIMPRODUCT SOURCE QUERY
SELECT
    p.Product_ID,
    p.Supplier_ID,
	p.Product_Name,
	pc.product_cat_ID AS 'Category_ID',
	pc.cat_name AS 'Category_name',
	psc.product_subcategory_ID AS 'Subcategory_ID',
	psc.product_name AS 'Subcategory_name',
	p.Standard_Cost,
	p.List_Price
FROM
    products p
INNER JOIN	product_sub_category psc
	ON p.product_subcategory_ID = psc.product_subcategory_ID
INNER JOIN	product_categories pc
	ON psc.product_category_ID = pc.product_cat_ID;
    
-- 4. DIMTIME SOURCE QUERY
SELECT DISTINCT CAST(Order_Date AS DATE) AS Date
FROM sales_orders
WHERE Order_Date IS NOT NULL

-- 5. DIMTERRITORY SOURCE QUERY
SELECT 
    st.Territory_ID,
    st.Territory_Name,
    crc.Country_Name AS Country,
    sp.Sales_Person_ID AS Salesperson_ID
FROM sales_territory st
INNER JOIN country_region_codes crc
    ON st.Country_Region_Code = crc.Country_Code
LEFT JOIN sales_persons sp
    ON st.Territory_ID = sp.Territory_ID
ORDER BY Territory_ID;

-- 6. FACTSALES SOURCE QUERY
SELECT 
    so.Customer_ID,
    p.Product_ID,
    p.Supplier_ID,
    st.Territory_ID,
    CAST(DATE_FORMAT(so.Order_Date, '%Y%m%d') AS UNSIGNED) AS Order_Date_Updated,
    sod.Sales_Order_Number AS Order_ID,
    sod.Order_Line_ID,
    sod.Unit_Price,
    p.Standard_Cost AS Unit_Cost,
    p.List_Price AS Unit_List_Price,
    sod.Order_Qty AS Units_Sold,
    (p.Standard_Cost * sod.Order_Qty) AS Line_Cost,
    sod.Line_Total AS Line_Revenue,
    (sod.Unit_Price - p.Standard_Cost) * sod.Order_Qty AS Line_Gross_Profit
FROM
    sales_order_details sod
INNER JOIN products p
    ON sod.Product_Number = p.Product_ID
INNER JOIN sales_orders so
    ON sod.Sales_Order_Number = so.Sales_Order_Number
INNER JOIN sales_territory st
    ON st.Territory_ID = so.Territory_ID;