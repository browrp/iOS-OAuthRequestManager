using System;
using System.Threading.Tasks;

namespace Api.Domain
{
    public interface IProfileRepository
    {
        Task<UserProfile> GetByID(string userId);
        Task<UserProfile> UpdateUser(UserProfile userProfile);

    }
}
