using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.IRepository
{
    public interface ICategoryRepository
    {
        public Task<long> Add(Category category);
        public Task<int> Delete(long id);
        public Task<int> Edit(Category category);
        public Task<int> GetCount();

        public Task<Category> GetOneById(long id);
        public Task<List<Category>> GetAll(QueryOptions queryOptions);

        public Task<List<Category>> GetAllWeb();
    }
}
