#  Walmart Sales Analysis

Análisis exhaustivo de datos de ventas de Walmart para identificar patrones de comportamiento, evaluar el impacto de factores externos y optimizar la toma de decisiones operativas. Este proyecto simula un caso real de inteligencia comercial utilizando SQL Server y Power BI.

---

##  Descripción

Walmart es una corporación multinacional de retail que opera 45 tiendas con aproximadamente 99 departamentos cada una. La empresa enfrenta el desafío de optimizar sus operaciones en un mercado altamente competitivo, donde la eficiencia operativa y la planificación estratégica son críticas para mantener la rentabilidad. Para ello, este proyecto analiza 421,570 registros de ventas semanales entre febrero de 2010 y octubre de 2012, con el objetivo de anticipar la demanda y optimizar el inventario, la asignación de personal y las estrategias promocionales. Además, se evalúa el comportamiento de ventas por tienda y tipo de establecimiento, así como el impacto de factores externos como días festivos, temperatura y variables económicas.

---

##  Objetivos del Analisis

1. Identificar patrones temporales de venta
2. Evaluar desempeño por tienda
3. Cuantificar impacto de factores externos
4. Generar recomendaciones accionables
5. Establecer KPIs de monitoreo continuo

---

## Preguntas de Negocio

1. ¿Cómo varían las ventas semanales a lo largo del tiempo y existe crecimiento sostenido?
2. ¿Existe estacionalidad marcada que permita planificar operaciones anticipadamente?
3. ¿Qué incremento en ventas generan los días festivos y qué tiendas capitalizan mejor esta oportunidad?
4. ¿Variables externas (clima, economía) impactan significativamente las ventas o son factores internos los determinantes?
5. ¿Qué tiendas tienen mejor/peor desempeño y cuáles son los factores explicativos?


## Metodologia

### 1. Preparación de Datos (SQL Server)
#### Importación y Validación:
Carga de 3 tablas relacionales: sales (421K registros), stores (45 tiendas), features (factores externos)
Verificación de integridad referencial y tipos de datos
Identificación de períodos disponibles: Feb 2010 - Oct 2012

#### Limpieza y Transformación:
- Creacion de columnas derivadas para análisis temporal:
  Year, Month, Month_Name, Quarter, Week_Number
  Validación de valores nulos (< 0.1% en campos críticos)
  Estandarización de formatos de fecha
#### Análisis Exploratorio:
- Realize queries de SQL para responder preguntas de negocio
- Agregaciones por tienda, departamento, período temporal
- Cálculos de correlación entre variables externas y ventas

### 2. Modelado en Power BI
#### Arquitectura de Datos:
Modelo relacional tipo estrella
Tabla de hechos: sales (centro del modelo)
Tablas dimensionales: stores, features
Relaciones 1:* configuradas con filtrado bidireccional

#### Medidas DAX Desarrolladas:
15 medidas calculadas incluyendo:
- Total Sales, Avg Weekly Sales
- YoY Growth % (ajustado por períodos comparables)
- Holiday Impact %, Sales per SqFt
- Ranking dinámico de tiendas
- Índices de volatilidad y estacionalidad

### 3. Visualización Interactiva
#### Diseño del Dashboard:

5 páginas especializadas con visualizaciones
Slicers sincronizados: Año, Tienda, Tipo
Paleta de colores corporativa Walmart 
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

##  INSIGHTS 

### 1.  Concentración de ingresos = riesgo operativo  
Solo el **22% de las tiendas genera el 39% de las ventas totales**, lo que revela una alta dependencia de pocas ubicaciones.  
Si una tienda clave deja de operar una semana, el impacto supera los **$5.8M**.  
Esta concentración representa **vulnerabilidad operativa** y **subutilización** del resto del portafolio.  
Diversificar las fuentes de ingreso e impulsar el rendimiento de las tiendas medianas podría generar más de **$800M adicionales** en ventas.  

### 2.  Q4 define el año fiscal  
El **cuarto trimestre concentra el 35% de las ventas anuales**, con diciembre aportando el 15%.  
En solo seis semanas (noviembre–diciembre) se genera casi una quinta parte del total anual.  
Esto evidencia una **fuerte dependencia estacional**: si Q4 falla, el resto del año no compensa.  
Walmart necesita **optimizar la ejecución operativa durante Q4** y **crear eventos de venta en los primeros trimestres** para equilibrar la demanda.  


### 3.  Festivos benefician solo a tiendas tipo A  
Durante semanas festivas, las ventas aumentan un **7%**, pero el beneficio no es uniforme:  
las **tiendas Tipo A crecen 35%**, mientras las **Tipo C apenas 17%**.  
Este desequilibrio genera una **pérdida estimada de $70M** por falta de aprovechamiento en formatos menores.  
Se requiere una **estrategia diferenciada por tipo de tienda** que potencie las oportunidades de los formatos B y C.  


