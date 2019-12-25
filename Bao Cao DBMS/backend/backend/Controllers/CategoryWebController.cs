using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/web/categories")]
    [ApiController]
    public class CategoryWebController: Controller
    {
        private readonly ICategoryRepository _categoryRepo;

        public CategoryWebController(ICategoryRepository categoryRepo)
        {
            _categoryRepo = categoryRepo;
        }

        [HttpGet]
        public async Task<List<Category>> GetAll()
        {
            return await _categoryRepo.GetAllWeb();
        }
    }
}
