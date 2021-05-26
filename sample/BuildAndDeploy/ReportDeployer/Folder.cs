using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using Microsoft.SqlServer.ReportingServices2005;
using System.Web.Services.Protocols;

namespace ReportDeployer 
{
    public class Folder //: IComparable
    {

        String               _name;
        String               _description; 
        String               _path;
        Boolean              _isHidden;
        Boolean              _isActive;
        Boolean              _isDeleted;
        List<Security>       _securities;
        List<Report>         _reports;
        List<Folder>         _children;
        Folder               _parentFolder;
        Boolean _inheritSecurity;


        public Folder(String name, String description, String path, Boolean isHidden, 
                        Boolean isActive, Boolean isDeleted, Folder parentFolder, Boolean inheritSecurity)
        {
            _name = name;
            _description = description;
            _path = path;
            _isHidden = isHidden;
            _isActive = isActive;
            _isDeleted = isDeleted;
            _parentFolder = parentFolder;
            _inheritSecurity = inheritSecurity;

            _securities = new List<Security>();
            _reports = new List<Report>();
            _children = new List<Folder>();
        }

        public void addSecurity(Security security)
        {
            _securities.Add(security);
        }

        public void addReport(Report report)
        {
            _reports.Add(report);
        }

        public void addChild(Folder folder)
        {
            _children.Add(folder);
        }

        public List<Security> getSecurties()
        {
            return _securities;
        }
      

        public List<Report> getReports()
        {
            return _reports;
        }

        public List<Folder> getChildren()
        {
            return _children;
        }

        public Boolean inheritSecurity()
        {
            return _inheritSecurity;
        }

        public String getName()
        {
            return _name;
        }

        public String getDescription()
        {
            return _description;
        }

        public String getPath()
        {
            return _path;
        }

        public Folder getParent()
        {
            return _parentFolder;
        }

        public Boolean isHidden()
        {
            return _isHidden;
        }

        public Boolean isActive()
        {
            return _isActive;
        }

        public Boolean isDeleted()
        {
            return _isDeleted;
        }
    }
}
