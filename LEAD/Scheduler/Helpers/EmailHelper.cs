using Scheduler.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Net.Mail;
using Scheduler.Api.Helpers;
using System.DirectoryServices.AccountManagement;

namespace Scheduler.Helpers
{
    public class EmailHelper
    {
        public static void SendNotification(Engagement engagement, Schedule schedule, int preStatus)
        {
            try
            {
                if (engagement != null && engagement.Id > 0)
                {
                    string requestorUsername = engagement.EntryBy != null && engagement.EntryBy.ADUser != null ? engagement.EntryBy.ADUser : null;
                    bool isRequiredPurpose = Array.Exists(Constants.RequiredPurposeId, p => p == engagement.Purpose.Id);
                    int division = engagement.DivisionFk;


                    var section = ConfigurationManager.GetSection("EmailConfigurationSection");
                    if (section != null)
                    {
                        #region Get email templates from config
                        List<EmailNotificationTemplate> notificationTemplates = new List<EmailNotificationTemplate>();
                        var emailconfigs = (section as EmailConfigurationSection).EmailCollection;
                        if (emailconfigs != null && emailconfigs.Count > 0)
                        {
                            foreach (EmailConfigElement e in emailconfigs)
                            {
                                EmailNotificationTemplate nt = new EmailNotificationTemplate(e.Name, e.EngagementPreStatus, e.EngagementPostStatus, e.Subject, e.From, e.To, e.Template);
                                notificationTemplates.Add(nt);
                            }
                        }
                        #endregion

                        //Select appropriate email template based on status
                        var applicableEmails = notificationTemplates.Where(t => t.RequiredPostStatus.Contains(engagement.Status.Id) &&
                                                                                t.RequiredPreStatus.Contains(preStatus)).ToList();
                        #region Send email
                        //Build the email
                        if (applicableEmails != null && applicableEmails.Count > 0)
                        {
                            foreach (EmailNotificationTemplate nt in applicableEmails)
                            {
                                MailMessage message = new MailMessage();
                                message.Subject = nt.Subject;
                                message.Body = CreateEmailBody(nt.BodyTemplate, engagement, schedule);
                                message.From = new MailAddress(nt.MailFrom);
                                message.IsBodyHtml = true;
                                SetMailRecipients(message, nt.MailTo, requestorUsername, division);

                                if (nt.TemplateName == "NotifyScheduler_WhenScheduled")
                                {
                                    if (isRequiredPurpose && schedule != null)
                                    {
                                        SendEmail(message);
                                        //message.Dispose();
                                    }
                                    else
                                        message.Dispose();
                                }
                                else
                                {
                                    SendEmail(message);
                                    //message.Dispose();
                                }
                            }
                        }
                        #endregion
                    }
                }
            }
            catch(Exception e)
            {
                SessionHelper.LogError(e.Message);
            }
        }

        private static void SetMailRecipients(MailMessage message, List<string> mailto, string requestorUsername, int division)
        {
            string DefaultEmailAddress = ConfigurationManager.AppSettings["DefaultEmailAddress"].ToString();
            foreach (string recipients in mailto)
            {
                if (recipients.ToLower() == "requestor")
                {
                    string requestorEmailAddress = !string.IsNullOrEmpty(requestorUsername) ? GetEmailAddress(requestorUsername) : null;
                    string to = !string.IsNullOrEmpty(requestorEmailAddress) && IsValidEmail(requestorEmailAddress) ? requestorEmailAddress : DefaultEmailAddress;
                    message.To.Add(new MailAddress(to));
                }
                else if (recipients.ToLower() == "divisionapprover")
                {
                    string approvers = ConfigurationManager.AppSettings["Division_" + division.ToString()];
                    if (approvers != null && approvers != "")
                    {
                        string[] userEmails = approvers.Split(new[] { ";" }, StringSplitOptions.None);

                        foreach (string userEmail in userEmails)
                        {
                            if (!string.IsNullOrEmpty(userEmail) && IsValidEmail(userEmail))
                            {
                                message.To.Add(new MailAddress(userEmail));
                            }
                        }
                    }
                    else
                    {
                        message.To.Add(new MailAddress(DefaultEmailAddress));
                    }
                }
                else
                {
                    //Check if designated recipient is an Active Directory group
                    List<string> members = ActiveDirectoryHelper.GetMembersOfAnAdGroup(recipients);
                    if (members != null && members.Count > 0)
                    {
                        foreach (string userName in members)
                        {
                            string emailAddress = !string.IsNullOrEmpty(userName) ? GetEmailAddress(userName) : null;
                            if (!string.IsNullOrEmpty(emailAddress))
                            {
                                message.To.Add(new MailAddress(emailAddress));
                            }
                        }
                    }
                    //Check if designated recipient is an email address
                    else if (IsValidEmail(recipients))
                    {
                        message.To.Add(new MailAddress(recipients));
                    }
                    //If all else fails, send to default email address
                    else
                    {
                        message.To.Add(new MailAddress(DefaultEmailAddress));
                    }
                }
            }
        }

