using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Globalization;

namespace CCRAT.Web
{
    public static class CCRATString
    {
        public static string CCRAT = "CCRAT";

        public static string Race = "Race";
        public static string Gender = "Gender";
        public static string Age = "Age";
        public static string Hispanic = "Hispanic";
        public static string Feet = "Feet";
        public static string Inch = "Inch";
        public static string Weight = "Weight";

        public static string Veggie = "Veggie";
        public static string VeggieAmount = "VeggieAmount";

        public static string Colonoscopy = "Colonoscopy";
        public static string Polyp = "Polyp";

        public static string Aspirin = "Aspirin";
        public static string Ibuprofen = "Ibuprofen";

        public static string ModerateActivities = "ModerateActivities";
        public static string ModerateHours = "ModerateHours";
        public static string VigorousActivities = "VigorousActivities";
        public static string VigorousHours = "VigorousHours";

        public static string MoreThan100Cigs = "MoreThan100Cigs";
        public static string StartSmoke = "StartSmoke";
        public static string StillSmoke = "StillSmoke";
        public static string SmokeQuit = "SmokeQuit";
        public static string CigNumPerDay = "CigNumPerDay";
        
        public static string LastCycle = "LastCycle";
        public static string Period = "Period";
        public static string UsedEstrogen = "UsedEstrogen";

        public static string NumRelativesHavingCC = "NumRelativesHavingCC";
        public static string HasRelativeHadCC = "HasRelativeHadCC";

        public static string ReplaceNAN(this string s)
        {
            if (string.IsNullOrEmpty(s))
                return string.Empty;
            else 
                return s.Replace("NAN",string.Empty);
        }
    }

    public partial class Result : System.Web.UI.Page
    {
        public string Input5yearHigh { get; set; }
        public string Input5yearLow { get; set; }
        public string Input5yearAvg { get; set; }
        public string Input10yearHigh { get; set; }
        public string Input10yearLow { get; set; }
        public string Input10yearAvg { get; set; }
        public string InputLTyearHigh { get; set; }
        public string InputLTyearLow { get; set; }
        public string InputLTyearAvg { get; set; }

       

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {              
                RenderTabs();               
            }
        }


