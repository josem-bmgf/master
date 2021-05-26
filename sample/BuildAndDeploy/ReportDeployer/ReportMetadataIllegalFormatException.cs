using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ReportDeployer
{
    public class ReportMetadataIllegalFormatException : Exception
    {
        public ReportMetadataIllegalFormatException()
        {
        }

        public ReportMetadataIllegalFormatException(string message)
            : base(message)
        {
        }
    

    }
}
