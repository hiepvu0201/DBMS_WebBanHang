using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Dtos
{
    public class UserForRegisterDto
    {
        public string Username { get; set; }
        public string Name { get; set; }
        public string Password { get; set; }
    }
}
