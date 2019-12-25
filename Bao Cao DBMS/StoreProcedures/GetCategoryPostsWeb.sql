-- Trả về danh sách post với visibility = 1 và visibility category = 1 (phân trang, sắp xếp)

-- GET POSTS
create procedure [dbo].[GetCategoryPostsWeb]  
(  
	@CategoryName varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@CategoryName IS NULL)
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1 AND [c].[Id] = @CategoryName
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

-- EXEC
EXEC[dbo].[GetCategoryPostsWeb] @CategoryName = null, @SortOrderName="name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCategoryPostsWeb] @CategoryName = "1", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCategoryPostsWeb] @CategoryName = "2", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCategoryPostsWeb] @CategoryName = "10", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
