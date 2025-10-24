
-- Limpieza, validación y transformación del dataset de Walmart

USE WalmartSales;
GO

-- SECCIÓN 1: EXPLORACIÓN INICIAL

-- 1.1 Verificar conteo de registros en cada tabla
SELECT 'sales' AS tabla, COUNT(*) AS total_registros FROM sales
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'features', COUNT(*) FROM features
UNION ALL
SELECT 'test', COUNT(*) FROM test;

-- 1.2 Verificar rango de fechas
SELECT 
    'sales' AS tabla,
    MIN(Date) AS fecha_inicio,
    MAX(Date) AS fecha_fin,
    DATEDIFF(MONTH, MIN(Date), MAX(Date)) AS meses_totales
FROM sales;

-- 1.3 Contar tiendas y departamentos únicos
SELECT 
    COUNT(DISTINCT Store) AS total_tiendas,
    COUNT(DISTINCT Dept) AS total_departamentos
FROM sales;

-- 1.4 Verificar estructura de tabla stores
SELECT TOP 5 * FROM stores ORDER BY Store;

-- 1.5 Verificar estructura de tabla features
SELECT TOP 5 * FROM features ORDER BY Store, Date;


-- SECCIÓN 2: VALIDACIÓN DE CALIDAD DE DATOS
-- 2.1 Identificar valores nulos en sales
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS null_store,
    SUM(CASE WHEN Dept IS NULL THEN 1 ELSE 0 END) AS null_dept,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS null_weekly_sales,
    SUM(CASE WHEN IsHoliday IS NULL THEN 1 ELSE 0 END) AS null_isholiday
FROM sales;

-- 2.2 Identificar valores nulos en features
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Temperature IS NULL THEN 1 ELSE 0 END) AS null_temperature,
    SUM(CASE WHEN Fuel_Price IS NULL THEN 1 ELSE 0 END) AS null_fuel_price,
    SUM(CASE WHEN CPI IS NULL THEN 1 ELSE 0 END) AS null_cpi,
    SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS null_unemployment
FROM features;

-- 2.3 Buscar duplicados en sales (Store + Date + Dept debe ser único)
SELECT 
    Store, Date, Dept, COUNT(*) AS veces_repetido
FROM sales
GROUP BY Store, Date, Dept
HAVING COUNT(*) > 1;

-- 2.4 Buscar duplicados en features (Store + Date debe ser único)
SELECT 
    Store, Date, COUNT(*) AS veces_repetido
FROM features
GROUP BY Store, Date
HAVING COUNT(*) > 1;

-- 2.5 Verificar valores negativos en ventas (no deberían existir)
SELECT 
    COUNT(*) AS ventas_negativas,
    MIN(Weekly_Sales) AS venta_minima,
    MAX(Weekly_Sales) AS venta_maxima
FROM sales
WHERE Weekly_Sales < 0;

-- 2.6 Verificar rangos lógicos de temperatura (debe estar entre -20 y 120 °F)
SELECT 
    MIN(Temperature) AS temp_minima,
    MAX(Temperature) AS temp_maxima,
    COUNT(*) AS registros_fuera_rango
FROM features
WHERE Temperature < -20 OR Temperature > 120;

-- 2.7 Verificar consistencia de IsHoliday entre sales y features
SELECT 
    s.Store,
    s.Date,
    s.IsHoliday AS IsHoliday_Sales,
    f.IsHoliday AS IsHoliday_Features
FROM sales s
INNER JOIN features f 
    ON s.Store = f.Store AND s.Date = f.Date
WHERE s.IsHoliday != f.IsHoliday;

-- SECCIÓN 3: TRANSFORMACIÓN Y ENRIQUECIMIENTO

-- 3.1 Agregar columnas temporales a sales (Year, Month, Quarter, etc.)
-- Vista con columnas temporales enriquecidas
CREATE OR ALTER VIEW vw_sales_enriched AS
SELECT 
    s.Store,
    s.Dept,
    s.Date,
    s.Weekly_Sales,
    s.IsHoliday,
    -- Columnas temporales
    YEAR(s.Date) AS Year,
    MONTH(s.Date) AS Month,
    DATENAME(MONTH, s.Date) AS Month_Name,
    DATEPART(QUARTER, s.Date) AS Quarter,
    DATEPART(WEEK, s.Date) AS Week_Number,
    DATEPART(WEEKDAY, s.Date) AS Day_of_Week,
    -- Información de stores
    st.Type AS Store_Type,
    st.Size AS Store_Size,
    -- Información de features
    f.Temperature,
    f.Fuel_Price,
    f.CPI,
    f.Unemployment
