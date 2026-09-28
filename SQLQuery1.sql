/*drop table DimDate;
drop table DimPharmacy;
drop table DimProduct;
drop table FactSales;
drop table Pharmacy_data;*/
select * from DimDate;
select * from DimProduct;
select * from DimPharmacy;select * from FactSales;

--total revenue & total units
select 
sum(UnitsSold) as total_units ,
sum(RevenueEur) as total_Revenue
from FactSales;
--How many pharmacies are there per country?
select Country,
count(PharmacyName) as num_pharmacy 
from DimPharmacy
group by Country
order by num_pharmacy DESC;
--Which products are discontinued?
SELECT 
ProductName
from DimProduct
where IsDiscontinued = 1;
-- What is the total revenue per country?
select D.country,
sum(F.RevenueEUR) AS total_revenue
from	DimPharmacy as D
inner join FactSales as F
ON D.PharmacyID = F.PharmacyID
GROUP BY D.Country
order by total_revenue DESC
-- Which product category generates the most revenue?
SELECT G.Category,
sum(F.RevenueEUR) AS most_revenue
from DimProduct as G
INNER JOIN FactSales as F
ON G.ProductID = F.ProductID
GROUP BY Category
ORDER BY  most_revenue DESC;
--What is the average margin per product?
/*select F.ProductID,
AVG(F.RevenueEUR) as average_margin
FROM FactSales as F
inner join DimPharmacy as D
on F.PharmacyID = D.PharmacyID
group by F.ProductID
order by average_margin desc;*/
select 
ProductID,
AVG(MarginEUR) AS average_margin
from FactSales
group by ProductID
order by average_margin desc;
--Which pharmacy has the highest total sales?
-- the highest total sales by quantity
select PharmacyID,
sum(UnitsSold) as highest_totalsales
from FactSales
group by PharmacyID
order by highest_totalsales desc;
---- the highest total sales by money
SELECT 
    PharmacyID,
    SUM(RevenueEUR) AS highest_totalsales
FROM FactSales
GROUP BY PharmacyID
ORDER BY highest_totalsales DESC;
-- What is the monthly revenue trend (by YearMonth)?
select DD.YearMonth,
SUM(F.RevenueEUR) AS MONTHLY_REVENUE
FROM DimDate as DD
inner join FactSales as F
ON DD.DateKey = F.DateKey
group by DD.YearMonth
ORDER BY DD.YearMonth ;
-- What percentage of sales had a promo applied?
SELECT 
round(sum(cast(PromoFlag as int)) * 100.0 /count(*) , 2) as percentage_promoapplied
from FactSales
--Which is more profitable on average: generic or branded products?
select * from DimProduct;
select * from FactSales;
select * from DimPharmacy;
select D.IsGeneric,
AVG(F.MarginEUR) AS AVERAGEPRODUCT
FROM DimProduct as D
inner join FactSales as F
ON D.ProductID = F.ProductID
group by D.IsGeneric
-- Find products sold in Italy but never sold in Austria (EXCEPT)
select F.ProductID
FROM FactSales as F
inner join DimPharmacy as D
ON F.PharmacyID = D.PharmacyID
WHERE D.Country ='Italy'
except
select F.ProductID
FROM FactSales as F
inner join DimPharmacy as D
ON F.PharmacyID = D.PharmacyID
WHERE Country = 'Austria'
--Find pharmacies that sell both OTC and Medical Devices products (INTERSECT logic)
select * from DimProduct;
select * from FactSales;
select * from DimPharmacy;
SELECT F.PharmacyID
FROM FactSales as F
INNER JOIN DimProduct as DP
ON F.ProductID = DP.ProductID
WHERE Category = 'OTC'
INTERSECT
SELECT F.PharmacyID
FROM FactSales as F
INNER JOIN DimProduct as DP
ON F.ProductID = DP.ProductID
WHERE  Category = 'Medical Devices'
