using backend.Helpers.IHelpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Controllers
{
    [Route("api/upload")]
    [ApiController]
    public class UploadImageController: Controller
    {
        private readonly IUploadImageHelper _uploadImageHelper;

        public UploadImageController(IUploadImageHelper uploadImageHelper)
        {
            _uploadImageHelper = uploadImageHelper;
        }

        [HttpPost]
        public async Task<IActionResult> Upload(IFormFile file)
        {
            var url = await _uploadImageHelper.UploadImage(file);
            return Json(new { location = url });
        }
    }
}
