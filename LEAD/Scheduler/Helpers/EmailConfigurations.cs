using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Configuration;
using System.Xml;

namespace Scheduler.Helpers
{
    public class EmailConfigurationSection : ConfigurationSection
    {
        [ConfigurationProperty("emailConfiguration")]
        public EmailConfigElementCollection EmailCollection
        {
            get { return ((EmailConfigElementCollection)(base["emailConfiguration"])); }
            set { base["emailConfiguration"] = value; }
        }
    }

    [ConfigurationCollection(typeof(EmailConfigElement))]
    public class EmailConfigElementCollection : ConfigurationElementCollection
    {
        internal const string PropertyName = "email";

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMapAlternate;
            }
        }
        protected override string ElementName
        {
            get
            {
                return PropertyName;
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return elementName.Equals(PropertyName,
              StringComparison.InvariantCultureIgnoreCase);
        }

        public override bool IsReadOnly()
        {
            return false;
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new EmailConfigElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((EmailConfigElement)(element)).Name;
        }

        public EmailConfigElement this[int idx]
        {
            get { return (EmailConfigElement)BaseGet(idx); }
        }
    }

    public class EmailConfigElement : ConfigurationElement
    {
        public EmailConfigElement()
        {

        }
        
        [ConfigurationProperty("name", IsRequired = true, IsKey = true, DefaultValue = "")]
        public string Name
        {
            get { return (string)this["name"]; }
            set { this["name"] = value; }
        }

        [ConfigurationProperty("engPreStatus", IsRequired = true)]
        public string EngagementPreStatus
        {
            get { return (string)this["engPreStatus"]; }
            set { this["engPreStatus"] = value; }
        }

        [ConfigurationProperty("engPostStatus", IsRequired = true)]
        public string EngagementPostStatus
        {
            get { return (string)this["engPostStatus"]; }
            set { this["engPostStatus"] = value; }
        }

        [ConfigurationProperty("subject", IsRequired = true)]
        public string Subject
        {
            get { return (string)this["subject"]; }
            set { this["subject"] = value; }
        }

        [ConfigurationProperty("from", IsRequired = true)]
        public string From
        {
            get { return (string)this["from"]; }
            set { this["from"] = value; }
        }

        [ConfigurationProperty("to", IsRequired = true)]
        public string To
        {
            get { return (string)this["to"]; }
            set { this["to"] = value; }
        }

        [ConfigurationProperty("template", IsRequired = true)]
        public string Template
        {
            get { return (string)this["template"]; }
            set { this["template"] = value; }
        }
    }

    public class EmailNotificationTemplate
    {
        public string TemplateName { get; set; }
        public List<int> RequiredPreStatus { get; set; }
        public List<int> RequiredPostStatus { get; set; }
        public string Subject { get; set; }
        public string MailFrom { get; set; }
        public List<string> MailTo { get; set; }
        public string BodyTemplate { get; set; }

        public EmailNotificationTemplate(string templateName, string requiredPreStatus, string requiredPostStatus, string subject, string mailFrom, string mailTo, string bodyTemplate)
        {
            this.TemplateName = templateName;
            this.RequiredPreStatus = GetRequiredStatus(requiredPreStatus);
            this.RequiredPostStatus = GetRequiredStatus(requiredPostStatus);
            this.Subject = subject;
            this.MailFrom = mailFrom == "LEADSender" ? ConfigurationManager.AppSettings["LEADSender"].ToString() : mailFrom;
            this.MailTo = GetMailRecipients(mailTo);
            this.BodyTemplate = bodyTemplate;
        }

        public EmailNotificationTemplate()
        {
        }

        public List<int> GetRequiredStatus(string prestatus)
        {
            string[] ps = prestatus.Split(new[] { ";" }, StringSplitOptions.None);
            List<int> rs = new List<int>();
            foreach(string s in ps)
            {
                int i;
                if (!String.IsNullOrEmpty(s))
                {
                    int.TryParse(s, out i);
                    rs.Add(i);
                }
            }

            return rs;
        }
        public List<string> GetMailRecipients(string mailto)
        {
            string[] mt = mailto.Split(new[] { ";" }, StringSplitOptions.None);
            List<string> mr = new List<string>();
            foreach (string r in mt)
            {
                if (!String.IsNullOrEmpty(r))
                {
                    switch (r.ToLower())
                    {
                        case "requestor":
                            mr.Add(r);
                            break;
                        case "divisionapprover":
                            mr.Add(r);
                            break;
                        case "reviewer":
                            mr.Add(ConfigurationManager.AppSettings["LeadReviewerGroup"].ToString());
                            break;
                        case "scheduler":
                            mr.Add(ConfigurationManager.AppSettings["LeadSchedulerDomainGroup"].ToString());
                            break;
                        default:
                            mr.Add(r);
                            break;
                    }
                }
            }

            return mr;
        }
    }
}