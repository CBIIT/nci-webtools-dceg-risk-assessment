using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace MRAT.Mobile
{   
    public class Helper
    {
        public static string GetRequestValue(string Name, string DefaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[Name];
            return (o != null) ? o.ToString() : DefaultValue;
        }
        public static long GetRequestValue(string Name, long DefaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[Name];
            return (o != null) ? Convert.ToInt64(o) : DefaultValue;
        }

        public static bool GetRequestValue(string Name, bool DefaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[Name];
            return (o != null) ? Convert.ToBoolean(o) : DefaultValue;
        }
    }
}
