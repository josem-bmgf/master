using Microsoft.Owin;
using Owin;
using System;
using System.Threading.Tasks;



namespace Scheduler
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);

        }
    }
}
