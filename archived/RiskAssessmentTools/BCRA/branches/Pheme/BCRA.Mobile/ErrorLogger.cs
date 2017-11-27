using System;
using System.Data;
using System.Diagnostics;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace BCRA.Mobile
{
    public static class ErrorLogger
    {
        public static void LogError(string message, Exception ex)
        {
            string logsource = ConfigurationManager.AppSettings["LogSource"];

            string errorMessage = "BCRA.MOBILE Error: \n" + message + " \n" + ex.ToString();

            try
            {
                if (logsource != null && EventLog.Exists(logsource))
                {
                    EventLog.WriteEntry(logsource, errorMessage, EventLogEntryType.Error);
                }
            }
            catch (Exception exc)
            {
                //Do nothing.
            }
        }
    }
}
