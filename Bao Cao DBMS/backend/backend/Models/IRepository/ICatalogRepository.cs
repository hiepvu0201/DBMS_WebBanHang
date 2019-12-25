using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Repository
{
    public interface ICatalogRepository
    {
        public Task<long> Add(Catalog catalog);
        public Task<int> Delete(long id);
        public Task<int> Edit(Catalog catalog);
        public Task<int> GetCount();

        public Task<Catalog> GetOneById(long id);
        public Task<List<Catalog>> GetAll(QueryOptions queryOptions);

        public Task<List<Catalog>> GetAllWeb();
    }
}
