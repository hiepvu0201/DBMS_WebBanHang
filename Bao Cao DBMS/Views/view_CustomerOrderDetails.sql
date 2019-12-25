-- Trả vê một view gồm join từ bốn bảng Customers, Orders, OrderDetails, Products

use SHOP_DBMS

GO

CREATE VIEW [dbo].[view_CustomerOrderDetails] AS
SELECT [o].[Id]  as OrderId, [OrderDate],
	   [c].[Id] as CustomerId, [c].[FristName], [c].[LastName], [c].[Phone], [c].[Email], [c].[Address], [c].[City], [c].[Note],
	   [od].[ProductId] as ProductId, [od].[Quantity],
	   [p].[Name] as ProductName, [p].[Price]
		FROM [dbo].[Orders] as o
		INNER JOIN [dbo].[Customers] as c
		ON [c].[Id] = [o].[CustomerId]
		INNER JOIN [dbo].[OrderDetails] as od
		ON [od].[OrderId] = [o].[Id]
		INNER JOIN [dbo].[Products] as p
		ON [od].[ProductId] = [p].[Id]

GO

-- EXEC
SELECT * FROM [dbo].[view_CustomerOrderDetails]