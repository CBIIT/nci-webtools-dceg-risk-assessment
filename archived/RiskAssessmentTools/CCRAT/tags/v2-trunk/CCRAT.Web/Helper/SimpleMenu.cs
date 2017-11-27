using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace CCRAT.Web.Helper
{
    public class SimpleMenu: Menu
    {
        protected override HtmlTextWriterTag TagKey
        {
            get
            {
                return base.TagKey;
            }
        }
        public override void RenderBeginTag(HtmlTextWriter writer)
        {
            
        }
    }
}
