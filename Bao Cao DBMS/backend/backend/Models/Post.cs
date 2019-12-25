using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class Post:AbstractModel
    {
        public string Title { get; set; }
        public string Slug { get; set; }
        public string ShortDescription { get; set; }
        public string Content { get; set; }
        public string Image { get; set; }
        public bool Visibility { get; set; }
        public long CategoryId { get; set; }

        public Category Category { get; set; }
    }
}
