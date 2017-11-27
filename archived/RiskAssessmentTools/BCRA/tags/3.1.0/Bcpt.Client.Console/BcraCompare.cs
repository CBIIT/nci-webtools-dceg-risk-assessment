using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.Diagnostics;
using NCI.BCPT.Engine;
using NCI.BCPT.Engine.Helper;
namespace Bcra
{
    public class BcraComparision
    {
        /// <summary>
        /// BcraTestHarness
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="usingFortranLib"></param>
        /// <param name="usingDotNetLib"></param>
        /// <param name="printDifferenceCount"></param>
        /// <param name="convertToPercentage"></param>
        /// <param name="printInputParams"></param>
        public static void BcraTestHarness(string filePath, bool usingFortranLib, bool usingDotNetLib, bool printDifferenceCount, bool convertToPercentage, bool printInputParams, Logger.FileLogging fileLog)
        {
        
            string outputFileFormat = "txt";

            switch (outputFileFormat.ToLower())
            {
                case "xml":
                    BcraTestHarnessXML(filePath, usingFortranLib, usingDotNetLib, printDifferenceCount, convertToPercentage, printInputParams);
                    break;
                case "txt":
                default:
                    BcraTestHarnessTabDelimited(filePath, usingFortranLib, usingDotNetLib, printDifferenceCount, convertToPercentage, printInputParams, fileLog);
                    break;
            }
        }

