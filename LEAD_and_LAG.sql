/*
Create a query with the following columns:
-“PurchaseOrderID” from the Purchasing.PurchaseOrderHeader table
-“OrderDate” from the Purchasing.PurchaseOrderHeader table
-“TotalDue” from the Purchasing.PurchaseOrderHeader table
-“Name” from the Purchasing.Vendor table, which can be aliased as “VendorName”

Find orders that took place after 2013 where the total due is greater than $500.
*/

SELECT 
	  PurchaseOrderID,
    OrderDate,
    TotalDue,
	  VendorName = B.Name
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
JOIN AdventureWorks2019.Purchasing.Vendor B
    ON A.VendorID = B.BusinessEntityID
WHERE YEAR(A.OrderDate) >= 2013
	AND A.TotalDue > 500


/*
Modify the previous query and add a derived column that returns the 
“previous” TotalDue value (relative to the current row) within the group of all orders with the same vendor ID. 
We are defining “previous” based on order date.
*/

SELECT 
    PurchaseOrderID,
    OrderDate,
    TotalDue,
	  VendorName = B.Name,
	  PrevOrderFromVendorAmt = LAG(A.TotalDue) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
  JOIN AdventureWorks2019.Purchasing.Vendor B
    ON A.VendorID = B.BusinessEntityID
WHERE YEAR(A.OrderDate) >= 2013
	AND A.TotalDue > 500
ORDER BY A.VendorID, A.OrderDate


/*
Modify the previous query and add a derived colum “next” vendor name 
(the “name” field from Purchasing.Vendor) within the group of all orders 
that have the same EmployeeID value in Purchasing.PurchaseOrderHeader. 
Similar to the last exercise, we are defining “next” based on order date.
*/

SELECT 
	  PurchaseOrderID, 
    OrderDate, 
    TotalDue,
	  VendorName = B.Name,
	  PrevOrderFromVendorAmt = LAG(A.TotalDue) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate),
	  NextOrderByEmployeeVendor = LEAD(B.Name) OVER(PARTITION BY A.EmployeeID ORDER BY A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
  JOIN AdventureWorks2019.Purchasing.Vendor B
    ON A.VendorID = B.BusinessEntityID
WHERE YEAR(A.OrderDate) >= 2013
	AND A.TotalDue > 500
ORDER BY A.EmployeeID, A.OrderDate


/*
Modify your query from Exercise 3 by adding a derived column called "Next2OrderByEmployeeVendor" that returns, 
within the group of all orders that have the same EmployeeID, the vendor name offset TWO orders into the “future” 
relative to the order in the current row.
*/

SELECT 
	  PurchaseOrderID,
    OrderDate,
    TotalDue,
	  VendorName = B.Name,
	  PrevOrderFromVendorAmt = LAG(A.TotalDue) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate),
	  NextOrderByEmployeeVendor = LEAD(B.Name) OVER(PARTITION BY A.EmployeeID ORDER BY A.OrderDate),
	  Next2OrderByEmployeeVendor = LEAD(B.Name,2) OVER(PARTITION BY A.EmployeeID ORDER BY A.OrderDate)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
  JOIN AdventureWorks2019.Purchasing.Vendor B
    ON A.VendorID = B.BusinessEntityID
WHERE YEAR(A.OrderDate) >= 2013
	AND A.TotalDue > 500
ORDER BY A.EmployeeID, A.OrderDate