using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace store.Models
{
    public class Bill
    {
        public Customer Customer { get; set; }
        public ProductSelection[] ProductSelections { get; set; }
    }
}
