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

namespace CCRAT.Web.UserControls
{
    public partial class Results : System.Web.UI.UserControl
    {
        private const string _cannotCmpute = "Risks could not be computed for this combination of risk factors";
        public CCRAT.RiskCalculator.AbsoluteRisks Risks
        {
            set
            {
                if (value.Is5YrRiskValid)
                {
                    ph5Year.Visible = true;
                    main5YearRisk.InnerHtml = value.FiveYearAbsRiskPercent.ToString() + "%";
                    exp5YearRisk.InnerHtml = value.FiveYearAbsRiskPercent.ToString() + "%";
                }

                if (value.Is10YrRiskValid)
                {
                    ph10Year.Visible = true;
                    main10YearRisk.InnerHtml = value.TenYearAbsRiskPercent.ToString() + "%";
                    exp10YearRisk.InnerHtml = value.TenYearAbsRiskPercent.ToString() + "%";
                }

                if (value.IsPatternFoundInDB)
                {
                    phLifeRisk.Visible = true;
                    mainLifeRisk.InnerHtml = value.LifetimeAbsRiskPercent.ToString() + "%";
                    expLifeRisk.InnerHtml = value.LifetimeAbsRiskPercent.ToString() + "%";
                }
                else
                {
                    phErrorMsg.Visible = true;
                    errorMsg.InnerHtml = string.Format(@"Pattern {0} {1}"
                        , value.PatternID.ToString()
                        , _cannotCmpute);
                }


                age.InnerHtml = value.CurrentAge;
                gender.InnerHtml = value.Gender;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ph5Year.Visible = false;
            ph10Year.Visible = false;
            phLifeRisk.Visible = false;
            phErrorMsg.Visible = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
        }
    }
}