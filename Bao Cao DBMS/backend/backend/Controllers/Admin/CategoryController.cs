using AutoMapper;
using backend.Dtos;
using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/categories")]
    [ApiController]
    public class CategoryController: Controller
    {
        private readonly ICategoryRepository _categoryRepo;
        private readonly IMapper _mapper;

        public CategoryController(ICategoryRepository categoryRepo, IMapper mapper)
        {
            _categoryRepo = categoryRepo;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<List<Category>> GetAll([FromHeader] QueryOptions queryOptions)
        {
            return await _categoryRepo.GetAll(queryOptions);
        }

        [HttpGet("{id}")]
        public async Task<Category> GetOne(long id)
        {
            return await _categoryRepo.GetOneById(id);
        }

        [HttpPost]
        public async Task<long> Create([FromBody] Category category)
        {
            return await _categoryRepo.Add(category);
        }

        [HttpPut("{id}")]
        public async Task<int> Edit(long id, [FromBody] CategoryDto categoryDto)
        {
            var categoryFromRepo = await _categoryRepo.GetOneById(id);

            var category= _mapper.Map(categoryDto, categoryFromRepo);

            return await _categoryRepo.Edit(category);
        }

        [HttpDelete("{id}")]
        public async Task<int> Delete(long id)
        {
            return await _categoryRepo.Delete(id);
        }
    }
}
