using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class ProductSelection
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public decimal price { get; set; }
        public int quantity { get; set; }
    }
}
