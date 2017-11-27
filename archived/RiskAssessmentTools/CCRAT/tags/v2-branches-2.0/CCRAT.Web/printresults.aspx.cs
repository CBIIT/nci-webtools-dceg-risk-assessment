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
using System.Collections.Generic;

namespace CCRAT.Web
{
    public partial class printresults : System.Web.UI.Page
    {
        public string InputHigh5 { get; set; }
        public string InputLow5 { get; set; }
        public string InputHighRound5 { get; set; }
        public string InputLowRound5 { get; set; }
        public string InputAvg5 { get; set; }
        public string Comparison5 { get; set; }

        public string InputHigh10 { get; set; }
        public string InputLow10 { get; set; }
        public string InputHighRound10 { get; set; }
        public string InputLowRound10 { get; set; }
        public string InputAvg10 { get; set; }
        public string Comparison10 { get; set; }

        public string InputHighlt { get; set; }
        public string InputLowlt { get; set; }
        public string InputHighRoundlt { get; set; }
        public string InputLowRoundlt { get; set; }
        public string InputAvglt { get; set; }
        public string Comparisonlt { get; set; }

        public string PeopleTotal5 { get; set; }
        public string persons5 { get; set; }
        public string PeopleTotal10 { get; set; }
        public string persons10 { get; set; }
        public string PeopleTotallt { get; set; }
        public string personslt { get; set; }

        public string Hispanic { get; set; }
        public string Race { get; set; }
        public string Gender { get; set; }
        public string Age { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session[CCRATString.CCRAT] != null)
                {
                    Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
                    CCRAT.RiskCalculator.AbsoluteRisks risks = (CCRAT.RiskCalculator.AbsoluteRisks)Session["Risk"];
                    int fiveYear = GetTotalPeople(risks.AbsRisk05L, risks.AbsRisk05U);
                    int tenYear = GetTotalPeople(risks.AbsRisk10L, risks.AbsRisk10U);
                    int lifeYear = GetTotalPeople(risks.AbsRskLTL, risks.AbsRiskLTU);


                    InputHigh5 = Math.Round(risks.AbsRisk05U * 100, 1).ToString();
                    InputLow5 = Math.Round(risks.AbsRisk05L * 100, 1).ToString();
                    InputHighRound5 = Math.Round(double.Parse(risks.AbsRisk05U.ToString()) * fiveYear).ToString();
                    InputLowRound5 = Math.Round(double.Parse(risks.AbsRisk05L.ToString()) * fiveYear).ToString();
                    InputAvg5 = risks.FiveYearAvgRiskPercent.ToString();
                    string comparer = CreateComparer(risks.FiveYearAbsRisk, risks.FiveYearAvgRisk);
                    Comparison5 = comparer;
                    if (float.Parse(InputHigh5) < 1 || float.Parse(InputLow5) < 1)
                    {
                        PeopleTotal5 = "1000";
                        persons5 = "1000";
                    }
                    else
                    {
                        PeopleTotal5 = "100";
                        persons5 = "100";

                    }

                    InputHigh10 = Math.Round(risks.AbsRisk10U * 100, 1).ToString();
                    InputLow10 = Math.Round(risks.AbsRisk10L * 100, 1).ToString();
                    InputHighRound10 = Math.Round(double.Parse(risks.AbsRisk10U.ToString()) * tenYear).ToString();
                    InputLowRound10 = Math.Round(double.Parse(risks.AbsRisk10L.ToString()) * tenYear).ToString();
                    InputAvg10 = risks.TenYearAvgRiskPercent.ToString();
                    comparer = CreateComparer(risks.TenYearAbsRisk, risks.TenYearAvgRisk);
                    Comparison10 = comparer;

                    if (float.Parse(InputHigh10) < 1 || float.Parse(InputLow10)<1)
                    {
                        PeopleTotal10 = "1000";
                        persons10 = "1000";
                    }
                    else
                    {
                        PeopleTotal10 = "100";
                        persons10 = "100";

                    }

                    InputHighlt = Math.Round(risks.AbsRiskLTU * 100, 1).ToString();
                    InputLowlt = Math.Round(risks.AbsRskLTL * 100, 1).ToString();
                    InputHighRoundlt = Math.Round(double.Parse(risks.AbsRiskLTU.ToString()) * lifeYear).ToString();
                    InputLowRoundlt = Math.Round(double.Parse(risks.AbsRskLTL.ToString()) * lifeYear).ToString();
                    InputAvglt = risks.LifeTimeAvgRiskPercent.ToString();
                    comparer = CreateComparer(risks.LifetimeAbsRisk, risks.LifetimeAvgRisk);
                    Comparisonlt = comparer;

                    if (float.Parse(InputHighlt) < 1 || float.Parse(InputLowlt)<1)
                    {
                        PeopleTotallt = "1000";
                        personslt = "1000";
                    }
                    else
                    {
                        PeopleTotallt = "100";
                        personslt = "100";

                    }


                    //common value
                    string race = (inputs[CCRATString.Hispanic].ToLower() == "yes" ? "Hispanic" : inputs[CCRATString.Race]);

                    Age = inputs[CCRATString.Age];
                    Race = race;
                    Gender = inputs[CCRATString.Gender];


                }
            }
            catch (Exception ex)
            {
                Response.Write("There is a problem printing this page.Please try again later.");
            }
        }

        private string CreateComparer(decimal self, decimal avg)
        {
            //Commented by ravi
            //Response.Write(self + "<br>" + avg);
            string comparer = "";
            if (self > avg)
                comparer = "higher than";
            else if (self < avg)
                comparer = "lower than";
            else
            {
                comparer = "equals to";
            }
            return comparer;
        }

        private int GetTotalPeople(decimal low, decimal high)
        {
            int returnValue = 1000;
            double x = double.Parse(low.ToString());
            double y = double.Parse(high.ToString());
            if (x >= 0.01)
                returnValue = 100;
            if (y < 0.001)
                returnValue = 10000;

            return returnValue;
        }
    }
}
