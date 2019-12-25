using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/web/posts")]
    [ApiController]
    public class PostWebControler: Controller
    {
        private readonly IPostRepository _postRepo;

        public PostWebControler(IPostRepository postRepo)
        {
            _postRepo = postRepo;
        }

        [HttpGet]
        public async Task<List<Post>> GetAll([FromHeader] QueryOptions queryOptions)
        {
            return await _postRepo.GetAllCategoryPostWeb(queryOptions);
        }
    }
}
