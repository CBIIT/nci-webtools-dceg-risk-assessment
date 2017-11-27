using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;

using Common.Utils;
using Common.Utils.Logger;

namespace CCRAT.ConsoleApp.XmlParser
{
    class CCRATXmlParser
    {
        private string _inFile = string.Empty;
        private string _outFile = string.Empty;
        private string _inputColumnSeperator = "\t,  ";
        private const string UNANSWERED = "NAN";

        private FileLogging _fileLog = null;

        public CCRATXmlParser(string inFilePath, string outFilePath)
        {
            _inFile = inFilePath;
            _outFile = outFilePath;
        }
        public CCRATXmlParser(string inFilePath, string outFilePath, string inputColumnSeperator, FileLogging fileLog)
        {
            _inFile = inFilePath;
            _outFile = outFilePath;
            _inputColumnSeperator = inputColumnSeperator;
            if (fileLog == null)
                _fileLog = new FileLogging(Helper.ReadConfigSetting("LogFile", "BCRA.log"), true, true, true, true);
            else
                _fileLog = fileLog;

        }
       
        public static void ParseCCRATXml(string filePath, string gender, bool printInputParams, string delim, bool usePercentage, int decimals)
        {
            XmlDocument oXmlDoc = new XmlDocument();
            
            int recordsSucceeded = 0;
            int recordsFailed = 0;

            //output file            
            string outFilePath = Path.ChangeExtension(filePath, ".out.txt");
            FileLogging outFile = new FileLogging(outFilePath, false, false, true, true);
            outFile.DisplayMessage = false;

            oXmlDoc.Load(filePath);
            XmlNodeList oNodeList = oXmlDoc.SelectNodes("TestCases/TestCase");
            //outFile.WriteLine(string.Format("<TestCases InputFile=\"{0}\">", Path.GetFileName(filePath)));

            string race = UNANSWERED
                //, gender = UNANSWERED
                , currentAge = UNANSWERED
                , height = UNANSWERED
                , weight = UNANSWERED
                , numServingsVeg = UNANSWERED
                , amountVeg = UNANSWERED
                , colonoscopy = UNANSWERED
                , hadPolyp = UNANSWERED
                , asprin = UNANSWERED
                , ibuprofen = UNANSWERED
                , cigs100More = UNANSWERED
                , smokeStartAge = UNANSWERED
                , stillSmoke = UNANSWERED
                , ageQuit = UNANSWERED
                , quitNumPerDay = UNANSWERED
                , vigorousActivities = UNANSWERED
                , vigorousHours = UNANSWERED
                , stillHavePeriods = UNANSWERED
                , lastCycle = UNANSWERED
                , usedEstrogen = UNANSWERED
                , hasRelativeHadCC = UNANSWERED
                , numRelativesHavingCC = UNANSWERED;

            
            string testCase = string.Empty;

            Console.WriteLine("Processing Test case file: {0}", filePath);

            if (gender == "Male")
            {
                if (printInputParams)
                    outFile.WriteLine(string.Format("Age{0}h(in){0}w(lb){0}numSrvngs{0}amountVeg{0}colonoscopy{0}hadPolyp{0}asprin{0}ibuprofen{0}cigs100More{0}smokeStartAge{0}stillSmoke{0}ageQuit{0}quitNumPerDay{0}vigorousActivities{0}vigorousHours{0}hasRelativeHadCC{0}numRelativesHavingCC{0}numrel{0}cigarets{0}duration{0}noNSaids{0}noIbuprofn{0}sigmod{0}vegLT5{0}bmiTrnd{0}hrsExcrise{0}patternID{0}5Yr{0}10Yr{0}20Yr{0}life", delim));
            }
            else if (gender == "Female")
            {
                if (printInputParams)
                    outFile.WriteLine(string.Format("Age{0}h(in){0}w(lb){0}numSrvngs{0}amountVeg{0}colonoscopy{0}hadPolyp{0}asprin{0}ibuprofen{0}vigorousActivities{0}vigorousHours{0}stillHavePeriods{0}lastCycle{0}usedEstrogen{0}hasRelativeHadCC{0}numRelativesHavingCC{0}numrel{0}noStrogen{0}noNSaids{0}sigmod{0}vegLT5{0}bmiGe30{0}hrsExcrise{0}patternID{0}5Yr{0}10Yr{0}20Yr{0}life", delim));
            }
            else
                throw new Exception("unknown answer to question gender");

            foreach (XmlNode oNode in oNodeList)
            {
                try
                {
                    testCase = Helper.GetAttributeValue(oNode, "ID", "0");

                    currentAge = Helper.GetNodeValue(oNode, "currentAge");
                    gender = Helper.GetNodeValue(oNode, "gender");
                    height = Helper.GetNodeValue(oNode, "height");
                    //height = ConvertFeetToInches(Helper.GetNodeValue(oNode, "height")).ToString();

                    weight = Helper.GetNodeValue(oNode, "weight");
                    numServingsVeg = Helper.GetNodeValue(oNode, "numServingsVeg");
                    amountVeg = Helper.GetNodeValue(oNode, "amountVeg");
                    colonoscopy = Helper.GetNodeValue(oNode, "colonoscopy");
                    hadPolyp = Helper.GetNodeValue(oNode, "hadPolyp");
                    asprin = Helper.GetNodeValue(oNode, "asprin");
                    ibuprofen = Helper.GetNodeValue(oNode, "ibuprofen");

                    vigorousActivities = Helper.GetNodeValue(oNode, "vigorousActivities");
                    vigorousHours = Helper.GetNodeValue(oNode, "vigorousHours");

                    hasRelativeHadCC = Helper.GetNodeValue(oNode, "hasRelativeHadCC");
                    numRelativesHavingCC = Helper.GetNodeValue(oNode, "numRelativesHavingCC");

                    if (gender == "Male")
                    {
                        cigs100More = Helper.GetNodeValue(oNode, "cigs100More");
                        smokeStartAge = Helper.GetNodeValue(oNode, "smokeStartAge");
                        stillSmoke = Helper.GetNodeValue(oNode, "stillSmoke");
                        ageQuit = Helper.GetNodeValue(oNode, "ageQuit");
                        quitNumPerDay = Helper.GetNodeValue(oNode, "quitNumPerDay");
                    }
                    else if (gender == "Female")
                    {
                        stillHavePeriods = Helper.GetNodeValue(oNode, "stillHavePeriods");
                        lastCycle = Helper.GetNodeValue(oNode, "lastCycle");
                        usedEstrogen = Helper.GetNodeValue(oNode, "usedEstrogen");
                    }
                                         
                    CCRAT.RiskCalculator.AbsoluteRisks results = null;
                    results = CCRAT.RiskCalculator.Manager.CalculateRisks(
                        race
                        , currentAge
                        , gender
                        , height
                        , weight
                        , numServingsVeg
                        , amountVeg
                        , colonoscopy
                        , hadPolyp
                        , asprin
                        , ibuprofen
                        , cigs100More
                        , smokeStartAge
                        , stillSmoke
                        , ageQuit
                        , quitNumPerDay
                        , vigorousActivities
                        , vigorousHours
                        , stillHavePeriods
                        , lastCycle
                        , usedEstrogen
                        , hasRelativeHadCC
                        , numRelativesHavingCC
                        );

                    if (results != null)
                    {
                        results.NumDecimalPlaces = decimals;
                        if (results.Is5YrRiskValid == false)
                            recordsFailed++;
                        else
                            recordsSucceeded++;

                        string r = string.Empty;
                        string f = string.Empty;
                        if (gender == "Male")
                        {
                            f = "{1}{0}{2}{0}{3}{0}{4}{0}{5}{0}{6}{0}{7}{0}{8}{0}{9}{0}{10}{0}{11}{0}{12}{0}{13}{0}{14}{0}{15}{0}{16}{0}{17}{0}{18}{0}{19}{0}{20}{0}{21}{0}{22}{0}{23}{0}{24}{0}{25}{0}{26}{0}{27}{0}{28}{0}{29}{0}{30}{0}{31}{0}{32}";
                            if(usePercentage)
                                r = string.Format(f, delim, currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.Cigarets, results.Duration, results.NoNSaids, results.NoIbuprofn, results.Sigmod, results.VegLT5, results.BmiTrnd, results.HrsExcrise, results.PatternID, results.FiveYearAbsRiskPercent, results.TenYearAbsRiskPercent, results.TwentyYearAbsRiskPercent, results.LifetimeAbsRiskPercent);
                            else
                                r = string.Format(f, delim, currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, cigs100More, smokeStartAge, stillSmoke, ageQuit, quitNumPerDay, vigorousActivities, vigorousHours, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.Cigarets, results.Duration, results.NoNSaids, results.NoIbuprofn, results.Sigmod, results.VegLT5, results.BmiTrnd, results.HrsExcrise, results.PatternID, results.FiveYearAbsRisk, results.TenYearAbsRisk, results.TwentyYearAbsRisk, results.LifetimeAbsRisk);
                        }
                        else
                        {
                            f = "{1}{0}{2}{0}{3}{0}{4}{0}{5}{0}{6}{0}{7}{0}{8}{0}{9}{0}{10}{0}{11}{0}{12}{0}{13}{0}{14}{0}{15}{0}{16}{0}{17}{0}{18}{0}{19}{0}{20}{0}{21}{0}{22}{0}{23}{0}{24}{0}{25}{0}{26}{0}{27}{0}{28}";
                            if(usePercentage)
                                r = string.Format(f, delim, currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.NoStrogen, results.NoNSaids, results.Sigmod, results.VegLT5, results.BmiGe30, results.HrsExcrise, results.PatternID, results.FiveYearAbsRiskPercent, results.TenYearAbsRiskPercent, results.TwentyYearAbsRiskPercent, results.LifetimeAbsRiskPercent);
                            else
                                r = string.Format(f, delim, currentAge, height, weight, numServingsVeg, amountVeg, colonoscopy, hadPolyp, asprin, ibuprofen, vigorousActivities, vigorousHours, stillHavePeriods, lastCycle, usedEstrogen, hasRelativeHadCC, numRelativesHavingCC, results.Numrel, results.NoStrogen, results.NoNSaids, results.Sigmod, results.VegLT5, results.BmiGe30, results.HrsExcrise, results.PatternID, results.FiveYearAbsRiskPercent, results.TenYearAbsRisk, results.TwentyYearAbsRisk, results.LifetimeAbsRisk);

                        }

                        outFile.WriteLine(r);
                    }
                    else
                        recordsFailed++;

                }

                catch (Exception e)
                {
                    recordsFailed++;
                    string r = string.Format("TC:{0} Age:{1} Gender:{2} <Exception>{3}</Exception>", testCase, currentAge, gender, e.Message);
                    Console.WriteLine(r);
                    outFile.WriteLine(r);
                    continue;
                }             
            }

            string s = string.Format("OutFilePath:{0}\n#records succeeded:{1} #failed:{2}", outFilePath, recordsSucceeded, recordsFailed);
            Console.WriteLine(s);
            outFile.WriteLine(s);
            //outFile.WriteLine(string.Format("</TestCases>"));
            outFile.Dispose();
        }


        public static string ConvertFeetInchesToInches(string feetInches)
        {

            string[] feeta = feetInches.Split('.');
            string inches = string.Empty;
            if (feeta.Length == 2)
                inches = (int.Parse(feeta[0]) * 12 + int.Parse(feeta[1])).ToString();
            else
                inches = (int.Parse(feeta[0]) * 12).ToString();
            return inches;

        }

        public static float ConvertFeetToInches(string feet)
        {
          return float.Parse(feet) * 12 ;
        }
    }
}

