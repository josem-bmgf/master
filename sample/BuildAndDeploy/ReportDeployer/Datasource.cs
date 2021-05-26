using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ReportDeployer
{
    public class Datasource 
    {
        String _name;
        String _connection;
        String _dsFolderPath;
        Boolean _isDeleted;
        Boolean _isActive;
        Boolean _isHidden;
        String _dsUserName;
        String _dsUserPass;
        Boolean _isWinCredential;

        public Datasource(String name, String connection, String dsFolderPath, Boolean isDeleted, Boolean isActive, Boolean isHidden, String dsUserName, String dsUserPass, Boolean isWinCredential)
        {
            _name = name;
            _connection = connection;
            _dsFolderPath = dsFolderPath;
            _isActive = isActive;
            _isDeleted = isDeleted;
            _isHidden = isHidden;
            _dsUserName = dsUserName;
            _dsUserPass = dsUserPass;
            _isWinCredential = isWinCredential;
        }

        public Boolean isActive()
        {
            return _isActive;
        }

        public Boolean isHidden()
        {
            return _isHidden;
        }

        public Boolean isDeleted()
        {
            return _isDeleted;
        }

        public String getName()
        {
            return _name;
        }

        public String getConnection()
        {
            return _connection;
        }

        public String getDsFolderPath()
        {
            return _dsFolderPath;
        }

        public String getDsUserName()
        {
            return _dsUserName;
        }

        public String getDsUserPass()
        {
            return _dsUserPass;
        }

        public Boolean isWinCredential()
        {
            return _isWinCredential;
        }
    }
}
