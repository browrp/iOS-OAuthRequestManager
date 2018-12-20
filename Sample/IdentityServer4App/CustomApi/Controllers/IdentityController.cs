using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CustomApi.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CustomApi.Controllers
{
    [Authorize]
    [Route("[controller]")]
    [ApiController]
    public class IdentityController : ControllerBase
    {
        private readonly IProfileRepository _profileRepository;

        public IdentityController(IProfileRepository profileRepository)
        {
            _profileRepository = profileRepository;
        }

        /*
        [HttpGet]
        public IActionResult Get()
        {
            return new JsonResult(from c in User.Claims select new { c.Type, c.Value });
        }
        */


        //[HttpGet]
        //[Route("action")]
        //public IActionResult Claims()
        //{
        //    return new JsonResult(from c in User.Claims select new { c.Type, c.Value });
        //}

        [HttpGet]
        [Route("Claims")]
        public async Task<ActionResult> Claims()
        {
            return  new JsonResult(from c in User.Claims select new { c.Type, c.Value });
        }


        [HttpGet]
        [Route("[action]")]
        public async Task<ActionResult<UserProfile>> GetProfile()
        {
            var userID = (from c in User.Claims select c.Subject).FirstOrDefault();

            var subject = Guid.Parse(HttpContext.User.FindFirst("sub").Value);

            UserProfile userProfile = await _profileRepository.GetByID(subject);
            return userProfile;
        }


        [HttpGet]
        [Route("action")]
        public IActionResult GetData()
        {
            return new JsonResult ( new { Name = "Robert" } );
        }




        [HttpPost]
        [Route("[action]")]
        public async Task<ActionResult<UserProfile>> UpdateProfile([FromBody] UserProfile userProfile)
        {
            var userID = (from c in User.Claims select c.Subject).FirstOrDefault();
            var subject = Guid.Parse(HttpContext.User.FindFirst("sub").Value);
            userProfile.UserID = subject;

            var userprofile = await _profileRepository.UpdateUser(userProfile);
            return userprofile;
        }


      

        /*
        // POST: api/File
        [HttpPost]
        [Consumes("multipart/form-data")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status413PayloadTooLarge)]
        [ProducesResponseType(StatusCodes.Status415UnsupportedMediaType)]
        public async Task<IActionResult> Post(PostModel model)
        {
            if (FileExists(model.File.FileName))
            {
                return StatusCode(StatusCodes.Status409Conflict);
            }

            const int megabyte = 1024 * 1024;
            if (model.File.Length > 8 * megabyte)
            {
                return StatusCode(StatusCodes.Status413PayloadTooLarge);
            }

            if (!IsValidFileExtension(model.File.FileName))
            {
                return StatusCode(StatusCodes.Status415UnsupportedMediaType);
            }

            await _storage.CreateAsync(model.File);

            return Created($"https://files.example.com/{file.FileName}", null);
        }

        */

    }

}
