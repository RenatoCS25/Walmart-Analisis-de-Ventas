#  Walmart Sales Analysis

Análisis exhaustivo de datos de ventas de Walmart para identificar patrones de comportamiento, evaluar el impacto de factores externos y optimizar la toma de decisiones operativas. Este proyecto simula un caso real de inteligencia comercial utilizando SQL Server y Power BI.

---

##  Descripción

Walmart, como líder global en retail, requiere anticipar la demanda para optimizar inventario, asignación de personal y estrategias promocionales. Este proyecto analiza 421,570 registros de ventas semanales de 45 tiendas durante el período febrero 2010 - octubre 2012, evaluando el comportamiento de ventas por tienda, tipo de establecimiento y el impacto de factores externos como días festivos, temperatura y variables económicas.

---

##  Objetivos del Proyecto

- Explorar y transformar el dataset de ventas utilizando SQL Server
- Analizar patrones de ventas por tienda, departamento y temporada
- Evaluar el impacto de días festivos en el comportamiento de compra
- Identificar correlaciones entre factores externos (clima, economía) y ventas
- Construir un dashboard interactivo en Power BI para comunicar insights de forma visual
- Generar recomendaciones accionables basadas en datos

---

##  Impacto en el Negocio

Este análisis permite a Walmart:

-  **Optimizar inventario:** Identificar patrones estacionales para ajustar stock por tienda y período
-  **Planificar staffing:** Anticipar períodos de alta demanda para asignación de personal
-  **Diseñar campañas promocionales:** Determinar cuándo y dónde las promociones tienen mayor impacto
-  **Evaluar desempeño por tienda:** Identificar tiendas de alto y bajo rendimiento para intervenciones específicas
-  **Mejorar planificación operativa:** Tomar decisiones basadas en evidencia en lugar de intuición

---

## Metodologia

### 1. Preparación de Datos (SQL Server)
#### Importación y Validación:

Carga de 3 tablas relacionales: sales (421K registros), stores (45 tiendas), features (factores externos)
Verificación de integridad referencial y tipos de datos
Identificación de períodos disponibles: Feb 2010 - Oct 2012

#### Limpieza y Transformación:
sql-- Creación de columnas derivadas para análisis temporal
- Year, Month, Month_Name, Quarter, Week_Number
- Validación de valores nulos (< 0.1% en campos críticos)
- Estandarización de formatos de fecha
#### Análisis Exploratorio:

### 2. Modelado en Power BI
#### Arquitectura de Datos:

Modelo relacional tipo estrella
Tabla de hechos: sales (centro del modelo)
Tablas dimensionales: stores, features
Relaciones 1:* configuradas con filtrado bidireccional

#### Medidas DAX Desarrolladas:
15+ medidas calculadas incluyendo:
- Total Sales, Avg Weekly Sales
- YoY Growth % (ajustado por períodos comparables)
- Holiday Impact %, Sales per SqFt
- Ranking dinámico de tiendas
- Índices de volatilidad y estacionalidad

50+ queries SQL para responder preguntas de negocio
Agregaciones por tienda, departamento, período temporal
Cálculos de correlación entre variables externas y ventas

### 3. Visualización Interactiva
#### Diseño del Dashboard:

