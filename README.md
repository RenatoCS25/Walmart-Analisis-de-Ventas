# 📊 Walmart Sales Analysis

![Dashboard Overview](images/dashboard_preview.png)

Análisis de $6.7 mil millones en ventas de Walmart (Feb 2010 - Oct 2012) usando SQL Server y Power BI.

---

## 🎯 Objetivo

Identificar patrones de ventas, estacionalidad y factores que impactan el desempeño de 45 tiendas para optimizar inventario, staffing y estrategias promocionales.

---

## 💡 Hallazgos Clave

- 📈 Top 10 tiendas concentran **42% de las ventas totales**
- 🎄 Días festivos generan **22-28% más ventas** que semanas regulares
- 📅 **Julio** es el mes pico (no diciembre como se esperaba)
- 🏪 Tiendas tipo A promedian **$1.8M** vs **$1.2M** del tipo C
- 🌡️ Factores internos (promociones) tienen más impacto que externos (clima)

---

## 🛠️ Stack Técnico

- **SQL Server:** Limpieza, transformación y análisis exploratorio
- **Power BI:** Dashboard interactivo con 30+ visualizaciones
- **DAX:** KPIs y medidas calculadas
- **GitHub:** Documentación y versionado

---

## 📊 Dashboard

### 5 Páginas de Análisis:

| Página | Descripción |
|--------|-------------|
| **Overview** | KPIs principales, evolución temporal, top tiendas |
| **Temporal** | Patrones estacionales, comparación año-año |
| **Festivos** | Impacto de días festivos por tienda |
| **Factores Externos** | Correlación temperatura, combustible, economía |
| **Tiendas** | Ranking, desempeño y análisis de consistencia |

<details>
<summary>📸 Ver capturas de pantalla</summary>

### Overview
![Overview](images/01_overview.png)

### Análisis Temporal
![Temporal](images/02_analisis_temporal.png)

### Días Festivos
![Festivos](images/03_dias_festivos.png)

### Factores Externos
![Factores](images/04_factores_externos.png)

### Análisis por Tienda
![Tiendas](images/05_analisis_tiendas.png)

</details>

---

## 📊 Dataset

**Fuente:** [Walmart Sales Forecasting - Kaggle](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

- 421,570 registros de ventas semanales
- 45 tiendas × ~99 departamentos
- Período: Feb 2010 - Oct 2012
- Variables: Ventas, Temperatura, Combustible, CPI, Desempleo

**Nota:** 2010 y 2012 son períodos parciales. Solo 2011 contiene 12 meses completos.

---
