-- Tạo mới một customer

use SHOP_DBMS

GO

-- Insert Customer
create procedure [dbo].[InsertCustomer]  
(  
    @FirstName varchar(50),  
	@LastName varchar(50),
	@Phone varchar(50),
	@Email varchar(255),
	@Address varchar(255),
    @City varchar(100),  
    @Note varchar(255)
)  
As  
BEGIN  
	INSERT INTO Customers(FristName, LastName, Phone, Email, Address, City, Note)  
	VALUES(@FirstName,@LastName, @Phone, @Email, @Address, @City, @Note)  
	SELECT SCOPE_IDENTITY()
END

-- EXEC
EXEC [dbo].[InsertCustomer] @FirstName = "ABC", @LastName="ABC", @Phone="111-111-1111", @Email="aaa@gmail.com", @Address="USA", @City="USA", @Note="a"