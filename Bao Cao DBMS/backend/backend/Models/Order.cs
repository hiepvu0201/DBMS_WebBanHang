using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class Order
    {
        public long Id { get; set; }
        public DateTime OrderDate { get; set; }

        public long CustomerId { get; set; }
        public Customer Customer { get; set; }
    }
}
