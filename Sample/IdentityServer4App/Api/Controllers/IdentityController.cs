// Copyright (c) Brock Allen & Dominick Baier. All rights reserved.
// Licensed under the Apache License, Version 2.0. See LICENSE in the project root for license information.

using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Api.Domain;
using System.Threading.Tasks;

namespace Api.Controllers
{
    [Produces("application/json")]

    [Route("[controller]")]
    [Authorize]
    public class IdentityController : ControllerBase
    {


        [HttpGet]
        public IActionResult Get()
        {
            return new JsonResult(from c in User.Claims select new { c.Type, c.Value });
        }


        /*
         [HttpGet]
         [Route("[action]")]
         public IActionResult GetClaims()
         {

             return new JsonResult(from c in User.Claims select new { c.Type, c.Value });
         }
        */

    }
}