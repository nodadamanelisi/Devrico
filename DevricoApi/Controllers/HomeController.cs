using Devrico.Domain.Contracts.Services;
using DevricoApi.Models;
using Newtonsoft.Json;
using System.Web.Mvc;

namespace DevricoApi.Controllers
{
    public class HomeController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";
            return View();
        }
    }
}
