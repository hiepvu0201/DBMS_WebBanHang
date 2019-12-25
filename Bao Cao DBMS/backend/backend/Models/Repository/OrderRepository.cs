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
    public class OrderRepository: IOrderRepository
    {
        IConfiguration _configuration { get; }
        private string connectionString;

        public OrderRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task CreateOrder(Bill bill)
        {
            Customer customer = new Customer
            {
                FirstName = bill.Customer.FirstName,
                LastName = bill.Customer.LastName,
                Phone = bill.Customer.Phone,
                Email = bill.Customer.Email,
                Address = bill.Customer.Address,
                City = bill.Customer.City,
                Note = bill.Customer.Note,
            };

            long idCustomer = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[InsertCustomer]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@FirstName", customer.FirstName);
                command.Parameters.AddWithValue("@LastName", customer.LastName);
                command.Parameters.AddWithValue("@Phone", customer.Phone);
                command.Parameters.AddWithValue("@Email", customer.Email);
                command.Parameters.AddWithValue("@Address", customer.Address);
                command.Parameters.AddWithValue("@City", customer.City);
                command.Parameters.AddWithValue("@Note", customer.Note);

                var obj = await command.ExecuteScalarAsync();
                idCustomer = Convert.ToInt64(obj);

                con.Close();
            }

            // Add Order
            Order order = new Order
            {
                OrderDate = DateTime.Now,
                CustomerId = idCustomer
            };

            long idOrder = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand commandOrder = new SqlCommand("[InsertOrder]", con);
                commandOrder.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                commandOrder.Parameters.AddWithValue("@CustomerId", order.CustomerId);
                commandOrder.Parameters.AddWithValue("@OrderDate", order.OrderDate);

                var obj = await commandOrder.ExecuteScalarAsync();
                idOrder = Convert.ToInt64(obj);

                con.Close();
            }

            var productSelections = bill.ProductSelections;
            foreach (ProductSelection p in productSelections)
            {

                OrderDetail orderDetails = new OrderDetail
                {
                    OrderId = idOrder,
                    ProductId = p.Id,
                    Quantity = p.quantity,
                };

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand commandOrderDetail = new SqlCommand("[InsertOrderDetail]", con);
                    commandOrderDetail.CommandType = CommandType.StoredProcedure;

                    if (con.State == ConnectionState.Closed)
                        con.Open();
                    commandOrderDetail.Parameters.AddWithValue("@OrderId", orderDetails.OrderId);
                    commandOrderDetail.Parameters.AddWithValue("@ProductId", orderDetails.ProductId);
                    commandOrderDetail.Parameters.AddWithValue("@Quantity", orderDetails.Quantity);

                    await commandOrderDetail.ExecuteNonQueryAsync();
                    con.Close();
                }
            }
        }

        public async Task<int> GetCount()
        {
            int count = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetOrderCount]", con);
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

        public async Task<List<BillDetail>> GetOrder(long orderId)
        {
            List<BillDetail> billDetailList = new List<BillDetail>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetOrderDetail]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@OrderId", orderId);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();


                while (await dataReader.ReadAsync())
                {
                    BillDetail billDetail = new BillDetail();

                    billDetail.OrderId = Convert.ToInt64(dataReader["OrderId"]);
                    billDetail.FirstName = dataReader["FristName"].ToString();
                    billDetail.LastName = dataReader["LastName"].ToString();
                    billDetail.Phone = dataReader["Phone"].ToString();
                    billDetail.Email = dataReader["Email"].ToString();
                    billDetail.Address = dataReader["Address"].ToString();
                    billDetail.City = dataReader["City"].ToString();
                    billDetail.Note = dataReader["Note"].ToString();
                    billDetail.OrderDate = DateTime.Parse(dataReader["OrderDate"].ToString());
                    billDetail.ProductName = dataReader["ProductName"].ToString();
                    billDetail.Quantity = Convert.ToInt32(dataReader["Quantity"]);
                    billDetail.Price = Decimal.Parse(dataReader["Price"].ToString());

                    billDetailList.Add(billDetail);
                }

                con.Close();
            }
            return billDetailList;
        }

        public async Task<List<CutomerOrder>> GetOrders(QueryOptions queryOptions)
        {
            List<CutomerOrder> cutomerOrderList = new List<CutomerOrder>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("GetCustomerOrders", con);
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
                    CutomerOrder cutomerOrder = new CutomerOrder();
                    cutomerOrder.OrderId = Convert.ToInt64(dataReader["OrderId"]);
                    cutomerOrder.FirstName = dataReader["FristName"].ToString();
                    cutomerOrder.LastName = dataReader["LastName"].ToString();
                    cutomerOrder.Phone = dataReader["Phone"].ToString();
                    cutomerOrder.Email = dataReader["Email"].ToString();
                    cutomerOrder.Address = dataReader["Address"].ToString();
                    cutomerOrder.City = dataReader["City"].ToString();
                    cutomerOrder.Note = dataReader["Note"].ToString();
                    cutomerOrder.OrderDate = DateTime.Parse(dataReader["OrderDate"].ToString());

                    cutomerOrderList.Add(cutomerOrder);
                }

                con.Close();
            }
            return cutomerOrderList;
        }

        public async Task<decimal> GetTotalIncome()
        {
            decimal totalIncome = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetTotalIncome]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                {
                    if (dataReader["TotalIncome"] != null)
                    {
                        totalIncome = Convert.ToInt64(dataReader["TotalIncome"]);
                    }
                }

                con.Close();
            }
            return totalIncome;
        }
    }
}
