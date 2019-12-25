using backend.Models.IRepository;
using backend.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/dashboard")]
    [ApiController]
    public class DashboardController: Controller
    {
        private readonly ICatalogRepository _catalogRepo;
        private readonly IProductRepostiory _productRepo;
        private readonly ICategoryRepository _categoryRepo;
        private readonly IPostRepository _postRepo;
        private readonly IOrderRepository _orderRepo;

        public DashboardController
            (
                ICatalogRepository catalogRepo, 
                IProductRepostiory productRepo, 
                ICategoryRepository categoryRepo,
                IPostRepository postRepo,
                IOrderRepository orderRepo
            )
        {
            _catalogRepo = catalogRepo;
            _productRepo = productRepo;
            _categoryRepo = categoryRepo;
            _postRepo = postRepo;
            _orderRepo = orderRepo;
        }

        [HttpGet("catalogs")]
        public async Task<IActionResult> GetCatalogCount()
        {
            int count = await _catalogRepo.GetCount();
            return Ok(count);
        }

        [HttpGet("products")]
        public async Task<IActionResult> GetProductCount()
        {
            int count = await _productRepo.GetCount();
            return Ok(count);
        }

        [HttpGet("categories")]
        public async Task<IActionResult> GetCategoryCount()
        {
            int count = await _categoryRepo.GetCount();
            return Ok(count);
        }

        [HttpGet("posts")]
        public async Task<IActionResult> GetPostCount()
        {
            int count = await _postRepo.GetCount();
            return Ok(count);
        }

        [HttpGet("orders")]
        public async Task<IActionResult> GetOrderCount()
        {
            int count = await _orderRepo.GetCount();
            return Ok(count);
        }

        [HttpGet("totalIncome")]
        public async Task<IActionResult> GetTotalIncome()
        {
            decimal totalIncome = await _orderRepo.GetTotalIncome();
            return Ok(totalIncome);
        }
    }
}
