using backend.Models.IRepository;
using Microsoft.Extensions.Configuration;
using store.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Models.Repository
{
    public class AuthRepository : IAuthRepository
    {
        IConfiguration _configuration { get; }
        private string connectionString;

        public AuthRepository(IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration["ConnectionStrings:DefaultConnection"];
        }

        public async Task<User> Login(string userName, string password)
        {

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetUserByUserName]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Username", userName);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                {
                    User user = new User();
                    user.Id = Convert.ToInt64(dataReader["Id"]);
                    user.Name = dataReader["Name"].ToString();
                    user.Username = dataReader["Username"].ToString();
                    user.PasswordHash = (byte[])(dataReader["PasswordHash"]);
                    user.PasswordSalt = (byte[])(dataReader["PasswordSalt"]);

                    if (!VerifyPasswordHash(password, user.PasswordHash, user.PasswordSalt))
                        return null;

                    return user;
                }
                else
                {
                    return null;
                }
            }
        }

        /**
         * COMPARE PASSWORD ()
         * params password: string, passwordHash: byte[], passwordSalt[]
         */
        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512(passwordSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                for (int i = 0; i < computedHash.Length; i++)
                {
                    if (computedHash[i] != passwordHash[i]) return false;
                }
            }
            return true;
        }

        public async Task<User> Register(User user, string password)
        {
            byte[] passwordHash, passwordSalt;
            CreatePasswordHash(password, out passwordHash, out passwordSalt);

            user.PasswordHash = passwordHash;
            user.PasswordSalt = passwordSalt;

            using (SqlConnection con = new SqlConnection(connectionString))
            {

                SqlCommand command = new SqlCommand("[InsertUser]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Name", user.Name);
                command.Parameters.AddWithValue("@Username", user.Username);
                command.Parameters.AddWithValue("@PasswordHash", user.PasswordHash);
                command.Parameters.AddWithValue("@PasswordSalt", user.PasswordSalt);

                await command.ExecuteNonQueryAsync();
            }

            return user;
        }

        // CreatePasswordHash
        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        public async Task<bool> UserExists(string userName)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand("[GetUserByUserName]", con);
                command.CommandType = CommandType.StoredProcedure;

                if (con.State == ConnectionState.Closed)
                    con.Open();

                command.Parameters.AddWithValue("@Username", userName);

                SqlDataReader dataReader = await command.ExecuteReaderAsync();

                if (await dataReader.ReadAsync())
                    return true;
            }

            return false;
        }
    }
}
