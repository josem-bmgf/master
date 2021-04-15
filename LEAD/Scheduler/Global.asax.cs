using Scheduler.Api.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;


namespace Scheduler
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            RouteConfig.RegisterRoutes(RouteTable.Routes);            
        }

        protected void Application_PostAuthorizeRequest()
        {

            if (IsWebApiRequest())
            {
                HttpContext.Current.SetSessionStateBehavior(SessionStateBehavior.Required);
            }

        }

        private bool IsWebApiRequest()
        {
            return HttpContext.Current.Request.AppRelativeCurrentExecutionFilePath.StartsWith("~/api");
        }

        protected void Application_EndRequest(Object sender, EventArgs e)
        {

            if (Response.StatusCode == 401)
            {
                Response.ClearContent();
                Response.WriteFile("~/Views/Home/AuthorizationDenied.cshtml");
                Response.ContentType = "text/html";
            }

        }
    }
}
