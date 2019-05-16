using Devrico.Domain.Contracts.Services;
using DevricoApi.Models;
using Newtonsoft.Json;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web.Mvc;

namespace DevricoApi.Controllers
{
    public class UserController : ApiController
    {


        #region Dependencies
        private IUserService _userService { get; set; }
        #endregion

        #region Constructors
        public UserController(IUserService userService)
        {
            _userService = userService;
        }
        #endregion

        [System.Web.Http.HttpPost]
        public JsonResult UserSignUp(User user)
        {
            var serializedUser = JsonConvert.SerializeObject(user, Formatting.Indented);
            var response = _userService.UserSignUp(serializedUser);
            return new JsonResult()
            {
                Data = response
            };
        }

        [System.Web.Http.HttpGet]
        public JsonResult PendingRequests()
        {
            var response = _userService.PendingRequests();

            return new JsonResult()
            {
                Data = response
            };
        }
    }
}
