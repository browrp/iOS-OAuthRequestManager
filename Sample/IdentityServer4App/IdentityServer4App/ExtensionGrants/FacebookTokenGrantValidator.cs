using IdentityServer4.Models;
using IdentityServer4.Validation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IdentityServer4App.ExtensionGrants
{
    public class FacebookTokenGrantValidator : IExtensionGrantValidator
    {
        private readonly ITokenValidator _validator;

        public FacebookTokenGrantValidator(ITokenValidator validator)
        {
            _validator = validator;
        }

        public string GrantType => "activationcodedelegation";

        public async Task ValidateAsync(ExtensionGrantValidationContext context)
        {
            var facebookToken = context.Request.Raw.Get("activationcode");
            var deviceName = context.Request.Raw.Get("devicename");


            if (string.IsNullOrEmpty(facebookToken))
            {
                context.Result = new GrantValidationResult(TokenRequestErrors.InvalidGrant);
                return;
            }

            var result = await _validator.ValidateAccessTokenAsync(facebookToken);
            if (result.IsError)
            {
                context.Result = new GrantValidationResult(TokenRequestErrors.InvalidGrant);
                return;
            }

            // get user's identity
            var sub = result.Claims.FirstOrDefault(c => c.Type == "sub").Value;

            context.Result = new GrantValidationResult(sub, "delegation");
            return;
        }
    }
}
