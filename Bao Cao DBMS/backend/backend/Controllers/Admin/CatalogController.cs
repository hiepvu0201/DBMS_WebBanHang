using AutoMapper;
using backend.Dtos;
using backend.Models.Repository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/catalogs")]
    [ApiController]
    public class CatalogController : Controller
    {
        private readonly ICatalogRepository _catalogRepo;
        private readonly IMapper _mapper;

        public CatalogController(ICatalogRepository catalogRepo, IMapper mapper)
        {
            _catalogRepo = catalogRepo;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<List<Catalog>> GetAll([FromHeader] QueryOptions queryOptions)
        {
            return await _catalogRepo.GetAll(queryOptions);
        }

        [HttpGet("{id}")]
        public async Task<Catalog> GetOne(long id)
        {
            return await _catalogRepo.GetOneById(id);
        }

        [HttpPost]
        public async Task<long> Create([FromBody] Catalog catalog)
        {
            return await _catalogRepo.Add(catalog);
        }

        [HttpPut("{id}")]
        public async Task<int> Edit(long id, [FromBody] CatalogDto catalogDto)
        {
            var catalogFromRepo = await _catalogRepo.GetOneById(id);

            var catalog = _mapper.Map(catalogDto, catalogFromRepo);

            return await _catalogRepo.Edit(catalog);
        }

        [HttpDelete("{id}")]
        public async Task<int> Delete(long id)
        {
            return await _catalogRepo.Delete(id);
        }
    }
}
