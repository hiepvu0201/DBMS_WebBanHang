using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Repository
{
    public abstract class AbstractRepository
    {
        IConfiguration _configuration { get; }
        protected SqlConnection con;

        public AbstractRepository(IConfiguration configuration)
        {
            _configuration = configuration;

            con = new SqlConnection(configuration["ConnectionStrings:DefaultConnection"]);
            if (con == null)
                con = new SqlConnection(configuration["ConnectionStrings:DefaultConnection"]);
            if (con.State == ConnectionState.Closed)
                con.Open();
        }
    }
}
