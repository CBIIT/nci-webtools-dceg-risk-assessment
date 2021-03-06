﻿using System;
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

 
    }
}
