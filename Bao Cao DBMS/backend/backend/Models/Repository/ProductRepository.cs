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
    public class ProductRepository: IProductRepostiory
    {
        IConfiguration _configuration { get; }
        private string connectionString;

        public ProductRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<long> Add(Product product)
        {
            long id = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[InsertProduct]", con);
                command.CommandType = CommandType.StoredProcedure;
                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Name", product.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(product.Name));
                command.Parameters.AddWithValue("@ShortDescription", product.ShortDescription);
                command.Parameters.AddWithValue("@Description", product.Description);
                command.Parameters.AddWithValue("@Price", product.Price);
                command.Parameters.AddWithValue("@Image", product.Image);
                command.Parameters.AddWithValue("@Visibility", product.Visibility);
                command.Parameters.AddWithValue("@CatalogId", product.CatalogId);
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
                SqlCommand command = new SqlCommand("[DeleteProduct]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                rowAffected = await command.ExecuteNonQueryAsync();

                con.Close();
            }

            return rowAffected;
        }

        public async Task<int> Edit(Product product)
        {
            int rowAffected = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[UpdateProduct]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", product.Id);
                command.Parameters.AddWithValue("@Name", product.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(product.Name));
                command.Parameters.AddWithValue("@ShortDescription", product.ShortDescription);
                command.Parameters.AddWithValue("@Description", product.Description);
                command.Parameters.AddWithValue("@Price", product.Price);
                command.Parameters.AddWithValue("@Image", product.Image);
                command.Parameters.AddWithValue("@Visibility", product.Visibility);
                command.Parameters.AddWithValue("@CatalogId", product.CatalogId);
                command.Parameters.AddWithValue("@CreatedAt", product.CreatedAt);
                command.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                rowAffected = await command.ExecuteNonQueryAsync();
                con.Close();
            }
            return rowAffected;
        }

        public async Task<List<Product>> GetAll(QueryOptions queryOptions)
        {
            List<Product> productList = new List<Product>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetProducts", con);
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

                    Product product = new Product();
                    product.Id = dataReader.GetInt64(index++);
                    product.CatalogId = dataReader.GetInt64(index++);
                    product.Name = dataReader.GetString(index++);
                    product.Slug = dataReader.GetString(index++);
                    product.ShortDescription = dataReader.GetString(index++);
                    product.Description = dataReader.GetString(index++);
                    product.Image = dataReader.GetString(index++);
                    product.Price = dataReader.GetDecimal(index++);
                    product.Visibility = dataReader.GetBoolean(index++);
                    product.CreatedAt = dataReader.GetDateTime(index++);
                    product.UpdatedAt = dataReader.GetDateTime(index++);

                    Catalog catalog = new Catalog();
                    catalog.Id = dataReader.GetInt64(index++);
                    catalog.Name = dataReader.GetString(index++);
                    catalog.Slug = dataReader.GetString(index++);
                    catalog.Visibility = dataReader.GetBoolean(index++);
                    catalog.ProductCount = dataReader.GetInt32(index++);
                    catalog.CreatedAt = dataReader.GetDateTime(index++);
                    catalog.UpdatedAt = dataReader.GetDateTime(index++);
                    product.Catalog = catalog;

                    productList.Add(product);
                }
                con.Close();
            }

            return productList;
        }

        public async Task<List<Product>> GetAllCatalogProductWeb(QueryOptions queryOptions)
        {
            List<Product> productList = new List<Product>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCatalogProductsWeb", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@CatalogName", queryOptions.SearchValue);
                command.Parameters.AddWithValue("@SortOrderName", queryOptions.SortOrderName);
                command.Parameters.AddWithValue("@SortOrder", queryOptions.SortOrder);
                command.Parameters.AddWithValue("@CurrentPage", queryOptions.CurrentPage);
                command.Parameters.AddWithValue("@PageSize", queryOptions.PageSize);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    int index = 0;

                    Product product = new Product();
                    product.Id = dataReader.GetInt64(index++);
                    product.CatalogId = dataReader.GetInt64(index++);
                    product.Name = dataReader.GetString(index++);
                    product.Slug = dataReader.GetString(index++);
                    product.ShortDescription = dataReader.GetString(index++);
                    product.Description = dataReader.GetString(index++);
                    product.Image = dataReader.GetString(index++);
                    product.Price = dataReader.GetDecimal(index++);
                    product.Visibility = dataReader.GetBoolean(index++);
                    product.CreatedAt = dataReader.GetDateTime(index++);
                    product.UpdatedAt = dataReader.GetDateTime(index++);

                    Catalog catalog = new Catalog();
                    catalog.Id = dataReader.GetInt64(index++);
                    catalog.Name = dataReader.GetString(index++);
                    catalog.Slug = dataReader.GetString(index++);
                    catalog.Visibility = dataReader.GetBoolean(index++);
                    catalog.ProductCount = dataReader.GetInt32(index++);
                    catalog.CreatedAt = dataReader.GetDateTime(index++);
                    catalog.UpdatedAt = dataReader.GetDateTime(index++);
                    product.Catalog = catalog;

                    productList.Add(product);
                }
                con.Close();
            }
            return productList;
        }

        public async Task<int> GetCount()
        {
            int count = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetProductCount]", con);
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

        public async Task<Product> GetOneById(long id)
        {
            Product product = new Product();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetProduct]", con);
                command.CommandType = CommandType.StoredProcedure;
                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                {
                    int index = 0;

                    product.Id = dataReader.GetInt64(index++);
                    product.CatalogId = dataReader.GetInt64(index++);
                    product.Name = dataReader.GetString(index++);
                    product.Slug = dataReader.GetString(index++);
                    product.ShortDescription = dataReader.GetString(index++);
                    product.Description = dataReader.GetString(index++);
                    product.Image = dataReader.GetString(index++);
                    product.Price = dataReader.GetDecimal(index++);
                    product.Visibility = dataReader.GetBoolean(index++);
                    product.CreatedAt = dataReader.GetDateTime(index++);
                    product.UpdatedAt = dataReader.GetDateTime(index++);

                    Catalog catalog = new Catalog();
                    catalog.Id = dataReader.GetInt64(index++);
                    catalog.Name = dataReader.GetString(index++);
                    catalog.Slug = dataReader.GetString(index++);
                    catalog.Visibility = dataReader.GetBoolean(index++);
                    catalog.ProductCount = dataReader.GetInt32(index++);
                    catalog.CreatedAt = dataReader.GetDateTime(index++);
                    catalog.UpdatedAt = dataReader.GetDateTime(index++);
                    product.Catalog = catalog;
                }
                con.Close();
            }
            return product;
        }

        public async Task<List<Product>> GetAllProductHomeWeb()
        {
            List<Product> productList = new List<Product>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetProductsHomeWeb", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    int index = 0;

                    Product product = new Product();
                    product.Id = dataReader.GetInt64(index++);
                    product.CatalogId = dataReader.GetInt64(index++);
                    product.Name = dataReader.GetString(index++);
                    product.Slug = dataReader.GetString(index++);
                    product.ShortDescription = dataReader.GetString(index++);
                    product.Description = dataReader.GetString(index++);
                    product.Image = dataReader.GetString(index++);
                    product.Price = dataReader.GetDecimal(index++);
                    product.Visibility = dataReader.GetBoolean(index++);
                    product.CreatedAt = dataReader.GetDateTime(index++);
                    product.UpdatedAt = dataReader.GetDateTime(index++);

                    Catalog catalog = new Catalog();
                    catalog.Id = dataReader.GetInt64(index++);
                    catalog.Name = dataReader.GetString(index++);
                    catalog.Slug = dataReader.GetString(index++);
                    catalog.Visibility = dataReader.GetBoolean(index++);
                    catalog.ProductCount = dataReader.GetInt32(index++);
                    catalog.CreatedAt = dataReader.GetDateTime(index++);
                    catalog.UpdatedAt = dataReader.GetDateTime(index++);
                    product.Catalog = catalog;

                    productList.Add(product);
                }
                con.Close();
            }

            return productList;
        }
    }
}
