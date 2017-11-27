using System;
using System.Collections.Generic;
using System.Text;

using NCI.DCEG.BCRA.Engine;

namespace NCI.DCEG.BCRA.ConsoleSample
{
    class Program
    {
        static void Main(string[] args)
        {
            // This risk assessment was based on data for white females.
            // Researchers are conducting additional studies, including studies with minority populations, to gather more data and to
            // increase the accuracy of the tool for women in these populations.

            // Also, this tool cannot calculate breast cancer risk accurately for women with a medical history of any breast cancer or of DCIS or LCIS.

            // Setup Sample Data.
            int currentAge = BcptConvert.GetCurrentAge(35);
            int menarcheAge = BcptConvert.GetMenarcheAge("14");
            int firstLiveBirthAge = BcptConvert.GetFirstLiveBirthAge("27");
            int firstDegreeRel = BcptConvert.GetFirstDegRelatives("1");
            int hadBiopsy = BcptConvert.GetEverHadBiopsy("1");
            int numBiopsy = BcptConvert.GetNumberOfBiopsy("1");
            int hyperPlasia = BcptConvert.GetHyperPlasia("1");
            int race = BcptConvert.GetRace("1");

            double absRisk = 0, avgRisk = 0, absRiskPctg = 0, avgRiskPctg = 0;

            // Calculate 5 year risk.
            Helper.RiskCalc(0, currentAge, currentAge + 5, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy,
                hyperPlasia, firstDegreeRel, race, out absRisk, out avgRisk);
            Helper.CalcPercentage(absRisk, avgRisk, out absRiskPctg, out avgRiskPctg);

            Console.WriteLine("5 year risk");
            Console.WriteLine("This woman (age {0:N}) = {1:F}", currentAge, absRiskPctg);
            Console.WriteLine("Average woman (age {0:N}) = {1:F}", currentAge, avgRiskPctg);

            // Calculate lifetime risk.
            Helper.RiskCalc(0, currentAge, 90, menarcheAge, firstLiveBirthAge, hadBiopsy, numBiopsy,
                hyperPlasia, firstDegreeRel, race, out absRisk, out avgRisk);
            Helper.CalcPercentage(absRisk, avgRisk, out absRiskPctg, out avgRiskPctg);

            Console.WriteLine("\nLifetime risk");
            Console.WriteLine("This woman (to age 90): " + absRiskPctg.ToString("F1"));
            Console.WriteLine("Average woman (to age 90): " + avgRiskPctg.ToString("F1"));

            Console.Read();
        }
    }
}