FROM sales s
LEFT JOIN stores st ON s.Store = st.Store
LEFT JOIN features f ON s.Store = f.Store AND s.Date = f.Date;
GO

-- 3.2 Verificar que la vista funciona correctamente
SELECT TOP 10 * FROM vw_sales_enriched ORDER BY Store, Date, Dept;

-- 3.3 Contar registros de la vista vs tabla original (deben coincidir)
SELECT 
    (SELECT COUNT(*) FROM sales) AS registros_sales,
    (SELECT COUNT(*) FROM vw_sales_enriched) AS registros_vista,
    CASE 
        WHEN (SELECT COUNT(*) FROM sales) = (SELECT COUNT(*) FROM vw_sales_enriched)
        THEN 'OK - Sin duplicación'
        ELSE 'ERROR - Hay duplicación de datos'
    END AS status_validacion;

-- 3.4 Verificar suma de ventas (debe ser igual en tabla original y vista)
SELECT 
    (SELECT SUM(Weekly_Sales) FROM sales) AS total_sales_original,
    (SELECT SUM(Weekly_Sales) FROM vw_sales_enriched) AS total_sales_vista,
    CASE 
        WHEN ABS((SELECT SUM(Weekly_Sales) FROM sales) - 
                 (SELECT SUM(Weekly_Sales) FROM vw_sales_enriched)) < 0.01
        THEN 'OK - Totales coinciden'
        ELSE 'ERROR - Totales no coinciden'
    END AS status_validacion;

-- SECCIÓN 4: CREACIÓN DE TABLAS DE RESUMEN (OPCIONAL)
-- 4.1 Tabla resumen: Ventas mensuales por tienda
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

-- 4.2 Tabla resumen: Ventas por tipo de tienda
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

-- 4.3 Tabla resumen: Ventas por día festivo
CREATE OR ALTER VIEW vw_sales_by_holiday AS
SELECT 
    CASE 
        WHEN IsHoliday = 1 THEN 'Holiday Week'
        ELSE 'Regular Week'
    END AS Week_Type,
    COUNT(*) AS Number_of_Records,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(DISTINCT Store) AS Stores,
    COUNT(DISTINCT Date) AS Weeks
FROM vw_sales_enriched
GROUP BY IsHoliday;
GO

-- SECCIÓN 5: ESTADÍSTICAS FINALES
-- 5.1 Resumen general del dataset
SELECT 
    'Dataset Overview' AS Metrica,
    (SELECT COUNT(*) FROM sales) AS Registros_Totales,
    (SELECT COUNT(DISTINCT Store) FROM sales) AS Tiendas_Unicas,
    (SELECT COUNT(DISTINCT Dept) FROM sales) AS Departamentos_Unicos,
    (SELECT MIN(Date) FROM sales) AS Fecha_Inicio,
    (SELECT MAX(Date) FROM sales) AS Fecha_Fin,
    (SELECT SUM(Weekly_Sales) FROM sales) AS Ventas_Totales,
    (SELECT AVG(Weekly_Sales) FROM sales) AS Promedio_Ventas_Semanales;

-- 5.2 Distribución de registros por año
SELECT 
    YEAR(Date) AS Year,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Store) AS Unique_Stores,
    COUNT(DISTINCT MONTH(Date)) AS Months_Available,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM sales
GROUP BY YEAR(Date)
ORDER BY Year;

-- 5.3 Calidad de datos - Resumen final
SELECT 
    'Calidad de Datos' AS Categoria,
    CAST(COUNT(*) AS DECIMAL(10,2)) AS Total_Registros,
    CAST(SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) AS DECIMAL(10,2)) AS Registros_Nulos,
    CAST(SUM(CASE WHEN Weekly_Sales < 0 THEN 1 ELSE 0 END) AS DECIMAL(10,2)) AS Registros_Negativos,
    CAST((1.0 - (SUM(CASE WHEN Weekly_Sales IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*))) * 100 AS DECIMAL(5,2)) AS Porcentaje_Completitud
FROM sales;
