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
    public partial class Q02 : MratQuestion
    {
        protected override void OnInit(EventArgs e)
        {
            Question = 2;
            ExplanationURL = "Q2ex.aspx";
            SessionKey = Manager.sex;
            InputControl = this.answer;
        }   
    }
}