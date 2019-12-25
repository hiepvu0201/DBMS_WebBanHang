-- Trả vê một view gồm join từ hai bảng Customers và Orders 

use SHOP_DBMS

GO

CREATE VIEW [dbo].[view_CustomerOrders] AS
SELECT [o].[Id]  as OrderId, [OrderDate],
	   [c].[Id] as CustomerId, [c].[FristName], [c].[LastName], [c].[Phone], [c].[Email], [c].[Address], [c].[City], [c].[Note]
FROM Customers as c
INNER JOIN Orders as o
ON c.Id = o.CustomerId


GO
-- TEST
SELECT * FROM [dbo].[view_CustomerOrders]