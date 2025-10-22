#  Walmart Sales Analysis

![Dashboard Overview](images/dashboard_preview.png)

Análisis exhaustivo de datos de ventas de Walmart para identificar patrones de comportamiento, evaluar el impacto de factores externos y optimizar la toma de decisiones operativas. Este proyecto simula un caso real de inteligencia comercial utilizando SQL Server y Power BI.

---

##  Descripción

Walmart, como líder global en retail, requiere anticipar la demanda para optimizar inventario, asignación de personal y estrategias promocionales. Este proyecto analiza **421,570 registros de ventas semanales** de 45 tiendas durante el período febrero 2010 - octubre 2012, evaluando el comportamiento de ventas por tienda, tipo de establecimiento y el impacto de factores externos como días festivos, temperatura y variables económicas.

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

##  Resultados Clave

- **$6.7 mil millones** en ventas totales analizadas durante 33 meses
- Las **10 tiendas top** concentran **42% de las ventas totales**, indicando alta concentración de ingresos
- Los días festivos generan un incremento de **22-28%** en ventas vs semanas regulares
- **Julio** es el mes de mayor venta (no diciembre como se esperaría), con picos relacionados a back-to-school
- Q4 representa **35% de las ventas anuales**, con diciembre superando el promedio mensual en **+45%**
- Tiendas tipo A generan **60% del volumen total**, con mejor desempeño per square foot

---

##  Insights del Análisis

###  Variabilidad entre Tiendas
- **Tienda #20 lidera** con $30.3M en ventas totales, seguida por tiendas #4 y #14
- Existe alta variación en desempeño: las bottom 10 tiendas representan solo **8% de ventas**
- Mayor tamaño de tienda **NO garantiza** mejores ventas por pie cuadrado, sugiriendo que la eficiencia operativa es más relevante que el tamaño

###  Estacionalidad Marcada
- **Patrón estacional claro:** Q4 domina las ventas con picos en noviembre-diciembre
- Las **semanas 47-52** (Thanksgiving y Navidad) muestran los mayores volúmenes del año
- Enero-febrero son los meses más débiles, con ventas **18% bajo el promedio anual**
- La estacionalidad es consistente a lo largo de los 3 años analizados

###  Impacto de Festivos
- Las semanas con festivos generan ventas **22-28% superiores** a semanas regulares
- **Tiendas tipo A se benefician más** (+35%) del efecto festivo vs tipo C (+18%)
- El "efecto halo" de festivos se extiende **1 semana después** del evento principal
- **Thanksgiving** muestra el mayor impacto individual en ventas

###  Factores Externos Limitados
- **Temperatura:** Correlación débil positiva (0.00) - rango óptimo 60-80°F
- **Precio del combustible:** Impacto mínimo en comportamiento de compra (-0.08 correlación)
- **Variables económicas (CPI, desempleo):** Correlación muy baja (<0.05)
- **Conclusión:** Factores internos (marketing, promociones, surtido) tienen **mayor impacto** que variables externas

###  Oportunidades de Mejora
- **12 tiendas** mantienen ventas consistentemente bajas (<$25M), requiriendo análisis de causas raíz
- Existe oportunidad de replicar estrategias de tiendas exitosas en ubicaciones de bajo desempeño
- El análisis revela necesidad de estrategias diferenciadas por tipo de tienda y región

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

##  Cómo Reproducir el Análisis

### Requisitos Previos
```
- SQL Server 2019 o superior
- Power BI Desktop (última versión)
- Dataset de Kaggle (link arriba)
```

### Pasos

1. **Clonar el repositorio:**
```bash
git clone https://github.com/RenatoCS25/Walmart-Sales-Analysis.git
cd Walmart-Sales-Analysis
```

2. **Configurar base de datos:**
```sql
-- Importar CSVs a SQL Server
-- Ejecutar scripts en orden:
-- 1. sql/01_exploratory_analysis.sql
-- 2. sql/02_business_questions.sql
```

3. **Abrir dashboard:**
```
- Abrir: powerbi/walmart_dashboard.pbix
- Actualizar credenciales de conexión SQL (si es necesario)
- Refrescar datos
- Explorar las 5 páginas interactivas
```

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
