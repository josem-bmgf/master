using Microsoft.Graph;
using Microsoft.Identity.Client;
using Scheduler.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;

namespace Scheduler.Helpers
{
    public class GraphAADHelper
    {
        private static string clientId = ConfigurationManager.AppSettings["ida:ClientId"];
        private static string appSecret = ConfigurationManager.AppSettings["ida:AppSecret"];
        private static string redirectUri = ConfigurationManager.AppSettings["ida:RedirectUri"];
        private static List<string> graphScopes =
            new List<string>(ConfigurationManager.AppSettings["ida:AppScopes"].Split(' '));

        public static async Task<CachedUser> GetUserDetailsAsync(string accessToken)
        {
            var graphClient = new GraphServiceClient(
                new DelegateAuthenticationProvider(
                    async (requestMessage) =>
                    {
                        requestMessage.Headers.Authorization =
                            new AuthenticationHeaderValue("Bearer", accessToken);
                    }));

            var user = await graphClient.Me.Request()
                .Select(u => new {
                    u.DisplayName,
                    u.Mail,
                    u.UserPrincipalName
                })
                .GetAsync();

            return new CachedUser
            {
                Avatar = string.Empty,
                DisplayName = user.DisplayName,
                Email = string.IsNullOrEmpty(user.Mail) ?
                    user.UserPrincipalName : user.Mail
            };
        }

        private static GraphServiceClient GetAuthenticatedClient()
        {
            return new GraphServiceClient(
                new DelegateAuthenticationProvider(
                    async (requestMessage) =>
                    {
                        var idClient = ConfidentialClientApplicationBuilder.Create(clientId)
                            .WithRedirectUri(redirectUri)
                            .WithClientSecret(appSecret)
                            .Build();

                        var tokenStore = new SessionTokenStore(idClient.UserTokenCache,
                                HttpContext.Current, ClaimsPrincipal.Current);

                        var accounts = await idClient.GetAccountsAsync();

                        var result = await idClient.AcquireTokenSilent(graphScopes, accounts.FirstOrDefault())
                            .ExecuteAsync();

                        requestMessage.Headers.Authorization =
                            new AuthenticationHeaderValue("Bearer", result.AccessToken);
                    }));
        }

        public static async Task<List<string>> GetGroupsAssignedAsync()
        {
            var graphClient = GetAuthenticatedClient();

            var page = await graphClient.Me.MemberOf.Request().GetAsync();

            var Groups = new List<string>();
            Groups.AddRange(page
                    .OfType<Group>()
                    .Select(x => x.DisplayName.ToLower())
                    .Where(name => !string.IsNullOrEmpty(name)));
            while (page.NextPageRequest != null)
            {
                page = await page.NextPageRequest.GetAsync();
                Groups.AddRange(page
                    .OfType<Group>()
                    .Select(x => x.DisplayName.ToLower())
                    .Where(name => !string.IsNullOrEmpty(name)));
            }

            return Groups;
        }

        public static async Task<List<string>> GetMembersOfGroup(string groupName)
        {
            List<string> ListMembers = null;
            var graphClient = GetAuthenticatedClient();

            var GroupID = await graphClient.Groups.Request().Filter("startsWith(displayName, '" + groupName + "')")
                .GetAsync();
            if (GroupID != null)
            {
               var ADmembers = await graphClient.Groups[GroupID.CurrentPage.FirstOrDefault().Id].Members.Request().GetAsync();
               ListMembers = new List<string>();
                ListMembers.AddRange(ADmembers
                        .OfType<User>()
                        .Select(x => x.UserPrincipalName)
                        .Where(name => !string.IsNullOrEmpty(name)));
            }
            return ListMembers;
        }

       
    }
}