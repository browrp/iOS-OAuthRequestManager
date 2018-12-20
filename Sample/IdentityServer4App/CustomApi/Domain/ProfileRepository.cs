using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Dapper;
using System.Linq;

namespace CustomApi.Domain
{
    public class ProfileRepository : IProfileRepository
    {
        private readonly IConfiguration _config;

        public ProfileRepository(IConfiguration config)
        {
            _config = config;
        }

        public IDbConnection Connection
        {
            get
            {
                return new SqlConnection(_config.GetConnectionString("MyConnectionString"));
            }
        }

        public async Task<UserProfile> GetByID(Guid userId)
        {
            using (IDbConnection conn = Connection)
            {
                conn.Open();
                var result = await conn.QueryAsync<UserProfile>("GetUserProfileByID",
                new { UserId = userId }, commandType: CommandType.StoredProcedure);
                return result.FirstOrDefault();
            }
        }

        public async Task<UserProfile> UpdateUser(UserProfile userProfile)
        {
            using (IDbConnection conn = Connection)
            {
                conn.Open();
                var result = await conn.QueryAsync<UserProfile>("UpdateUserProfileByID",
                new { UserId = userProfile.UserID,
                    FirstName= userProfile.FirstName,
                    LastName = userProfile.LastName,
                    PhoneNumber = userProfile.PhoneNumber }, commandType: CommandType.StoredProcedure);
                return result.FirstOrDefault();
            }
        }
    }
}
