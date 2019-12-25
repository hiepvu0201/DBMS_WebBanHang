using AutoMapper;
using backend.Dtos;
using backend.Helpers.IHelpers;
using backend.Models.IRepository;
using Microsoft.AspNetCore.Mvc;
using store.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/products")]
    [ApiController]
    public class ProductController: Controller
    {
        private readonly IUploadImageHelper _uploadImageHelper;
        private readonly IProductRepostiory _productRepo;
        private readonly IMapper _mapper;

        public ProductController(IProductRepostiory productRepo, IUploadImageHelper uploadImageHelper, IMapper mapper)
        {
            _uploadImageHelper = uploadImageHelper;
            _productRepo = productRepo;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<List<Product>> GetAll([FromHeader] QueryOptions queryOptions)
        {
            return await _productRepo.GetAll(queryOptions);
        }

        [HttpGet("{id}")]
        public async Task<Product> GetOne(long id)
        {
            return await _productRepo.GetOneById(id);
        }

        [HttpPost]
        public async Task<long> Create([FromForm] ProductDto productDto)
        {
            if (productDto.File.Length > 0)
            {
                productDto.Image = await _uploadImageHelper.UploadImage(productDto.File);
            }

            var product = _mapper.Map<Product>(productDto);

            return await _productRepo.Add(product);
        }

        [HttpPut("{id}")]
        public async Task<int> Edit(long id, [FromForm] ProductDto productDto)
        {
            var productFromRepo = await _productRepo.GetOneById(id);

            try
            {
                productDto.Image = await _uploadImageHelper.UploadImage(productDto.File);
            }
            catch
            {
                productDto.Image = productFromRepo.Image;
            }

            var product = _mapper.Map(productDto, productFromRepo);

            return await _productRepo.Edit(product);
        }

        [HttpDelete("{id}")]
        public async Task<int> Delete(long id)
        {
            return await _productRepo.Delete(id);
        }
    }
}
