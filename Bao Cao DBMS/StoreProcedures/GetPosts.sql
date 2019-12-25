-- Trả về danh sách post (Tìm kiếm, phân trang, sắp xếp)

-- GET POSTS
create procedure [dbo].[GetPosts]  
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
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE CHARINDEX(@SearchValue, [p].[Title]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

-- EXEC
EXEC[dbo].[GetPosts] @SearchValue = null, @SortOrderName="name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetPosts] @SearchValue = "abc", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5