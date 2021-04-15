namespace Scheduler.Api.Helpers
{
    using System.Collections;
    using System.Collections.Generic;
    using System.Configuration;
    using System.DirectoryServices;
    using System.DirectoryServices.AccountManagement;
    using System.Linq;
    public static class ActiveDirectoryHelper
    {
        public static List<string> GetDomainGroups(string username)
        {
            var groupNames = new List<string>();
            UserPrincipal userprincipal = GetUserPrincipal(username);

            if (userprincipal != null)
            {
                PrincipalSearchResult<Principal> groups;
                try
                {
                    groups = userprincipal.GetGroups();
                    foreach (Principal group in groups)
                    {
                        if (group != null
                            && group.Context != null
                            && group.Context.Name != null)
                        {
                            if (group.Context.Name.Split('.')[0].Trim().ToLower()
                                == System.Environment.UserDomainName.Trim().ToLower())
                            {
                                groupNames.Add(group.Name.ToLower());
                            }
                        }
                    }
                }
                catch
                {
                    try
                    {
                        groups = userprincipal.GetAuthorizationGroups();
                        foreach (Principal group in groups)
                        {
                            if (group != null
                                && group.Context != null
                                && group.Context.Name != null)
                            {
                                if (group.Context.Name.Split('.')[0].Trim().ToLower()
                                    == System.Environment.UserDomainName.Trim().ToLower())
                                {
                                    groupNames.Add(group.Name.ToLower());
                                }
                            }
                        }
                    }
                    catch
                    {
                        // do nothing - this would return and empty group   
                    }
                }
            }

            return groupNames;
        }

        public static UserPrincipal GetUserPrincipal(string username)
        {
            PrincipalContext ctx = new PrincipalContext(ContextType.Domain);
            if (ctx == null)
            {
                return null;
            }

            return UserPrincipal.FindByIdentity(ctx, username != null ? username : string.Empty);
        }

        public static DirectoryEntry GetDirectoryEntry(string username)
        {
            UserPrincipal userprincipal = GetUserPrincipal(username);
            if (userprincipal != null)
            {
                DirectoryEntry conn = userprincipal.GetUnderlyingObject() as DirectoryEntry;
                return conn;
            }
            else
            {
                return null;
            }
        }

        public static List<string> GetMembersOfAnAdGroup(string adGroup)
        {
            PrincipalContext pcRoot = new PrincipalContext(ContextType.Domain);
            GroupPrincipal grp = GroupPrincipal.FindByIdentity(pcRoot, adGroup);
            List<string> members = grp.Members.Select(g => g.SamAccountName).ToList();
            return members;
        }

        public static void getADGroup(string username)
        {
            // create your domain context
            PrincipalContext ctx = new PrincipalContext(ContextType.Domain);

            // Get User
            UserPrincipal user = UserPrincipal.FindByIdentity(ctx, IdentityType.SamAccountName, username);
            
            // Browse user's groups
            foreach (GroupPrincipal group in user.GetGroups())
            {
                string domainGroup = group.Name.ToString();
            }


            //// define a "query-by-example" principal - here, we search for a GroupPrincipal 
            //GroupPrincipal qbeGroup = new GroupPrincipal(ctx);

            //// create your principal searcher passing in the QBE principal    
            //PrincipalSearcher srch = new PrincipalSearcher(qbeGroup);

            //// find all matches
            //foreach (var found in srch.FindAll())
            //{
            //    var domaingroups = found.GetGroups();
            //    // do whatever here - "found" is of type "Principal" - it could be user, group, computer.....          
            //}
        }

        //Return [Domain]\username
        public static string UserLoggedIn(string username)
        {
            UserPrincipal currentUser = GetUserPrincipal(username);
            string userLoggedIn = ConfigurationManager.AppSettings["Domain"].ToLower() + "\\" + currentUser.SamAccountName.ToLower();
            return userLoggedIn;
        }
    }
}