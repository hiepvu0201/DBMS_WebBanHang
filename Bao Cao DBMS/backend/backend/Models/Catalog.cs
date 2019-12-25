using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class Catalog: AbstractModel
    {
        public string Name { get; set; }
        public string Slug { get; set; }
        public bool Visibility { get; set; }
        public int ProductCount { get; set; }
    }
}
