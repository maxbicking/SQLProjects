/*
The the CEO of Adventure Works decided that the top 10 orders per month are actually outliers 
that need to be clipped out of our data before doing meaningful analysis.

Further, she would like the sum of sales AND purchases (minus these "outliers") listed 
side by side, by month.
*/

WITH Sales AS ( --Create sales CTE with order date, order month, total due, and top orders per month ranked
SELECT 
    OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
    TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
),

SalesMinusTop10 AS ( --Create a CTE that contains all but top 10 orders per month
SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
FROM Sales
WHERE OrderRank > 10
GROUP BY OrderMonth
),

Purchases AS ( --Similar CTE for purchases, enables us to later analyze profit
SELECT 
    OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
    TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
),

PurchasesMinusTop10 AS (
SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
FROM Purchases
WHERE OrderRank > 10
GROUP BY OrderMonth
)

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM SalesMinusTop10 A --Join CTEs together, creating a table of sales and purchases by month
	JOIN PurchasesMinusTop10 B
		ON A.OrderMonth = B.OrderMonth
ORDER BY 1