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
    [Route("api/posts")]
    [ApiController]
    public class PostController: Controller
    {
        private readonly IUploadImageHelper _uploadImageHelper;
        private readonly IPostRepository _postRepo;
        private readonly IMapper _mapper;

        public PostController(IPostRepository postRepo, IUploadImageHelper uploadImageHelper, IMapper mapper)
        {
            _uploadImageHelper = uploadImageHelper;
            _postRepo = postRepo;
            _mapper = mapper;
        }

        [HttpGet]
        public async Task<List<Post>> GetAll([FromHeader] QueryOptions queryOptions)
        {
            return await _postRepo.GetAll(queryOptions);
        }

        [HttpGet("{id}")]
        public async Task<Post> GetOne(long id)
        {
            return await _postRepo.GetOneById(id);
        }

        [HttpPost]
        public async Task<long> Create([FromForm] PostDto postDto)
        {
            if (postDto.File.Length > 0)
            {
                postDto.Image = await _uploadImageHelper.UploadImage(postDto.File);
            }

            var post = _mapper.Map<Post>(postDto);

            return await _postRepo.Add(post);
        }

        [HttpPut("{id}")]
        public async Task<int> Edit(long id, [FromForm] PostDto postDto)
        {
            var postFromRepo = await _postRepo.GetOneById(id);

            try
            {
                postDto.Image = await _uploadImageHelper.UploadImage(postDto.File);
            }
            catch
            {
                postDto.Image = postFromRepo.Image;
            }

            var post = _mapper.Map(postDto, postFromRepo);

            return await _postRepo.Edit(post);
        }

        [HttpDelete("{id}")]
        public async Task<int> Delete(long id)
        {
            return await _postRepo.Delete(id);
        }
    }
}
