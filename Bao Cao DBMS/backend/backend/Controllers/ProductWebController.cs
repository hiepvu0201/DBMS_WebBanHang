using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;

namespace backend.Controllers
{
    [Route("api/web/products")]
    [ApiController]
    public class ProductWebController : Controller
    {
        private readonly IProductRepostiory _productRepo;

        public ProductWebController(IProductRepostiory productRepo)
        {
            _productRepo = productRepo;
        }

        [HttpGet]
        public async Task<List<Product>> GetAll()
        {
            return await _productRepo.GetAllProductHomeWeb();
        }

        [HttpGet("catalog")]
        public async Task<List<Product>> GetAllCatalogProduct([FromHeader] QueryOptions queryOptions)
        {
            return await _productRepo.GetAllCatalogProductWeb(queryOptions);
        }
    }
}