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
using NCI.BCPT.Engine;
using System.Diagnostics;

public partial class RiskAssessment : System.Web.UI.Page
{
    private const string _notApplicable = "n/a";
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsPostBack)
                CalculateAbsoluteAndAverageRisks();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine(string.Format("{0}\n{1}", ex.Message, ex.StackTrace ));
        }
    }  

    /// <summary>
    /// Calculates Absolute And Average Risks
    /// </summary>
    protected void CalculateAbsoluteAndAverageRisks()
    {
        string currentAge
            , menarcheAge
            , firstLiveBirthAge
            , everHadBiopsy
            , numberOfBiopsy
            , hyperPlasia
            , firstDegRelatives
            , race;

        double absoluteRisk = 0
            , averageRisk = 0
            , absoluteRiskPercent = 0
            , averageRiskPercent = 0;

        try
        {           
            //collect all information provided by the user about the a woman
            currentAge = GetRequestStr("current_age", string.Empty);
            menarcheAge = GetRequestStr("age_at_menarche", string.Empty);
            firstLiveBirthAge = GetRequestStr("age_at_first_live_birth", string.Empty);
            everHadBiopsy = GetRequestStr("ever_had_biopsy", string.Empty);
            numberOfBiopsy = GetRequestStr("previous_biopsies", string.Empty);
            hyperPlasia = GetRequestStr("biopsy_with_hyperplasia", string.Empty);
            firstDegRelatives = GetRequestStr("related_with_breast_cancer", string.Empty);
            race = GetRequestStr("race", string.Empty);

            //estimate the woman's risk for developing invasive breast cancer 
            //over the next 5 years and a risk for a woman of the same age 
            //and race/ethnicity from the general U.S. population

            //The ProjectionAge is Current Age + 5 years, because it is patient's 
            //risk of breast cancer over the next five years
            int projectionAge = Convert.ToInt32(currentAge) + 5;
            

            CalculateRisks(0, Convert.ToInt32(currentAge), projectionAge, Convert.ToInt32(menarcheAge), Convert.ToInt32(firstLiveBirthAge), Convert.ToInt32(everHadBiopsy), Convert.ToInt32(numberOfBiopsy), Convert.ToInt32(hyperPlasia), Convert.ToInt32(firstDegRelatives), Convert.ToInt32(race)
              , out absoluteRisk
              , out averageRisk
            );

            absoluteRisk = Math.Round(absoluteRisk, 6);
            averageRisk = Math.Round(averageRisk, 6);

            absoluteRiskPercent = Math.Round((absoluteRisk * 100), 1);
            averageRiskPercent = Math.Round((averageRisk * 100), 1);

            //print the result 
            lblCurrentAge.Text = currentAge;
            lblCurrentAge2.Text = currentAge;
            lbl5YrAbsoluteRisk.Text = absoluteRiskPercent.ToString() + "%";
            lbl5YrAveragRisk.Text = averageRiskPercent.ToString() + "%";
            lbl5YrAbsoluteRisk2.Text = absoluteRiskPercent.ToString() + "%";
            lbl5YrAveragRisk2.Text = averageRiskPercent.ToString() + "%";

            lbl5YrEstimatedRiskForNotGettingCancer.Text = Convert.ToString(
                Math.Round(((1 - absoluteRisk) * 100), 1)) + "%";

            //estimate the woman's risk for developing invasive breast cancer 
            //over her lifetime (to age 90) and for a woman of the same age 
            //and race/ethnicity from the general U.S. population.
            projectionAge = 90;
            absoluteRisk = 0; 
            averageRisk = 0; 
            absoluteRiskPercent = 0; 
            averageRiskPercent = 0;

            CalculateRisks(0, Convert.ToInt32(currentAge), Convert.ToInt32(projectionAge), Convert.ToInt32(menarcheAge), Convert.ToInt32(firstLiveBirthAge), Convert.ToInt32(everHadBiopsy), Convert.ToInt32(numberOfBiopsy), Convert.ToInt32(hyperPlasia), Convert.ToInt32(firstDegRelatives), Convert.ToInt32(race)
              , out absoluteRisk
              , out averageRisk
            );
            absoluteRisk = Math.Round(absoluteRisk, 6);
            averageRisk = Math.Round(averageRisk, 6);

            absoluteRiskPercent = Math.Round((absoluteRisk * 100), 1);
            averageRiskPercent = Math.Round((averageRisk * 100), 1);

            lblLifetimeAbsoluteRisk90.Text = absoluteRiskPercent.ToString() + "%";
            lblLifeTimeAverageRisk90.Text = averageRiskPercent.ToString() + "%";
            lblLifetimeAbsoluteRisk902.Text = absoluteRiskPercent.ToString() + "%";
            lblLifeTimeAverageRisk902.Text = averageRiskPercent.ToString() + "%";

            lblAnsHistory.Text = "No";
            lblAnsAge.Text = currentAge;
            FillinAnswers(
                  menarcheAge
                , firstLiveBirthAge
                , everHadBiopsy
                , numberOfBiopsy
                , hyperPlasia
                , firstDegRelatives
                , race
                );
        }
        catch (Exception ex)
        {
            //TODO: write to error log
            Console.WriteLine(ex.Message);
            //Logger.FileLogging logFile = new Logger.FileLogging(Path.ChangeExtension(filePath, ".out.xml"), false, false, true, true);
            //logFile.DisplayMessage = false;
        }
        finally 
        { 
        }
    }

    /// <summary>
    /// Print/fill in other answers on the result page
    /// </summary>
    /// <param name="MenarcheAge"></param>
    /// <param name="FirstLiveBirthAge"></param>
    /// <param name="EverHadBiopsy"></param>
    /// <param name="NumberOfBiopsy"></param>
    /// <param name="HyperPlasia"></param>
    /// <param name="FirstDegRelatives"></param>
    /// <param name="Race"></param>
    private void FillinAnswers
    (
          string MenarcheAge
        , string FirstLiveBirthAge
        , string EverHadBiopsy
        , string NumberOfBiopsy
        , string HyperPlasia
        , string FirstDegRelatives
        , string Race
    )
    {
        //Now fill in answers.
          switch (MenarcheAge)
        {
            case "99":
                {
                    lblAnsPeriod.Text = "Unknown";            
                }
                break;
            case "10":
                {
                    lblAnsPeriod.Text = "7 to 11";
                }
                break;
            case "13":
                {
                    lblAnsPeriod.Text = "12 to 13";
                }
                break;
            case "14":
                {
                    lblAnsPeriod.Text = "&gt; =14";
                }
                break;

        }

        switch (FirstLiveBirthAge)
        {
            case "99":
                {
                    lblAnsBirth.Text = "Unknown";
                }
                break;
            case "0":
                {
                    lblAnsBirth.Text = "No births";
                }
                break;
            case "15":
                {
                    lblAnsBirth.Text = "&lt; 20";
                }
                break;
            case "22":
                {
                    lblAnsBirth.Text = "20 to 24";
                }
                break;
            case "27":
                {
                    lblAnsBirth.Text = "25 to 29";
                }
                break;
            case "30":
                {
                    lblAnsBirth.Text = "&gt; =30";
                }
                break;
        }

        switch (FirstDegRelatives)
        {
            case "99":
                {
                    lblAnsRelatives.Text = "Unknown";
                }
                break;
            case "0":
                {
                    lblAnsRelatives.Text = "0";
                }
                break;
            case "1":
                {
                    lblAnsRelatives.Text = "1";
                }
                break;
            case "2":
                {
                    lblAnsRelatives.Text = "&gt; 1";
                }
                break;
        }

        switch (EverHadBiopsy)
        {
            case "99":
                {
                    lblAnsBiopsy.Text = "Unknown";
                }
                break;
            case "0":
                {
                    lblAnsBiopsy.Text = "No";
                }
                break;
            case "1":
                {
                    lblAnsBiopsy.Text = "Yes";
                }
                break;
        }


        if (EverHadBiopsy != "1")
            lblAnsNumBiopsies.Text = _notApplicable;
        else
        {
            switch (NumberOfBiopsy)
            {
                case "99":
                    {

                        lblAnsNumBiopsies.Text = "Unknown";
                    }
                    break;
                case "1":
                    {
                        lblAnsNumBiopsies.Text = "1";
                    }
                    break;
                case "2":
                    {
                        lblAnsNumBiopsies.Text = "&gt; 1";
                    }
                    break;
                default:
                    {
                        lblAnsNumBiopsies.Text = _notApplicable;
                    }
                    break;
            }
        }

        if (EverHadBiopsy != "1")
            lblAnsHyp.Text = _notApplicable;
        else
        {
            switch (HyperPlasia)
            {
                case "99":
                    {
                        lblAnsHyp.Text = "Unknown";
                    }
                    break;
                case "0":
                    {
                        lblAnsHyp.Text = "No";
                    }
                    break;
                case "1":
                    {
                        lblAnsHyp.Text = "Yes";
                    }
                    break;
                default:
                    {
                        lblAnsHyp.Text = _notApplicable;
                    }
                    break;
            }
        }

        switch (Race)
        {
            case "1":
                {
                    lblEthWhite.Visible = true;
                    lblAnsRace.Text = "White";
                }
                break;
            case "2":
                {
                    lblEthBlack.Visible = true;
                    lblAnsRace.Text = "African American";
                }
                break;
            case "3":
                {
                    lblEthHispanic.Visible = true;
                    lblAnsRace.Text = "Hispanic";
                }
                break;
            case "4":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian or Pacific Islander";
                }
                break;
            case "5":
                {
                    lblEthNative.Visible = true;
                    lblAnsRace.Text = "American Indian or Alaskan Native";
                }
                break;
            case "6":
                {
                    lblEthUnknown.Visible = true;
                    lblAnsRace.Text = "Unknown";
                }
                break;

            case "7":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Chinese";
                    lblEthAsian.Text = "Asian-American: Chinese";
                }

                break;

            case "8":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Japanese";
                    lblEthAsian.Text = "Asian-American: Japanese";
                }

                break;
            case "9":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Filipino";
                    lblEthAsian.Text = "Asian-American: Filipino";
                }

                break;

            case "10":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Hawaiian";
                    lblEthAsian.Text = "Asian-American: Hawaiian";
                }

                break;
            case "11":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Other Pacific Islander";
                    lblEthAsian.Text = "Asian-American: Other Pacific Islander";
                }

                break;
            case "12":
                {
                    lblEthAsian.Visible = true;
                    lblAnsRace.Text = "Asian-American: Other Asian-American";
                    lblEthAsian.Text = "Asian-American: Other Asian-American";
                }

                break;

        }
    }
    protected void CalculateRisks(int RiskIndex, int CurrentAge, int ProjectionAge, int MenarcheAge, int FirstLiveBirthAge, int EverHadBiopsy, int NumberOfBiopsy, int HyperPlasia, int FirstDegRelatives, int Race, out double AbsoluteRisk, out double AverageRisk)
    {
        //double AbsoluteRisk = 0, AverageRisk = 0;
        //int CurrentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, Race;
        int AgeIndicator;
        double RHyperPlasia;

        CurrentAge = BcptConvert.GetCurrentAge(CurrentAge);
        //ProjectionAge = 
        MenarcheAge = BcptConvert.MenarcheAge(MenarcheAge);
        FirstLiveBirthAge = BcptConvert.FirstLiveBirthAge(FirstLiveBirthAge);
        EverHadBiopsy = BcptConvert.EverHadBiopsy(EverHadBiopsy);
        NumberOfBiopsy = BcptConvert.NumberOfBiopsy(NumberOfBiopsy, EverHadBiopsy);
        HyperPlasia = BcptConvert.Hyperplasia(HyperPlasia, EverHadBiopsy);
        Race = BcptConvert.GetRace(Race.ToString());
        if(Race<7)
            FirstDegRelatives = BcptConvert.FirstDegRelatives(FirstDegRelatives);
        else
            FirstDegRelatives = BcptConvert.FirstDegRelatives(FirstDegRelatives,Race);


        AgeIndicator = BcptConvert.CurrentAgeIndicator(CurrentAge);
        RHyperPlasia = BcptConvert.RHyperplasia(HyperPlasia, EverHadBiopsy);

        RiskIndex = 1;  //get absolute risk
        RiskCalculator oBcpt = new RiskCalculator();
        AbsoluteRisk = oBcpt.CalculateAbsoluteRisk(
             CurrentAge		//[t1]
            , ProjectionAge		//[t2]
            , AgeIndicator		//[i0]
            , NumberOfBiopsy	//[i2]
            , MenarcheAge		//[i1]
            , FirstLiveBirthAge	//[i3]
            , FirstDegRelatives	//[i4]
            , EverHadBiopsy		//[iever]
            , HyperPlasia		//[ihyp]
            , RHyperPlasia		//[rhyp]
            , Race				//[race]
            );
        RiskIndex = 2;  //get average risk also
        AverageRisk = oBcpt.CalculateAeverageRisk(
              CurrentAge		//[t1]
            , ProjectionAge		//[t2]
            , AgeIndicator		//[i0]
            , NumberOfBiopsy	//[i2]
            , MenarcheAge		//[i1]
            , FirstLiveBirthAge	//[i3]
            , FirstDegRelatives	//[i4]
            , EverHadBiopsy		//[iever]
            , HyperPlasia		//[ihyp]
            , RHyperPlasia		//[rhyp]
            , Race				//[race]
            );
        Console.WriteLine(String.Format("3. Absolute Risk: {0}\nAverage Risk: {1}", AbsoluteRisk, AverageRisk));
        //oOutFile.WriteLine(String.Format("<MethodC>Absolute Risk: \"{0}\" Average Risk: \"{1}\" </MethodC>", AbsoluteRisk, AverageRisk));
        //Console.ReadLine();

    }

    protected string GetRequestStr(string Name, string DefaultValue)
    {
        object o = System.Web.HttpContext.Current.Request[Name];
        return (o != null) ? o.ToString() : DefaultValue;
    }

    #region other methods   
    #endregion

}