        private static void SendEmail(MailMessage message)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogFile"];
            SmtpClient client = new SmtpClient(ConfigurationManager.AppSettings["SMTPClient"]);

            try
            {
                // Credentials are necessary if the server requires the client 
                // to authenticate before it will send e-mail on the client's behalf.
                client.UseDefaultCredentials = true;
                client.EnableSsl = false;
                client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]);
                client.Send(message);
            }
            catch (SmtpFailedRecipientsException ex)
            {
                SessionHelper.LogError(ex.ToString() + "\n Sending email keeps failing. ");
                client.Dispose();
                message.Dispose();
                return;
            }
            catch (Exception e)
            {
                SessionHelper.LogError(e.ToString());
                client.Dispose();
                message.Dispose();
                return;
            }
            client.Dispose();
            message.Dispose();
        }

        private static string GetEmailAddress(string username)
        {
            string emailAddress = null;
            // Do not proceed if string is empty
            if (string.IsNullOrEmpty(username)) return null;

            // Search from active directory and get UserPrincipalName (email address)
            UserPrincipal userprincipal = ActiveDirectoryHelper.GetUserPrincipal(username.ToLower());
            if (userprincipal != null) emailAddress = userprincipal.UserPrincipalName;

            return emailAddress;

        }

        private static string CreateEmailBody(string templatePath, Engagement engagement, Schedule schedule)
        {
            string body = String.Empty;
            string preReadDeadline = String.Empty;
            string title = !String.IsNullOrEmpty(engagement.Title) ? engagement.Title : String.Empty;
            string location = !String.IsNullOrEmpty(engagement.Location) ? engagement.Location : String.Empty;
            string team = engagement.Team != null ? engagement.Team.team : String.Empty;
            string requestor = engagement.EntryBy != null ? engagement.EntryBy.FullName : String.Empty;
            string briefduetoGCEbydate = String.Empty;

            using (System.IO.StreamReader reader = new System.IO.StreamReader(System.IO.Path.Combine(HttpRuntime.AppDomainAppPath, templatePath)))
            {
                body = reader.ReadToEnd();
            }
            
            if (schedule != null)
            {
                preReadDeadline = schedule.BriefDueToGCEByDate != null ? schedule.BriefDueToGCEByDate.Value.ToShortDateString() : "";
                briefduetoGCEbydate = schedule.DateFrom != null ? schedule.DateFrom.Value.ToString("MM/dd/yyyy") : "";
            }

            body = body.Replace("{title}", title);
            body = body.Replace("{engagementteam}", team);
            body = body.Replace("{requestor}", requestor);
            body = body.Replace("{location}", location);
            body = body.Replace("{scheduleDateFrom}", briefduetoGCEbydate);
            body = body.Replace("{preReadDeadline}", preReadDeadline);

            return body;
        }

        private static bool IsValidEmail(string email)
        {
            try
            {
                var addr = new MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
    }
}