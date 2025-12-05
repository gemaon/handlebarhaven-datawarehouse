# SQL Scripts

## 01_source_extraction_scripts.sql
SQL queries used to extract and denormalise data from the MySQL operational database. Includes LEFT JOINs with COALESCE functions to handle incomplete customer address data, and transformations to prepare data for SSIS ingestion (date formatting, attribute concatenation, initial metric calculations).

## 02_schema_ddl_scripts.sql
CREATE TABLE statements defining the data warehouse schema in SQL Server. Establishes fact and dimension tables with appropriate data types, primary keys (IDENTITY for surrogate keys), and constraints. Executed before ETL pipeline to prepare target database structure.

## 03_analysis_queries.sql
Business intelligence queries answering the five strategic questions: key customers, profitable products, territorial performance, temporal patterns, and underperforming categories. Includes aggregations across dimensional hierarchies (year/quarter/month, category/subcategory, territory/country) with calculated metrics for profitability analysis.
