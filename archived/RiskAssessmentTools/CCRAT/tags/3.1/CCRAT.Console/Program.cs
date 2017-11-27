using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CCRAT.RiskCalculator;
using Common.Utils;
using Common.Utils.Logger;
namespace CCRAT.ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string gender = Helper.ReadConfigSetting("Gender", string.Empty);

                string[] genderArray = gender.Split(new char[] { ',' });
                string filePath = Helper.ReadConfigSetting("XmlFilePath", string.Empty);

                int maxCount = Helper.ReadConfigSetting("MaxCount", 0);

                if (Helper.ReadConfigSetting("GenerateXmlTestCases", false))
                    GenerateTestCases(filePath, genderArray, maxCount);

                if (Helper.ReadConfigSetting("CalculateRisks", false))
                {
                    string outputDelimiter = Helper.ReadConfigSetting("OutputDelimiter", string.Format("\t"));
                    bool usePercentage = Helper.ReadConfigSetting("UsePercentage", false);
                    int decimals = Helper.ReadConfigSetting("NumberofDecimalPlaces", 1);
                    XmlParser.CCRATXmlParser.ParseCCRATXml(filePath, gender, true, outputDelimiter, usePercentage, decimals);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: {0}\nStackTrace:\n\t{1}", ex.Message, ex.StackTrace);
            }
        }

        /// <summary>
        /// Generates Test Cases as xml
        /// </summary>
        /// <param name="maxCount">Specify a maximum count or 0 for all</param>
        public static void GenerateTestCases(string filePath, string[] genderArray,  int maxCount)
        {

            string[] inputDelim = new string[] { Helper.ReadConfigSetting("InputDelimiter", ", ")};
            //common questions
            string[] raceArray = Helper.ReadConfigSetting("race").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] currentAgeArray = Helper.ReadConfigSetting("currentAge").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] heightArray = Helper.ReadConfigSetting("height").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] weightArray = Helper.ReadConfigSetting("weight").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] numServingsVegArray = Helper.ReadConfigSetting("numServingsVeg").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] amountVegArray = Helper.ReadConfigSetting("amountVeg").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] colonoscopyArray = Helper.ReadConfigSetting("colonoscopy").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] hadPolypArray = Helper.ReadConfigSetting("hadPolyp").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] asprinArray = Helper.ReadConfigSetting("asprin").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] ibuprofenArray = Helper.ReadConfigSetting("ibuprofen").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] hasRelativeHadCCArray = Helper.ReadConfigSetting("hasRelativeHadCC").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] numRelativesHavingCCArray = Helper.ReadConfigSetting("numRelativesHavingCC").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] vigorousActivitiesArray = Helper.ReadConfigSetting("vigorousActivities").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] vigorousHoursArray = Helper.ReadConfigSetting("vigorousHours").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            
            // questions specific to male
            string[] cigs100MoreArray = Helper.ReadConfigSetting("cigs100More").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] smokeStartAgeArray = Helper.ReadConfigSetting("smokeStartAge").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] stillSmokeArray = Helper.ReadConfigSetting("stillSmoke").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] ageQuitArray = Helper.ReadConfigSetting("ageQuit").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] quitNumPerDayArray = Helper.ReadConfigSetting("quitNumPerDay").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);

            // questions specific to female
            string[] stillHavePeriodsArray = Helper.ReadConfigSetting("stillHavePeriods").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] lastCycleArray = Helper.ReadConfigSetting("lastCycle").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);
            string[] usedEstrogenArray = Helper.ReadConfigSetting("usedEstrogen").Split(inputDelim, StringSplitOptions.RemoveEmptyEntries);

            long counter = 0;
            string output = string.Empty;
            AbsoluteRisks results = null;

            FileLogging outFile = new FileLogging(filePath, false, false, true, true);
            outFile.DisplayMessage = false;
            outFile.WriteLine("<TestCases>");
            //gender
            foreach (string gender in genderArray)
            {
                if(gender == "Male")
                {
                    Console.WriteLine("Generating test case xml input file for Male...");
                    foreach (string height in heightArray){
                    foreach (string weight in weightArray){
                    foreach (string numServingsVeg in numServingsVegArray){
                    foreach (string amountVeg in amountVegArray){
                    foreach (string colonoscopy in colonoscopyArray){
                    foreach (string hadPolyp in hadPolypArray){
                    foreach (string asprin in asprinArray){
                    foreach (string ibuprofen in ibuprofenArray){
                    foreach (string cigs100More in cigs100MoreArray){
                    foreach (string smokeStartAge in smokeStartAgeArray){
                    foreach (string stillSmoke in stillSmokeArray){
                    foreach (string ageQuit in ageQuitArray){
                    foreach (string quitNumPerDay in quitNumPerDayArray){
                    foreach (string vigorousActivities in vigorousActivitiesArray){
                    foreach (string vigorousHours in vigorousHoursArray){
                    foreach (string hasRelativeHadCC in hasRelativeHadCCArray){
                    foreach (string numRelativesHavingCC in numRelativesHavingCCArray){
                    foreach (string currentAge in currentAgeArray){                      
                        counter++;
                        /*
                        results = CalculateRisks(
                            counter, "race", currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC
                        );                                                                                                       
                        */
                        output = string.Format("<TestCase ID=\"{0}\"><currentAge>{1}</currentAge><gender>{2}</gender><height>{3}</height><weight>{4}</weight><numServingsVeg>{5}</numServingsVeg><amountVeg>{6}</amountVeg><colonoscopy>{7}</colonoscopy><hadPolyp>{8}</hadPolyp><asprin>{9}</asprin><ibuprofen>{10}</ibuprofen><cigs100More>{11}</cigs100More><smokeStartAge>{12}</smokeStartAge><stillSmoke>{13}</stillSmoke><ageQuit>{14}</ageQuit><quitNumPerDay>{15}</quitNumPerDay><vigorousActivities>{16}</vigorousActivities><vigorousHours>{17}</vigorousHours><hasRelativeHadCC>{18}</hasRelativeHadCC><numRelativesHavingCC>{19}</numRelativesHavingCC></TestCase>"
                            , counter, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, hasRelativeHadCC, numRelativesHavingCC);
                        outFile.WriteLine(output);

                        if (maxCount != 0 && counter >= maxCount)
                            goto final;

                    }}}}}}}}}}}}}}}}}}
                }
                else if(gender == "Female")
                {
                    Console.WriteLine("Generating test case xml input file for Female...");
                    foreach (string height in heightArray) {
                    foreach (string weight in weightArray){
                    foreach (string numServingsVeg in numServingsVegArray){
                    foreach (string amountVeg in amountVegArray){
                    foreach (string colonoscopy in colonoscopyArray){
                    foreach (string hadPolyp in hadPolypArray){
                    foreach (string asprin in asprinArray){
                    foreach (string ibuprofen in ibuprofenArray){
                    foreach (string vigorousActivities in vigorousActivitiesArray){
                    foreach (string vigorousHours in vigorousHoursArray){
                    foreach (string stillHavePeriods in stillHavePeriodsArray){
                    foreach (string lastCycle in lastCycleArray){
                    foreach (string usedEstrogen in usedEstrogenArray){
                    foreach (string hasRelativeHadCC in hasRelativeHadCCArray){
                    foreach (string numRelativesHavingCC in numRelativesHavingCCArray){
                    foreach (string currentAge in currentAgeArray){
                        
                        counter++;
                        /*
                        results = CalculateRisks(counter
                            , "race", currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC
                        );
                        */
                        output = string.Format("<TestCase ID=\"{0}\"><currentAge>{1}</currentAge><gender>{2}</gender><height>{3}</height><weight>{4}</weight><numServingsVeg>{5}</numServingsVeg><amountVeg>{6}</amountVeg><colonoscopy>{7}</colonoscopy><hadPolyp>{8}</hadPolyp><asprin>{9}</asprin><ibuprofen>{10}</ibuprofen><vigorousActivities>{11}</vigorousActivities><vigorousHours>{12}</vigorousHours><stillHavePeriods>{13}</stillHavePeriods><lastCycle>{14}</lastCycle><usedEstrogen>{15}</usedEstrogen><hasRelativeHadCC>{16}</hasRelativeHadCC><numRelativesHavingCC>{17}</numRelativesHavingCC></TestCase>"
                            , counter, currentAge, gender, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC);
                        outFile.WriteLine(output);

                        if (maxCount != 0 && counter >= maxCount)
                            goto final;

                    }}}}}}}}}}}}}}}}
                }
            }          
            
            final:            
                outFile.WriteLine("</TestCases>");                
                outFile.Dispose();
        }

        private static AbsoluteRisks CalculateRisks(
              long counter
            , string race
            , string gender
            , string currentAge
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
            , string numRelativesHavingCC)
        {

            AbsoluteRisks results = null;

            results = CalculateRisks(
                counter, "race", currentAge,  gender,  height,  weight,  numServingsVeg,  amountVeg,  colonoscopy,  hadPolyp,  asprin,  ibuprofen,  cigs100More,  smokeStartAge,  stillSmoke,  ageQuit,  quitNumPerDay,  vigorousActivities,  vigorousHours,  stillHavePeriods,  lastCycle,  usedEstrogen,  hasRelativeHadCC,  numRelativesHavingCC
            );

            if (results != null)
            {
                if (gender == "Male")
                {
                    Console.WriteLine(string.Format("currentAge\theight\tweight\tnumServingsVeg\tamountVeg\tcolonoscopy\thadPolyp\tasprin\tibuprofen\tcigs100More\tsmokeStartAge\tstillSmoke\tageQuit\tquitNumPerDay\tvigorousActivities\tvigorousHours\thasRelativeHadCC\tnumRelativesHavingCC\tnumrel\tcigarets\tduration\tnoNSaids\tnoIbuprofn\tsigmod\tvegLT5\tbmiTrnd\thrsExcrise\tpatternID\t5Yr\t10Yr\t20Yr\tlife"));
                    Console.WriteLine("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\t{10}\t{11}\t{12}\t{13}\t{14}\t{15}\t{16}\t{17}\t{18}\t{19}\t{20}\t{21}\t{22}\t{23}\t{24}\t{25}\t{26}\t{27}\t{28}\t{29}\t{30}\t{31}",
                            currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.Cigarets, results.Duration, results.NoNSaids, results.NoIbuprofn, results.Sigmod, results.VegLT5, results.BmiTrnd, results.HrsExcrise, results.PatternID, results.FiveYearAbsRiskPercent, results.TenYearAbsRiskPercent, results.TwentyYearAbsRiskPercent, results.LifetimeAbsRiskPercent);
                }
                else if (gender == "Female")
                    Console.WriteLine(string.Format("currentAge\theight\tweight\tnumServingsVeg\tamountVeg\tcolonoscopy\thadPolyp\tasprin\tibuprofen\tvigorousActivities\tvigorousHours\tstillHavePeriods\tlastCycle\tusedEstrogen\thasRelativeHadCC\tnumRelativesHavingCC\tnumrel\tnoStrogen\tnoNSaids\tsigmod\tvegLT5\tbmiGe30\thrsExcrise\tpatternID\t5Yr\t10Yr\t20Yr\tlife"));
                    Console.WriteLine("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\t{10}\t{11}\t{12}\t{13}\t{14}\t{15}\t{16}\t{17}\t{18}\t{19}\t{20}\t{21}\t{22}\t{23}\t{24}\t{25}\t{26}\t{27}",
                            currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.NoStrogen, results.NoNSaids, results.Sigmod, results.VegLT5, results.BmiGe30, results.HrsExcrise, results.PatternID, results.FiveYearAbsRiskPercent, results.TenYearAbsRiskPercent, results.TwentyYearAbsRiskPercent, results.LifetimeAbsRiskPercent);
            }
            return results;


        }
    }
}
