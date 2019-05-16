USE Northwind
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manelisi Phezile Nodada
-- Create date: 2019/05/14
-- Description:	Get summary of orders.
-- =============================================
ALTER PROCEDURE pr_GetOrderSummary
	
@StartDate	DATETIME = '1 Jan 1996',
@EndDate	DATETIME = '31 Aug 1996',
@EmpoyeeID	INT		 = NULL,
@CustomerID NCHAR(5) = 'VINET'
AS
BEGIN
	
	SET NOCOUNT ON;

	IF OBJECT_ID(N'tempdb..#CustomerOrderDetails', N'U') IS NOT NULL 
	BEGIN 
       DROP TABLE #CustomerOrderDetails; 
	END

	IF OBJECT_ID(N'tempdb..#CustomerOrdersCount', N'U') IS NOT NULL  
	BEGIN
       DROP TABLE #CustomerOrdersCount; 
	END

	IF OBJECT_ID(N'tempdb..#OrdersTotalCost', N'U') IS NOT NULL  
	BEGIN
       DROP TABLE #OrdersTotalCost; 
	END

	IF OBJECT_ID(N'tempdb..#Anthropology', N'U') IS NOT NULL
	BEGIN  
       DROP TABLE #Anthropology; 
	END
	
	IF OBJECT_ID(N'tempdb..#DifferentProductsOrderCount', N'U') IS NOT NULL  
	BEGIN
       DROP TABLE #DifferentProductsOrderCount; 
	END

	IF OBJECT_ID(N'tempdb..#DifferentProductsOrderCount1', N'U') IS NOT NULL  
	BEGIN
       DROP TABLE #DifferentProductsOrderCount1; 
	END

	CREATE TABLE #CustomerOrderDetails(Id							INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
									   CustomerId					NCHAR(5),
									   EmployeeId					INT,
									   OrderId						INT,
									   EmployeeFullName				VARCHAR(100),
									   ShipperCompanyName			VARCHAR(100),
									   CustomerCompanyName			VARCHAR(100),
									   NumberOfOrders				INT,
									   [Date]						DATETIME,
									   TotalFreightCost				NUMERIC,
									   NumberOfDifferentProducts	INT,
									   TotalOrderValue				NUMERIC)

	CREATE TABLE #CustomerOrdersCount(CustomerId				NCHAR(5),
									NumberOfOrders				INT)

    CREATE TABLE #DifferentProductsOrderCount(OrderId				NCHAR(5),
											  ProductId				INT)

    CREATE TABLE #DifferentProductsOrderCount1(OrderId					NCHAR(5),
											  NumberOfDifferentProducts	INT)

    CREATE TABLE #OrdersTotalCost(OrderId						INT,
								  TotalCost						Numeric)

    INSERT INTO #CustomerOrderDetails(CustomerId, OrderId, EmployeeId, EmployeeFullName, ShipperCompanyName, CustomerCompanyName, [Date])									
	SELECT	c.CustomerID														'CustomerID',
			o.OrderID															'OrderID',
			emp.EmployeeID														'EmployeeID',
			emp.TitleOfCourtesy +' '+emp.FirstName +' '+ emp.LastName			'Employee FullName',
			s.CompanyName														'Shipper CompanyName',
			c.CompanyName														'Customer CompanyName',
			o.OrderDate															'OrderDate'
	FROM Employees emp
		INNER JOIN Orders		o ON emp.EmployeeID = o.EmployeeID
		INNER JOIN Shippers		s ON s.ShipperID	= o.ShipVia
		INNER JOIN Customers	c ON c.CustomerID	= o.CustomerID
		
	INSERT INTO #CustomerOrdersCount(CustomerId, NumberOfOrders)
	SELECT cod.CustomerId, COUNT(cod.CustomerId) 	
	FROM #CustomerOrderDetails cod
	INNER JOIN Orders  o ON o.CustomerID = cod.CustomerId
	GROUP BY cod.CustomerId
	
	UPDATE cod
	SET cod.NumberOfOrders = coc.NumberOfOrders
	FROM #CustomerOrderDetails cod
	INNER JOIN #CustomerOrdersCount coc ON coc.CustomerId = cod.CustomerId

	INSERT INTO #OrdersTotalCost(OrderId, TotalCost)
	SELECT [OrderID],
      SUM(UnitPrice * Quantity - Discount)
	FROM [Northwind].[dbo].[Order Details]
	GROUP BY OrderID
	
	UPDATE cod
	SET cod.TotalFreightCost = otc.TotalCost
	FROM #CustomerOrderDetails cod
	INNER JOIN #OrdersTotalCost otc ON otc.OrderId = cod.OrderId


    UPDATE cod
	SET cod.TotalOrderValue = otc.TotalCost
	FROM #CustomerOrderDetails cod
	INNER JOIN #OrdersTotalCost otc ON otc.OrderId = cod.OrderId
	
	INSERT INTO #DifferentProductsOrderCount(OrderId, ProductId)
	SELECT DISTINCT [OrderID], ProductID
	FROM [Northwind].[dbo].[Order Details]
	
	INSERT INTO #DifferentProductsOrderCount1(OrderId, NumberOfDifferentProducts)
	SELECT OrderId, COUNT(ProductId) 
	FROM #DifferentProductsOrderCount
	GROUP BY OrderId

	UPDATE cod
	SET cod.NumberOfDifferentProducts = dpoc.NumberOfDifferentProducts
	FROM #CustomerOrderDetails cod
	INNER JOIN #DifferentProductsOrderCount1 dpoc ON dpoc.OrderId = cod.OrderId
	
	SELECT	cod.EmployeeFullName						'Employee Full Name', 
			cod.ShipperCompanyName						'Shipper Company Name', 
			cod.CustomerCompanyName						'Customer Company Name', 
			cod.NumberOfOrders							'Number Of Orders', 
			cod.[Date]									'Oder Date',
			cod.TotalFreightCost						'Total Freight Cost', 
			cod.NumberOfDifferentProducts				'Number Of Differenct Products', 
			cod.TotalOrderValue							'Total Order Value'
	FROM #CustomerOrderDetails cod
	WHERE ((@EmpoyeeID IS NOT NULL AND @EmpoyeeID = cod.EmployeeId) OR @EmpoyeeID IS NULL) 
		  AND ((@CustomerID IS NOT NULL AND @CustomerID = cod.CustomerId) OR @CustomerID IS NULL)
		  AND (cod.[Date] BETWEEN @StartDate AND @EndDate)
    GROUP BY	cod.[Date], 
				EmployeeId, 
				cod.CustomerId, 
				cod.ShipperCompanyName, 
				cod.EmployeeFullName, 
				cod.CustomerCompanyName, 
				cod.NumberOfOrders, 
				cod.[Date],
				cod.TotalFreightCost, 
				cod.NumberOfDifferentProducts, 
				cod.TotalOrderValue 
END
GO