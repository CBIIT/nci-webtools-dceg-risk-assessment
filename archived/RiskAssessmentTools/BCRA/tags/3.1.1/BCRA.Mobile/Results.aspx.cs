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
using NCI.DCEG.BCRA;
using NCI.BCPT.Engine;
using BCRA.Mobile;
using System.Collections.Specialized;

public partial class Results : System.Web.UI.Page
{
    protected string race = String.Empty;
    protected string age = String.Empty;
    protected string fiveYearRiskThisWoman = String.Empty;
    protected string fiveYearRiskAvgWoman = String.Empty;
    protected string lifetimeRiskThisWoman = String.Empty;
    protected string lifetimeRiskAvgWoman = String.Empty;

    private void LogDetailedError(
        int currentAge, 
        int menarcheAge, 
        int firstLiveBirthAge, 
        int hadBiopsy, 
        int numBiopsy, 
        int hyperPlasia, 
        int firstDegreeRel, 
        int intRace,
        Exception ex,
        string errMsg
        )
    {
        
        ErrorLogger.LogError(errMsg + String.Format(
        @"
        Converted Values
        ----------------
        currentAge: {0}
        menarcheAge: {1}
        firstLiveBirthAge: {2}
        hadBiopsy: {3}
        numBiopsy: {4}
        hyperPlasia: {5}
        firstDegreeRel: {6}
        intRace: {7}

        Session Values
        --------------
        currentAge: {8}
        menarcheAge: {9}
        firstLiveBirthAge: {10}
        hadBiopsy: {11}
        numBiopsy: {12}
        hyperPlasia: {13}
        firstDegreeRel: {14}
        race: {15}

        Previous URL: {16}
        ", currentAge.ToString(), menarcheAge.ToString(), firstLiveBirthAge.ToString(), 
                   hadBiopsy.ToString(), numBiopsy.ToString(), hyperPlasia.ToString(), firstDegreeRel.ToString(), 
                   intRace.ToString(), Session["age"], Session["ageMP"], Session["ageLB"], Session["relativeNum"],
                   Session["biopsy"], Session["biopsyNum"], Session["biopsyAH"], Session["race"], (Request.UrlReferrer ?? Request.Url)), ex);

    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
                NameValueCollection postedValues = HttpContext.Current.Request.Form;
                String nextKey;
                string race = string.Empty;

                for (int i = 0; i < postedValues.AllKeys.Length; i++)
                {
                    nextKey = postedValues.AllKeys[i];
                    if (nextKey.Substring(0, 1) != "__")
                    {
                        if (nextKey.Contains("race"))
                        {
                            race = postedValues[i];
                            Session["race"] = race;
                        }
                    }
                }

            if ((BCRA.Mobile.Manager.CurrentQuestion == "9" || BCRA.Mobile.Manager.CurrentQuestion == "10") && (Request.UrlReferrer ?? Request.Url).LocalPath.EndsWith("Q00.aspx"))
            {
                if (BCRA.Mobile.Manager.CurrentQuestion == "9")
                {
                    Session[BCRA.Mobile.Manager.race] = race; //Request.Form["q"];

                }
                else
                {
                    Session[BCRA.Mobile.Manager.race] = race; //Request.Form[1];

                }
            }
        }

        int currentAge = BcptConvert.GetCurrentAge(Session["age"]);
        int menarcheAge = BcptConvert.GetMenarcheAge(Session["ageMP"].ToString());
        int firstLiveBirthAge = BcptConvert.GetFirstLiveBirthAge(Session["ageLB"].ToString());
        int firstDegreeRel = BcptConvert.GetFirstDegRelatives(Session["relativeNum"].ToString());
        int hadBiopsy = BcptConvert.GetEverHadBiopsy(Session["biopsy"].ToString());
        int numBiopsy = BcptConvert.GetNumberOfBiopsy(Session["biopsyNum"].ToString());
        int hyperPlasia = BcptConvert.GetHyperPlasia(Session["biopsyAH"].ToString());
        int intRace = BcptConvert.GetRace(Session["race"].ToString());
        int inputRace = Convert.ToInt32(Session["race"]);

        double absRisk = 0, avgRisk = 0, absRiskPctg = 0, avgRiskPctg = 0, absLifeTimeRiskPctg = 0, avgLifeTimeRiskPctg = 0;       

        try
        {
            Helper.RiskCalc(0, currentAge, currentAge + 5, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy,
        hyperPlasia, firstDegreeRel, intRace, out absRisk, out avgRisk);
        }
        catch (Exception ex)
        {
            LogDetailedError(currentAge, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy, hyperPlasia, firstDegreeRel, intRace, ex, "Error calculating 5 year risk");                
            throw;
        }

        try
        {
            Helper.CalcPercentage(absRisk, avgRisk, out absRiskPctg, out avgRiskPctg);
        }
        catch (Exception ex)
        {
            LogDetailedError(currentAge, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy, hyperPlasia, firstDegreeRel, intRace, ex, "Error calculating average 5 year risk");                
            throw;
        }

        age = currentAge.ToString();
        fiveYearRiskThisWoman = absRiskPctg.ToString("F1");
        fiveYearRiskAvgWoman = avgRiskPctg.ToString("F1");
        Session["fiveYearRiskThisWoman"] = fiveYearRiskThisWoman.ToString();
        Session["fiveYearRiskAvgWoman"] = fiveYearRiskAvgWoman.ToString();


        // Calculate lifetime risk.
        try {
            Helper.RiskCalc(0, currentAge, 90, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy,
                hyperPlasia, firstDegreeRel, intRace, out absRisk, out avgRisk);
        }
        catch (Exception ex)
        {
            LogDetailedError(currentAge, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy, hyperPlasia, firstDegreeRel, intRace, ex, "Error calculating life time risk");
            throw;
        }

        try
        {
            Helper.CalcPercentage(absRisk, avgRisk, out absLifeTimeRiskPctg, out avgLifeTimeRiskPctg);
        }
        catch (Exception ex)
        {
            LogDetailedError(currentAge, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy, hyperPlasia, firstDegreeRel, intRace, ex, "Error calculating average life time risk");
            throw;
        }

        lifetimeRiskThisWoman = absLifeTimeRiskPctg.ToString("F1");
        lifetimeRiskAvgWoman = avgLifeTimeRiskPctg.ToString("F1");
        Session["lifetimeRiskThisWoman"] = lifetimeRiskThisWoman.ToString();
        Session["lifetimeRiskAvgWoman"] = lifetimeRiskAvgWoman.ToString();

        switch (inputRace)
        {
            case 1:
                race = "White";
                break;
            case 2:
                race = "African American";
                break;
            case 3:
                race = "Hispanic";
                break;
            case 4:
                race = "Asian or Pacific Islander";
                break;
            case 5:
                race = "American Indian or Alaskan Native";
                break;
            case 6:
                race = "Unknown";
                break;
            case 7:
                {
                    race = "Asian-American: Chinese";
                }

                break;

            case 8:
                {
                    race = "Asian-American: Japanese";
                }

                break;
            case 9:
                {
                    race = "Asian-American: Filipino";
                }

                break;

            case 10:
                {
                    race = "Asian-American: Hawaiian";
                }

                break;
            case 11:
                {
                    race = "Asian-American: Other Pacific Islander";
                }

                break;
            case 12:
                {
                    race = "Asian-American: Other Asian-American";
                }
                break;
            default:
                race = "Unknown";
                break;
        }
        //if (inputRace != 1) impactlink.Visible = true;
    }
}
