using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backend.Helpers.IHelpers
{
    public interface IUploadImageHelper
    {
        Task<string> UploadImage(IFormFile file);
        bool CheckIfImageFile(IFormFile file);
    }
}
