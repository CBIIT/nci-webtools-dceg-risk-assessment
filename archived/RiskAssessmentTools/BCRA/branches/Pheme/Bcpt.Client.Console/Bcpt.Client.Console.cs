/**************************************************************************************************
* Name		: Bcpt.Client.Console.cs
* Purpose	: BCRA Test Harness Console Application which can use text or xml as input files.
* Author	: SRamaiah
* Date		: 03/23/2006
* Changes	: Dec 2007 SR: Added text file parser
**************************************************************************************************/
using System;
using System.Xml;
using System.Data;
using System.IO;
using System.Diagnostics;
using NCI.BCPT.Engine;
using NCI.BCPT.Engine.Helper;
using Bcra;
namespace Bcpt.Client
{
    /// <summary>
    /// Summary description for BCPTClient.
    /// </summary>
    class BcptClientConsole
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            Logger.FileLogging fileLog  = null;

            try
            {
                string filePath = Helper.GetConfig("BcptScenariFile");
                bool bUsingFortranLib = Convert.ToBoolean(Helper.GetConfig("UsingFortranLib"));
                bool bUsingDotNetLib = Convert.ToBoolean(Helper.GetConfig("UsingDotNetLib"));
                bool bPrintDifferenceCount = Convert.ToBoolean(Helper.GetConfig("differenceCount"));
                bool bConvertToPercentage = Convert.ToBoolean(Helper.GetConfig("ConvertToPercentage"));
                bool bPrintInputParams = Convert.ToBoolean(Helper.GetConfig("PrintInputParams"));
                bool needsConversion = Convert.ToBoolean(Helper.GetConfig("NeedsToBeconverted", "false"));
                fileLog = new Logger.FileLogging(Helper.GetConfig("LogFile", "BCRA.log"), true, true, true, true);
                fileLog.WriteLine("======================================================================================");
                string inputColumnSeperator = "\t,  ";
                //convert to xml format first
                if (needsConversion)
                {
                    string xmlInputFile = Path.ChangeExtension(filePath, ".xml");
                    inputColumnSeperator = Helper.GetConfig("InputColumnSeperator", inputColumnSeperator);
                    FileParser parser = new FileParser(filePath, xmlInputFile, inputColumnSeperator, fileLog);
                    parser.Parse();                    
                    filePath = xmlInputFile;
                }
                BcraComparision.BcraTestHarness(filePath, bUsingFortranLib, bUsingDotNetLib, bPrintDifferenceCount, bConvertToPercentage, bPrintInputParams, fileLog);
                fileLog.WriteLine("======================================================================================");
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("{0}\n{1}", e.Message, e.StackTrace));
                Console.Read();
            }
            finally
            {
                fileLog.Dispose();
            }
        }
    }
}
