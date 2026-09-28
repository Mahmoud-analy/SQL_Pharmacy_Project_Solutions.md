# Pharmacy Sales Analysis - SQL Server

تحليل مبيعات صيدليات أوروبية باستخدام **Microsoft SQL Server (T-SQL)**، على قاعدة بيانات مصممة بنظام **Star Schema** (جدول حقائق + 3 جداول أبعاد).

## هيكل البيانات

| الجدول | النوع | الوصف |
|---|---|---|
| `FactSales` | Fact | المعاملات (62,139 صف): الكمية، الإيراد، التكلفة، الهامش، العرض |
| `DimDate` | Dimension | التواريخ (السنة، الربع، الشهر) |
| `DimPharmacy` | Dimension | الصيدليات (الدولة، المدينة، النوع) |
| `DimProduct` | Dimension | المنتجات (الفئة، العلامة التجارية، جنيس/براند) |

**العلاقات:** `FactSales.DateKey → DimDate` · `FactSales.PharmacyID → DimPharmacy` · `FactSales.ProductID → DimProduct`

**المصدر:** [European Pharmacy Sales Dataset - Kaggle](https://www.kaggle.com/datasets/ehmadali/eu-pharmacy-products-and-pricing)

---

## Q1: What is the total revenue and total units sold?
```sql
SELECT
    SUM(UnitsSold) AS total_units,
    SUM(RevenueEUR) AS total_revenue
FROM FactSales;
```
**النتيجة:** 445,793 وحدة، وإيراد 8,621,701.90 يورو

## Q2: How many pharmacies are there per country?
```sql
SELECT Country, COUNT(PharmacyName) AS num_pharmacy
FROM DimPharmacy
GROUP BY Country
ORDER BY num_pharmacy DESC;
```
**النتيجة:** Germany (22) ← France (20) ← Italy (18)

## Q3: Which products are discontinued?
```sql
SELECT ProductName
FROM DimProduct
WHERE IsDiscontinued = 1;
```
`IsDiscontinued` من نوع `BIT` (1 = متوقف).

## Q4: What is the total revenue per country?
```sql
SELECT D.Country, SUM(F.RevenueEUR) AS total_revenue
FROM DimPharmacy AS D
INNER JOIN FactSales AS F
    ON D.PharmacyID = F.PharmacyID
GROUP BY D.Country
ORDER BY total_revenue DESC;
```
**النتيجة:** Germany (1,563,603.95) ← France (1,406,811.74) ← Italy (1,332,155.51)

## Q5: Which product category generates the most revenue?
```sql
SELECT G.Category, SUM(F.RevenueEUR) AS most_revenue
FROM DimProduct AS G
INNER JOIN FactSales AS F
    ON G.ProductID = F.ProductID
GROUP BY G.Category
ORDER BY most_revenue DESC;
```
**النتيجة:** Prescription (2,784,740.35) ثم OTC ثم Wellness

## Q6: What is the average margin per product?
```sql
SELECT ProductID, AVG(MarginEUR) AS average_margin
FROM FactSales
GROUP BY ProductID
ORDER BY average_margin DESC;
```
**النتيجة:** المنتج PR0025 الأعلى بمتوسط هامش 99.89

## Q7: Which pharmacy has the highest total sales?
```sql
-- بالإيراد
SELECT PharmacyID, SUM(RevenueEUR) AS total_sales
FROM FactSales
GROUP BY PharmacyID
ORDER BY total_sales DESC;

-- بالكمية
SELECT PharmacyID, SUM(UnitsSold) AS total_units
FROM FactSales
GROUP BY PharmacyID
ORDER BY total_units DESC;
```
**النتيجة:** الأعلى إيرادًا PH0095 (162,320.29)، والأعلى كمية PH0078 (7,774 وحدة). الترتيب بيختلف حسب تعريف "Sales".

## Q8: What is the monthly revenue trend?
```sql
SELECT DD.YearMonth, SUM(F.RevenueEUR) AS monthly_revenue
FROM DimDate AS DD
INNER JOIN FactSales AS F
    ON DD.DateKey = F.DateKey
GROUP BY DD.YearMonth
ORDER BY DD.YearMonth ASC;
```
ترتيب زمني من 2024-01 لحد 2025-12. الإيراد الشهري بيتذبذب حوالين 330 ألف - 390 ألف يورو.

## Q9: What percentage of sales had a promo applied?
```sql
SELECT
    ROUND(SUM(CAST(PromoFlag AS INT)) * 100.0 / COUNT(*), 2) AS percentage_promo
FROM FactSales;
```
**النتيجة:** 11.96%

## Q10: Which is more profitable on average: generic or branded?
```sql
SELECT D.IsGeneric, AVG(F.MarginEUR) AS AverageMargin
FROM DimProduct AS D
INNER JOIN FactSales AS F
    ON D.ProductID = F.ProductID
GROUP BY D.IsGeneric;
```
`IsGeneric = 1` يعني Generic، و`0` يعني Branded.

**النتيجة:** Branded (40.15) أعلى من Generic (32.64)

## Q11: Products sold in Italy but never sold in Austria (EXCEPT)
```sql
SELECT F.ProductID
FROM FactSales AS F
INNER JOIN DimPharmacy AS D
    ON F.PharmacyID = D.PharmacyID
WHERE D.Country = 'Italy'

EXCEPT

SELECT F.ProductID
FROM FactSales AS F
INNER JOIN DimPharmacy AS D
    ON F.PharmacyID = D.PharmacyID
WHERE D.Country = 'Austria';
```
**النتيجة:** منتج واحد فقط: PR0152

## Q12: Pharmacies that sell both OTC and Medical Devices (INTERSECT)
```sql
SELECT F.PharmacyID
FROM FactSales AS F
INNER JOIN DimProduct AS DP
    ON F.ProductID = DP.ProductID
WHERE DP.Category = 'OTC'

INTERSECT

SELECT F.PharmacyID
FROM FactSales AS F
INNER JOIN DimProduct AS DP
    ON F.ProductID = DP.ProductID
WHERE DP.Category = 'Medical Devices';
```

---

## المفاهيم المستخدمة
`Star Schema` · `INNER JOIN` · `GROUP BY` · `Aggregate Functions` · `CAST` · `BIT` · `Set Operators (EXCEPT, INTERSECT)` · `ORDER BY`
