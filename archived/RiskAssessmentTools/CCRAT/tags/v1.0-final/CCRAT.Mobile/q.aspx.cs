using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using CCRAT.RiskCalculator;
namespace CCRAT.Mobile
{
    public partial class Q : System.Web.UI.Page
    {
        private CCRAT.Mobile.UserControls.QuestionAsker _questionAsker;
        protected void Page_Load(object sender, EventArgs e)
        {
            _questionAsker = (CCRAT.Mobile.UserControls.QuestionAsker)Page.LoadControl("~/UserControls/QuestionAsker.ascx");
            _questionAsker.ID = "q";
            phToolView.Controls.Add(_questionAsker);
            _questionAsker.DisplayMode = QuestionDisplayModes.Questioning;

        }
    }
}
