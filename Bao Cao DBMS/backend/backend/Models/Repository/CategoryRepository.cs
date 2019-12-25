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
    public class CategoryRepository: ICategoryRepository
    {
        IConfiguration _configuration { get; }
        private string connectionString;

        public CategoryRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<long> Add(Category category)
        {
            long id = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[InsertCategory]", con);
                command.CommandType = CommandType.StoredProcedure;
                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Name", category.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(category.Name));
                command.Parameters.AddWithValue("@Visibility", category.Visibility);
                command.Parameters.AddWithValue("@PostCount", category.PostCount);
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
                SqlCommand command = new SqlCommand("[DeleteCategory]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                con.Close();
                rowAffected = await command.ExecuteNonQueryAsync();
            }
            return rowAffected;
        }

        public async Task<int> Edit(Category category)
        {
            int rowAffected = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[UpdateCategory]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", category.Id);
                command.Parameters.AddWithValue("@Name", category.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(category.Name));
                command.Parameters.AddWithValue("@Visibility", category.Visibility);
                command.Parameters.AddWithValue("@PostCount", category.PostCount);
                command.Parameters.AddWithValue("@CreatedAt", category.CreatedAt);
                command.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                con.Close();
                rowAffected = await command.ExecuteNonQueryAsync();
            }

            return rowAffected;
        }

        public async Task<List<Category>> GetAll(QueryOptions queryOptions)
        {
            List<Category> categoryList = new List<Category>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCategories", con);
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
                    Category category = new Category();
                    category.Id = Convert.ToInt64(dataReader["Id"]);
                    category.Name = dataReader["Name"].ToString();
                    category.Slug = dataReader["Slug"].ToString();
                    category.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    category.PostCount = Convert.ToInt32(dataReader["PostCount"]);
                    category.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    category.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());

                    categoryList.Add(category);
                }

                con.Close();
            }

            return categoryList;
        }

        public async Task<int> GetCount()
        {
            int count = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetCategoryCount]", con);
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

        public async Task<Category> GetOneById(long id)
        {
            Category category = new Category();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetCategory]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                {
                    category.Id = Convert.ToInt64(dataReader["Id"]);
                    category.Name = dataReader["Name"].ToString();
                    category.Slug = dataReader["Slug"].ToString();
                    category.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    category.PostCount = Convert.ToInt32(dataReader["PostCount"]);
                    category.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    category.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());
                }

                con.Close();
            }
            return category;
        }

        public async Task<List<Category>> GetAllWeb()
        {
            List<Category> categoryList = new List<Category>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCategoriesWeb", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    Category category = new Category();
                    category.Id = Convert.ToInt64(dataReader["Id"]);
                    category.Name = dataReader["Name"].ToString();
                    category.Slug = dataReader["Slug"].ToString();
                    category.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    category.PostCount = Convert.ToInt32(dataReader["PostCount"]);
                    category.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    category.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());

                    categoryList.Add(category);
                }

                con.Close();
            }

            return categoryList;
        }
    }
}
