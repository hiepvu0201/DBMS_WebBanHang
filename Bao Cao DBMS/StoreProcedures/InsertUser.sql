-- TẠO MỚI MỘT USER
use SHOP_DBMS

GO
-- INSERT USER
create procedure [dbo].[InsertUser]  
(  
    @Name varchar(255),  
	@Username varchar(255),
	@PasswordHash varbinary(MAX),
	@PasswordSalt varbinary(MAX)
)  
As  
BEGIN  
	 INSERT INTO [dbo].[Users](Name, Username, PasswordHash, PasswordSalt)  
	 VALUES(@Name, @Username, @PasswordHash, @PasswordSalt)
END