        private void RenderTabs()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs[CCRATString.Gender].ToLower() == "male")
                {
                    this.WUCMiscellaneous.Visible = true;
                    this.WUCMiscWoman.Visible = false;
                }
                else
                {
                    this.WUCMiscellaneous.Visible = false;
                    this.WUCMiscWoman.Visible = true;
                }

                //foreach (KeyValuePair<string, string> info in inputs)
                //{
                //    Response.Output.Write("{0} = {1} <br />", info.Key, info.Value);
                //}

                //Convert height to inches
                int feet = Int32.Parse(inputs[CCRATString.Feet]);
                int inches = 0;
                Int32.TryParse(inputs[CCRATString.Inch], out inches);

                int height = (feet * 12) + inches;

                //Calculate the risk

                CCRAT.RiskCalculator.AbsoluteRisks risks = CCRAT.RiskCalculator.Manager.CalculateRisks(
                        inputs[CCRATString.Hispanic].ReplaceNAN(),
                        inputs[CCRATString.Race].ReplaceNAN(),
                        inputs[CCRATString.Age].ReplaceNAN(),
                        inputs[CCRATString.Gender].ReplaceNAN(),
                        height.ToString(),
                        inputs[CCRATString.Weight].ReplaceNAN(),
                        inputs[CCRATString.Veggie].ReplaceNAN(),
                        inputs[CCRATString.VeggieAmount].ReplaceNAN(),
                        inputs[CCRATString.Colonoscopy].ReplaceNAN(),
                        inputs[CCRATString.Polyp].ReplaceNAN(),
                        inputs[CCRATString.Aspirin].ReplaceNAN(),
                        inputs[CCRATString.Ibuprofen].ReplaceNAN(),
                        inputs[CCRATString.MoreThan100Cigs].ReplaceNAN(),
                        inputs[CCRATString.StartSmoke].ReplaceNAN(),
                        inputs[CCRATString.StillSmoke].ReplaceNAN(),
                        inputs[CCRATString.SmokeQuit].ReplaceNAN(),
                        inputs[CCRATString.CigNumPerDay].ReplaceNAN(),
                        inputs[CCRATString.VigorousActivities].ReplaceNAN(),
                        inputs[CCRATString.VigorousHours].ReplaceNAN(),
                        inputs[CCRATString.Period].ReplaceNAN(),
                        inputs[CCRATString.LastCycle].ReplaceNAN(),
                        inputs[CCRATString.UsedEstrogen].ReplaceNAN(),
                        inputs[CCRATString.HasRelativeHadCC].ReplaceNAN(),
                        inputs[CCRATString.NumRelativesHavingCC].ReplaceNAN()
                );

                int fiveYear = GetTotalPeople(risks.AbsRisk05L, risks.AbsRisk05U);
                int tenYear = GetTotalPeople(risks.AbsRisk10L, risks.AbsRisk10U);
                int lifeYear = GetTotalPeople(risks.AbsRskLTL, risks.AbsRiskLTU);
                //Assign risk to the control property
                // 5 year
                this.Input5yearHigh = this.WUCResult1.InputHigh = Math.Round(risks.AbsRisk05U * 100, 1).ToString();
                this.Input5yearLow = this.WUCResult1.InputLow = Math.Round(risks.AbsRisk05L * 100, 1).ToString();
                this.Input5yearAvg = this.WUCResult1.InputAvg = risks.FiveYearAvgRiskPercent.ToString();

                this.WUCResult1.InputHighRound = Math.Round(double.Parse(risks.AbsRisk05U.ToString()) * fiveYear).ToString();
                this.WUCResult1.InputLowRound = Math.Round(double.Parse(risks.AbsRisk05L.ToString()) * fiveYear).ToString();
                this.WUCResult1.Years = "5 year";
                this.WUCResult1.PeopleTotal = fiveYear.ToString();

                string comparer = CreateComparer(risks.FiveYearAbsRisk, risks.FiveYearAvgRisk);
                this.WUCResult1.Comparison = comparer;

                //10 years
               this.Input10yearHigh = this.WUCResult2.InputHigh = Math.Round(risks.AbsRisk10U* 100, 1).ToString();
               this.Input10yearLow = this.WUCResult2.InputLow = Math.Round(risks.AbsRisk10L * 100, 1).ToString();
               this.Input10yearAvg =  this.WUCResult2.InputAvg = risks.TenYearAvgRiskPercent.ToString();

                this.WUCResult2.InputHighRound = Math.Round(double.Parse(risks.AbsRisk10U.ToString()) * tenYear).ToString();
                this.WUCResult2.InputLowRound = Math.Round(double.Parse(risks.AbsRisk10L.ToString()) * tenYear).ToString();
                this.WUCResult2.PeopleTotal = tenYear.ToString();
                this.WUCResult2.Years = "10 year";
                comparer = CreateComparer(risks.TenYearAbsRisk, risks.TenYearAvgRisk);
                this.WUCResult2.Comparison = comparer;
                //lifetime
                this.InputLTyearHigh = this.WUCResult.InputHigh = Math.Round(risks.AbsRiskLTU * 100, 1).ToString();
                this.InputLTyearLow = this.WUCResult.InputLow = Math.Round(risks.AbsRskLTL * 100, 1).ToString();
                this.InputLTyearAvg = this.WUCResult.InputAvg = risks.LifeTimeAvgRiskPercent.ToString();

                this.WUCResult.InputHighRound = Math.Round(double.Parse(risks.AbsRiskLTU.ToString()) * lifeYear).ToString();
                this.WUCResult.InputLowRound = Math.Round(double.Parse(risks.AbsRskLTL.ToString()) * lifeYear).ToString();
               this.WUCResult.PeopleTotal = lifeYear.ToString();

                comparer = CreateComparer(risks.LifetimeAbsRisk, risks.LifetimeAvgRisk);

                this.WUCResult.Years = "lifetime";
                this.WUCResult.Comparison = comparer;
                //common value
                string race =(inputs[CCRATString.Hispanic].ToLower()=="yes"? "Hispanic" :inputs[CCRATString.Race]);

                this.WUCResult1.Age = this.WUCResult.Age = this.WUCResult2.Age = inputs[CCRATString.Age];
                this.WUCResult1.Race = this.WUCResult.Race = this.WUCResult2.Race = race;
                this.WUCResult1.Gender = this.WUCResult.Gender = this.WUCResult2.Gender = inputs[CCRATString.Gender];
            }
        }

        private int GetTotalPeople(decimal low, decimal high)
        {
            int returnValue=1000;
            double x = double.Parse(low.ToString());
            double y = double.Parse(high.ToString());
            if (x >= 0.01)
                returnValue = 100;
            if (y < 0.001)
                returnValue = 10000;
            
            return returnValue;
        }

        private  string CreateComparer(decimal self, decimal avg) 
        {
            Response.Write(self + "<br>" + avg);
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

        protected void btnStartOver_click(object sender, ImageClickEventArgs e)
        {
            Session[CCRATString.CCRAT] = null;
            Response.Redirect("tool.aspx");
        }

        protected void btnCalculate_Click(object sender, ImageClickEventArgs e)
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
                Page.Validate("vgDemo");
                Page.Validate("vgDiet");
                Page.Validate("vgMed");
                Page.Validate("vgHistory");
                Page.Validate("vgActivity");
                Page.Validate("vgFamily");
                 Page.Validate("vgMisc");
               

                if (Page.IsValid)
                {//Save the info to Sesession first
                    this.WUCDemo.Save();
                    this.WUCDiet.Save();
                    this.WUCFamily.Save();
                    this.WUCMedicalHistory.Save();
                    this.WUCMedication.Save();
                    this.WUCPhysicalActivity.Save();


                    if (inputs[CCRATString.Gender].ToLower() == "male")
                    {
                        this.WUCMiscellaneous.Save();
                    }
                    else
                    {
                        this.WUCMiscWoman.Save();
                    }
                    //Then redirect
                    Response.Redirect("result.aspx");
                }
            }
        }
    }
}
