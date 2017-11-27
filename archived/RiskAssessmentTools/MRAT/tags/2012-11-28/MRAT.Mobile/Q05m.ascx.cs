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
    public partial class Q05m : MratQuestion
    {
        protected override void OnInit(EventArgs e)
        {
            Question = 5;
            ExplanationURL = "Q5mex.aspx";
            SessionKey = Manager.sunburn;
            InputControl = this.answer;
        }
    }
}