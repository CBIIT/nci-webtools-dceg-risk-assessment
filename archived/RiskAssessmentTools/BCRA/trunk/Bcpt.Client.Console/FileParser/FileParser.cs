using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using Common.Utils;
namespace Bcpt.Client
{
    public class FileParser
    {
        private string _inFile = string.Empty;
        private string _outFile = string.Empty;
        private string _inputColumnSeperator = "\t,  ";
        private int _numberColumnsIncluded = 10; //number of columns in the input file
        private string _xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><BreastCancerScenarios xmlns:od=\"urn:schemas-microsoft-com:officedata\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"  xsi:noNamespaceSchemaLocation=\"BreastCancerScenarios.xsd\" generated=\"2006-03-22T10:20:41\">";
        private string _xmlFooter = "</BreastCancerScenarios>";
        private Logger.FileLogging _fileLog = null;

        public FileParser(string inFilePath, string outFilePath)
        {
            _inFile = inFilePath;
            _outFile = outFilePath;
        }
        public FileParser(string inFilePath, string outFilePath, string inputColumnSeperator, Logger.FileLogging fileLog)
        {
            _inFile = inFilePath;
            _outFile = outFilePath;
            _inputColumnSeperator = inputColumnSeperator;
            if (fileLog == null)
                _fileLog = new Logger.FileLogging(Helper.ReadConfigSetting("LogFile", "BCRA.log"), true, true, true, true);
            else
                _fileLog = fileLog;

        }

        public void Parse()
        {
            bool recordNumberIncluded = false;
            string line = string.Empty;
            long recordNumber = 0;
            long recordFailed = 0;
            _numberColumnsIncluded = Convert.ToInt16(Helper.ReadConfigSetting("NumberColumnsIncluded", _numberColumnsIncluded.ToString()));
            string xmlColumns =
                "<BreastCancerScenario>"
                   + "<Scenario>{0}</Scenario>"
                   + "<CurrentAge>{1}</CurrentAge>"
                   + "<ProjectionAge>{2}</ProjectionAge>"
                   + "<MenarcheAge>{3}</MenarcheAge>"
                   + "<FirstLiveBirthAge>{4}</FirstLiveBirthAge>"
                   + "<EverHadBiopsy>{5}</EverHadBiopsy>"
                   + "<NumberOfBiopsy>{6}</NumberOfBiopsy>"
                   + "<HyperPlasia>{7}</HyperPlasia>"
                   + "<FirstDegRelatives>{8}</FirstDegRelatives>"
                   + "<Race>{9}</Race>"
                + "</BreastCancerScenario>";

            //check input file
            if (!File.Exists(_inFile))
            {
                throw new Exception(string.Format("File not found in specified directory. File path:{0}", _inFile));
            }
            //check output file path
            if (!Directory.Exists(Path.GetDirectoryName(_outFile)))
            {
                Directory.CreateDirectory(Path.GetDirectoryName(_outFile));
            }

            using (StreamReader reader = new StreamReader(_inFile))
            {
                using (StreamWriter writer = new StreamWriter(_outFile, false))
                {
                    writer.AutoFlush = true;
                    try
                    {
                        _fileLog.WriteLine("BOF Text File Parser");
                        //read the xml format from config file
                        xmlColumns = Helper.ReadConfigSetting("XmlColumns", xmlColumns);

                        _fileLog.DisplayMessage = true;
                        recordNumberIncluded = Convert.ToBoolean(Helper.ReadConfigSetting("RecordNumberIncluded", recordNumberIncluded.ToString()));

                        string[] seperator = _inputColumnSeperator.Split(',');


                        writer.WriteLine(_xmlHeader);
                        while ((line = reader.ReadLine()) != null)
                        {
                            recordNumber++;
                            //string[] fields = line.Split(seperator, StringSplitOptions.RemoveEmptyEntries);
                            string[] fields = line.Split(new char[] { '\t' });

                            //string[] fields = line.Split(seperator, StringSplitOptions.RemoveEmptyEntries);
                            //string[] fields = line.Split(@"\t");
                            //Split(@"\t");


                            //check if the first column is record/sequence number
                            if (recordNumberIncluded == false && fields.Length == _numberColumnsIncluded)
                            {
                                writer.WriteLine(xmlColumns, recordNumber, fields[0].Trim(), fields[1].Trim(), fields[2].Trim(), fields[3].Trim(), fields[4].Trim(), fields[5].Trim(), fields[6].Trim(), fields[7].Trim(), fields[8].Trim());
                            }
                            else if (fields.Length == _numberColumnsIncluded)
                            {
                                writer.WriteLine(xmlColumns, fields[0].Trim(), fields[1].Trim(), fields[2].Trim(), fields[3].Trim(), fields[4].Trim(), fields[5].Trim(), fields[6].Trim(), fields[7].Trim(), fields[8].Trim(), fields[9].Trim());
                            }
                            else
                            {
                                _fileLog.WriteLine(string.Format("Invalid record or format does not match. Record: {0}", line));
                                recordFailed++;
                            }
                        }
                        writer.WriteLine(_xmlFooter);
                        writer.Flush();
                        writer.Close();
                    }
                    catch (Exception ex)
                    {
                        _fileLog.WriteLine(ex);
                    }
                    finally
                    {
                        _fileLog.WriteLine(string.Format("Total records: {0}", recordNumber));
                        _fileLog.WriteLine(string.Format("Succeeded records: {0}", recordNumber - recordFailed));
                        _fileLog.WriteLine(string.Format("Failed records: {0}", recordFailed));
                        _fileLog.WriteLine("EOF Text File Parser");
                        
                    }
                }
            }
        }
    }
}
