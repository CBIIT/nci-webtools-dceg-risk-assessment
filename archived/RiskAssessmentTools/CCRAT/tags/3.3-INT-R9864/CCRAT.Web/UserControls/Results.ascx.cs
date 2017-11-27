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
                    //main5YearRisk.InnerHtml = value.FiveYearAbsRiskPercent.ToString() + "%";
                    exp5YearRisk1.InnerHtml = value.FiveYearAbsRiskPercent.ToString() + "%";
                    //exp5YearRisk2.InnerHtml = Math.Round((value.FiveYearAbsRiskPercent * 10 ), 0, MidpointRounding.AwayFromZero).ToString() ;
                    exp5YearAvgRisk1.InnerHtml = value.FiveYearAvgRiskPercent.ToString() + "%";
                    //exp5YearAvgRisk2.InnerHtml = Math.Round((value.FiveYearAvgRiskPercent * 10), 0, MidpointRounding.AwayFromZero).ToString();
                    //gender5Year1.InnerHtml = value.Gender;
                    //gender5Year2.InnerHtml = value.Gender;
                    //race5Year1.InnerHtml = value.Race;
                    //race5Year2.InnerHtml = value.Race;

                    /*
                    if (value.FiveYearAbsRiskPercent == value.FiveYearAvgRiskPercent)
                        absVsAvgRisks5Year.InnerHtml = "average.";
                    else if (value.FiveYearAbsRiskPercent > value.FiveYearAvgRiskPercent)
                        absVsAvgRisks5Year.InnerHtml = "higher than average.";
                    else
                        absVsAvgRisks5Year.InnerHtml = "lower than average.";
                    */

                }

                if (value.Is10YrRiskValid)
                {
                    ph10Year.Visible = true;
                    //main10YearRisk.InnerHtml = value.TenYearAbsRiskPercent.ToString() + "%";
                    exp10YearRisk1.InnerHtml = value.TenYearAbsRiskPercent.ToString() + "%";
                    //exp10YearRisk2.InnerHtml = Math.Round((value.TenYearAbsRiskPercent * 10), 0, MidpointRounding.AwayFromZero).ToString();
                    exp10YearAvgRisk1.InnerHtml = value.TenYearAvgRiskPercent.ToString() + "%";
                    //exp10YearAvgRisk2.InnerHtml = Math.Round((value.TenYearAvgRiskPercent * 10), 0, MidpointRounding.AwayFromZero).ToString();
                    //gender10Year1.InnerHtml = value.Gender;
                    //gender10Year2.InnerHtml = value.Gender;
                    //race10Year1.InnerHtml = value.Race;
                    //race10Year2.InnerHtml = value.Race;

                    /*
                    if (value.TenYearAbsRiskPercent == value.TenYearAvgRiskPercent)
                        absVsAvgRisks10Year.InnerHtml = "average.";
                    else if (value.TenYearAbsRiskPercent > value.TenYearAvgRiskPercent)
                        absVsAvgRisks10Year.InnerHtml = "higher than average.";
                    else
                        absVsAvgRisks10Year.InnerHtml = "lower than average.";
                    */


                }

                if (value.IsPatternFoundInDB)
                {
                    phLifeRisk.Visible = true;
                    //mainLifeRisk.InnerHtml = value.LifetimeAbsRiskPercent.ToString() + "%";
                    expLifeRisk1.InnerHtml = value.LifetimeAbsRiskPercent.ToString() + "%";
                    //expLifeRisk2.InnerHtml = Math.Round((value.LifetimeAbsRiskPercent * 10), 0, MidpointRounding.AwayFromZero).ToString();
                    expLifeYearAvgRisk1.InnerHtml = value.LifeTimeAvgRiskPercent.ToString() + "%";
                    //expLifeYearAvgRisk2.InnerHtml = Math.Round((value.LifeTimeAvgRiskPercent * 10), 0, MidpointRounding.AwayFromZero).ToString();
                    //genderLifeYear1.InnerHtml = value.Gender;
                    //genderLifeYear2.InnerHtml = value.Gender;
                    //raceLifeYear1.InnerHtml = value.Race;
                    //raceLifeYear2.InnerHtml = value.Race;

                    /*
                    if (value.LifetimeAbsRiskPercent == value.LifeTimeAvgRiskPercent)
                        absVsAvgRisksLifeTime.InnerHtml = "average.";
                    else if (value.LifetimeAbsRiskPercent > value.LifeTimeAvgRiskPercent)
                        absVsAvgRisksLifeTime.InnerHtml = "higher than average.";
                    else
                        absVsAvgRisksLifeTime.InnerHtml = "lower than average.";
                    */

                }
                else
                {
                    phErrorMsg.Visible = true;
                    errorMsg.InnerHtml = string.Format(@"Pattern {0} {1}"
                        , value.PatternID.ToString()
                        , _cannotCmpute);
                }
                phWhatNext.Visible = true;
                //age.InnerHtml = value.CurrentAge;
                //gender.InnerHtml = value.Gender;
                //race.InnerHtml = value.Race;



                #region print variables
                if (Common.Utils.Helper.ReadConfigSetting("PrintVariables", false))
                {
                    phTestVars.Visible = true;
                    if (value.Gender.ToLower() == "male")
                    {
                        litTestVars.Text = String.Format(
                            @"
                            NumRel: {0}&nbsp;&nbsp;&nbsp;&nbsp;Cigarets: {1}<br/>
                            NoIbuprofn: {2}&nbsp;&nbsp;&nbsp;&nbsp;NoNSAIDS: {3}<br/>
                            BMI: {4}&nbsp;&nbsp;&nbsp;&nbsp;bmi_trnd: {5}<br/>
                            Sigmod: {6}&nbsp;&nbsp;&nbsp;&nbsp;Veglt5: {7}<br/>
                            CigYr: {8}&nbsp;&nbsp;&nbsp;&nbsp;HrsExcrise: {9}<br/>                            
                            "
                            , value.Numrel, value.Cigarets, value.NoIbuprofn, value.NoNSaids
                            , Math.Round(value.Bmi, 2, MidpointRounding.AwayFromZero), value.BmiTrnd
                            , value.Sigmod, value.VegLT5, value.Duration, value.HrsExcrise
                         );
                    }
                    else
                    {
                        litTestVars.Text = String.Format(
                            @"
                            NRelTrnd: {0}&nbsp;&nbsp;&nbsp;&nbsp;NoNsaids: {1}<br/>
                            BMI: {2}&nbsp;&nbsp;&nbsp;&nbsp;BMIge30: {3}<br/>
                            sigmod: {4}&nbsp;&nbsp;&nbsp;&nbsp;Veglt5: {5}<br/>
                            NoStrogen: {6}&nbsp;&nbsp;&nbsp;&nbsp;XrcisHrsTrnd: {7}<br/>
                            "
                            , value.Numrel, value.NoNSaids
                            , Math.Round(value.Bmi, 2, MidpointRounding.AwayFromZero), value.BmiGe30
                            , value.Sigmod, value.VegLT5, value.NoStrogen, value.HrsExcrise
                            );
                    }



                    if (value.IsPatternFoundInDB)
                    {
                        litTestVars.Text += string.Format(
                            @"
                            Pattern: {0}<br/>
                            FiveYrAbsRisk   : {1}%({2})<br/>
                            TenYrAbsRisk    : {3}%({4})<br/>
                            TwentyYrAbsRisk : {5}%({6})<br/>
                            LifeTimeAbsRisk : {7}%({8})<br/>
                            FiveYrAvgRisk   : {9}%({10})<br/>
                            TenYrAvgRisk    : {11}%({12})<br/>
                            LifeTimeAvgRisk : {13}%({14})<br/>
                            "
                            , value.PatternID.ToString()
                            , value.FiveYearAbsRiskPercent, value.FiveYearAbsRisk
                            , value.TenYearAbsRiskPercent, value.TenYearAbsRisk
                            , value.TwentyYearAbsRiskPercent, value.TwentyYearAbsRisk
                            , value.LifetimeAbsRiskPercent, value.LifetimeAbsRisk
                            , value.FiveYearAvgRiskPercent, value.FiveYearAvgRisk
                            , value.TenYearAvgRiskPercent, value.TenYearAvgRisk
                            , value.LifeTimeAvgRiskPercent, value.LifetimeAvgRisk
                            );
                    }
                    else
                    {
                        litTestVars.Text += string.Format(
                            @"<span style='color:red'>Pattern: {0} {1}</span>"
                            , value.PatternID.ToString(), _cannotCmpute
                        );
                    }
                }
                #endregion print variables
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ph5Year.Visible = false;
            ph10Year.Visible = false;
            phLifeRisk.Visible = false;
            phErrorMsg.Visible = false;
            phWhatNext.Visible = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //RegisterClientScript();
        }
        private void RegisterClientScript()
        {
            if (this.IsPostBack)
            {
                //Page.ClientScript.RegisterClientScriptInclude("liveboxJS", ResolveClientUrl("~/script/DHtmlModalPopup3.js"));
                //Page.ClientScript.RegisterClientScriptInclude("livePipeJS", ResolveClientUrl("~/script/DHtmlModalPopup2.js"));
                /*
                Page.ClientScript.RegisterStartupScript(typeof(Results), "modalPopupScript"
                    , @"<script type='text/javascript'>
                        document.observe('dom:loaded', function() {
                            //Modal Window
                            var modal1 = new Control.Modal($('modal5YrAnchor'), {
                                overlayOpacity: 0.75,
                                className: 'modal',
                                closeOnClick: 'container',
                                fade: false            
                            });
                            
                            var modal2 = new Control.Modal($('modal10YrAnchor'), {
                                overlayOpacity: 0.75,
                                className: 'modal',
                                closeOnClick: 'container',
                                fade: false
                            });

                            var modal3 = new Control.Modal($('modalLifeTimeAnchor'), {
                                overlayOpacity: 0.75,
                                className: 'modal',
                                closeOnClick: 'container',
                                fade: false
                            });              
                        });
                    </script>");
                */
            }
        }

        protected void Average_Click(object sender, EventArgs e)
        {
            //ma5YearRisk.CanShow = true;
        }

    }
}