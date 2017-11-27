/**************************************************************************************************
* Name		: Manager.cs
* Purpose	: Manager class for Colorectal Cancer Risk Assessment Tool(CCRAT)
* Author	: SRamaiah
* Date		: 10/15/2008
* Changes	: 
**************************************************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
namespace CCRAT.RiskCalculator
{
    public class Manager
    {
        #region constants
        public const string OutOfRangeExection = "Out of range exception";
        #endregion constants

        #region public methods

        
        /// <summary>
        /// Returns five, ten, twenty year and life time abs risks
        /// </summary>
        /// <param name="race"></param>
        /// <param name="currentAge"></param>
        /// <param name="gender"></param>
        /// <param name="height">in inches</param>
        /// <param name="weight">in lbs</param>
        /// <param name="numServingsVeg"></param>
        /// <param name="amountVeg"></param>
        /// <param name="colonoscopy"></param>
        /// <param name="hadPolyp"></param>
        /// <param name="asprin"></param>
        /// <param name="ibuprofen"></param>
        /// <param name="cigs100More"></param>
        /// <param name="smokeStartAge"></param>
        /// <param name="stillSmoke"></param>
        /// <param name="ageQuit"></param>
        /// <param name="quitNumPerDay"></param>
        /// <param name="vigorousActivities"></param>
        /// <param name="vigorousHours"></param>
        /// <param name="stillHavePeriods"></param>
        /// <param name="lastCycle"></param>
        /// <param name="usedEstrogen"></param>
        /// <param name="hasRelativeHadCC"></param>
        /// <param name="numRelativesHavingCC"></param>
        /// <returns></returns>
        public static AbsoluteRisks CalculateRisks(
           string hispanic
         , string race
         , string currentAge
         , string gender
         , string height
         , string weight
         , string numServingsVeg
         , string amountVeg
         , string colonoscopy
         , string hadPolyp
         , string asprin
         , string ibuprofen
         , string cigs100More
         , string smokeStartAge
         , string stillSmoke
         , string ageQuit
         , string quitNumPerDay
         , string vigorousActivities
         , string vigorousHours
         , string stillHavePeriods
         , string lastCycle
         , string usedEstrogen
         , string hasRelativeHadCC
         , string numRelativesHavingCC
         )
        {

            Hispanic eHispanic;
            if (IsUnanswered(hispanic))
                throw new Exception("Hispanic has not been answered.");
            else if (hispanic.ToLower() == "no")
                eHispanic = Hispanic.No;
            else if (hispanic.ToLower() == "yes")
                eHispanic = Hispanic.Yes;
            else if (hispanic.ToLower() == "dontknow")
                eHispanic = Hispanic.No;
            else
                throw new Exception("Unknown answer for Hispanic");
       
            Genders eGender;

            if (IsUnanswered(gender))
                throw new Exception("Gender has not been answered.");
            else if (gender == "Male")
                eGender = Genders.Male;
            else if (gender == "Female")
                eGender = Genders.Female;
            else
                throw new Exception("Unknown answer for Gender");

            //BTW, I am naming the vars the same as David Pee's program, that is why the spelling is a bit wierd.

            if (IsUnanswered(currentAge))
                throw new Exception("CurrentAge has not been answered");

            int iCurrentAge = Int32.Parse(currentAge);

            //SETUP Vars for both Genders.
            int VegLt5 = CalculateVegLt5(numServingsVeg, amountVeg);
            int Sigmod = CalculateSigmod(colonoscopy, hadPolyp);
            int NoNSaids = CalculateNoNSaids(asprin, ibuprofen);
            int HrsExcrise = CalculateHrsExcrise(vigorousActivities, vigorousHours);
            int Numrel = CalculateNumrel(hasRelativeHadCC, numRelativesHavingCC);
            decimal bmi = CalculateBMI(height, weight);

            Race eRace = GetRace(race, eHispanic);

            if (eGender == Genders.Male)
            {
                int NoIbuprofn = CalculateNoIbuprofn(ibuprofen);
                int Duration = CalculateDuration(iCurrentAge, cigs100More, smokeStartAge, stillSmoke, ageQuit);
                int Cigarets = CalculateCigarets(cigs100More, smokeStartAge, quitNumPerDay);
                int BMI_Trnd = CalculateBmi_trnd(height, weight);
                return RiskCalculator.CalculateAbsRiskForMen(eRace, iCurrentAge, Numrel, Cigarets, Duration, NoNSaids, NoIbuprofn, Sigmod, VegLt5, BMI_Trnd, HrsExcrise, bmi);
            }
            else
            {
                //Since the Enum is either male or female, then if they are not male, then they cannot be female.
                int Nostrogen = CalculateNostrogen(stillHavePeriods, lastCycle, usedEstrogen);
                int BmiGe30 = CalculateBMIge30(height, weight);

                return RiskCalculator.CalculateAbsRiskForWomen(eRace, iCurrentAge, Numrel, Nostrogen, NoNSaids, Sigmod, VegLt5, BmiGe30, HrsExcrise, bmi);
            }
        }

        /// <summary>
        /// Returns Body Mass Index (BMI)
        /// </summary>
        /// <param name="weight">Weight in lbs</param>
        /// <param name="height">Height in inches</param>
        /// <returns></returns>
        private static decimal CalculateBMI(string height, string weight)
        {
            //q1 - height in meeters; a)1 Foot = 0.3048 Meters b)1 Inch = 0.0254 Meters
            //q2 - weight in Kilograms; 1 Pound = 0.45359237 Kilograms
            if (IsUnanswered(height))
                throw new Exception("Height has not been answered");

            if (IsUnanswered(weight))
                throw new Exception("Weight has not been answered");

            decimal dHeight = decimal.Parse(height);
            decimal dWeight = decimal.Parse(weight);

            return (dWeight * 0.45359237m) / (dHeight * 0.0254m * dHeight * 0.0254m);
            
        }

        public static int CalculateBMIge30(string height, string weight)
        {
            decimal bmi = CalculateBMI(height, weight);

            if (bmi < 30m)
                return 0;
            else
                return 1;
        }

        public static int CalculateBmi_trnd(string height, string weight)
        {
            decimal bmi = CalculateBMI(height, weight);

            if (bmi <= 24.9m)
                return 0;
            else if (bmi <= 29.9m)
                return 1;
            else
                return 2;
        }

        #region Var Translations

        #region Var Translations for both Men and Women

        /// <summary>
        /// Gets in the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?
        /// </summary>
        /// <param name="numServingsVeg">Number of vegetables or leafy green salads servings</param>
        /// <param name="amountVeg">Amount of vegetable servings</param>
        /// <returns></returns>
        private static int CalculateVegLt5(string numServingsVeg, string amountVeg)
        {
            /* From Mapping Document
             * numServingsVeg is Q3 and amountVeg is Q4
               Veglt5= 1 if numServingsVeg * amountVeg / 3.5 <5
               Veglt5= 0 if numServingsVeg * amountVeg / 3.5 >=5
             */

            if (IsUnanswered(numServingsVeg))
                throw new Exception("NumServingsVeg has not been answered");

            float fNumServingsVeg = float.Parse(numServingsVeg);

            if (fNumServingsVeg == 0f)
            {
                return 1;
            }
            else
            {
                if (IsUnanswered(amountVeg))
                    throw new Exception("AmountVeg has not been answered, yet NumServingsVeg is > 0");

                float fAmountVeg = float.Parse(amountVeg);
              
                if (fNumServingsVeg * fAmountVeg / 3.5 < 5)
                    return 1;
                else
                    return 0;

            }

            throw new Exception("Something went wrong calculating VegetableServings.");
        }

        /// <summary>
        /// Gets Sigmod value
        /// </summary>
        /// <param name="colonoscopy">Have you had a colonoscopy or a sigmoidoscopy in the past 10 years?</param>
        /// <param name="hadPolyp">Have you had a colon polyp or a rectal polyp in the past 10 years?</param>
        /// <returns></returns>
        private static int CalculateSigmod(string colonoscopy, string hadPolyp)
        {
            /* From Mapping Document: colonoscopy is Q5 and hadPolyp is Q6
             * if colonoscopy= yes and hadPolyp = no          then    sigmod=0;
                if colonoscopy= yes and hadPolyp = I don’t know then    sigmod=3;
                if colonoscopy= no                       then    sigmod=1;
                if colonoscopy= yes and hadPolyp = yes         then    sigmod=2;
                if colonoscopy= I don’t know              then    sigmod=3     
            */
            if (IsUnanswered(colonoscopy))
                throw new Exception("Colonoscopy has not been answered.");

            if (colonoscopy == "No")
            {
                return 1;
            }
            else if (colonoscopy == "DontKnow")
            {
                return 3;
            }
            else if (colonoscopy == "Yes")
            {
                if (IsUnanswered(hadPolyp))
                    throw new Exception("HadPolyp has not been answered yet Colonoscopy has.");

                if (hadPolyp == "Yes")
                    return 2;
                else if (hadPolyp == "No")
                    return 0;
                else if (hadPolyp == "DontKnow")
                    return 3;
                else
                    throw new Exception("Unknown answer to HadPolyp");
            }
            else
            {
                throw new Exception("Unknown answer to Colonoscopy");
            }
        }

        /// <summary>
        /// Returns NoNSaids value
        /// </summary>
        /// <param name="asprin">During the past 30 days, have you taken aspirin, Bufferin, Bayer, or Excedrin at least 3 times a week?  Do NOT include Tylenol.</param>
        /// <param name="ibuprofen">During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.</param>
        /// <returns></returns>
        private static int CalculateNoNSaids(string asprin, string ibuprofen)
        {
            /* From Mapping Document:
             * asprin is Q7 and ibuprofen is Q8
             * If asprin = no AND ibuprofen = no then NoNSaids=1;
             * If asprin = yes OR ibuprofen = yes then NoNSaids=0;
             */
            try
            {
                if (IsUnanswered(asprin))
                    throw new Exception("Asprin has not been answered.");

                if (IsUnanswered(ibuprofen))
                    throw new Exception("Ibuprofen has not been answered.");

                if (asprin != "Yes" && asprin != "No" && asprin != "DontKnow")
                    throw new Exception("Asprin has an unknown answer.");

                if (ibuprofen != "Yes" && ibuprofen != "No" && ibuprofen != "DontKnow")
                    throw new Exception("Ibuprofen has an unknown answer.");

                if (asprin == "No" && ibuprofen == "No")
                    return 1;
                else
                    return 0;
            }
            catch
            {
                return 0; //Only an answer of No should result in a higher risk.  (Although we should log errors and not just return the value)
            }
        }

        /// <summary>
        /// Gets Average Hours Of Exercise per month
        /// </summary>
        /// <param name="vigorousActivities">Now think about the vigorous physical activity you may have done in the past 12 months.</param>
        /// <param name="vigorousHours">During those months, on average, about how many hours per week did you do vigorous physical activities?</param>
        /// <returns></returns>
        private static int CalculateHrsExcrise(string vigorousActivities, string vigorousHours)
        {
            /* From the Mapping Document:
             * vigorousActivities is Q16 and vigorousHours is Q17
               Hrstotal= vigorousHours * vigorousActivities/12 
               if         Hrstotal =0                  then HrsExcrise =3; 
               else  if   Hrstotal >0 and  Hrstotal  =<2 then HrsExcrise =2; 
               else  if   Hrstotal >2 and  Hrstotal  =<4 then HrsExcrise =1; 
               else  if   Hrstotal >4                  then HrsExcrise =0; 
            */

            if (IsUnanswered(vigorousActivities))
                throw new Exception("VigorousActivities has not been answered.");

            int iVigorousActivities = Int32.Parse(vigorousActivities);

            if (iVigorousActivities == 0)
                return 3;

            if (IsUnanswered(vigorousHours))
                throw new Exception("VigorousHours has not been answered yet VigorousActivities > 0.");

            float fVigorousHours = float.Parse(vigorousHours);

            if (fVigorousHours == float.NaN)
                throw new Exception("VigorousHours is not a number.");

            float Hrstotal = fVigorousHours * (iVigorousActivities / 12);

            if (Hrstotal < 0)
                throw new Exception("Hrstotal is < 0");
            if (Hrstotal == 0)
                return 3;
            else if (Hrstotal <= 2)
                return 2;
            else if (Hrstotal <= 4)
                return 1;
            else
                return 0;
        }

        /// <summary>
        /// How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?
        /// </summary>
        /// <param name="hasRelativeHadCC">Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have cancer of the colon or rectum?</param>
        /// <param name="numRelativesHavingCC">How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?</param>
        /// <returns></returns>
        private static int CalculateNumrel(string hasRelativeHadCC, string numRelativesHavingCC)
        {
            /* From Mapping Document:
             * hasRelativeHadCC is Q22 and numRelativesHavingCC is Q23
                If hasRelativeHadCC = no  or hasRelativeHadCC = I don’t know  then Numrel=0

                If hasRelativeHadCC =yes and numRelativesHavingCC=1                       then Numrel=1
                If hasRelativeHadCC =yes and numRelativesHavingCC= I don’t know  then Numrel=1

                If hasRelativeHadCC =yes and numRelativesHavingCC=2 then Numrel=2
             */

            if (IsUnanswered(hasRelativeHadCC))
                throw new Exception("HasRelativeHadCC has not been answered yet.");

            if (hasRelativeHadCC == "No" || hasRelativeHadCC == "DontKnow")
            {
                return 0;
            }
            else if (hasRelativeHadCC == "Yes")
            {
                if (IsUnanswered(numRelativesHavingCC))
                    throw new Exception("NumRelativesHavingCC has not been answered yet HasRelativeHadCC has been.");

                if (numRelativesHavingCC == "One" || numRelativesHavingCC == "DontKnow")
                    return 1;
                else if (numRelativesHavingCC == "TwoPlus")
                    return 2;
                else
                    throw new Exception("Unknown answer for NumRelativesHavingCC");
            }
            else
            {
                throw new Exception("Unknown answer for HasRelativeHadCC");
            }
        }

        /// <summary>
        /// Gets the recoded race enum for a given race string and hispanic enum flag
        /// </summary>
        /// <param name="race"></param>
        /// <param name="ehispanic"></param>
        /// <returns>Recoded Race enumeration</returns>
        private static Race GetRace(string race, Hispanic ehispanic)
        {
            Race erace = Race.Unknown;
            try
            {
                switch (ehispanic)
                {
                    //non-hispanic or don't know from ddlHispanic
                    case Hispanic.No:
                    case Hispanic.DontKnow:
                        erace = (Race)Enum.Parse(typeof(Race), race, true);
                        switch (erace)
                        {
                            case Race.Indian:
                               erace = Race.White;
                                break;
                            case Race.Hawaiian:
                                //HACK: this is re-coded as white in BCRA
                                erace = Race.Asian;
                                break;
                            default:
                                break;
                        }
                        break;
                    // if user answers yes to ddlHispanic then we re-code the race to hispanic 
                    // ir-respective of their race selection from ddlRace dropdown
                    case Hispanic.Yes:
                        erace = Race.Hispanic;
                        break;
                }
            }
            catch
            {
                throw new Exception(string.Format("The race ({0}) is not supported", race));
            }
            return erace;
        }

        #endregion

        #region Var Translations for Men

        /// <summary>
        /// NoIbuprofn
        /// </summary>
        /// <param name="ibuprofen">During the past 30 days, have you taken Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin at least 3 times a week?  Do NOT include Tylenol.</param>
        /// <returns></returns>
        private static int CalculateNoIbuprofn(string ibuprofen)
        {
            /* From Mapping Document:
             * ibuprofen is Q8
             * If ibuprofen=no then NoIbuprofn=1;
             * If ibuprofen=yes then NoIbuprofn=0;
             */
            try
            {
                if (IsUnanswered(ibuprofen))
                    throw new Exception("Ibuprofen has not been answered.");

                if (ibuprofen != "Yes" && ibuprofen != "No" && ibuprofen != "DontKnow")
                    throw new Exception("Ibuprofen has an unknown answer.");

                if (ibuprofen == "No")
                    return 1;
                else
                    return 0; //Was returning 1; fixed by JIRA OCEOTHER-35
            }
            catch
            {
                return 0; //Only an answer of No should result in a higher risk.  (Although we should log errors and not just return the value)
            }
        }

        /// <summary>
        /// Gets how long a person has smoked
        /// </summary>
        /// <param name="currentAge"></param>
        /// <param name="cigs100More"></param>
        /// <param name="smokeStartAge"></param>
        /// <param name="occasionalSmoke"></param>
        /// <param name="ageQuit"></param>
        /// <returns></returns>
        public static int CalculateDuration(int currentAge, string cigs100More, string smokeStartAge, string stillSmoke, string ageQuit)
        {
            /* From the mapping doc:
             * cigs100More is Q9 and smokeStartAge is Q10 and stillSmoke is Q11 and ageQuit is Q12
             * If cigs100More=no then duration =0 ;
               If smokeStartAge = “I have never smoked cigarettes 
	                Regularly” then duration =0;
                Otherwise take the age from smokeStartAge

                If stillSmoke = yes, then yearssmoked = current age - age given in smokeStartAge
                If stillSmoke = no then yearssmoke = age given in ageQuit – age given in smokeStartAge

                if       yearssmoke =  0                    then duration=0;
                else if  yearssmoke >  0 and yearssmoke <15 then duration=1;
                else if  yearssmoke >=15 and yearssmoke <35 then duration=2;
                else if  yearssmoke >=35                    then duration=3;
            */
            //q9-cigs100More, q10-smokeStartAge, q11-occasionalSmoke, q12-ageQuit, q13-quitNumPerDay

            //ASSUMPTION! currentAge should be valid by the time we get here.

            if (IsUnanswered(cigs100More))
                throw new Exception("Cigs100More has not been answered yet");

            if (cigs100More == "No" || cigs100More == "DontKnow")
            {
                return 0;
            }
            else if (cigs100More == "Yes")
            {
                if (IsUnanswered(smokeStartAge))
                    throw new Exception("SmokeStart not answered event though Cigs100More has.");

                if (smokeStartAge == "NeverSmoke")
                    return 0;

                int iSmokeStartAge = Int32.Parse(smokeStartAge);


                //if (IsUnanswered(stillSmoke))
                    //throw new Exception("StillSmoke not answered event though Cigs100More has and SmokeStart is not NeverSmoke.");

                int yearsSmoke = -1;

                if (stillSmoke == "Yes")
                {
                    yearsSmoke = currentAge - iSmokeStartAge;
                }
                else if (stillSmoke == "No")
                {
                    //Check the quit age.
                    if (IsUnanswered(ageQuit))
                        throw new Exception("SmokeStop not answered even though Cigs100More has and SmokeStart is not NeverSmoke and StillSmoke is no.");

                    int iAgeQuit = Int32.Parse(ageQuit);

                    yearsSmoke = iAgeQuit - iSmokeStartAge;
                }
                else
                {
                    return 0;
                    //throw new Exception("Unknown answer for StillSmoke.");
                }

                if (yearsSmoke < 0)
                    return 0;
                    //throw new Exception("The years smoke is < 0");
                else if (yearsSmoke == 0)
                    return 0;
                else if (yearsSmoke < 15)
                    return 1;
                else if (yearsSmoke < 35)
                    return 2;
                else
                    return 3;
            }
            else
            {
                throw new Exception("Unknown answer for Cigs100More");
            }
        }

        /// <summary>
        /// Gets number of cigaretts a person has smoked
        /// </summary>
        /// <param name="cigs100More"></param>
        /// <param name="smokeStartAge"></param>
        /// <param name="quitNumPerDay"></param>
        /// <returns></returns>
        public static int CalculateCigarets(string cigs100More, string smokeStartAge, string quitNumPerDay)
        {
            //q9-cigs100More, q10-smokeStartAge, q13-quitNumPerDay

            //if (IsUnanswered(cigs100More))
                //throw new Exception("Cigs100More has not been answered yet");

            if (cigs100More == "No" || cigs100More == "DontKnow")
            {
                return 0;
            }
            else if (cigs100More == "Yes")
            {
                if (IsUnanswered(smokeStartAge))
                    return 0;
                    //throw new Exception("SmokeStart not answered event though Cigs100More has.");

                if (smokeStartAge == "NeverSmoke")
                    return 0;

                //Just try to parse smokeStartAge to see if it is a valid number
                Int32.Parse(smokeStartAge);

                //if (IsUnanswered(quitNumPerDay))
                    //throw new Exception("QuitNumPerDay has not been answered even though Cigs100More has and SmokeStartAge indicates smoker");

                if (quitNumPerDay == "1To10")
                    return 1;
                else if (quitNumPerDay == "11To20")
                    return 2;
                else if (quitNumPerDay == "GT20")
                    return 3;
                else
                    return 1;
                    //throw new Exception("Unknown answer for QuitNumPerDay");
            }
            else
            {
                return 1;
                //throw new Exception("Unknown answer for Cigs100More");
            }
        }

        #endregion

        #region Var Translations for Women
        /// <summary>
        /// Gets during the past 2 years, have you used estrogen, progestin, Hormone Replacement Therapy or other female hormones?
        /// </summary>
        /// <param name="stillHavePeriods"></param>
        /// <param name="lastCycle"></param>
        /// <param name="usedEstrogen"></param>
        /// <returns></returns>
        private static int CalculateNostrogen(string stillHavePeriods, string lastCycle, string usedEstrogen)
        {
            /* From Mapping Doc:
             * stillHavePeriods is Q18 and lastCycle is Q19 and usedEstrogen is Q20

                Nostrogen   =1 if stillHavePeriods=no AND lastCycle=3 (two or more years ago) AND usedEstrogen= no
            
                Nostrogen   =0  (positive estrogen or estrogen exposure in last 2 years) 
                if stillHavePeriods= yes  OR  (stillHavePeriods=no AND lastCycle= 1 or 2)  or 
                if stillHavePeriods= no AND usedEstrogen=yes
            */

            if (IsUnanswered(stillHavePeriods))
                throw new Exception("StillHavePeriods has not been answered.");

            if (stillHavePeriods == "Yes")
            {
                return 0;
            }
            else if (stillHavePeriods == "No")
            {
                if (IsUnanswered(lastCycle))
                    throw new Exception("LastCycle not answered even though StillHavePeriods was.");

                if (lastCycle == "LT1" || lastCycle == "GT1LT2")
                {
                    return 0;
                }
                else if (lastCycle == "GT2")
                {
                    if (IsUnanswered(usedEstrogen))
                        throw new Exception("UsedEstrogen not answered event though LastCycle > 2 and StillHavePeriods is No.");

                    if (usedEstrogen == "Yes")
                        return 0;
                    else if (usedEstrogen == "No")
                        return 1;
                    else
                        throw new Exception("Unknown answer to UsedEstrogen");
                }
                else
                {
                    throw new Exception("Unknown answer to LastCycle");
                }
            }
            else
            {
                throw new Exception("Unknown answer for StillHavePeriods");
            }
        }

        #endregion

        #endregion

        /// <summary>
        /// Checks to see if a question has been answered
        /// </summary>
        /// <param name="question"></param>
        /// <returns></returns>
        private static bool IsUnanswered(string question)
        {
            if (string.IsNullOrEmpty(question))
                return true;
            else
                return (question.Equals("NAN", StringComparison.OrdinalIgnoreCase));
        }
        #endregion public methods


    }
}
