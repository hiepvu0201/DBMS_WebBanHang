using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Dtos
{
    public class PostDto
    {
        public string Title { get; set; }
        public IFormFile File { get; set; }
        public string ShortDescription { get; set; }
        public string Content { get; set; }
        public string Image { get; set; }
        public bool Visibility { get; set; }
        public long CategoryId { get; set; }
    }
}
