using backend.Helpers;
using backend.Models.IRepository;
using Microsoft.Extensions.Configuration;
using store.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Repository
{
    public class PostRepository :IPostRepository
    {
        IConfiguration _configuration { get; }
        private string connectionString;

        public PostRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<long> Add(Post post)
        {
            long id = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[InsertPost]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Title", post.Title);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(post.Title));
                command.Parameters.AddWithValue("@ShortDescription", post.ShortDescription);
                command.Parameters.AddWithValue("@Content", post.Content);
                command.Parameters.AddWithValue("@Image", post.Image);
                command.Parameters.AddWithValue("@Visibility", post.Visibility);
                command.Parameters.AddWithValue("@CategoryId", post.CategoryId);
                command.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                command.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                var obj = await command.ExecuteScalarAsync();
                id = Convert.ToInt64(obj);
                con.Close();
            } 
            return id;
        }

        public async Task<int> Delete(long id)
        {
            int rowAffected = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[DeletePost]", con);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Id", id);
                if (con.State == ConnectionState.Closed)
                    con.Open();

                rowAffected = await command.ExecuteNonQueryAsync();
            }
            return rowAffected;
        }

        public async Task<int> Edit(Post post)
        {
            int rowAffected = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[UpdatePost]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", post.Id);
                command.Parameters.AddWithValue("@Title", post.Title);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(post.Title));
                command.Parameters.AddWithValue("@ShortDescription", post.ShortDescription);
                command.Parameters.AddWithValue("@Content", post.Content);
                command.Parameters.AddWithValue("@Image", post.Image);
                command.Parameters.AddWithValue("@Visibility", post.Visibility);
                command.Parameters.AddWithValue("@CategoryId", post.CategoryId);
                command.Parameters.AddWithValue("@CreatedAt", post.CreatedAt);
                command.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                rowAffected = await command.ExecuteNonQueryAsync();
                con.Close();
            }


            return rowAffected;
        }

        public async Task<List<Post>> GetAll(QueryOptions queryOptions)
        {
            List<Post> postList = new List<Post>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetPosts", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@SearchValue", queryOptions.SearchValue);
                command.Parameters.AddWithValue("@SortOrderName", queryOptions.SortOrderName);
                command.Parameters.AddWithValue("@SortOrder", queryOptions.SortOrder);
                command.Parameters.AddWithValue("@CurrentPage", queryOptions.CurrentPage);
                command.Parameters.AddWithValue("@PageSize", queryOptions.PageSize);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    int index = 0;

                    Post post = new Post();
                    post.Id = dataReader.GetInt64(index++);
                    post.CategoryId = dataReader.GetInt64(index++);
                    post.Title = dataReader.GetString(index++);
                    post.Slug = dataReader.GetString(index++);
                    post.ShortDescription = dataReader.GetString(index++);
                    post.Content = dataReader.GetString(index++);
                    post.Image = dataReader.GetString(index++);
                    post.Visibility = dataReader.GetBoolean(index++);
                    post.CreatedAt = dataReader.GetDateTime(index++);
                    post.UpdatedAt = dataReader.GetDateTime(index++);

                    Category category = new Category();
                    category.Id = dataReader.GetInt64(index++);
                    category.Name = dataReader.GetString(index++);
                    category.Slug = dataReader.GetString(index++);
                    category.Visibility = dataReader.GetBoolean(index++);
                    category.PostCount = dataReader.GetInt32(index++);
                    category.CreatedAt = dataReader.GetDateTime(index++);
                    category.UpdatedAt = dataReader.GetDateTime(index++);
                    post.Category = category;

                    postList.Add(post);
                }

                con.Close();
            }

            return postList;
        }

        public async Task<int> GetCount()
        {
            int count = 0;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetPostCount]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlDataReader dataReader = await command.ExecuteReaderAsync();


                if (await dataReader.ReadAsync())
                {
                    count = Convert.ToInt32(dataReader["Total"]);
                }

                con.Close();
            }
               
            return count;
        }

        public async Task<Post> GetOneById(long id)
        {
            Post post = new Post();

            using (SqlConnection con = new SqlConnection(connectionString))
            {

                SqlCommand command = new SqlCommand("[GetPost]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                {
                    int index = 0;

                    post.Id = dataReader.GetInt64(index++);
                    post.CategoryId = dataReader.GetInt64(index++);
                    post.Title = dataReader.GetString(index++);
                    post.Slug = dataReader.GetString(index++);
                    post.ShortDescription = dataReader.GetString(index++);
                    post.Content = dataReader.GetString(index++);
                    post.Image = dataReader.GetString(index++);
                    post.Visibility = dataReader.GetBoolean(index++);
                    post.CreatedAt = dataReader.GetDateTime(index++);
                    post.UpdatedAt = dataReader.GetDateTime(index++);

                    Category category = new Category();
                    category.Id = dataReader.GetInt64(index++);
                    category.Name = dataReader.GetString(index++);
                    category.Slug = dataReader.GetString(index++);
                    category.Visibility = dataReader.GetBoolean(index++);
                    category.PostCount = dataReader.GetInt32(index++);
                    category.CreatedAt = dataReader.GetDateTime(index++);
                    category.UpdatedAt = dataReader.GetDateTime(index++);
                    post.Category = category;
                }

                con.Close();
            }
            return post;
        }

        public async Task<List<Post>> GetAllCategoryPostWeb(QueryOptions queryOptions)
        {
            List<Post> postList = new List<Post>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCategoryPostsWeb", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@CategoryName", queryOptions.SearchValue);
                command.Parameters.AddWithValue("@SortOrderName", queryOptions.SortOrderName);
                command.Parameters.AddWithValue("@SortOrder", queryOptions.SortOrder);
                command.Parameters.AddWithValue("@CurrentPage", queryOptions.CurrentPage);
                command.Parameters.AddWithValue("@PageSize", queryOptions.PageSize);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    int index = 0;

                    Post post = new Post();
                    post.Id = dataReader.GetInt64(index++);
                    post.CategoryId = dataReader.GetInt64(index++);
                    post.Title = dataReader.GetString(index++);
                    post.Slug = dataReader.GetString(index++);
                    post.ShortDescription = dataReader.GetString(index++);
                    post.Content = dataReader.GetString(index++);
                    post.Image = dataReader.GetString(index++);
                    post.Visibility = dataReader.GetBoolean(index++);
                    post.CreatedAt = dataReader.GetDateTime(index++);
                    post.UpdatedAt = dataReader.GetDateTime(index++);

                    Category category = new Category();
                    category.Id = dataReader.GetInt64(index++);
                    category.Name = dataReader.GetString(index++);
                    category.Slug = dataReader.GetString(index++);
                    category.Visibility = dataReader.GetBoolean(index++);
                    category.PostCount = dataReader.GetInt32(index++);
                    category.CreatedAt = dataReader.GetDateTime(index++);
                    category.UpdatedAt = dataReader.GetDateTime(index++);
                    post.Category = category;

                    postList.Add(post);
                }

                con.Close();
            }

            return postList;
        }
    }
}
