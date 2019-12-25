-- Trả ra danh sách khách hàng đã order

-- Get Customer Orders
create procedure [dbo].[GetCustomerOrders]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM [dbo].[view_CustomerOrders] as c
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[OrderId] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[OrderId] END,
					CASE WHEN @SortOrderName = 'FristName' AND @SortOrder = 'DESC' THEN [c].[FristName] END DESC,
					CASE WHEN @SortOrderName = 'FristName' THEN [c].[FristName] END,
					CASE WHEN @SortOrderName = 'LastName' AND @SortOrder = 'DESC' THEN [c].[LastName] END DESC,
					CASE WHEN @SortOrderName = 'LastName' THEN [c].[LastName] END,
					CASE WHEN @SortOrderName = 'Email' AND @SortOrder = 'DESC' THEN [c].[Email] END DESC,
					CASE WHEN @SortOrderName = 'Email' THEN [c].[Email] END,
					CASE WHEN @SortOrderName = 'City' AND @SortOrder = 'DESC' THEN [c].[City] END DESC,
					CASE WHEN @SortOrderName = 'City' THEN [c].[City] END,
					CASE WHEN @SortOrderName = 'OrderDate' AND @SortOrder = 'DESC' THEN [c].[OrderDate] END DESC,
					CASE WHEN @SortOrderName = 'OrderDate' THEN [c].[OrderDate] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[view_CustomerOrders] as c
			WHERE CHARINDEX(@SearchValue, [c].[FristName]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[OrderId] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[OrderId] END,
					CASE WHEN @SortOrderName = 'FristName' AND @SortOrder = 'DESC' THEN [c].[FristName] END DESC,
					CASE WHEN @SortOrderName = 'FristName' THEN [c].[FristName] END,
					CASE WHEN @SortOrderName = 'LastName' AND @SortOrder = 'DESC' THEN [c].[LastName] END DESC,
					CASE WHEN @SortOrderName = 'LastName' THEN [c].[LastName] END,
					CASE WHEN @SortOrderName = 'Email' AND @SortOrder = 'DESC' THEN [c].[Email] END DESC,
					CASE WHEN @SortOrderName = 'Email' THEN [c].[Email] END,
					CASE WHEN @SortOrderName = 'City' AND @SortOrder = 'DESC' THEN [c].[City] END DESC,
					CASE WHEN @SortOrderName = 'City' THEN [c].[City] END,
					CASE WHEN @SortOrderName = 'OrderDate' AND @SortOrder = 'DESC' THEN [c].[OrderDate] END DESC,
					CASE WHEN @SortOrderName = 'OrderDate' THEN [c].[OrderDate] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

-- EXEC
EXEC[dbo].[GetCustomerOrders] @SearchValue = null, @SortOrderName="Id", @SortOrder="desc", @CurrentPage=1, @PageSize=5