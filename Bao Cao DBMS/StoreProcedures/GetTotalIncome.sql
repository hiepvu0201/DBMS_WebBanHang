-- Trả về tổng thu nhập của trang web

use SHOP_DBMS

GO

-- GetTotalIncome
create procedure [dbo].[GetTotalIncome]    
As  
BEGIN  
	SELECT TotalIncome FROM [dbo].[func_TotalIncome]()
END 

-- EXEC
EXEC [dbo].[GetTotalIncome] 