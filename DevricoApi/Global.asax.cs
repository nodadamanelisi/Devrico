using System;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using log4net;

namespace DevricoApi
{
    public class WebApiApplication : System.Web.HttpApplication
    {
	    private readonly ILog _log = LogManager.GetLogger(typeof(WebApiApplication));

		protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            UnityConfig.RegisterComponents();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();
            var innerException = ex.InnerException;
			_log.Error(innerException);
        }


        public override void Init()
        {
            base.Init();
            this.Error += WebApiApplication_Error;
        }

        void WebApiApplication_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();
            _log.Error(ex);
        }
    }
}
