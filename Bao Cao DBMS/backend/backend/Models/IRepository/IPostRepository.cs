using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.IRepository
{
    public interface IPostRepository
    {
        public Task<long> Add(Post post);
        public Task<int> Delete(long id);
        public Task<int> Edit(Post post);
        public Task<int> GetCount();

        public Task<Post> GetOneById(long id);
        public Task<List<Post>> GetAll(QueryOptions queryOptions);

        public Task<List<Post>> GetAllCategoryPostWeb(QueryOptions queryOptions);
    }
}
