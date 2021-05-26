using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using InvestmentScore.Spa.Models;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Mvc;
using InvestmentScore.Spa.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.SpaServices.Webpack;

namespace InvestmentScore_Spa
{
    public class Startup
    {
        public Startup(IWebHostEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            builder.AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        public IConfigurationRoot Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            // Add framework services.
            services.AddDbContext<InvestmentScoreContext>(options =>
            options.UseSqlServer(Configuration.GetConnectionString("InvestmentScoreDatabase")));

            services.AddMvc().AddRazorRuntimeCompilation().AddNewtonsoftJson(options =>
            {
                options.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
                options.SerializerSettings.DefaultValueHandling = DefaultValueHandling.Include;
                options.SerializerSettings.NullValueHandling = NullValueHandling.Ignore;
                options.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
            });

            // Add our Config object so it can be injected
            services.AddOptions();

            services.Configure<InvestmentScoreConfig>(option =>
            {
                option.Tenant = Configuration["Authentication:AzureAd:Domain"];
                option.ClientId = Configuration["Authentication:AzureAd:ClientId"];
            });

            services.Configure<DNSProperties>(option =>
            {
                option.DNSConfiguration = new List<DNSConfiguration>();
                DNSConfiguration dnsItem = new DNSConfiguration();
                dnsItem.Placeholder = Configuration["DNS:ReportServerPlaceholder"];
                dnsItem.Server = Configuration["DNS:ReportServer"];
                option.DNSConfiguration.Add(dnsItem);

            });

            services.Configure<Division>(option =>
            {
                string divisionString = Configuration["Divisions:GPA"];
                string[] division = divisionString.Split(',');
                option.Divisions = division;
            });
            services.Configure<FISConfigurations>(option =>
            {
                option.GuidanceURL = Configuration["FISConfigurations:FISLinks:GuidanceURL"];
                option.PreviewDetailedSlideReportURL = Configuration["FISConfigurations:FISLinks:PreviewDetailedSlideReportURL"];
                option.FraudulentActivityURL = Configuration["FISConfigurations:FISLinks:FraudulentActivityURL"];
                option.PrivacyAndCookiesURL = Configuration["FISConfigurations:FISLinks:PrivacyAndCookiesURL"];
                option.TermsOfUseURL = Configuration["FISConfigurations:FISLinks:TermsOfUseURL"];
            });
            services.Configure<MaintenanceNoticeConfiguration>(option =>
            {
                option.MaintenanceNoticeHTML = Configuration["MaintenanceNoticeConfiguration:MaintenanceMessageHTML"];
            });
            services.Configure<FISConfigurations>(option =>
            {
                var lengthSection = Configuration.GetSection("FISConfigurations:FieldLength");
                option.FieldLength = new Dictionary<string, int>();
                foreach (IConfigurationSection item in lengthSection.GetChildren())
                {
                    option.FieldLength.Add(item.GetValue<string>("id"), item.GetValue<int>("maxLength"));
                }
            });

            services.Configure<DateReference>(option =>
            {
                option.EndOfSeason = Configuration["DateReference:EndOfSeason"];
                option.EndOfSeasonFormat = Configuration["DateReference:EndOfSeasonFormat"];
                option.TestScoreYear = Configuration["DateReference:TestScoreYear"];
            });

            services
                .AddAntiforgery(options =>
                {
                    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                })
                .AddMvc(options =>
                {
                    options.Filters.Add(new RequireHttpsAttribute());
                });

            services.AddAuthentication(options =>
            {
                options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = OpenIdConnectDefaults.AuthenticationScheme;

            })
            .AddCookie(options => {
                options.AccessDeniedPath = "/Home/AccessDenied/";
            })
            .AddOpenIdConnect(options =>
            {
                options.Authority = Configuration["Authentication:AzureAd:AADInstance"] + Configuration["Authentication:AzureAd:TenantId"];
                options.ClientId = Configuration["Authentication:AzureAd:ClientId"];

                options.Events = new OpenIdConnectEvents
                {
                    OnRemoteFailure = context => {
                        context.Response.Redirect("/Home/AccessDenied/");
                        context.HandleResponse();

                        return Task.FromResult(0);
                    }
                };
            });

            services.AddLogging(loggingBuilder =>
            {
                loggingBuilder.AddConfiguration(Configuration.GetSection("Logging"));
                loggingBuilder.AddConsole();
                loggingBuilder.AddDebug();
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILoggerFactory loggerFactory)
        {

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseWebpackDevMiddleware(new WebpackDevMiddlewareOptions
                {
                    HotModuleReplacement = true,
                    HotModuleReplacementEndpoint = "/dist/__webpack_hmr"
                });
                app.UseBrowserLink();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
            }

            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");

                endpoints.MapFallbackToController("Index", controller: "Home");
            });
           
        }
    }
}
