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
namespace CCRAT.Web
{
    public partial class Default : System.Web.UI.Page
    {
        private CCRAT.Web.UserControls.Results _results;
        private CCRAT.Web.UserControls.QuestionAsker2 _questionAsker;

        protected void Page_Load(object sender, EventArgs e)
        {

            _results = (CCRAT.Web.UserControls.Results)Page.LoadControl("~/UserControls/Results.ascx");
            _results.ID = "Results";
            phToolView.Controls.Add(_results);
            _results.Visible = false;

            _questionAsker = (CCRAT.Web.UserControls.QuestionAsker2)Page.LoadControl("~/UserControls/QuestionAsker2.ascx");
            _questionAsker.ID = "QuestionAsker";
            phToolView.Controls.Add(_questionAsker);
            _questionAsker.CalculateRisk += new CCRAT.Web.UserControls.CalculationEventHandler(_questionAsker_CalculateRisk);
            _questionAsker.DisplayMode = QuestionDisplayModes.Questioning;

            lnlExpResults.Visible = false;
            litEmpty.Visible = true;
        }

        void _questionAsker_CalculateRisk(object sender, CCRAT.Web.UserControls.CalculationEventArgs e)
        {
            _results.Visible = true;
            _results.Risks = e.Risks;
            _questionAsker.DisplayMode = QuestionDisplayModes.Results;
            phToolNotes.Visible = false;
            this.MaintainScrollPositionOnPostBack = false;
            lnlExpResults.Visible = true;
            litEmpty.Visible = false;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (_questionAsker.DisplayMode == QuestionDisplayModes.Questioning)
            {
                imgQuestionBoxTitle.Visible = true;
                imgResults.Visible = false;
            }
            else
            {
                imgQuestionBoxTitle.Visible = false;
                imgResults.Visible = true;
            }

        }

    }
}
