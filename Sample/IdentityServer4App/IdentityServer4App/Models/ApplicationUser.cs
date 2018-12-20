using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

//https://docs.microsoft.com/en-us/aspnet/core/security/authentication/identity-primary-key-configuration?view=aspnetcore-2.1&tabs=aspnetcore2x
namespace IdentityServer4App.Models
{
    public class ApplicationUser : IdentityUser<Guid>
    {
        
        public Guid ActivationGuid { get; set; }
        public string Notes { get; set; }
    }
}
