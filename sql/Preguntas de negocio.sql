
USE WalmartSales;
GO

-- Pregunta 1: ¿Como varian las ventas semanales a lo largo del tiempo?
-- 1.1 Ventas totales por año
SELECT 
    YEAR(Date) AS Year,
    SUM(Weekly_Sales) AS Total_Annual_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(*) AS Total_Weeks,
    COUNT(DISTINCT Store) AS Active_Stores
FROM vw_sales_enriched
GROUP BY YEAR(Date)
ORDER BY Year;

-- 1.2 Ventas por mes (agregando todos los años)
SELECT 
    Month,
    Month_Name,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    SUM(Weekly_Sales) AS Total_Sales,
    COUNT(*) AS Observations
FROM vw_sales_enriched
GROUP BY Month, Month_Name
ORDER BY Month;

-- 1.3 Evolución temporal - Serie semanal completa
SELECT 
    Date,
    SUM(Weekly_Sales) AS Total_Sales_All_Stores,
    AVG(Weekly_Sales) AS Avg_Sales_Per_Store,
    COUNT(DISTINCT Store) AS Stores_Reporting
FROM vw_sales_enriched
GROUP BY Date
ORDER BY Date;

-- 1.4 Comparación mes a mes (MoM)
WITH Monthly_Sales AS (
    SELECT 
        Year,
        Month,
        Month_Name,
        SUM(Weekly_Sales) AS Total_Sales
    FROM vw_sales_enriched
    GROUP BY Year, Month, Month_Name
)
SELECT 
    Year,
    Month,
    Month_Name,
    Total_Sales,
    LAG(Total_Sales) OVER (PARTITION BY Month ORDER BY Year) AS Previous_Year_Same_Month,
    Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Month ORDER BY Year) AS Absolute_Change,
    CASE 
        WHEN LAG(Total_Sales) OVER (PARTITION BY Month ORDER BY Year) IS NOT NULL
        THEN ((Total_Sales - LAG(Total_Sales) OVER (PARTITION BY Month ORDER BY Year)) / 
              LAG(Total_Sales) OVER (PARTITION BY Month ORDER BY Year) * 100)
        ELSE NULL
    END AS Percent_Change_YoY
FROM Monthly_Sales
ORDER BY Year, Month;

-- Pregunta 2: ¿Existe estacionalidad en las ventas?
-- 2.1 Índice estacional por mes
WITH Monthly_Avg AS (
    SELECT 
        Month,
        Month_Name,
        AVG(Weekly_Sales) AS Avg_Monthly_Sales
    FROM vw_sales_enriched
    GROUP BY Month, Month_Name
),
Overall_Avg AS (
    SELECT AVG(Weekly_Sales) AS Overall_Average
    FROM vw_sales_enriched
)
SELECT 
    m.Month,
    m.Month_Name,
    m.Avg_Monthly_Sales,
    o.Overall_Average,
    (m.Avg_Monthly_Sales / o.Overall_Average * 100) AS Seasonal_Index,
    CASE 
        WHEN (m.Avg_Monthly_Sales / o.Overall_Average) > 1.2 THEN 'Muy Alto'
        WHEN (m.Avg_Monthly_Sales / o.Overall_Average) > 1.05 THEN 'Alto'
        WHEN (m.Avg_Monthly_Sales / o.Overall_Average) < 0.95 THEN 'Bajo'
        WHEN (m.Avg_Monthly_Sales / o.Overall_Average) < 0.8 THEN 'Muy Bajo'
        ELSE 'Normal'
    END AS Clasificacion_Estacional
FROM Monthly_Avg m
CROSS JOIN Overall_Avg o
ORDER BY m.Month;

-- 2.2 Ventas por trimestre
SELECT 
    Year,
    Quarter,
    SUM(Weekly_Sales) AS Quarterly_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(*) AS Weeks_in_Quarter
FROM vw_sales_enriched
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- 2.3 Participación de cada trimestre en ventas anuales
WITH Quarterly_Sales AS (
    SELECT 
        Year,
        Quarter,
        SUM(Weekly_Sales) AS Q_Sales
    FROM vw_sales_enriched
    GROUP BY Year, Quarter
),
Annual_Sales AS (
    SELECT 
        Year,
        SUM(Weekly_Sales) AS Annual_Sales
    FROM vw_sales_enriched
    GROUP BY Year
)
SELECT 
    q.Year,
    q.Quarter,
    q.Q_Sales AS Quarterly_Sales,
    a.Annual_Sales,
    (q.Q_Sales / a.Annual_Sales * 100) AS Percent_of_Annual
