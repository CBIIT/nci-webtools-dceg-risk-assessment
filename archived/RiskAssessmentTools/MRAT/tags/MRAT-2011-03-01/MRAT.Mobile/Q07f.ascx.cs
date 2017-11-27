using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace MRAT.Mobile
{
    public partial class Q07f : MratQuestion
    {
        protected override void OnInit(EventArgs e)
        {
            Question = 7;
            SessionKey = Manager.smallmolesfemales;
            ExplanationURL = "Q1ex.aspx";
            InputControl = this.answer;
        }    
    }
}