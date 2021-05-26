using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ReportDeployer
{
    public class ReportModel
    {
        List<Datasource> _datasources;
        List<Folder> _folders;

        public ReportModel(List<Datasource> datasources, List<Folder> folders)
        {
            _datasources = datasources;
            _folders = folders;
        }

        public List<Datasource> getDatasources()
        {
            return _datasources;
        }

        public List<Folder> getFolders()
        {
            return _folders;
        }

    }
}
