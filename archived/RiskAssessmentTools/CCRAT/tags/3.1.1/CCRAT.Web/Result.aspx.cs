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
        public string Input5yearAbs { get; set; }
        public string Input10yearAbs { get; set; }
        public string InputLifeAbs { get; set; }

        //Print related 
        //Variables from calculation 
        public decimal FiveYearRisk { get; set; }
        public decimal FiveYearRiskRangeStart { get; set; }
        public decimal FiveYearRiskRangeEnd { get; set; }
        public decimal FiveYearRiskAverage { get; set; }

        public decimal TenYearRisk { get; set; }
        public decimal TenYearRiskRangeStart { get; set; }
        public decimal TenYearRiskRangeEnd { get; set; }
        public decimal TenYearRiskAverage { get; set; }

        public decimal LifetimeRisk { get; set; }
        public decimal LifetimeRiskRangeStart { get; set; }
        public decimal LifetimeRiskRangeEnd { get; set; }
        public decimal LifetimeRiskAverage { get; set; }

        //Output and output formatting variables 
        public string Sex { get; set; }

        public string FiveYearRiskText = "YOUR 5 YEAR RISK";
        public string FiveYearAverageText = "AVERAGE RISK";
        public string FiveYearRiskRangeText = "YOUR 5 YEAR RISK RANGE";

        public string TenYearRiskText = "YOUR 10 YEAR RISK";
        public string TenYearAverageText = "AVERAGE RISK";
        public string TenYearRiskRangeText = "YOUR 10 YEAR RISK RANGE";

        public string LifetimeRiskText = "YOUR LIFETIME RISK";
        public string LifetimeAverageText = "AVERAGE RISK";
        public string LifetimeRiskRangeText = "YOUR LIFETIME RISK RANGE";



        public string FiveYearRiskArrowLeft { get; set; }
        public string FiveYearRiskTextLeft { get; set; }
        //public string FiveYearRiskText { get; set; }
        public string FiveYearAverageArrowLeft { get; set; }
        public string FiveYearAverageTextLeft { get; set; }
        //public string FiveYearAverageText { get; set; }
        public string FiveYearRiskRange { get; set; }
        public string FiveYearRiskRangeTextLeft { get; set; }
        //public string FiveYearRiskRangeText { get; set; }
        public string FiveYearGraphLine { get; set; }

        public string TenYearRiskArrowLeft { get; set; }
        public string TenYearRiskTextLeft { get; set; }
        //public string TenYearRiskText { get; set; }
        public string TenYearAverageArrowLeft { get; set; }
        public string TenYearAverageTextLeft { get; set; }
        //public string TenYearAverageText { get; set; }
        public string TenYearRiskRange { get; set; }
        public string TenYearRiskRangeTextLeft { get; set; }
        //public string TenYearRiskRangeText { get; set; }
        public string TenYearGraphLine { get; set; }

        public string LifetimeRiskArrowLeft { get; set; }
        public string LifetimeRiskTextLeft { get; set; }
        //public string LifetimeRiskText { get; set; }
        public string LifetimeAverageArrowLeft { get; set; }
        public string LifetimeAverageTextLeft { get; set; }
        //public string LifetimeAverageText { get; set; }
        public string LifetimeRiskRange { get; set; }
        public string LifetimeRiskRangeTextLeft { get; set; }
        //public string LifetimeRiskRangeText { get; set; }
        public string LifetimeGraphLine { get; set; }

        public string Responses { get; set; }

        public static double[] graphPosition = new double[21] 
            { 18,  38,  59,  81, 101, 123, 145, 164, 186, 207, 228,
             249, 271, 292, 312, 334, 355, 376, 398, 418, 439 };


       

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                RenderTabs();
                RequiredField.Attributes.CssStyle.Value = "display: none;";

            }

            else
            {
            }
            try
            {
                if (Session["CurrentYearTab"].ToString() == "5Y")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "currenttab", "<script>$(document).ready(function() {$(\"#tabs\").tabs({ selected: 0 });$('.tabsinfo a').click(function() {switch_tabs($(this));});$('#higherRisk>li>div').hide();$('#higherRisk>li>a.ref_link_more').click(ToggleLi);$('#lowerRisk>li>div').hide();$('#lowerRisk>li>a.ref_link_more').click(ToggleLi);});</script>");

                }
                else if (Session["CurrentYearTab"].ToString() == "10Y")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "currenttab", "<script>$(document).ready(function() {$(\"#tabs\").tabs({ selected: 1 });$('.tabsinfo a').click(function() {switch_tabs($(this));});$('#higherRisk>li>div').hide();$('#higherRisk>li>a.ref_link_more').click(ToggleLi);$('#lowerRisk>li>div').hide();$('#lowerRisk>li>a.ref_link_more').click(ToggleLi);});</script>");

                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "currenttab", "<script>$(document).ready(function() {$(\"#tabs\").tabs({ selected: 2 });$('.tabsinfo a').click(function() {switch_tabs($(this));});$('#higherRisk>li>div').hide();$('#higherRisk>li>a.ref_link_more').click(ToggleLi);$('#lowerRisk>li>div').hide();$('#lowerRisk>li>a.ref_link_more').click(ToggleLi);});</script>");

                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(this.GetType(), "currenttab", "<script>$(document).ready(function() {$(\"#tabs\").tabs({ selected: 2 });$('.tabsinfo a').click(function() {switch_tabs($(this));});$('#higherRisk>li>div').hide();$('#higherRisk>li>a.ref_link_more').click(ToggleLi);$('#lowerRisk>li>div').hide();$('#lowerRisk>li>a.ref_link_more').click(ToggleLi);});</script>");

            }

            // Print related 




 



        }

        protected void Page_PreRender(object sender, EventArgs e)
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

            if (IsPostBack)
            {
                //definitionEdit.Attributes.CssStyle.Value = "display:;";
              //ClientScript.RegisterStartupScript(this.GetType(),"EditPerInfo", "<script>javascript:toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#defaulttab'))</script>");
                Label LblMsgMisc = (Label)WUCDemo.FindControl("lblMessageMisc");
                if (Session["FocusTab"].ToString() == "")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "EditPerInfo", "<script>toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#defaulttab'))</script>");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "EditPerInfo", "<script>toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#" + Session["FocusTab"].ToString() + "'))</script>");

                    //Page.Validate("vgMisc");
                    //if (Page.IsValid)
                    //{
                    //    ClientScript.RegisterStartupScript(this.GetType(), "EditPerInfo", "<script>toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#" + Session["FocusTab"].ToString() + "'))</script>");
                    //}
                    //else
                    //{
                    //    ClientScript.RegisterStartupScript(this.GetType(), "EditPerInfo", "<script>toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#Misctab'))</script>");

                    //}

                }


                if (inputs[CCRATString.Gender].ToLower() != txtGender.Value.ToLower())
                {
                    RenderTabs1();

                }

                if (inputs[CCRATString.Gender].ToLower() == txtGender.Value.ToLower())
                {
                    RenderTabs();
                    LblMsgMisc.Visible = false;

                }
                else
                {
                    LblMsgMisc.Visible = true;

                    if (txtGender.Value == "Male")
                    {
                        LblMsgMisc.Text = "Please fill in the complete information for the Female \"Misc\" Tab.";
                        //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationFemale", "<script>alert('Please fill in the complete information for the Female \"Misc\" Tab.');</script>");


                    }
                    else
                    {
                        LblMsgMisc.Text = "Please fill in the complete information for the Male \"Misc\" Tab.";
                        //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMale", "<script>alert('Please fill in the complete information for the Male \"Misc\" Tab.');</script>");


                    }

                }
            }
            //cl=this.WUCDemo.FindControl("rblSex");
            

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
                    txtGender.Value = "Male";
                }
                else
                {
                    this.WUCMiscellaneous.Visible = false;
                    this.WUCMiscWoman.Visible = true;
                    txtGender.Value = "Female";

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

                Session["Risk"] = risks;
                int fiveYear = GetTotalPeople(risks.AbsRisk05L, risks.AbsRisk05U);
                int tenYear = GetTotalPeople(risks.AbsRisk10L, risks.AbsRisk10U);
                int lifeYear = GetTotalPeople(risks.AbsRskLTL, risks.AbsRiskLTU);
                //Assign risk to the control property
                // 5 year
                this.Input5yearHigh = this.WUCResult1.InputHigh = Math.Round(risks.AbsRisk05U * 100, 1).ToString();
                this.Input5yearLow = this.WUCResult1.InputLow = Math.Round(risks.AbsRisk05L * 100, 1).ToString();
                this.Input5yearAvg = this.WUCResult1.InputAvg = risks.FiveYearAvgRiskPercent.ToString();
                this.Input5yearAbs = this.WUCResult1.InputAbsolute = risks.FiveYearAbsRiskPercent.ToString();
                //this.Input5yearAvg = this.WUCResult1.InputAvg = ((Math.Round(risks.AbsRisk05U * 100, 1) + Math.Round(risks.AbsRisk05L * 100, 1)) / 2).ToString();
                

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
               this.Input10yearAbs = this.WUCResult2.InputAbsolute = risks.TenYearAbsRiskPercent.ToString();
               //this.Input10yearAvg = this.WUCResult2.InputAvg = ((Math.Round(risks.AbsRisk10U * 100, 1) + Math.Round(risks.AbsRisk10L * 100, 1)) / 2).ToString();


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
                //this.InputLTyearAvg = this.WUCResult.InputAvg = ((Math.Round(risks.AbsRiskLTU * 100, 1) + Math.Round(risks.AbsRskLTL * 100, 1)) / 2).ToString();
                this.InputLifeAbs = this.WUCResult.InputAbsolute = risks.LifetimeAbsRiskPercent.ToString();



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


                
                //Print output
                //CalculateRisk(); // This is somewhat redundenat 
                    
                //5 year risks 
                this.FiveYearRisk = risks.FiveYearAbsRiskPercent;
                this.FiveYearRiskAverage = risks.FiveYearAvgRiskPercent;
                this.FiveYearRiskRangeStart = Math.Round(risks.AbsRisk05L * 100, 1);
                this.FiveYearRiskRangeEnd = Math.Round(risks.AbsRisk05U * 100, 1);

                //10 year risks
                this.TenYearRisk = risks.TenYearAbsRiskPercent;
                this.TenYearRiskAverage = risks.TenYearAvgRiskPercent;
                this.TenYearRiskRangeStart = Math.Round(risks.AbsRisk10L * 100, 1);
                this.TenYearRiskRangeEnd = Math.Round(risks.AbsRisk10U * 100, 1);

                //lifetime risks
                this.LifetimeRisk = risks.LifetimeAbsRiskPercent;
                this.LifetimeRiskAverage = risks.LifeTimeAvgRiskPercent;
                this.LifetimeRiskRangeStart = Math.Round(risks.AbsRskLTL * 100, 1);
                this.LifetimeRiskRangeEnd = Math.Round(risks.AbsRiskLTU * 100, 1);

                this.Sex = risks.Gender.ToLower();
                BuildOutput();
                BuildResponsesOutput();

            
            }
        }
        private void RenderTabs1()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                //if (inputs[CCRATString.Gender].ToLower() == "male")
                //{
                //    this.WUCMiscellaneous.Visible = true;
                //    this.WUCMiscWoman.Visible = false;
                //    txtGender.Value = "Male";
                //}
                //else
                //{
                //    this.WUCMiscellaneous.Visible = false;
                //    this.WUCMiscWoman.Visible = true;
                //    txtGender.Value = "Female";

                //}

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
                        txtGender.Value,
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
                Session["Risk"] = risks;
                int fiveYear = GetTotalPeople(risks.AbsRisk05L, risks.AbsRisk05U);
                int tenYear = GetTotalPeople(risks.AbsRisk10L, risks.AbsRisk10U);
                int lifeYear = GetTotalPeople(risks.AbsRskLTL, risks.AbsRiskLTU);
                //Assign risk to the control property
                // 5 year
                this.Input5yearHigh = this.WUCResult1.InputHigh = Math.Round(risks.AbsRisk05U * 100, 1).ToString();
                this.Input5yearLow = this.WUCResult1.InputLow = Math.Round(risks.AbsRisk05L * 100, 1).ToString();
                this.Input5yearAvg = this.WUCResult1.InputAvg = risks.FiveYearAvgRiskPercent.ToString();
                //this.Input5yearAvg = this.WUCResult1.InputAvg = ((Math.Round(risks.AbsRisk05U * 100, 1) + Math.Round(risks.AbsRisk05L * 100, 1)) / 2).ToString();


                this.WUCResult1.InputHighRound = Math.Round(double.Parse(risks.AbsRisk05U.ToString()) * fiveYear).ToString();
                this.WUCResult1.InputLowRound = Math.Round(double.Parse(risks.AbsRisk05L.ToString()) * fiveYear).ToString();
                this.WUCResult1.Years = "5 year";
                this.WUCResult1.PeopleTotal = fiveYear.ToString();

                string comparer = CreateComparer(risks.FiveYearAbsRisk, risks.FiveYearAvgRisk);
                this.WUCResult1.Comparison = comparer;

                //10 years
                this.Input10yearHigh = this.WUCResult2.InputHigh = Math.Round(risks.AbsRisk10U * 100, 1).ToString();
                this.Input10yearLow = this.WUCResult2.InputLow = Math.Round(risks.AbsRisk10L * 100, 1).ToString();
                this.Input10yearAvg = this.WUCResult2.InputAvg = risks.TenYearAvgRiskPercent.ToString();
                //this.Input10yearAvg = this.WUCResult2.InputAvg = ((Math.Round(risks.AbsRisk10U * 100, 1) + Math.Round(risks.AbsRisk10L * 100, 1)) / 2).ToString();


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
                //this.InputLTyearAvg = this.WUCResult.InputAvg = ((Math.Round(risks.AbsRiskLTU * 100, 1) + Math.Round(risks.AbsRskLTL * 100, 1)) / 2).ToString();


                this.WUCResult.InputHighRound = Math.Round(double.Parse(risks.AbsRiskLTU.ToString()) * lifeYear).ToString();
                this.WUCResult.InputLowRound = Math.Round(double.Parse(risks.AbsRskLTL.ToString()) * lifeYear).ToString();
                this.WUCResult.PeopleTotal = lifeYear.ToString();

                comparer = CreateComparer(risks.LifetimeAbsRisk, risks.LifetimeAvgRisk);

                this.WUCResult.Years = "lifetime";
                this.WUCResult.Comparison = comparer;
                //common value
                string race = (inputs[CCRATString.Hispanic].ToLower() == "yes" ? "Hispanic" : inputs[CCRATString.Race]);

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

        protected void btnStartOver_click(object sender, ImageClickEventArgs e)
        {
            Session[CCRATString.CCRAT] = null;
            Session["Risk"] = null;
            Response.Redirect("tool.aspx");
        }

        protected void btnCalculate_Click(object sender, ImageClickEventArgs e)
        {

            if (Session[CCRATString.CCRAT] != null)
            {
                Label LblMsgMisc = (Label)WUCDemo.FindControl("lblMessageMisc");
                LblMsgMisc.Visible = false;
                RequiredField.Attributes.CssStyle.Value = "display: none;";

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

                 else
                 {
                     //string Message = "Please complete the information in following tab(s): ";
                     //if (Session["DietValid"].ToString() == "False")                        
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + "Diet";
                     //}

                     //if (Session["MedicalHistValid"].ToString() == "False")
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + ", Medical History";

                     //}

                     //if (Session["PhysicalValid"].ToString() == "False")
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + ", Physical Activity";

                     //}

                     //if (Session["MisWomenValid"].ToString() == "False")
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + ", Miscellaneous";

                     //}

                     //if (Session["MiscValid"].ToString() == "False")
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + ", Miscellaneous";

                     //}

                     //if (Session["FamilyValid"].ToString() == "False")
                     //{
                     //    RequiredField.Attributes.CssStyle.Value = "display: block;";
                     //    Message = Message + ", Family History";

                     //}
                     //RequiredFieldMessage.InnerHtml = Message;
                     if (inputs[CCRATString.Gender].ToLower() == txtGender.Value.ToLower())
                     {

                         RenderTabs();
                     }
                     LblMsgMisc.Visible = true;
                     if (txtGender.Value == "Male")
                     {
                         LblMsgMisc.Text = "Please fill in the complete information for the Female \"Misc\" Tab.";
                     }
                     else
                     {
                         LblMsgMisc.Text = "Please fill in the complete information for the Male \"Misc\" Tab.";

                     }

                 }
            }
        }


        // Printer related ****************************************************************
        private void BuildResponsesOutput()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                Responses = "<ol>";

                //Page 1 - Demographics
                Responses += QuestionAndAnswerBuilder(
                    "Do you consider yourself to be Hispanic or Latino",
                    inputs[CCRATString.Hispanic].ToUpper());

                if (inputs[CCRATString.Hispanic].ToUpper() != "YES")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "Which of the following do you consider yourself to be",
                        inputs[CCRATString.Race].ToUpper());
                }

                Responses += QuestionAndAnswerBuilder(
                    "What is your age",
                    inputs[CCRATString.Age].ToUpper());

                Responses += QuestionAndAnswerBuilder(
                    "Are you male or female",
                    inputs[CCRATString.Gender].ToUpper());

                Responses += QuestionAndAnswerBuilder(
                    "What is your height without shoes",
                    inputs[CCRATString.Feet],
                    inputs[CCRATString.Inch]);

                Responses += QuestionAndAnswerBuilder(
                    "What is your weight without shoes",
                    inputs[CCRATString.Weight]);


                //Page 2 - Diet
                Responses += QuestionAndAnswerBuilder(
                    "In the past 30 days, about how many servings per week of vegetables or leafy green salads did you eat",
                    inputs[CCRATString.Veggie].ToUpper());

                if (inputs[CCRATString.Veggie].ToUpper() != "0")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "In the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads",
                        inputs[CCRATString.VeggieAmount].ToUpper());
                }


                //Page 3 - Medical History
                Responses += QuestionAndAnswerBuilder(
                    "During the past 10 years, did you have a colonoscopy, sigmoidoscopy, or both",
                    inputs[CCRATString.Colonoscopy].ToUpper());

                if (inputs[CCRATString.Colonoscopy].ToUpper() == "YES")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "In the past 10 years did a healthcare provider tell you that you had a colon or rectal polyp",
                        inputs[CCRATString.Polyp].ToUpper());
                }


                //Page 4 - Medications
                Responses += QuestionAndAnswerBuilder(
                    "During the past 30 days, have you taken aspirin, Bufferin, Bayer, or Excedrin at least 3 times a week",
                    inputs[CCRATString.Aspirin].ToUpper());

                Responses += QuestionAndAnswerBuilder(
                    "During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week",
                    inputs[CCRATString.Ibuprofen].ToUpper());


                //Page 5 - Physical Activity
                Responses += QuestionAndAnswerBuilder(
                    "Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity",
                    inputs[CCRATString.ModerateActivities]);

                if (inputs[CCRATString.ModerateActivities] != "0")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "During those months, on average, about how many hours per week did you do moderate physical activities",
                        inputs[CCRATString.ModerateHours].ToUpper());
                }

                Responses += QuestionAndAnswerBuilder(
                     "Over the past 12 months, in how many months, if any, did you do any kind of vigorous physical activity",
                     inputs[CCRATString.VigorousActivities]);

                if (inputs[CCRATString.VigorousActivities] != "0")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "During those months, on average, about how many hours per week did you do moderate physical activities",
                        inputs[CCRATString.VigorousHours].ToUpper());
                }


                //Page 6 - Miscellaneous
                if (inputs[CCRATString.Gender].ToUpper() == "MALE")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "In your entire lifetime, altogether, have you smoked 100 or more cigarettes",
                        inputs[CCRATString.MoreThan100Cigs].ToUpper());

                    if (inputs[CCRATString.MoreThan100Cigs].ToUpper() == "YES")
                    {
                        Responses += QuestionAndAnswerBuilder(
                            "How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longe",
                            inputs[CCRATString.StartSmoke].ToUpper());

                        Responses += QuestionAndAnswerBuilder(
                            "Do you currently smoke cigarettes",
                            inputs[CCRATString.StillSmoke].ToUpper());

                        if (inputs[CCRATString.StillSmoke].ToUpper() == "NO")
                        {
                            Responses += QuestionAndAnswerBuilder(
                                 "How old were you when you quit smoking cigarettes completely",
                                 inputs[CCRATString.SmokeQuit]);
                        }

                        string theAnswer = "";
                        switch (inputs[CCRATString.CigNumPerDay].ToUpper())
                        {
                            case "1TO10":
                                theAnswer = "1 TO 10 CIGARETTES A DAY";
                                break;
                            case "11TO20":
                                theAnswer = "11 TO 20 CIGARETTES A DAY";
                                break;
                            case "GT20":
                                theAnswer = "MORE THAN 20 CIGARETTES A DAY";
                                break;
                        }

                        Responses += QuestionAndAnswerBuilder(
                            "Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked a day",
                            theAnswer);

                    }
                }
                else
                {

                    Responses += QuestionAndAnswerBuilder(
                    "Do you still have periods",
                    inputs[CCRATString.Period].ToUpper());

                    if (inputs[CCRATString.Period].ToUpper() == "NO")
                    {
                        string theAnswer = "";
                        switch (inputs[CCRATString.LastCycle].ToUpper())
                        {
                            case "LT1":
                                theAnswer = "1 YEAR AGO OR LESS";
                                break;
                            case "GT1LT2":
                                theAnswer = "MORE THAN 1 YEAR AGO BUT LESS THAN 2 YEARS AGO";
                                break;
                            case "GT2":
                                theAnswer = "2 YEARS AGO OR MORE";
                                break;
                        }

                        Responses += QuestionAndAnswerBuilder(
                        "When did you have your last period",
                        theAnswer);

                        if (inputs[CCRATString.LastCycle].ToUpper() == "GT2")
                        {
                            Responses += QuestionAndAnswerBuilder(
                            "During the past 2 years, have you used estrogen, progestin, or other female hormones",
                            inputs[CCRATString.UsedEstrogen].ToUpper());
                        }
                    }
                }


                //Page 7 - Family 
                Responses += QuestionAndAnswerBuilder(
                    "Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters. At any time in their lives, did any of these relatives ever have cancer of the colon or rectum (cancer of the lower intestine)",
                    inputs[CCRATString.HasRelativeHadCC].ToUpper());


                if (inputs[CCRATString.HasRelativeHadCC].ToUpper() == "YES")
                {
                    Responses += QuestionAndAnswerBuilder(
                        "How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)",
                        inputs[CCRATString.NumRelativesHavingCC].ToUpper());
                }

                Responses += "</ol>";
            }

        }


        private string QuestionAndAnswerBuilder(string question, string answer)
        {

            return
                "<li>" +
                question + "? " +
                "<span class='responseAnswer'>" +
                answer +
                "</span></li>";
        }


        private string QuestionAndAnswerBuilder(string question, string feet, string inches)
        {

            string ret =
                "<li>" +
                question + "? " +
                "<span class='responseAnswer'>" +
                feet + "'";

            if (inches != "")
                ret += inches + "\"";

            ret += "</span></li>";

            return ret;
        }





        public string Formater(decimal value)
        {
            return value.ToString("0.0");
        }

        public string Rounder(decimal value)
        {
            string retValue = "";

            if (value > (decimal).5)
                retValue = Math.Round(value, 0).ToString("0");
            else
                retValue = value.ToString(".0");

            return retValue;
        }

        private void BuildOutput()
        {
            string textPos;
            decimal adjRisk;
            decimal adjRiskAverage;
            decimal adjRiskRangeStart;
            decimal adjRiskRangeEnd;

            if (FiveYearRisk > 20 || FiveYearRiskAverage > 20 || FiveYearRiskRangeEnd > 20)
            {
                FiveYearGraphLine = "images/ccrat_line_trans_extend.gif";
                adjRisk = FiveYearRisk / 5;
                adjRiskAverage = FiveYearRiskAverage / 5;
                adjRiskRangeStart = FiveYearRiskRangeStart / 5;
                adjRiskRangeEnd = FiveYearRiskRangeEnd / 5;
            }
            else
            {
                FiveYearGraphLine = "images/ccrat_line_trans.gif";
                adjRisk = FiveYearRisk;
                adjRiskAverage = FiveYearRiskAverage;
                adjRiskRangeStart = FiveYearRiskRangeStart;
                adjRiskRangeEnd = FiveYearRiskRangeEnd;
            }
            FiveYearRiskArrowLeft = arrowPosition(adjRisk, 4, FiveYearRiskText, out textPos);
            FiveYearRiskTextLeft = textPos;
            FiveYearAverageArrowLeft = arrowPosition(adjRiskAverage, 0, FiveYearAverageText, out textPos);
            FiveYearAverageTextLeft = textPos;
            FiveYearRiskRange = rangePosition(adjRiskRangeStart, 6, adjRiskRangeEnd, 6, 4, FiveYearRiskRangeText, out textPos);
            FiveYearRiskRangeTextLeft = textPos;

            if (TenYearRisk > 20 || TenYearRiskAverage > 20 || TenYearRiskRangeEnd > 20)
            {
                TenYearGraphLine = "images/ccrat_line_trans_extend.gif";
                adjRisk = TenYearRisk / 5;
                adjRiskAverage = TenYearRiskAverage / 5;
                adjRiskRangeStart = TenYearRiskRangeStart / 5;
                adjRiskRangeEnd = TenYearRiskRangeEnd / 5;
            }
            else
            {
                TenYearGraphLine = "images/ccrat_line_trans.gif";
                adjRisk = TenYearRisk;
                adjRiskAverage = TenYearRiskAverage;
                adjRiskRangeStart = TenYearRiskRangeStart;
                adjRiskRangeEnd = TenYearRiskRangeEnd;
            }
            TenYearRiskArrowLeft = arrowPosition(adjRisk, 4, TenYearRiskText, out textPos);
            TenYearRiskTextLeft = textPos;
            TenYearAverageArrowLeft = arrowPosition(adjRiskAverage, 0, TenYearAverageText, out textPos);
            TenYearAverageTextLeft = textPos;
            TenYearRiskRange = rangePosition(adjRiskRangeStart, 6, adjRiskRangeEnd, 6, 4, TenYearRiskRangeText, out textPos);
            TenYearRiskRangeTextLeft = textPos;


            if (LifetimeRisk > 20 || LifetimeRiskAverage > 20 || LifetimeRiskRangeEnd > 20)
            {
                LifetimeGraphLine = "images/ccrat_line_trans_extend.gif";
                adjRisk = LifetimeRisk / 5;
                adjRiskAverage = LifetimeRiskAverage / 5;
                adjRiskRangeStart = LifetimeRiskRangeStart / 5;
                adjRiskRangeEnd = LifetimeRiskRangeEnd / 5;
            }
            else
            {
                LifetimeGraphLine = "images/ccrat_line_trans.gif";
                adjRisk = LifetimeRisk;
                adjRiskAverage = LifetimeRiskAverage;
                adjRiskRangeStart = LifetimeRiskRangeStart;
                adjRiskRangeEnd = LifetimeRiskRangeEnd;
            }
            LifetimeRiskArrowLeft = arrowPosition(adjRisk, 4, LifetimeRiskText, out textPos);
            LifetimeRiskTextLeft = textPos;
            LifetimeAverageArrowLeft = arrowPosition(adjRiskAverage, 0, LifetimeAverageText, out textPos);
            LifetimeAverageTextLeft = textPos;
            LifetimeRiskRange = rangePosition(adjRiskRangeStart, 6, adjRiskRangeEnd, 6, 4, LifetimeRiskRangeText, out textPos);
            LifetimeRiskRangeTextLeft = textPos;

        }


        private string arrowPosition(decimal risk, int arrowTweak, string text, out string textPosition)
        {
            int pos = positionCalc(risk, arrowTweak);

            // Calc offset for text if near the right end of scale
            int textOffset = 0;
            if (risk > (decimal)17.5)
                textOffset = pos - (text.Length * 6);
            else
                textOffset = (pos + 6) - (text.Length * 3);

            textPosition = "left: " + textOffset.ToString().Trim() + "px;";
            return "left: " + pos.ToString().Trim() + "px;";
        }

        private string rangePosition(decimal start, int tweakStart, decimal end, int tweakEnd, int tweakText, string text, out string textPosition)
        {
            int pos1 = positionCalc(start, tweakStart);
            int pos2 = positionCalc(end, tweakEnd);
            int width = pos2 - pos1;

            int textPos;
            if (end > (decimal)13.5)
                textPos = (pos1 - (text.Length * 7)) + 3;
            else
                textPos = pos2 + tweakText;

            textPosition = "left: " + textPos.ToString().Trim() + "px;";
            return "left: " + pos1.ToString().Trim() + "px; width: " + width.ToString().Trim() + "px;";
        }

        private int positionCalc(decimal pos, int tweak)
        {

            int intPos = (int)pos;
            int decPos = (int)((pos - intPos) * 10);
            double betweenAmount = ((graphPosition[(intPos == 20 ? 20 : intPos + 1)] - graphPosition[intPos]) / 10);

            // Calc Fudge Factor offset
            int offset;
            if (decPos < 2)
                offset = ((int)betweenAmount * decPos) + 1;
            else if (decPos == 5)
                offset = ((int)betweenAmount * decPos) + 1;
            else
                offset = ((int)betweenAmount * decPos) - 1;

            return ((int)graphPosition[intPos] + offset) + tweak;

        }

        private void CalculateRisk()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

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
                Session["Risk"] = risks;

                //5 year risks 
                this.FiveYearRisk = risks.FiveYearAbsRiskPercent;
                this.FiveYearRiskAverage = risks.FiveYearAvgRiskPercent;
                this.FiveYearRiskRangeStart = Math.Round(risks.AbsRisk05L * 100, 1);
                this.FiveYearRiskRangeEnd = Math.Round(risks.AbsRisk05U * 100, 1);

                //10 year risks
                this.TenYearRisk = risks.TenYearAbsRiskPercent;
                this.TenYearRiskAverage = risks.TenYearAvgRiskPercent;
                this.TenYearRiskRangeStart = Math.Round(risks.AbsRisk10L * 100, 1);
                this.TenYearRiskRangeEnd = Math.Round(risks.AbsRisk10U * 100, 1);

                //lifetime risks
                this.LifetimeRisk = risks.LifetimeAbsRiskPercent;
                this.LifetimeRiskAverage = risks.LifeTimeAvgRiskPercent;
                this.LifetimeRiskRangeStart = Math.Round(risks.AbsRskLTL * 100, 1);
                this.LifetimeRiskRangeEnd = Math.Round(risks.AbsRiskLTU * 100, 1);

                this.Sex = risks.Gender.ToLower();

            }
        }
 
    }
}
