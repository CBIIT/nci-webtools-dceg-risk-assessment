using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class QuestionsFemale:Questions
    {

        /// <summary>
        /// Returns Body Mass Index Trend
        /// </summary>
        public int BmiTrnd
        {
            get
            {
                int retVal;
                decimal bmi = base.BMI;
                if (bmi < 30m)
                    retVal = 0;
                else if (bmi >= 30m)
                    retVal = 1;
                else
                    throw new Exception("Out of range exception");
                return retVal;
            }
        }
        
    }
}
