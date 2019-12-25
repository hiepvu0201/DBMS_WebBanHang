-- Trả về một user

use SHOP_DBMS;

GO
-- Get User By Username
create procedure [dbo].[GetUserByUserName]  
(  
	@Username varchar(255)
)  
As  
BEGIN  
	 SELECT * FROM [dbo].[Users] as u
	 WHERE [u].[Username] = @Username
END

-- EXEC
EXEC [dbo].[GetUserByUserName] @Username = "hayha19"

