using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class Product: AbstractModel
    {
        public string Name { get; set; }
        public string Slug { get; set; }
        public string ShortDescription { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string Image { get; set; }
        public bool Visibility { get; set; }
        public long CatalogId { get; set; }

        public virtual Catalog Catalog { get; set; }
    }
}
