using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.IRepository
{
    public interface IProductRepostiory
    {
        public Task<long> Add(Product product);
        public Task<int> Delete(long id);
        public Task<int> Edit(Product product);
        public Task<int> GetCount();

        public Task<Product> GetOneById(long id);
        public Task<List<Product>> GetAll(QueryOptions queryOptions);

        public Task<List<Product>> GetAllCatalogProductWeb(QueryOptions queryOptions);
        public Task<List<Product>> GetAllProductHomeWeb();
    }
}