FROM Quarterly_Sales q
INNER JOIN Annual_Sales a ON q.Year = a.Year
ORDER BY q.Year, q.Quarter;

-- 2.4 Identificar mejor y peor mes
SELECT TOP 1
    Month_Name AS Mejor_Mes,
    AVG(Weekly_Sales) AS Promedio_Ventas
FROM vw_sales_enriched
GROUP BY Month, Month_Name
ORDER BY AVG(Weekly_Sales) DESC;

SELECT TOP 1
    Month_Name AS Peor_Mes,
    AVG(Weekly_Sales) AS Promedio_Ventas
FROM vw_sales_enriched
GROUP BY Month, Month_Name
ORDER BY AVG(Weekly_Sales) ASC;

-- Pregunta 3: ¿Que impacto tienen los dias festivos?
-- 3.1 Comparación festivos vs regulares
SELECT 
    IsHoliday,
    CASE 
        WHEN IsHoliday = 1 THEN 'Holiday Week'
        ELSE 'Regular Week'
    END AS Week_Type,
    COUNT(*) AS Number_of_Weeks,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    MIN(Weekly_Sales) AS Min_Sales,
    MAX(Weekly_Sales) AS Max_Sales,
    STDEV(Weekly_Sales) AS StdDev_Sales
FROM vw_sales_enriched
GROUP BY IsHoliday;

-- 3.2 Diferencia porcentual (Holiday Impact)
WITH Holiday_Comparison AS (
    SELECT 
        AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) AS Avg_Holiday_Sales,
        AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) AS Avg_Regular_Sales
    FROM vw_sales_enriched
)
SELECT 
    Avg_Holiday_Sales,
    Avg_Regular_Sales,
    (Avg_Holiday_Sales - Avg_Regular_Sales) AS Absolute_Difference,
    ((Avg_Holiday_Sales - Avg_Regular_Sales) / Avg_Regular_Sales * 100) AS Percent_Increase
FROM Holiday_Comparison;

-- 3.3 Impacto de festivos por tienda
SELECT 
    Store,
    Store_Type,
    AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) AS Avg_Holiday_Sales,
    AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) AS Avg_Regular_Sales,
    (AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) - 
     AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END)) AS Sales_Difference,
    ((AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) - 
      AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END)) / 
      AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) * 100) AS Holiday_Lift_Percent
FROM vw_sales_enriched
GROUP BY Store, Store_Type
ORDER BY Holiday_Lift_Percent DESC;

-- 3.4 Impacto por tipo de tienda
SELECT 
    Store_Type,
    AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) AS Avg_Holiday_Sales,
    AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) AS Avg_Regular_Sales,
    ((AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) - 
      AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END)) / 
      AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) * 100) AS Holiday_Lift_Percent
FROM vw_sales_enriched
GROUP BY Store_Type
ORDER BY Holiday_Lift_Percent DESC;

-- 3.5 Timeline de semanas festivas con ventas
SELECT 
    Date,
    IsHoliday,
    SUM(Weekly_Sales) AS Total_Sales,
    COUNT(DISTINCT Store) AS Stores
FROM vw_sales_enriched
WHERE IsHoliday = 1
GROUP BY Date, IsHoliday
ORDER BY Date;

-- Pregunta 4: ¿hay correlacion con factores externos?
-- 4.1 Ventas por rangos de temperatura
SELECT 
    CASE 
        WHEN Temperature < 32 THEN 'Muy Frío (< 32°F)'
        WHEN Temperature BETWEEN 32 AND 50 THEN 'Frío (32-50°F)'
        WHEN Temperature BETWEEN 50 AND 70 THEN 'Templado (50-70°F)'
        WHEN Temperature BETWEEN 70 AND 85 THEN 'Cálido (70-85°F)'
        ELSE 'Muy Cálido (> 85°F)'
    END AS Temp_Range,
    COUNT(*) AS Observations,
    AVG(Weekly_Sales) AS Avg_Sales,
    SUM(Weekly_Sales) AS Total_Sales