### 4.  Factores externos no determinan resultados  
Las variables externas como **clima, combustible o economía** tienen una correlación menor al **5% con las ventas**.  
Esto demuestra que el desempeño de Walmart depende principalmente de su **ejecución interna**.  
En lugar de justificar resultados con condiciones macroeconómicas, la empresa debe **enfocar su análisis en operaciones, promociones y experiencia del cliente**, donde realmente puede influir.  


### 5.  Tiendas tipo C: el formato más eficiente  
Las tiendas pequeñas (**Tipo C**) generan **51% más ventas por pie cuadrado** que las grandes (**Tipo A**), con una inversión inicial tres veces menor.  
Ejemplos como la **Tienda #43**, que alcanza **$90M anuales con espacio limitado**, confirman su eficiencia.  
Este formato representa una **oportunidad estratégica** para expandirse en zonas urbanas con alta densidad y menor costo operativo.  


### 6.  Alta volatilidad en tiendas grandes  
Las tiendas de alto volumen presentan una **variabilidad de ventas tres veces superior al promedio**.  
Esto aumenta el riesgo de **quiebres de stock o exceso de inventario**, generando costos innecesarios.  
La complejidad operativa en estos establecimientos exige **sistemas de pronóstico más precisos** y **políticas de inventario flexibles**.  
Ser grande no significa ser fácil de gestionar.  

## Recomendaciones
## 1. Programa de Mejora de Tiendas
Busca elevar el desempeño de las tiendas con bajo rendimiento replicando las prácticas exitosas de las mejores. Incluye diagnóstico de operaciones, implementación de mejoras piloto, capacitación del personal y posterior expansión de los resultados más efectivos al resto de las tiendas.

## 2. Estrategia de Temporada Alta
Orienta los esfuerzos para maximizar las ventas en el último trimestre del año mediante una planificación anticipada, refuerzo de inventario y personal, y campañas promocionales intensivas. También contempla la optimización de la experiencia del cliente y acciones de fidelización tras la temporada.

## 3. Programa de Ventas Festivas
Tiene como objetivo incrementar las ventas durante los periodos festivos con estrategias adaptadas a cada tipo de tienda. Combina promociones atractivas, marketing local y experiencias diferenciadas para los clientes, impulsando tanto el tráfico como la rentabilidad.

## 4. Estrategia de Expansión de Formato
Propone el desarrollo de un nuevo modelo de tienda más compacto y eficiente, enfocado en ubicaciones urbanas de alta densidad. Este formato prioriza productos esenciales y de alta rotación, permitiendo ampliar la cobertura del negocio con menor inversión y tiempos de apertura más cortos.

### 5. Programa de Excelencia Operativa
Busca estandarizar procesos, mejorar la eficiencia y asegurar consistencia en la ejecución en todas las tiendas. Incluye auditorías, capacitación continua y adopción de mejores prácticas para fortalecer la cultura de mejora continua.

### 6. Estrategia de Desestacionalización Comercial
Pretende reducir la dependencia de la temporada alta mediante campañas temáticas durante todo el año. Sin embargo, se prioriza aprovechar la estacionalidad natural y usar los meses bajos para capacitación e innovación.

### 7. Sistema de Monitoreo Ejecutivo
Implementa una plataforma que permita visualizar en tiempo real los indicadores clave de ventas, inventario y desempeño operativo, facilitando decisiones ágiles y una gestión más eficiente en todos los niveles.

## 📈 Recomendaciones Ejecutivas

1. **Programa Top Store Replication:** replicar las mejores prácticas de las tiendas top (#20, #4, #14) en las tiendas de menor desempeño. Esto incluye capacitación del personal, optimización de merchandising y estrategias de clientela. El objetivo es incrementar las ventas promedio de las tiendas bottom 20 de $18M a $21M anuales.

2. **Optimización de Q4:** aumentar el inventario en preparación para la temporada alta, priorizando categorías de alto margen y ejecutando campañas de marketing anticipadas. Esto permitirá maximizar el 35% de las ventas anuales concentradas en los últimos tres meses del año y aumentar las ventas de Q4 de $2.3B a $2.5B.

3. **Estrategia de Festivos:** implementar un plan integral de pre, durante y post festivo, incluyendo campañas segmentadas, promociones flash, horarios extendidos y captación de clientes para remarketing. Esta estrategia busca incrementar las ventas en las 7 semanas festivas de $505M a $606M.

4. **Expansión de Formato Small Box:** replicar el modelo eficiente de tiendas tipo C en nuevas aperturas urbanas, optimizando el surtido de productos de alta rotación. El objetivo es lograr ventas superiores a $1,500 por pie cuadrado en nuevas tiendas dentro de los primeros 18 meses.

5. **Centro de Excelencia Operativa:** establecer un equipo permanente para estandarizar mejores prácticas, reducir ineficiencias y controlar costos operativos. Esto permitirá disminuir el costo operativo por venta de 18% a 16% y asegurar la consistencia en la ejecución de estrategias corporativas.

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
