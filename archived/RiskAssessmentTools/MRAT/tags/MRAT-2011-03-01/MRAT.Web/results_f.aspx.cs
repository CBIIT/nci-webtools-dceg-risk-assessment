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

namespace MRAT
{
    public partial class results_f : System.Web.UI.Page
    {
        int region, sex, race, age, sunburn, complexion, tanning, large_moles, small_moles_males, small_moles_females, frekcling, solar_damage;
        double _result;
        string emailTitle = "";
        string emailLink = "";

        public string EmailTitle
        {
            get { return emailTitle; }
            set { emailTitle = value; }
        }

        public string EmailLink
        {
            get { return emailLink; }
            set { emailLink = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string emailUrl = String.Format("PopEmail.aspx?language={0}&title={1}&docurl={2}", 1, System.Web.HttpUtility.UrlEncode(emailTitle.Replace("&#153;", "__tm;")), System.Web.HttpUtility.UrlEncode(this.Request.Url.ToString().Replace("&", "__amp;")));
            lnkEmail.HRef = emailUrl;
            lnkEmail.Attributes.Add("onclick", "popUp('" + emailUrl + "');return false;");

            if(!Page.IsPostBack)
                caculate();
        }
        private void caculate()
        {
            try {
                region = GetRequestValue("region", 0);
                sex = GetRequestValue("sex", 0);
                race = GetRequestValue("race", 0);
                age = GetRequestValue("age", 0);
                sunburn = GetRequestValue("sunburn", 0);
                complexion = GetRequestValue("complexion", 0);
                tanning = GetRequestValue("tanning", 0);
                large_moles = GetRequestValue("large_moles", 0);
                small_moles_males = GetRequestValue("small_moles_males", 0);
                small_moles_females = GetRequestValue("small_moles_females", 0);
                frekcling = GetRequestValue("freckling", 0);
                solar_damage = GetRequestValue("solar_damage", 0);
                


                if (sex == Constants.MALE)
                {
                    _result= Utils.processMale(region, sex, race, age, sunburn, complexion, large_moles, small_moles_males, frekcling, solar_damage);
                    PrintResults();
                }
                else if (sex == Constants.FEMALE)
                {
                    _result = Utils.processFemale(region, sex, race, age, complexion, tanning, small_moles_females, frekcling);
                    PrintResults();
                }
                else
                {
                    //showError("Unhandled condition: doCalc()");
                }

            }
            catch (Exception ex)
            {
                //TODO: NEEDS TO BE IMPLEMENTED
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally { }

        }
        private void PrintResults()
        {
            lblResult.Text = Convert.ToString(Math.Round(_result, ReadConfigValue("decimals", 2))) + "%";
            lblAvg.Text = (Math.Round(_result, ReadConfigValue("decimals", 2)) * 1000).ToString();
            if (sex == Constants.FEMALE)
                lblSex.Text = "Female";

            lblRegion.Text = Constants.region[region].ToString();
            lblAge.Text = age.ToString();
            lblComplexion.Text = Constants.fairComplexion[complexion].ToString();
            lblFreckling.Text = Constants.freckling[frekcling].ToString();
            lblGender.Text = Constants.sex[sex].ToString();
            lblRace.Text = Constants.race[race].ToString();
            lblRegion.Text = Constants.region[region].ToString();
            //TODO: check gender and display small mole column here
            if(sex == Constants.MALE){
                //lblLargerMoles.Text = Constants.largeMoles[large_moles].ToString();
                //lblBlisterinSunBurn.Text = Constants.blisterBurn[sunburn].ToString();
                //lblSmallMoles.Text = Constants.smallMolesMales[ small_moles_males].ToString();
                //lblSolarDamage.Text = Constants.solarDamage[solar_damage].ToString();
                //lblTanning.Text = @"N/A " + lblTanning.ToolTip ;
            }
            else if (sex == Constants.FEMALE){
                //lblLargerMoles.Text = @"N/A " + lblLargerMoles.ToolTip;
                //lblBlisterinSunBurn.Text = @"N/A " + lblBlisterinSunBurn.ToolTip;
                //lblSolarDamage.Text = @"N/A " + lblSolarDamage.ToolTip;

                lblSmallMoles.Text = Constants.smallMolesFemales[small_moles_females].ToString();
                lblTanning.Text = Constants.lightOrNoTan[tanning].ToString();
            }            
        }

        protected int GetRequestValue(string Name, int DefaultValue)
        {
            object o = System.Web.HttpContext.Current.Request[Name];
            return (o != null) ? Convert.ToInt32(o) : DefaultValue;
        }
        protected int ReadConfigValue(string Name, int DefaultValue)
        {
            int retval = DefaultValue;
            object o = System.Configuration.ConfigurationManager.AppSettings[Name];
            retval = (o != null || int.TryParse(o.ToString(), out retval)) ? Convert.ToInt32(o) : DefaultValue;
            return retval;
        }
    }
}
