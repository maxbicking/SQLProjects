/*
Using the Purchasing.PurchaseOrderHeader table, write a query that returns all records from the following columns:
-PurchaseOrderID
-VendorID
-OrderDate
-TotalDue

and a derived column that calculates, for each purchase order ID in the query output, 
the number of line items which did not have any rejections (i.e., RejectedQty = 0).

*/
SELECT 
	PurchaseOrderID,
    VendorID,
    OrderDate,
    TotalDue,
	NonRejectedItems = 
	  (
		  SELECT
			COUNT(*)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
	  )

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A


/*
Add a derived column to the previous query that returns the most expensive item in each PurchaseOrderID
*/

SELECT 
	PurchaseOrderID,
    VendorID,
    OrderDate,
    TotalDue,
	NonRejectedItems = 
	  (
		  SELECT
			COUNT(*)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
	  ),
	  MostExpensiveItem = 
	  (
		  SELECT
			MAX(B.UnitPrice)
		  FROM Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
	  )
	  
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

