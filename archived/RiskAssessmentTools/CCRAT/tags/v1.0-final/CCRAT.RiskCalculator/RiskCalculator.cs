using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class RiskCalculator
    {
        public static AbsoluteRisks CalculateAbsRiskForMen(int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal bmi)
        {
            AbsoluteRisks risks = null;

            //calculate covariate the pattern.
            int patternID = 0;
            patternID = (numrel + 1)
                + 3 * (cigarets)
                + 4 * 3 * (noIbuprofn)
                + 2 * 4 * 3 * (noNSaids)
                + 2 * 2 * 4 * 3 * (sigmod)
                + 4 * 2 * 2 * 4 * 3 * bmiTrnd
                + 3 * 4 * 2 * 2 * 4 * 3 * (vegLT5)
                + 2 * 3 * 4 * 2 * 2 * 4 * 3 * (duration) //CigYr
                + 4 * 2 * 3 * 4 * 2 * 2 * 4 * 3 * hrsExcrise;

            //query the database and fill the risks object
            DataRow row = Query.GetRisks(currentAge, 1, patternID);

            if (row != null)
            {
                risks = new AbsoluteRisks
                (
                    "Male", currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise
                    , (decimal)(row["Five_yr_Abs_Risk"])
                    , (decimal)(row["Ten_yr_Abs_Risk"])
                    , (decimal)(row["Twenty_yr_Abs_Risk"])
                    , (decimal)(row["Life_Abs_Risk"])
                    , patternID
                    , bmi
                );
            }
            else
            {
                risks = new AbsoluteRisks("Male", currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise, patternID, false, bmi);
            }

            return risks;
        }

        public static AbsoluteRisks CalculateAbsRiskForWomen(int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal bmi)
        {
            AbsoluteRisks risks = null;

            //calculate covariate the pattern.
            //20081107 SR: corrected as per david's email
            int patternID = 0;
            patternID = 
                  (numrel + 1)
                + 3 * (noNSaids)
                + 2 * 3 * (sigmod)
                + 4 * 2 * 3 * bmiGe30
                + 2 * 4 * 2 * 3 * (vegLT5)
                + 2 * 2 * 4 * 2 * 3 * (noStrogen)
                + 2 * 2 * 2 * 4 * 2 * 3 * hrsExcrise;

            //query the database and fill the risks object
            DataRow row = Query.GetRisks(currentAge, 2, patternID);

            if (row != null)
            {
                risks = new AbsoluteRisks
                (                    
                    "Female", currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise
                    , (decimal)(row["Five_yr_Abs_Risk"])
                    , (decimal)(row["Ten_yr_Abs_Risk"])
                    , (decimal)(row["Twenty_yr_Abs_Risk"])
                    , (decimal)(row["Life_Abs_Risk"])
                    , patternID
                    , bmi
                );
            }
            else
            {
                risks = new AbsoluteRisks("Female", currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise, patternID, false, bmi);
            }          
            return risks;
        }


    }
}
