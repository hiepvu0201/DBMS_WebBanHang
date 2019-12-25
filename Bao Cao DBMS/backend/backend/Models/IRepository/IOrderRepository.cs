using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.IRepository
{
    public interface IOrderRepository
    {
        Task CreateOrder(Bill bill);
        Task<List<BillDetail>> GetOrder(long orderId);
        Task<List<CutomerOrder>> GetOrders(QueryOptions queryOptions);
        public Task<int> GetCount();
        public Task<decimal> GetTotalIncome();
    }
}