FROM vw_sales_enriched
WHERE Temperature IS NOT NULL
GROUP BY 
    CASE 
        WHEN Temperature < 32 THEN 'Muy Frío (< 32°F)'
        WHEN Temperature BETWEEN 32 AND 50 THEN 'Frío (32-50°F)'
        WHEN Temperature BETWEEN 50 AND 70 THEN 'Templado (50-70°F)'
        WHEN Temperature BETWEEN 70 AND 85 THEN 'Cálido (70-85°F)'
        ELSE 'Muy Cálido (> 85°F)'
    END
ORDER BY Avg_Sales DESC;

-- 4.2 Ventas por rangos de precio de combustible
SELECT 
    CASE 
        WHEN Fuel_Price < 2.5 THEN 'Bajo (< $2.50)'
        WHEN Fuel_Price BETWEEN 2.5 AND 3.0 THEN 'Medio ($2.50-$3.00)'
        WHEN Fuel_Price BETWEEN 3.0 AND 3.5 THEN 'Alto ($3.00-$3.50)'
        ELSE 'Muy Alto (> $3.50)'
    END AS Fuel_Price_Range,
    COUNT(*) AS Observations,
    AVG(Weekly_Sales) AS Avg_Sales
FROM vw_sales_enriched
WHERE Fuel_Price IS NOT NULL
GROUP BY 
    CASE 
        WHEN Fuel_Price < 2.5 THEN 'Bajo (< $2.50)'
        WHEN Fuel_Price BETWEEN 2.5 AND 3.0 THEN 'Medio ($2.50-$3.00)'
        WHEN Fuel_Price BETWEEN 3.0 AND 3.5 THEN 'Alto ($3.00-$3.50)'
        ELSE 'Muy Alto (> $3.50)'
    END
ORDER BY Avg_Sales DESC;

-- 4.3 Matriz de correlación (aproximada)
-- Nota: SQL no tiene función nativa de correlación de Pearson
-- Esta query prepara los datos para análisis de correlación
SELECT 
    AVG(Weekly_Sales) AS Avg_Sales,
    AVG(Temperature) AS Avg_Temperature,
    AVG(Fuel_Price) AS Avg_Fuel_Price,
    AVG(CPI) AS Avg_CPI,
    AVG(Unemployment) AS Avg_Unemployment,
    STDEV(Weekly_Sales) AS StdDev_Sales,
    STDEV(Temperature) AS StdDev_Temperature,
    STDEV(Fuel_Price) AS StdDev_Fuel_Price,
    STDEV(CPI) AS StdDev_CPI,
    STDEV(Unemployment) AS StdDev_Unemployment
FROM vw_sales_enriched
WHERE Temperature IS NOT NULL 
  AND Fuel_Price IS NOT NULL 
  AND CPI IS NOT NULL 
  AND Unemployment IS NOT NULL;

-- 4.4 Estadísticas descriptivas de factores externos
SELECT 
    'Temperature' AS Variable,
    MIN(Temperature) AS Minimo,
    MAX(Temperature) AS Maximo,
    AVG(Temperature) AS Promedio,
    STDEV(Temperature) AS Desviacion_Estandar
FROM vw_sales_enriched
WHERE Temperature IS NOT NULL
UNION ALL
SELECT 
    'Fuel_Price',
    MIN(Fuel_Price),
    MAX(Fuel_Price),
    AVG(Fuel_Price),
    STDEV(Fuel_Price)
FROM vw_sales_enriched
WHERE Fuel_Price IS NOT NULL
UNION ALL
SELECT 
    'CPI',
    MIN(CPI),
    MAX(CPI),
    AVG(CPI),
    STDEV(CPI)
FROM vw_sales_enriched
WHERE CPI IS NOT NULL
UNION ALL
SELECT 
    'Unemployment',
    MIN(Unemployment),
    MAX(Unemployment),
    AVG(Unemployment),
    STDEV(Unemployment)
FROM vw_sales_enriched
WHERE Unemployment IS NOT NULL;

