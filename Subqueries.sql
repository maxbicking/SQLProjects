/*
Write a query that displays the three most expensive orders, per vendor ID, 
from the Purchasing.PurchaseOrderHeader table. There should ONLY be three records 
per Vendor ID, even if some of the total amounts due are identical. "Most expensive" 
is defined by the amount in the "TotalDue" field.
*/

SELECT
	PurchaseOrderID,
	VendorID,
	OrderDate,
	TaxAmt,
	Freight,
	TotalDue
FROM (
	SELECT 
		PurchaseOrderID,
		VendorID,
		OrderDate,
		TaxAmt,
		Freight,
		TotalDue,
		PurchaseOrderRank = ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
) X
WHERE PurchaseOrderRank <= 3



/*
Modify your query from the first problem such that the top three purchase order AMOUNTS are returned, 
regardless of how many records are returned per Vendor Id.
*/

SELECT
	PurchaseOrderID,
	VendorID,
	OrderDate,
	TaxAmt,
	Freight,
	TotalDue
FROM (
	SELECT 
		PurchaseOrderID,
		VendorID,
		OrderDate,
		TaxAmt,
		Freight,
		TotalDue,
		PurchaseOrderRank = DENSE_RANK() OVER(PARTITION BY VendorID ORDER BY TotalDue DESC) --Use dense rank to get distinct rankings
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
) X
WHERE PurchaseOrderRank <= 3