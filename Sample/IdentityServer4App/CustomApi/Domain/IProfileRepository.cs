using System;
using System.Threading.Tasks;

namespace CustomApi.Domain
{
    public interface IProfileRepository
    {
        Task<UserProfile> GetByID(Guid userId);
        Task<UserProfile> UpdateUser(UserProfile userProfile);

    }
}
