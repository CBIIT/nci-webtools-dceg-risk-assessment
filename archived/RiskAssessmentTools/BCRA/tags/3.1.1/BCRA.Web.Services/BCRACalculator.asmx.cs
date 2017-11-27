using System;
using System.Data;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.ComponentModel;
using NCI.BCPT.Engine;
using System.Configuration;
namespace BCRA.Web.Services
{
    /// <summary>
    /// BCPT - (B)reast (C)ancer (P)revention (T)rial
    /// </summary>
    [WebService(Namespace = "http://www.cancer.gov/bcrisktool/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public class BCRACalculator : System.Web.Services.WebService
    {
        /// <summary>
        /// Calculates Breast Cancer Risks - Absolute and Average risks for next 5 years and also Absolute and Average risks for a life time 
        /// </summary>
        /// <param name="CurrentAge">What is the woman's age?</param>
        /// <param name="MenarcheAge">What was the woman's age at the time of her first menstrual period?</param>
        /// <param name="FirstLiveBirthAge">What was the woman's age at the time of her first live birth of a child?</param>
        /// <param name="FirstDegRelatives">How many of the woman's first-degree relatives - mother, sisters, daughters - have had breast cancer? </param>
        /// <param name="EverHadBiopsy">Has the woman ever had a breast biopsy?</param>
        /// <param name="NumberOfBiopsy">How many breast biopsies (positive or negative) has the woman had?</param>
        /// <param name="HyperPlasia">Has the woman had at least one breast biopsy with atypical hyperplasia? </param>
        /// <param name="Race">What is the woman's race/ethnicity?</param>
        /// <returns></returns>

        [WebMethod]
        public string CalculateBreastCancerRisks
        ( 
            int CurrentAge
            , int MenarcheAge
            , int FirstLiveBirthAge
            , int FirstDegRelatives
            , int EverHadBiopsy
            , int NumberOfBiopsy
            , int HyperPlasia
            , int Race
        )
        {
            string retVal = string.Empty;
            double AbsoluteRisk = 0, AverageRisk = 0;
            int AgeIndicator;
            double RHyperPlasia;
            int projectionAgeNextNYears;
            int projectionAgeLifeTime;

            try
            {
                projectionAgeNextNYears = CurrentAge + int.Parse(ReadConfigSetting("ProjectionAgeNextNYears", "5"));
                projectionAgeLifeTime = int.Parse(ReadConfigSetting("ProjectionAgeLifeTime", "90"));

                CurrentAge = BcptConvert.GetCurrentAge(CurrentAge);
                MenarcheAge = BcptConvert.MenarcheAge(MenarcheAge);
                FirstLiveBirthAge = BcptConvert.FirstLiveBirthAge(FirstLiveBirthAge);
                EverHadBiopsy = BcptConvert.EverHadBiopsy(EverHadBiopsy);
                NumberOfBiopsy = BcptConvert.NumberOfBiopsy(NumberOfBiopsy, EverHadBiopsy);
                HyperPlasia = BcptConvert.Hyperplasia(HyperPlasia, EverHadBiopsy);
                FirstDegRelatives = BcptConvert.FirstDegRelatives(FirstDegRelatives);
                Race = BcptConvert.GetRace(Race.ToString());

                AgeIndicator = BcptConvert.CurrentAgeIndicator(CurrentAge);
                RHyperPlasia = BcptConvert.RHyperplasia(HyperPlasia, EverHadBiopsy);

                //calculate absolute risk for next [n] years
                RiskCalculator oBcpt = new RiskCalculator();
                AbsoluteRisk = oBcpt.CalculateAbsoluteRisk(
                     CurrentAge		//[t1]
                    , projectionAgeNextNYears //[t2]
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
                //calculate average risk for next [n] years
                AverageRisk = oBcpt.CalculateAeverageRisk(
                      CurrentAge		//[t1]
                    , projectionAgeNextNYears //[t2]
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

                retVal = string.Format("<FiveYearAbsoluteRisk>{0}</FiveYearAbsoluteRisk><FiveYearAverageRisk>{1}</FiveYearAverageRisk>", Math.Round(AbsoluteRisk * 100, 1), Math.Round(AverageRisk * 100, 1));

                //calculate life time absoulte risks
                AbsoluteRisk = oBcpt.CalculateAbsoluteRisk(
                    CurrentAge		    //[t1]
                   , projectionAgeLifeTime  //[t2]
                   , AgeIndicator		//[i0]
                   , NumberOfBiopsy	    //[i2]
                   , MenarcheAge		//[i1]
                   , FirstLiveBirthAge	//[i3]
                   , FirstDegRelatives	//[i4]
                   , EverHadBiopsy		//[iever]
                   , HyperPlasia		//[ihyp]
                   , RHyperPlasia		//[rhyp]
                   , Race				//[race]
                   );
                //calculate life time average risks
                AverageRisk = oBcpt.CalculateAeverageRisk(
                      CurrentAge		//[t1]
                    , projectionAgeLifeTime //[t2]
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
                retVal = retVal + string.Format("<LifeTimeAbsoluteRisk>{0}</LifeTimeAbsoluteRisk><LifeTimeAverageRisk>{1}</LifeTimeAverageRisk>", Math.Round(AbsoluteRisk * 100, 1), Math.Round(AverageRisk * 100, 1));
                return retVal;
            }
            catch (Exception ex)
            {
                throw new SoapException(ex.Message, SoapException.ClientFaultCode);
            }            
        }

        public static string ReadConfigSetting(string Name, string DefaultValue)
        {
            //use this for pre 2.0
            //string o = ConfigurationSettings.AppSettings[Name];
            string o = ConfigurationManager.AppSettings[Name];
            return (o != null) ? Convert.ToString(o) : DefaultValue;
        }

    }
}
