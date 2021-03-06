using Devrico.Domain.Contracts.Services;
using Devrico.Domain.Services;
using System.Web.Http;
using Unity;
using Unity.WebApi;

namespace DevricoApi
{
    public static class UnityConfig
    {
        public static void RegisterComponents()
        {
			var container = new UnityContainer();

            // register all your components with the container here
            // it is NOT necessary to register your controllers

            // e.g. container.RegisterType<ITestService, TestService>();
            container.RegisterType<IUserService, UserService>();


            GlobalConfiguration.Configuration.DependencyResolver = new UnityDependencyResolver(container);
        }
    }
}