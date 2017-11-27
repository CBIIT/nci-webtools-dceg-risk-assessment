using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class RiskCalculator
    {
        public static AbsoluteRisks CalculateAbsRiskForMen(Race race, int currentAge, int numrel, int cigarets, int duration, int noNSaids, int noIbuprofn, int sigmod, int vegLT5, int bmiTrnd, int hrsExcrise, decimal bmi)
        {
            AbsoluteRisks risks = null;

            //calculate covariate pattern.
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
            DataRow row = Query.GetRisks(currentAge, 1, patternID, race);

            if (row != null)
            {
                risks = new AbsoluteRisks( 
                    race, "Male", currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise
                    , (decimal)(row["FiveYrAbsRisk"])
                    , (decimal)(row["TenYrAbsRisk"])
                    , (decimal)(row["TwentyYrAbsRisk"])
                    , (decimal)(row["LifeAbsRisk"])
                    , patternID
                    , bmi
                    //03-13-09: average risk values FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
                    , (decimal)(row["FiveYrAvgRisk"])
                    , (decimal)(row["TenYrAvgRisk"])
                    , (decimal)(row["LifeTimeAvgRisk"])
                    
                    , (decimal)(row["AbsRsk_05_L"])
                    , (decimal)(row["AbsRsk_05_U"])
                    , (decimal)(row["AbsRsk_10_L"])
                    , (decimal)(row["AbsRsk_10_U"])
                    , (decimal)(row["AbsRsk_20_L"])
                    , (decimal)(row["AbsRsk_20_U"])
                    , (decimal)(row["AbsRsk_LT_L"])
                    , (decimal)(row["AbsRsk_LT_U"])
                );
            }
            else
            {
                risks = new AbsoluteRisks
                (
                    race, "Male", currentAge, numrel, cigarets, duration, noNSaids, noIbuprofn, sigmod, vegLT5, bmiTrnd, hrsExcrise
                    , patternID, false, bmi
                );
            }

            return risks;
        }

        public static AbsoluteRisks CalculateAbsRiskForWomen(Race race, int currentAge, int numrel, int noStrogen, int noNSaids, int sigmod, int vegLT5, int bmiGe30, int hrsExcrise, decimal bmi)
        {
            AbsoluteRisks risks = null;

            //calculate covariate pattern.
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
            DataRow row = Query.GetRisks(currentAge, 2, patternID, race);

            if (row != null)
            {
                risks = new AbsoluteRisks
                (                    
                    race, "Female", currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise
                    , (decimal)(row["FiveYrAbsRisk"])
                    , (decimal)(row["TenYrAbsRisk"])
                    , (decimal)(row["TwentyYrAbsRisk"])
                    , (decimal)(row["LifeAbsRisk"])
                    , patternID
                    , bmi
                    //03-13-09: average risk values FiveYrAvgRisk, TenYrAvgRisk, LifeTimeAvgRisk
                    , (decimal)(row["FiveYrAvgRisk"])
                    , (decimal)(row["TenYrAvgRisk"])
                    , (decimal)(row["LifeTimeAvgRisk"])
                    , (decimal)(row["AbsRsk_05_L"])
                    , (decimal)(row["AbsRsk_05_U"])
                    , (decimal)(row["AbsRsk_10_L"])
                    , (decimal)(row["AbsRsk_10_U"])
                    , (decimal)(row["AbsRsk_20_L"])
                    , (decimal)(row["AbsRsk_20_U"])
                    , (decimal)(row["AbsRsk_LT_L"])
                    , (decimal)(row["AbsRsk_LT_U"])
                );
            }
            else
            {
                risks = new AbsoluteRisks
                (
                    race, "Female", currentAge, numrel, noStrogen, noNSaids, sigmod, vegLT5, bmiGe30, hrsExcrise
                    , patternID, false, bmi
                );
            }          
            return risks;
        }
    }
}
