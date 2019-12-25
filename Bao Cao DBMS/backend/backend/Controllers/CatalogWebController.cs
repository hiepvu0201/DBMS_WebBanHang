using backend.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/web/catalogs")]
    [ApiController]
    public class CatalogWebController: Controller
    {
        private readonly ICatalogRepository _catalogRepo;

        public CatalogWebController(ICatalogRepository catalogRepo)
        {
            _catalogRepo = catalogRepo;
        }

        [HttpGet]
        public async Task<List<Catalog>> GetAll()
        {
            return await _catalogRepo.GetAllWeb();
        }
    }
}
