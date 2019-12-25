using backend.Helpers;
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
    public class CatalogRepository : ICatalogRepository
    {

        IConfiguration _configuration { get; }
        private string connectionString;

        public CatalogRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<long> Add(Catalog catalog)
        {
            long id = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[InsertCatalog]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Name", catalog.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(catalog.Name));
                command.Parameters.AddWithValue("@Visibility", catalog.Visibility);
                command.Parameters.AddWithValue("@ProductCount", catalog.ProductCount);
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
                SqlCommand command = new SqlCommand("[DeleteCatalog]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                rowAffected = await command.ExecuteNonQueryAsync();
                con.Close();
            }
            return rowAffected;
        }

        public async Task<int> Edit(Catalog catalog)
        {
            int rowAffected = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[UpdateCatalog]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", catalog.Id);
                command.Parameters.AddWithValue("@Name", catalog.Name);
                command.Parameters.AddWithValue("@Slug", SlugUrlHelper.Slugify(catalog.Name));
                command.Parameters.AddWithValue("@Visibility", catalog.Visibility);
                command.Parameters.AddWithValue("@ProductCount", catalog.ProductCount);
                command.Parameters.AddWithValue("@CreatedAt", catalog.CreatedAt);
                command.Parameters.AddWithValue("@UpdatedAt", DateTime.Now);

                rowAffected = await command.ExecuteNonQueryAsync();

                con.Close();
            }
            return rowAffected;
        }

        public async Task<Catalog> GetOneById(long id)
        {
            Catalog catalog = new Catalog();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetCatalog]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Id", id);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();
                
                if (await dataReader.ReadAsync())
                {
                    catalog.Id = Convert.ToInt64(dataReader["Id"]);
                    catalog.Name = dataReader["Name"].ToString();
                    catalog.Slug = dataReader["Slug"].ToString();
                    catalog.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    catalog.ProductCount = Convert.ToInt32(dataReader["ProductCount"]);
                    catalog.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    catalog.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());
                }

                con.Close();
            }
            return catalog;
        }

        public async Task<List<Catalog>> GetAll(QueryOptions queryOptions)
        {
            List<Catalog> catalogList = new List<Catalog>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCatalogs", con);
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
                    Catalog catalog = new Catalog();
                    catalog.Id = Convert.ToInt64(dataReader["Id"]);
                    catalog.Name = dataReader["Name"].ToString();
                    catalog.Slug = dataReader["Slug"].ToString();
                    catalog.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    catalog.ProductCount = Convert.ToInt32(dataReader["ProductCount"]);
                    catalog.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    catalog.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());

                    catalogList.Add(catalog);
                }

                con.Close();
            }
            return catalogList;
        }

        public async Task<int> GetCount()
        {
            int count = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetCatalogCount]", con);
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

        public async Task<List<Catalog>> GetAllWeb()
        {
            List<Catalog> catalogList = new List<Catalog>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCatalogsWeb", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                while (await dataReader.ReadAsync())
                {
                    Catalog catalog = new Catalog();
                    catalog.Id = Convert.ToInt64(dataReader["Id"]);
                    catalog.Name = dataReader["Name"].ToString();
                    catalog.Slug = dataReader["Slug"].ToString();
                    catalog.Visibility = Convert.ToBoolean(dataReader["Visibility"]);
                    catalog.ProductCount = Convert.ToInt32(dataReader["ProductCount"]);
                    catalog.CreatedAt = DateTime.Parse(dataReader["CreatedAt"].ToString());
                    catalog.UpdatedAt = DateTime.Parse(dataReader["UpdatedAt"].ToString());

                    catalogList.Add(catalog);
                }

                con.Close();
            }
            return catalogList;
        }
    }
}
