using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ReportDeployer
{
    public class Security
    {
        String _name;
        String _role;

        public Security(String name, String role)
        {
            _name = name;
            _role = role;
        }

        public String getName()
        {
            return _name;
        }

        public String getRole()
        {
            return _role;
        }
    }
}
