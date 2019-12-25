-- Trả về một post

use SHOP_DBMS

GO

-- GET POST BY ID
create procedure [dbo].[GetPost]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM [dbo].[Pots] as p
	INNER JOIN [dbo].[Categories] as c
	ON [p].[CategoryId] = c.Id
	WHERE [p].[Id] = @Id
END

--EXEC
EXEC[dbo].[GetPost] @Id = "1"