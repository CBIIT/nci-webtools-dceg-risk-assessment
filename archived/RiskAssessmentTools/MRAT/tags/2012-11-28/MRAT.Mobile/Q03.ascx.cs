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
    public partial class Q03 : MratQuestion
    {
        protected override void OnInit(EventArgs e)
        {
            Question = 3;
            ExplanationURL = "Q3ex.aspx";
            SessionKey = Manager.race;
            InputControl = this.answer;

        }

        protected override void OnLoad(EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                lblY.InnerText = (Session[Manager.sex] != null && ((GenderType)Session[Manager.sex]).Equals(GenderType.Male)) ? Manager.MaleQuestions.ToString() : Manager.FemaleQuestions.ToString();
            }
            base.OnLoad(e);
        }       
    }
}