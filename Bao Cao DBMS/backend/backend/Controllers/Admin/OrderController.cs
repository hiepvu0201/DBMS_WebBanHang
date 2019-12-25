using backend.Models;
using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/orders")]
    [ApiController]
    public class OrderController: Controller
    {
        private readonly IOrderRepository _orderRepo;

        public OrderController(IOrderRepository orderRepo)
        {
            _orderRepo = orderRepo;
        }

        // GET ALL ORDERS
        [HttpGet]
        public async Task<List<CutomerOrder>> GetAllOptions([FromHeader] QueryOptions queryOptions)
        {
            return await _orderRepo.GetOrders(queryOptions);
        }

        // GET ONE ORDER
        [HttpGet("{orderId}")]
        public async Task<List<BillDetail>> GetOne(long orderId)
        {
            return await _orderRepo.GetOrder(orderId);
        }

        // CREATE ONE ORDER
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Bill bill)
        {
            await _orderRepo.CreateOrder(bill);
            return Ok(1);
        }
    }
}
