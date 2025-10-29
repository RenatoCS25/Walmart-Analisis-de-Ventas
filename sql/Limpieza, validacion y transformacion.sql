
USE WalmartSales;
GO

-- 1. Creacion de tablas

-- Tabla Sales
CREATE TABLE IF NOT EXISTS Sales (
    Store INT,
    Dept INT,
    Date DATE,
    Weekly_Sales DECIMAL(18,2),
    IsHoliday BIT
);

-- Tabla Stores
CREATE TABLE IF NOT EXISTS Stores (
    Store INT,
    Type VARCHAR(50),
    Size INT
);

-- Tabla Features
CREATE TABLE IF NOT EXISTS Features (
    Store INT,
    Date DATE,
    Temperature DECIMAL(5,2),
    Fuel_Price DECIMAL(5,2),
    CPI DECIMAL(10,2),
    Unemployment DECIMAL(10,2),
    Holiday_Flag BIT
);
GO

-- 2. Importacion de CSV
-- NOTA: Para ejecutar este script, los CSV deben estar en una ruta accesible
-- por SQL Server. Por ejemplo, copia los archivos a "C:\walmart_project\data\".
-- Ajusta las rutas si tu carpeta es diferente.

-- Importar Sales
BULK INSERT Sales
FROM 'C:\walmart_project\data\sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Importar Stores
BULK INSERT Stores
FROM 'C:\walmart_project\data\stores.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Importar Features
BULK INSERT Features
FROM 'C:\walmart_project\data\features.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO


-- 3. Validación de datos
-- Conteo de registros por tabla
SELECT 'Sales' AS Tabla, COUNT(*) AS Total_Registros FROM Sales
UNION ALL
SELECT 'Stores', COUNT(*) FROM Stores
UNION ALL
SELECT 'Features', COUNT(*) FROM Features;

-- Revisar nulos en Sales
SELECT 
    COUNT(*) AS Total_Filas,
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Null_Store,
    SUM(CASE WHEN Dept IS NULL THEN 1 ELSE 0 END) AS Null_Dept,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS Null_Weekly_Sales,
    SUM(CASE WHEN IsHoliday IS NULL THEN 1 ELSE 0 END) AS Null_IsHoliday
FROM Sales;

-- Revisar nulos en Features
SELECT 
    COUNT(*) AS Total_Filas,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS Null_Temperature,
    SUM(CASE WHEN Fuel_Price IS NULL THEN 1 ELSE 0 END) AS Null_Fuel_Price,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS Null_CPI,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Null_Unemployment
FROM Features;

-- Revisar duplicados
SELECT Store, Date, Dept, COUNT(*) AS Veces_Repetido
FROM Sales
GROUP BY Store, Date, Dept
HAVING COUNT(*) > 1;

SELECT Store, Date, COUNT(*) AS Veces_Repetido
FROM Features
GROUP BY Store, Date
HAVING COUNT(*) > 1;

-- Revisar ventas negativas
SELECT COUNT(*) AS Ventas_Negativas, MIN(Weekly_Sales) AS Min_Venta, MAX(Weekly_Sales) AS Max_Venta
FROM Sales
WHERE Weekly_Sales < 0;

-- 4. Transformacion y vista 

CREATE OR ALTER VIEW vw_sales_enriched AS
SELECT 
    s.Store,
    s.Dept,
    s.Date,
    s.Weekly_Sales,
    s.IsHoliday,
    YEAR(s.Date) AS Year,
    MONTH(s.Date) AS Month,
    DATENAME(MONTH, s.Date) AS Month_Name,
    DATEPART(QUARTER, s.Date) AS Quarter,
    DATEPART(WEEK, s.Date) AS Week_Number,
    DATEPART(WEEKDAY, s.Date) AS Day_of_Week,
    st.Type AS Store_Type,
    st.Size AS Store_Size,
    f.Temperature,
    f.Fuel_Price,
    f.CPI,
    f.Unemployment
FROM Sales s
LEFT JOIN Stores st ON s.Store = st.Store
LEFT JOIN Features f ON s.Store = f.Store AND s.Date = f.Date;
GO

-- Verificar la vista
SELECT TOP 10 * FROM vw_sales_enriched ORDER BY Store, Date, Dept;


-- 5. Tablas de resumen
-- Ventas mensuales por tienda
CREATE OR ALTER VIEW vw_monthly_sales_by_store AS
SELECT 
    Store,
    Year,
    Month,
    Month_Name,
    Store_Type,
    Store_Size,
    SUM(Weekly_Sales) AS Monthly_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(DISTINCT Dept) AS Active_Departments,
    MAX(CAST(IsHoliday AS INT)) AS Had_Holiday
FROM vw_sales_enriched
GROUP BY Store, Year, Month, Month_Name, Store_Type, Store_Size;
GO

-- Ventas por tipo de tienda
CREATE OR ALTER VIEW vw_sales_by_store_type AS
SELECT 
    Store_Type,
    COUNT(DISTINCT Store) AS Number_of_Stores,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    MIN(Weekly_Sales) AS Min_Weekly_Sales,
    MAX(Weekly_Sales) AS Max_Weekly_Sales
FROM vw_sales_enriched
GROUP BY Store_Type;
GO

-- Ventas por días festivos
CREATE OR ALTER VIEW vw_sales_by_holiday AS
SELECT 
    CASE WHEN IsHoliday = 1 THEN 'Holiday Week' ELSE 'Regular Week' END AS Week_Type,
    COUNT(*) AS Number_of_Records,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(DISTINCT Store) AS Stores,
    COUNT(DISTINCT Date) AS Weeks
FROM vw_sales_enriched
GROUP BY IsHoliday;
GO

-- 6. Analisis Estadistico
-- Resumen general
SELECT 
    COUNT(*) AS Registros_Totales,
    COUNT(DISTINCT Store) AS Tiendas_Unicas,
    COUNT(DISTINCT Dept) AS Departamentos_Unicos,
    MIN(Date) AS Fecha_Inicio,
    MAX(Date) AS Fecha_Fin,
    SUM(Weekly_Sales) AS Ventas_Totales,
    AVG(Weekly_Sales) AS Promedio_Ventas_Semanales
FROM Sales;

-- Distribución anual
SELECT 
    YEAR(Date) AS Year,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Store) AS Unique_Stores,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM Sales
GROUP BY YEAR(Date)
ORDER BY Year;

-- Calidad de datos
SELECT 
    CAST(COUNT(*) AS DECIMAL(10,2)) AS Total_Registros,
    CAST(SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS DECIMAL(10,2)) AS Registros_Nulos,
    CAST(SUM(CASE WHEN Weekly_Sales < 0 THEN 1 ELSE 0 END) AS DECIMAL(10,2)) AS Registros_Negativos,
    CAST((1.0 - (SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*))) * 100 AS DECIMAL(5,2)) AS Porcentaje_Completitud
FROM Sales;