        /// <summary>
        /// BcraTestHarnessTabDelimited
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="usingFortranLib"></param>
        /// <param name="usingDotNetLib"></param>
        /// <param name="printDifferenceCount"></param>
        /// <param name="convertToPercentage"></param>
        /// <param name="printInputParams"></param>
        private static void BcraTestHarnessTabDelimited(string filePath, bool bUsingFortranLib, bool bUsingDotNetLib, bool bPrintDifferenceCount, bool bConvertToPercentage, bool bPrintInputParams, Logger.FileLogging fileLog)
        {
            //local variables
            int differenceCount = 0;
            StringBuilder sbOutput = new StringBuilder();
            int roundingDecimals = 1;
            string outputFormat = "0.000000";

            XmlDocument oXmlDoc = new XmlDocument();

            //read config settings
            outputFormat = Helper.GetConfig("OutputFormat", outputFormat);
            roundingDecimals = Convert.ToInt32(Helper.GetConfig("RoundingDecimals", roundingDecimals.ToString()));
            
            //output file
            Logger.FileLogging outFile = new Logger.FileLogging(Path.ChangeExtension(filePath, ".results.txt"), false, false, true, true);
            outFile.DisplayMessage = false;

            oXmlDoc.Load(filePath);
            XmlNodeList oNodeList = oXmlDoc.SelectNodes("BreastCancerScenarios/BreastCancerScenario");

            string CurrentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, Race;
            string ScenarioNo;
            Console.WriteLine("Processing Scenarios...");

            double AbsoluteRisk_A, AverageRisk_A, AbsoluteRisk90_A, AverageRisk90_A;
            double AbsoluteRisk_B, AverageRisk_B, AbsoluteRisk90_B, AverageRisk90_B;

            //Intiialize
            AbsoluteRisk_B = AverageRisk_B = AbsoluteRisk90_B = AverageRisk90_B = 0.0;
            AbsoluteRisk_A = AverageRisk_A = AbsoluteRisk90_A = AverageRisk90_A = 0.0;
            //outFile.WriteLine(string.Format("SNo\tCAg\tPAg\tMAg\tFAg\tEHB\t#Bi\tHyp\tFDR\tRac\tARsk_BCRA\tAvgwomen_5year"));
            outFile.WriteLine(string.Format("IDD\tCurrAge\tProjAge\tAgeMen\tAge1st\tEverBio\tNumBiop\tHypPlas\tNumRel\tRace\t5yr_AbsRisk\tAvgwomen_5yearAbsRisk\tLifetime_AbsRisk\tAvgwomen_LifetimeAbsRisk"));

            int iBlackCount = 0;
            foreach (XmlNode oNode in oNodeList)
            {
                bool bblack = false;
           
                try
                {
                    ScenarioNo = Helper.GetNodeValue(oNode, "Scenario");
                    CurrentAge = Helper.GetNodeValue(oNode, "CurrentAge");
                    ProjectionAge = Helper.GetNodeValue(oNode, "ProjectionAge");
                    ProjectionAge = Convert.ToString((Convert.ToInt32(CurrentAge) + 5));
                    MenarcheAge = Helper.GetNodeValue(oNode, "MenarcheAge");
                    FirstLiveBirthAge = Helper.GetNodeValue(oNode, "FirstLiveBirthAge");
                    EverHadBiopsy = Helper.GetNodeValue(oNode, "EverHadBiopsy");
                    NumberOfBiopsy = Helper.GetNodeValue(oNode, "NumberOfBiopsy");
                    HyperPlasia = Helper.GetNodeValue(oNode, "HyperPlasia");
                    FirstDegRelatives = Helper.GetNodeValue(oNode, "FirstDegRelatives");
                    Race = Helper.GetNodeValue(oNode, "Race");
                    
                    if (Convert.ToInt16(Race) >= 7)
                    {
                        if (FirstDegRelatives == "0" || FirstDegRelatives == "99")
                            FirstDegRelatives = "0";
                        else if (FirstDegRelatives == "1")
                            FirstDegRelatives = "1";
                        else if (Convert.ToInt16(FirstDegRelatives) >= 2 && Convert.ToInt16(FirstDegRelatives) <= 31 && Convert.ToInt16(Race) < 7)
                            FirstDegRelatives = "2";
                        else if (Convert.ToInt16(FirstDegRelatives) >= 2 && Convert.ToInt16(Race) >= 7)
                            FirstDegRelatives = "1";
                    }

                    bblack = false;

                    Console.WriteLine(string.Format("<Scenario Number=\"{0}\">", ScenarioNo));
                    if ((BcptRace)BcptConvert.GetRace(Race) == BcptRace.Black)
                    {
                        bblack = true;
                        iBlackCount++;
                    }

                    if (bPrintInputParams  )
                    {
                        sbOutput.Append(string.Format("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}", ScenarioNo, CurrentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, BcptConvert.GetRace(Race)));
                    }
                    

                    if (bUsingFortranLib)
                    {
                        //re-initialize
                        AbsoluteRisk_A = AverageRisk_A = AbsoluteRisk90_A = AverageRisk90_A = 0.0;
                        //getting risk values using fortran .net library
                        RiskCalcUsingFortran(0
                            , BcptConvert.GetCurrentAge(CurrentAge)
                            , BcptConvert.GetProjectionAge(ProjectionAge)
                            , BcptConvert.GetMenarcheAge(MenarcheAge)
                            , BcptConvert.GetFirstLiveBirthAge(FirstLiveBirthAge)
                            , BcptConvert.GetEverHadBiopsy(EverHadBiopsy)
                            , BcptConvert.GetNumberOfBiopsy(NumberOfBiopsy)
                            , BcptConvert.GetHyperPlasia(HyperPlasia)
                            , BcptConvert.GetFirstDegRelatives(FirstDegRelatives)
                            , BcptConvert.GetRace(Race)
                            , out AbsoluteRisk_A
                            , out AverageRisk_A
                            , out AbsoluteRisk90_A
                            , out AverageRisk90_A
                            );
                        //rounding the values
                        if (bConvertToPercentage)
                        {
                            AbsoluteRisk_A = Math.Round(AbsoluteRisk_A * 100, 1);
                            AverageRisk_A = Math.Round(AverageRisk_A * 100, 1);
                            AbsoluteRisk90_A = Math.Round(AbsoluteRisk90_A * 100, 1);
                            AverageRisk90_A = Math.Round(AverageRisk90_A * 100, 1);


                        }
                        else
                        {
                            AbsoluteRisk_A = Math.Round(AbsoluteRisk_A, roundingDecimals);
                            AverageRisk_A = Math.Round(AverageRisk_A, roundingDecimals);
                            AbsoluteRisk90_A = Math.Round(AbsoluteRisk90_A, roundingDecimals);
                            AverageRisk90_A = Math.Round(AverageRisk90_A, roundingDecimals);
                        }

                    }
                    if (bUsingDotNetLib)
                    {
                        //method B - using c#.net library
                        //re-initialize
                        AbsoluteRisk_B = AverageRisk_B = AbsoluteRisk90_B = AverageRisk90_B = 0.0;
                        //getting risk values using c#.net library
                        RiskCalcUsingNet(0
                            , BcptConvert.GetCurrentAge(CurrentAge)
                            , BcptConvert.GetProjectionAge(ProjectionAge)
                            , BcptConvert.GetMenarcheAge(MenarcheAge)
                            , BcptConvert.GetFirstLiveBirthAge(FirstLiveBirthAge)
                            , BcptConvert.GetEverHadBiopsy(EverHadBiopsy)
                            , BcptConvert.GetNumberOfBiopsy(NumberOfBiopsy)
                            , BcptConvert.GetHyperPlasia(HyperPlasia)
                            , BcptConvert.GetFirstDegRelatives(FirstDegRelatives)
                            , BcptConvert.GetRace(Race)
                            , out AbsoluteRisk_B
                            , out AverageRisk_B
                            , out AbsoluteRisk90_B
                            , out AverageRisk90_B
                            );
                        //rounding the values
                        if (bConvertToPercentage)
                        {
                            //AbsoluteRisk_B = Math.Round(AbsoluteRisk_B * 100, 1);
                            //AverageRisk_B = Math.Round(AverageRisk_B * 100, 1);
                            //AbsoluteRisk90_B = Math.Round(AbsoluteRisk90_B * 100, 1);
                            //AverageRisk90_B = Math.Round(AverageRisk90_B * 100, 1);

                            //No rounding
                            AbsoluteRisk_B = AbsoluteRisk_B * 100;
                            AverageRisk_B = AverageRisk_B * 100;
                            AbsoluteRisk90_B = AbsoluteRisk90_B * 100;
                            AverageRisk90_B = AverageRisk90_B * 100;


                            //writing output 
                            sbOutput.Append(String.Format("\t{0}", AbsoluteRisk_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t{0}", AverageRisk_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t\t{0}", AbsoluteRisk90_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t\t{0}", AverageRisk90_B.ToString(outputFormat)));
                        }
                        else
                        {
                            AbsoluteRisk_B = Math.Round(AbsoluteRisk_B, roundingDecimals);
                            AverageRisk_B = Math.Round(AverageRisk_B, roundingDecimals);
                            AbsoluteRisk90_B = Math.Round(AbsoluteRisk90_B, roundingDecimals);
                            AverageRisk90_B = Math.Round(AverageRisk90_B, roundingDecimals);
                            //writing output
                            sbOutput.Append(String.Format("\t{0}", AbsoluteRisk_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t{0}", AverageRisk_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t\t{0}", AbsoluteRisk90_B.ToString(outputFormat)));
                            sbOutput.Append(String.Format("\t\t{0}", AverageRisk90_B.ToString(outputFormat)));
                        }
                    }
                    if (bPrintDifferenceCount)
                    {
                        if (AbsoluteRisk_A != AbsoluteRisk_B || AverageRisk_A != AverageRisk_B
                            || AbsoluteRisk90_A != AbsoluteRisk90_B || AverageRisk90_A != AverageRisk90_B)
                        {
                            differenceCount++;
                        }
                    }
                }
                catch (Exception e)
                {
                    string sException = e.Message;
                    Console.WriteLine(String.Format("\t{0}\n{1}", e.Message, e.StackTrace));
                    sbOutput.Append(string.Format("\t<Exception>Message: {0}</Exception>", sException));
                    fileLog.WriteLine(sbOutput.ToString());
                    fileLog.WriteLine(string.Format("StackTrace:{0}", e.StackTrace));

                    continue;
                }
                finally
                {
                    //if (bblack ==true)
                        outFile.WriteLine(sbOutput.ToString());
                    sbOutput.Remove(0, sbOutput.Length);
                }                

            }
            Console.WriteLine(string.Format("Differences: {0}", differenceCount));
            outFile.WriteLine(string.Format("Differences: {0}", differenceCount));
            outFile.Dispose();
        }
      
        private static void RiskCalcUsingNet(int RiskIndex, int CurrentAge, int ProjectionAge, int MenarcheAge, int FirstLiveBirthAge, int EverHadBiopsy, int NumberOfBiopsy, int HyperPlasia, int FirstDegRelatives, int Race, out double AbsoluteRisk, out double AverageRisk, out double AbsoluteRisk90, out double AverageRisk90)
        {
            AbsoluteRisk = 0.0; AverageRisk = 0.0;
            AbsoluteRisk90 = 0.0; AverageRisk90 = 0.0;

            int AgeIndicator;
            double RHyperPlasia;

            CurrentAge = BcptConvert.GetCurrentAge(CurrentAge);
            ProjectionAge = CurrentAge + 5;
            MenarcheAge = BcptConvert.MenarcheAge(MenarcheAge);
            FirstLiveBirthAge = BcptConvert.FirstLiveBirthAge(FirstLiveBirthAge);
            EverHadBiopsy = BcptConvert.EverHadBiopsy(EverHadBiopsy);
            NumberOfBiopsy = BcptConvert.NumberOfBiopsy(NumberOfBiopsy, EverHadBiopsy);
            HyperPlasia = BcptConvert.Hyperplasia(HyperPlasia, EverHadBiopsy);
            FirstDegRelatives = BcptConvert.FirstDegRelatives(FirstDegRelatives);
            //Race

            AgeIndicator = BcptConvert.CurrentAgeIndicator(CurrentAge);
            RHyperPlasia = BcptConvert.RHyperplasia(HyperPlasia, EverHadBiopsy);

            RiskIndex = 1;  //get absolute risk
            //HACK:
            NCI.BCPT.Engine.RiskCalculator oBcpt = new NCI.BCPT.Engine.RiskCalculator();
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
            ProjectionAge = 90;
            //Age 90
            AbsoluteRisk90 = oBcpt.CalculateAbsoluteRisk(
                 CurrentAge		    //[t1]
               , ProjectionAge		//[t2]
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
            RiskIndex = 2;  //get average risk also
            AverageRisk90 = oBcpt.CalculateAeverageRisk(
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
        }
        private static void RiskCalcUsingFortran(int RiskIndex, int CurrentAge, int ProjectionAge, int MenarcheAge, int FirstLiveBirthAge, int EverHadBiopsy, int NumberOfBiopsy, int HyperPlasia, int FirstDegRelatives, int Race, out double AbsoluteRisk, out double AverageRisk, out double AbsoluteRisk90, out double AverageRisk90)
        {
            AbsoluteRisk = 0.0; AverageRisk = 0.0;
            AbsoluteRisk90 = 0.0; AverageRisk90 = 0.0;
            int AgeIndicator;

            double RHyperPlasia;
            int _CurrentAge, _ProjectionAge, _MenarcheAge, _FirstLiveBirthAge, _EverHadBiopsy, _NumberOfBiopsy, _HyperPlasia, _FirstDegRelatives, _Race;
            int _AgeIndicator;
            double _RHyperPlasia;
            CurrentAge = BcptConvert.GetCurrentAge(CurrentAge);
            ProjectionAge = CurrentAge + 5;
            MenarcheAge = BcptConvert.MenarcheAge(MenarcheAge);
            FirstLiveBirthAge = BcptConvert.FirstLiveBirthAge(FirstLiveBirthAge);
            EverHadBiopsy = BcptConvert.EverHadBiopsy(EverHadBiopsy);
            NumberOfBiopsy = BcptConvert.NumberOfBiopsy(NumberOfBiopsy, EverHadBiopsy);
            HyperPlasia = BcptConvert.Hyperplasia(HyperPlasia, EverHadBiopsy);
            FirstDegRelatives = BcptConvert.FirstDegRelatives(FirstDegRelatives);
            //Race

            AgeIndicator = BcptConvert.CurrentAgeIndicator(CurrentAge);
            RHyperPlasia = BcptConvert.RHyperplasia(HyperPlasia, EverHadBiopsy);

            //assign to local variables as some of values are being changed in the lib for avg and base line calcualtions
            _CurrentAge = CurrentAge; _ProjectionAge = ProjectionAge; _MenarcheAge = MenarcheAge; _FirstLiveBirthAge = FirstLiveBirthAge; _EverHadBiopsy = EverHadBiopsy; _NumberOfBiopsy = NumberOfBiopsy; _HyperPlasia = HyperPlasia; _FirstDegRelatives = FirstDegRelatives; _Race = Race; _AgeIndicator = AgeIndicator; _RHyperPlasia = RHyperPlasia;

            RiskIndex = 1;  //get absolute risk
            AbsoluteRisk = CalculateRisk2.CalculateRisk2(ref RiskIndex
                , ref _CurrentAge		//[t1]
                , ref _ProjectionAge	//[t2]
                , ref _AgeIndicator		//[i0]
                , ref _NumberOfBiopsy	//[i2]
                , ref _MenarcheAge		//[i1]
                , ref _FirstLiveBirthAge//[i3]
                , ref _FirstDegRelatives//[i4]
                , ref _EverHadBiopsy	//[iever]
                , ref _HyperPlasia		//[ihyp]
                , ref _RHyperPlasia		//[rhyp]
                , ref _Race				//[race]
                );
            RiskIndex = 2;  //get average risk also

            //assign to local variables as some of values are being changed in the lib for avg and base line calcualtions
            _CurrentAge = CurrentAge; _ProjectionAge = ProjectionAge; _MenarcheAge = MenarcheAge; _FirstLiveBirthAge = FirstLiveBirthAge; _EverHadBiopsy = EverHadBiopsy; _NumberOfBiopsy = NumberOfBiopsy; _HyperPlasia = HyperPlasia; _FirstDegRelatives = FirstDegRelatives; _Race = Race; _AgeIndicator = AgeIndicator; _RHyperPlasia = RHyperPlasia;

            AverageRisk = CalculateRisk2.CalculateRisk2(ref RiskIndex
                , ref _CurrentAge		//[t1]
                , ref _ProjectionAge	//[t2]
                , ref _AgeIndicator		//[i0]
                , ref _NumberOfBiopsy	//[i2]
                , ref _MenarcheAge		//[i1]
                , ref _FirstLiveBirthAge//[i3]
                , ref _FirstDegRelatives//[i4]
                , ref _EverHadBiopsy	//[iever]
                , ref _HyperPlasia		//[ihyp]
                , ref _RHyperPlasia		//[rhyp]
                , ref _Race				//[race]
                );

            //Age 90
            ProjectionAge = 90;
            RiskIndex = 1;  //get absolute risk

            //assign to local variables as some of values are being changed in the lib for avg and base line calcualtions
            _CurrentAge = CurrentAge; _ProjectionAge = ProjectionAge; _MenarcheAge = MenarcheAge; _FirstLiveBirthAge = FirstLiveBirthAge; _EverHadBiopsy = EverHadBiopsy; _NumberOfBiopsy = NumberOfBiopsy; _HyperPlasia = HyperPlasia; _FirstDegRelatives = FirstDegRelatives; _Race = Race; _AgeIndicator = AgeIndicator; _RHyperPlasia = RHyperPlasia;

            AbsoluteRisk90 = CalculateRisk2.CalculateRisk2(ref RiskIndex
                , ref _CurrentAge		//[t1]
                , ref _ProjectionAge	//[t2]
                , ref _AgeIndicator		//[i0]
                , ref _NumberOfBiopsy	//[i2]
                , ref _MenarcheAge		//[i1]
                , ref _FirstLiveBirthAge//[i3]
                , ref _FirstDegRelatives//[i4]
                , ref _EverHadBiopsy	//[iever]
                , ref _HyperPlasia		//[ihyp]
                , ref _RHyperPlasia		//[rhyp]
                , ref _Race				//[race]
                );
            RiskIndex = 2;  //get average risk also

            //assign to local variables as some of values are being changed in the lib for avg and base line calcualtions
            _CurrentAge = CurrentAge; _ProjectionAge = ProjectionAge; _MenarcheAge = MenarcheAge; _FirstLiveBirthAge = FirstLiveBirthAge; _EverHadBiopsy = EverHadBiopsy; _NumberOfBiopsy = NumberOfBiopsy; _HyperPlasia = HyperPlasia; _FirstDegRelatives = FirstDegRelatives; _Race = Race; _AgeIndicator = AgeIndicator; _RHyperPlasia = RHyperPlasia;

            AverageRisk90 = CalculateRisk2.CalculateRisk2(ref RiskIndex
                , ref _CurrentAge		//[t1]
                , ref _ProjectionAge	//[t2]
                , ref _AgeIndicator		//[i0]
                , ref _NumberOfBiopsy	//[i2]
                , ref _MenarcheAge		//[i1]
                , ref _FirstLiveBirthAge//[i3]
                , ref _FirstDegRelatives//[i4]
                , ref _EverHadBiopsy	//[iever]
                , ref _HyperPlasia		//[ihyp]
                , ref _RHyperPlasia		//[rhyp]
                , ref _Race				//[race]
                );
        }

        /// <summary>
        /// BcraTestHarnessXML
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="bUsingFortranLib"></param>
        /// <param name="bUsingDotNetLib"></param>
        /// <param name="bPrintDifferenceCount"></param>
        /// <param name="bConvertToPercentage"></param>
        /// <param name="bPrintInputParams"></param>
        public static void BcraTestHarnessXML(string filePath, bool bUsingFortranLib, bool bUsingDotNetLib, bool bPrintDifferenceCount, bool bConvertToPercentage, bool bPrintInputParams)
        {
            XmlDocument oXmlDoc = new XmlDocument();
            int differenceCount = 0;
            //output file
            Logger.FileLogging oOutFile = new Logger.FileLogging(Path.ChangeExtension(filePath, ".out.xml"), false, false, true, true);
            oOutFile.DisplayMessage = false;

            oXmlDoc.Load(filePath);
            XmlNodeList oNodeList = oXmlDoc.SelectNodes("BreastCancerScenarios/BreastCancerScenario");
            oOutFile.WriteLine(string.Format("<BctpScenarios InputFile=\"{0}\">", Path.GetFileName(filePath)));


            string CurrentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, Race;
            string ScenarioNo;
            Console.WriteLine("Processing Scenarios...");

            double AbsoluteRisk_A, AverageRisk_A, AbsoluteRisk90_A, AverageRisk90_A;
            double AbsoluteRisk_B, AverageRisk_B, AbsoluteRisk90_B, AverageRisk90_B;

            //Intiialize
            AbsoluteRisk_B = AverageRisk_B = AbsoluteRisk90_B = AverageRisk90_B = 0.0;
            AbsoluteRisk_A = AverageRisk_A = AbsoluteRisk90_A = AverageRisk90_A = 0.0;



            foreach (XmlNode oNode in oNodeList)
            {


                try
                {
                    ScenarioNo = Helper.GetNodeValue(oNode, "Scenario");
                    CurrentAge = Helper.GetNodeValue(oNode, "CurrentAge");
                    ProjectionAge = Helper.GetNodeValue(oNode, "ProjectionAge");

                    MenarcheAge = Helper.GetNodeValue(oNode, "MenarcheAge");
                    FirstLiveBirthAge = Helper.GetNodeValue(oNode, "FirstLiveBirthAge");
                    EverHadBiopsy = Helper.GetNodeValue(oNode, "EverHadBiopsy");
                    NumberOfBiopsy = Helper.GetNodeValue(oNode, "NumberOfBiopsy");
                    HyperPlasia = Helper.GetNodeValue(oNode, "HyperPlasia");
                    FirstDegRelatives = Helper.GetNodeValue(oNode, "FirstDegRelatives");
                    Race = Helper.GetNodeValue(oNode, "Race");



                    Console.WriteLine(string.Format("<Scenario Number=\"{0}\">", ScenarioNo));






                    if (bPrintInputParams)
                    {
                        oOutFile.WriteLine(string.Format("<Scenario Num=\"{0}\" CurAge=\"{1}\" ProjAge=\"{2}\" MenAge=\"{3}\" FLBAge=\"{4}\" EHBiopsy=\"{5}\" NumBiopsy=\"{6}\" Hyper=\"{7}\" FDRel=\"{8}\" Race=\"{9}\">", ScenarioNo, CurrentAge, ProjectionAge, MenarcheAge, FirstLiveBirthAge, EverHadBiopsy, NumberOfBiopsy, HyperPlasia, FirstDegRelatives, Race));

                    }


                    if (bUsingFortranLib)
                    {
                        //re-initialize
                        AbsoluteRisk_A = AverageRisk_A = AbsoluteRisk90_A = AverageRisk90_A = 0.0;
                        //getting risk values using fortran .net library
                        RiskCalcUsingFortran(0
                            , BcptConvert.GetCurrentAge(CurrentAge)
                            , BcptConvert.GetProjectionAge(ProjectionAge)
                            , BcptConvert.GetMenarcheAge(MenarcheAge)
                            , BcptConvert.GetFirstLiveBirthAge(FirstLiveBirthAge)
                            , BcptConvert.GetEverHadBiopsy(EverHadBiopsy)
                            , BcptConvert.GetNumberOfBiopsy(NumberOfBiopsy)
                            , BcptConvert.GetHyperPlasia(HyperPlasia)
                            , BcptConvert.GetFirstDegRelatives(FirstDegRelatives)
                            , BcptConvert.GetRace(Race)
                            , out AbsoluteRisk_A
                            , out AverageRisk_A
                            , out AbsoluteRisk90_A
                            , out AverageRisk90_A
                            );
                        //rounding the values
                        if (bConvertToPercentage)
                        {
                            AbsoluteRisk_A = Math.Round(AbsoluteRisk_A * 100, 1);
                            AverageRisk_A = Math.Round(AverageRisk_A * 100, 1);
                            AbsoluteRisk90_A = Math.Round(AbsoluteRisk90_A * 100, 1);
                            AverageRisk90_A = Math.Round(AverageRisk90_A * 100, 1);
                            //writing output to the file
                            oOutFile.WriteLine(String.Format("\t<Result.Fortran AbsRisk=\"{0}\" AvgRisk=\"{1}\" AbsRisk_90=\"{2}\" AvgRisk_90=\"{3}\" />", AbsoluteRisk_A + "%", AverageRisk_A + "%", AbsoluteRisk90_A + "%", AverageRisk90_A + "%"));




                        }
                        else
                        {
                            AbsoluteRisk_A = Math.Round(AbsoluteRisk_A, 4);
                            AverageRisk_A = Math.Round(AverageRisk_A, 4);
                            AbsoluteRisk90_A = Math.Round(AbsoluteRisk90_A, 4);
                            AverageRisk90_A = Math.Round(AverageRisk90_A, 4);
                            //writing output to the file
                            oOutFile.WriteLine(String.Format("\t<Result.Fortran AbsRisk=\"{0}\" AvgRisk=\"{1}\" AbsRisk_90=\"{2}\" AvgRisk_90=\"{3}\" />", AbsoluteRisk_A, AverageRisk_A, AbsoluteRisk90_A, AverageRisk90_A));

                            //oOutFile.WriteLine(String.Format("{0}\t {1}", AbsoluteRisk_A, AbsoluteRisk90_A));
                        }

                    }
                    if (bUsingDotNetLib)
                    {
                        //method B - using c#.net library
                        //re-initialize
                        AbsoluteRisk_B = AverageRisk_B = AbsoluteRisk90_B = AverageRisk90_B = 0.0;
                        //getting risk values using c#.net library
                        RiskCalcUsingNet(0
                            , BcptConvert.GetCurrentAge(CurrentAge)
                            , BcptConvert.GetProjectionAge(ProjectionAge)
                            , BcptConvert.GetMenarcheAge(MenarcheAge)
                            , BcptConvert.GetFirstLiveBirthAge(FirstLiveBirthAge)
                            , BcptConvert.GetEverHadBiopsy(EverHadBiopsy)
                            , BcptConvert.GetNumberOfBiopsy(NumberOfBiopsy)
                            , BcptConvert.GetHyperPlasia(HyperPlasia)
                            , BcptConvert.GetFirstDegRelatives(FirstDegRelatives)
                            , BcptConvert.GetRace(Race)
                            , out AbsoluteRisk_B
                            , out AverageRisk_B
                            , out AbsoluteRisk90_B
                            , out AverageRisk90_B
                            );
                        //rounding the values
                        if (bConvertToPercentage)
                        {
                            AbsoluteRisk_B = Math.Round(AbsoluteRisk_B * 100, 1);
                            AverageRisk_B = Math.Round(AverageRisk_B * 100, 1);
                            AbsoluteRisk90_B = Math.Round(AbsoluteRisk90_B * 100, 1);
                            AverageRisk90_B = Math.Round(AverageRisk90_B * 100, 1);
                            //writing output to the file
                            oOutFile.WriteLine(String.Format("\t<Result.Net AbsRisk=\"{0}\" AvgRisk=\"{1}\" AbsRisk_90=\"{2}\" AvgRisk_90=\"{3}\" />", AbsoluteRisk_B + "%", AverageRisk_B + "%", AbsoluteRisk90_B + "%", AverageRisk90_B + "%"));




                        }
                        else
                        {
                            AbsoluteRisk_B = Math.Round(AbsoluteRisk_B, 4);
                            AverageRisk_B = Math.Round(AverageRisk_B, 4);
                            AbsoluteRisk90_B = Math.Round(AbsoluteRisk90_B, 4);
                            AverageRisk90_B = Math.Round(AverageRisk90_B, 4);
                            //writing output to the file
                            oOutFile.WriteLine(String.Format("\t<Result.Net AbsRisk=\"{0}\" AvgRisk=\"{1}\" AbsRisk_90=\"{2}\" AvgRisk_90=\"{3}\" />", AbsoluteRisk_B, AverageRisk_B, AbsoluteRisk90_B, AverageRisk90_B));



                        }
                    }
                    if (bPrintDifferenceCount)
                    {
                        if (AbsoluteRisk_A != AbsoluteRisk_B || AverageRisk_A != AverageRisk_B
                            || AbsoluteRisk90_A != AbsoluteRisk90_B || AverageRisk90_A != AverageRisk90_B)
                        {
                            differenceCount++;
                            oOutFile.WriteLine(string.Format("\t<Status>!!!!!!!!!!!{0}!!!!!!!!</Status>", "Different"));


                        }
                        else
                        {
                            oOutFile.WriteLine(string.Format("\t<Status>-------{0}---------</Status>", "Same"));

                        }
                    }
                    if (bPrintInputParams)
                    {
                        oOutFile.WriteLine(string.Format("</Scenario>"));

                    }

                }
                catch (Exception e)
                {
                    string sException = e.Message;
                    Console.WriteLine(String.Format("{0}\n{1}", e.Message, e.StackTrace));
                    oOutFile.WriteLine(string.Format("</Results>"));
                    oOutFile.WriteLine(string.Format("<Exception>{0}</Exception>", sException));


                    //Debugger.Break();
                    continue;
                }
                finally
                {
                    //oOutFile.WriteLine(string.Format("</Scenario>"));




                }

            }
            oOutFile.WriteLine(string.Format("<Differences>{0}</Differences>", differenceCount));
            oOutFile.WriteLine(string.Format("</BctpScenarios>"));

            oOutFile.Dispose();
        }
    }
}