-- Pregunta 5: ¿Que tiendas tienen mejor desempeño?
-- 5.1 Ranking de tiendas por ventas totales
SELECT 
    Store,
    Store_Type,
    Store_Size,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    COUNT(DISTINCT Dept) AS Active_Departments,
    COUNT(*) AS Total_Weeks,
    RANK() OVER (ORDER BY SUM(Weekly_Sales) DESC) AS Sales_Rank,
    -- Ventas por pie cuadrado
    SUM(Weekly_Sales) / Store_Size AS Sales_per_SqFt
FROM vw_sales_enriched
GROUP BY Store, Store_Type, Store_Size
ORDER BY Total_Sales DESC;

-- 5.2 Top 10 y Bottom 10 tiendas
SELECT TOP 10
    Store,
    Store_Type,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    'Top 10' AS Category
FROM vw_sales_enriched
GROUP BY Store, Store_Type
ORDER BY Total_Sales DESC;

SELECT TOP 10
    Store,
    Store_Type,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    'Bottom 10' AS Category
FROM vw_sales_enriched
GROUP BY Store, Store_Type
ORDER BY Total_Sales ASC;

-- 5.3 Ventas por tipo de tienda
SELECT 
    Store_Type,
    COUNT(DISTINCT Store) AS Number_of_Stores,
    SUM(Weekly_Sales) AS Total_Sales,
    AVG(Weekly_Sales) AS Avg_Weekly_Sales,
    SUM(Weekly_Sales) / (SELECT SUM(Weekly_Sales) FROM vw_sales_enriched) * 100 AS Percent_of_Total,
    AVG(Store_Size) AS Avg_Store_Size,
    SUM(Weekly_Sales) / AVG(Store_Size) AS Avg_Sales_per_SqFt
FROM vw_sales_enriched
GROUP BY Store_Type
ORDER BY Total_Sales DESC;

-- 5.4 Volatilidad de ventas por tienda
SELECT 
    Store,
    Store_Type,
    AVG(Weekly_Sales) AS Avg_Sales,
    STDEV(Weekly_Sales) AS Sales_Volatility,
    STDEV(Weekly_Sales) / AVG(Weekly_Sales) * 100 AS Coefficient_of_Variation,
    CASE 
        WHEN STDEV(Weekly_Sales) / AVG(Weekly_Sales) < 0.2 THEN 'Muy Estable'
        WHEN STDEV(Weekly_Sales) / AVG(Weekly_Sales) < 0.4 THEN 'Estable'
        WHEN STDEV(Weekly_Sales) / AVG(Weekly_Sales) < 0.6 THEN 'Moderadamente Volátil'
        ELSE 'Muy Volátil'
    END AS Volatility_Classification
FROM vw_sales_enriched
GROUP BY Store, Store_Type
ORDER BY Coefficient_of_Variation ASC;

-- 5.5 Crecimiento por tienda (comparando años)
WITH Yearly_Sales AS (
    SELECT 
        Store,
        Year,
        SUM(Weekly_Sales) AS Annual_Sales
    FROM vw_sales_enriched
    GROUP BY Store, Year
)
SELECT 
    Store,
    Year,
    Annual_Sales,
    LAG(Annual_Sales) OVER (PARTITION BY Store ORDER BY Year) AS Previous_Year_Sales,
    (Annual_Sales - LAG(Annual_Sales) OVER (PARTITION BY Store ORDER BY Year)) / 
     LAG(Annual_Sales) OVER (PARTITION BY Store ORDER BY Year) * 100 AS Growth_Rate_Percent
FROM Yearly_Sales
ORDER BY Store, Year;

-- 5.6 Desempeño relativo: Sales per Square Foot por tipo
SELECT 
    Store,
    Store_Type,
    Store_Size,
    SUM(Weekly_Sales) AS Total_Sales,
    SUM(Weekly_Sales) / Store_Size AS Sales_per_SqFt,
    AVG(SUM(Weekly_Sales) / Store_Size) OVER (PARTITION BY Store_Type) AS Avg_Sales_per_SqFt_by_Type,
    (SUM(Weekly_Sales) / Store_Size) - 
     AVG(SUM(Weekly_Sales) / Store_Size) OVER (PARTITION BY Store_Type) AS Deviation_from_Type_Avg
FROM vw_sales_enriched
GROUP BY Store, Store_Type, Store_Size
ORDER BY Sales_per_SqFt DESC;

