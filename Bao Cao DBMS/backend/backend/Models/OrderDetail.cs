using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class OrderDetail
    {

        [Key]
        public long OrderId { get; set; }
        [Key]
        public long ProductId { get; set; }
        public int Quantity { get; set; }

        public Order Order { get; set; }
        public Product Product { get; set; }

    }
}
