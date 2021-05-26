using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using Microsoft.SqlServer.ReportingServices2005;
using System.IO;
using System.Web.Services.Protocols;

namespace ReportDeployer
{
    public class Report
    {
   

        String   _name;
        String   _description;
        String   _technicalDescription;
        Boolean  _isHidden;
        Boolean  _isActive;
        Boolean  _isDeleted;
        List<Datasource> _datasources;

        public Report(String name, String description, String technicalDescription, 
                        Boolean isHidden, Boolean isActvie, Boolean isDeleted)
        {
            _name = name;
            _description = description;
            _technicalDescription = technicalDescription;
            _isHidden = isHidden;
            _isActive = isActvie;
            _isDeleted = isDeleted;
            _datasources = new List<Datasource>();
        }


        public String getName()
        {
            return _name;
        }

        public String getDescription()
        {
            return _description;
        }

        public String getTechnicalDescription()
        {
            return _technicalDescription;
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

        public void updateParameters()
        {
        //updateParameters with the correct defaults
          throw new NotImplementedException();
        }

        public void addDataSources(Datasource ds)
        {
            _datasources.Add(ds);
        }

        public List<Datasource> getDatasources()
        {
            return _datasources;
        }
    }
}