5 páginas especializadas con 30+ visualizaciones
Slicers sincronizados: Año, Tienda, Tipo
Paleta de colores corporativa Walmart (azul #0071CE, amarillo #FFC220)
Navegación intuitiva entre análisis

#### Principios de Diseño:

Simplicidad: Un insight principal por visual
Interactividad: Todos los gráficos responden a filtros
Contexto: Text boxes con interpretación de datos
Acción: Recomendaciones basadas en hallazgos

---

##  Principales Hallazgos e Insights Estratégicos

### 1. Concentración Crítica de Ingresos
- El **39% de las ventas totales** proviene de solo 10 tiendas.  
- 12 tiendas registran bajo desempeño (<$25M).  
- **Implicación:** alto riesgo de dependencia y potencial de mejora en tiendas rezagadas.  
- **Recomendación:** replicar prácticas de tiendas top y crear alertas tempranas de desempeño.

### 2. Estacionalidad Extrema y Predecible
- Q4 concentra el **35% de las ventas anuales**, siendo diciembre el mes con mayor pico (+64.8% sobre promedio).  
- Enero y febrero presentan los niveles más bajos.  
- **Implicación:** capacidad subutilizada gran parte del año.  
- **Recomendación:** planificar inventario trimestral, aumentar stock antes de Q4, realizar promociones post-festivas y desarrollar campañas para suavizar la demanda en Q2 y Q3.

### 3. Impacto Significativo de Días Festivos
- Semanas con festivos generan **+7.13% en ventas**, concentrando utilidades significativas.  
- Tiendas tipo A capturan mejor estas oportunidades; las tipo C desaprovechan el potencial.  
- **Recomendación:** implementar estrategias integrales pre, durante y post festivo, incluyendo marketing digital segmentado, horarios extendidos, promociones flash y personal adicional para maximizar el tráfico y las ventas.

### 4. Factores Externos con Impacto Mínimo
- Correlación prácticamente nula con temperatura, gasolina, desempleo o CPI.  
- **Conclusión:** las ventas dependen de factores internos y no del entorno económico.  
- **Recomendación:** centrar la gestión en variables controlables como experiencia en tienda, promociones, fidelización y ejecución operativa, dejando de atribuir bajo desempeño a la economía externa.

### 5. Eficiencia por Pie Cuadrado
- Tiendas **tipo C** son las más eficientes ($1,667 ventas/pie² vs $1,106 en tipo A).  
- **Conclusión:** mayor tamaño no implica mayor rentabilidad.  
- **Recomendación:** auditar el uso de espacio en tiendas grandes, eliminar áreas de bajo giro, transformar espacios muertos en experiencias de cliente y replicar el formato “small box” en ubicaciones urbanas densas para maximizar ventas por pie cuadrado.

### 6. Volatilidad y Predictibilidad
- Mayor volumen → mayor volatilidad → menor predictibilidad.  
- **Recomendación:** segmentar operaciones según volatilidad: las tiendas de alta volatilidad requieren más stock, reabastecimiento frecuente y autonomía gerencial, mientras que las de baja volatilidad pueden operar con inventario lean y procesos automatizados.

---

## 📈 Recomendaciones Ejecutivas

**Programa Top Store Replication:** replicar las mejores prácticas de las tiendas top (#20, #4, #14) en las tiendas de menor desempeño. Esto incluye capacitación del personal, optimización de merchandising y estrategias de clientela. El objetivo es incrementar las ventas promedio de las tiendas bottom 20 de $18M a $21M anuales.

**Optimización de Q4:** aumentar el inventario en preparación para la temporada alta, priorizando categorías de alto margen y ejecutando campañas de marketing anticipadas. Esto permitirá maximizar el 35% de las ventas anuales concentradas en los últimos tres meses del año y aumentar las ventas de Q4 de $2.3B a $2.5B.

**Estrategia de Festivos:** implementar un plan integral de pre, durante y post festivo, incluyendo campañas segmentadas, promociones flash, horarios extendidos y captación de clientes para remarketing. Esta estrategia busca incrementar las ventas en las 7 semanas festivas de $505M a $606M.

**Expansión de Formato Small Box:** replicar el modelo eficiente de tiendas tipo C en nuevas aperturas urbanas, optimizando el surtido de productos de alta rotación. El objetivo es lograr ventas superiores a $1,500 por pie cuadrado en nuevas tiendas dentro de los primeros 18 meses.

**Centro de Excelencia Operativa:** establecer un equipo permanente para estandarizar mejores prácticas, reducir ineficiencias y controlar costos operativos. Esto permitirá disminuir el costo operativo por venta de 18% a 16% y asegurar la consistencia en la ejecución de estrategias corporativas.

---



##  Stack Técnico

| Herramienta | Uso en el Proyecto |
|-------------|-------------------|
| **SQL Server** | Limpieza de datos, transformaciones, análisis exploratorio con 50+ queries |
| **Power BI** | Dashboard interactivo de 5 páginas con 30+ visualizaciones |
| **DAX** | 15+ medidas calculadas para KPIs y análisis comparativos |
| **GitHub** | Control de versiones y documentación técnica |

---

##  Dashboard Interactivo

### 5 Páginas Especializadas:

| Página | Contenido Principal |
|--------|---------------------|
| **1. Overview** | KPIs ejecutivos, evolución temporal, distribución por tipo de tienda |
| **2. Análisis Temporal** | Patrones estacionales, comparaciones YoY, identificación de mejor mes |
| **3. Días Festivos** | Impacto de festivos por tienda, timeline de ventas, análisis comparativo |
| **4. Factores Externos** | Correlaciones con temperatura, combustible y variables económicas |
| **5. Análisis por Tienda** | Ranking completo, top 10 vs bottom 10, evolución temporal |

<details>
<summary> Ver capturas del dashboard</summary>

### Overview Ejecutivo
![Overview](images/01_overview.png)

### Análisis Temporal y Estacionalidad
![Temporal](images/02_analisis_temporal.png)

### Impacto de Días Festivos
![Festivos](images/03_dias_festivos.png)

### Factores Externos y Correlaciones
![Factores](images/04_factores_externos.png)

### Análisis Detallado por Tienda
![Tiendas](images/05_analisis_tiendas.png)

</details>

---

##  Dataset

**Fuente:** [Walmart Sales Forecasting - Kaggle](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

**Estructura:**
- **Sales:** 421,570 registros de ventas semanales
  - 45 tiendas
  - ~99 departamentos por tienda
  - Período: Febrero 2010 - Octubre 2012

- **Stores:** Información de tiendas
  - Tipo (A, B, C) según tamaño e importancia
  - Tamaño en pies cuadrados

- **Features:** Factores externos
  - Temperatura promedio semanal
  - Precio del combustible
  - CPI (Índice de Precios al Consumidor)
  - Tasa de desempleo
  - Indicadores de días festivos

** Consideración Metodológica:**
- 2010: Datos parciales (11 meses, desde febrero)
- 2011: Año completo ✓ (base para análisis anual)
- 2012: Datos parciales (10 meses, hasta octubre)

Las comparaciones interanuales fueron ajustadas para considerar solo períodos equivalentes disponibles en ambos años.

---

##  Estructura del Proyecto
```
Walmart-Sales-Analysis/
├── data/
│   ├── sales.csv              # Ventas semanales
│   ├── stores.csv             # Información de tiendas
│   ├── features.csv           # Factores externos
│   └── data_dictionary.md     # Descripción de campos
│
├── sql/
│   ├── 01_exploratory_analysis.sql    # Análisis exploratorio
│   ├── 02_business_questions.sql      # Queries de negocio
│   └── README.md                      # Documentación SQL
│
├── powerbi/
│   └── walmart_dashboard.pbix         # Dashboard interactivo
│
├── images/
│   ├── 01_overview.png
│   ├── 02_analisis_temporal.png
│   ├── 03_dias_festivos.png
│   ├── 04_factores_externos.png
│   ├── 05_analisis_tiendas.png
│   └── dashboard_preview.png
│
└── README.md
```

---

##  Skills Demostradas

**Análisis de Datos:**
- ✅ Limpieza y transformación de datasets complejos
- ✅ Análisis exploratorio con SQL (JOINs, agregaciones, window functions)
- ✅ Identificación de patrones temporales y estacionalidad
- ✅ Análisis de correlaciones y factores externos

**Visualización y Comunicación:**
- ✅ Diseño de dashboards interactivos con Power BI
- ✅ Creación de medidas DAX avanzadas
- ✅ Storytelling con datos para audiencias no técnicas
- ✅ Documentación técnica clara y estructurada

**Pensamiento de Negocio:**
- ✅ Traducción de datos en insights accionables
- ✅ Identificación de oportunidades de optimización
- ✅ Generación de recomendaciones basadas en evidencia
- ✅ Consideración de limitaciones metodológicas

---

##  Próximos Pasos

- [ ] Implementar forecasting con modelos de Machine Learning (Prophet, ARIMA)
- [ ] Análisis de canasta de mercado por departamento
- [ ] Segmentación de tiendas con clustering
- [ ] Dashboard de monitoreo en tiempo real

---





---

**Última actualización:** Octubre 2025
