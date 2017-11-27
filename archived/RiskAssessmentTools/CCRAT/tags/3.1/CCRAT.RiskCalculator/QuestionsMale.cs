using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CCRAT.RiskCalculator
{
    public class QuestionsMale:Questions
    {
        /// <summary>
        /// Returns Body Mass Index Trnd
        /// </summary>
        public int BmiTrnd
        {
            get 
            {
                int retVal;
                decimal bmi = base.BMI;
                if (bmi < 24.9m)
                    retVal = 1;
                else if (bmi >= 24.9m && bmi < 29.9m)
                    retVal = 2;
                else if (bmi >= 29.9m)
                    retVal = 3;
                else
                    throw new Exception("Out of range exception");
                return retVal;
            }
        }
    }
}
