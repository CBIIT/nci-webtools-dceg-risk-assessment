/**************************************************************************************************
* Name		: Logger.cs
* Purpose	: Logger.cs
* Author	: SRamaiah
* Date		: 03/23/2006
* Changes	:
**************************************************************************************************/
using System;
using System.Diagnostics;
using System.Text;
using System.Xml;
using System.IO;
namespace Common.Utils.Logger
{
    /// <summary>
    /// Implements File logger class.
    /// </summary>
    public class FileLogging : IDisposable
    {

        #region Public Members

        /// <summary>
        /// writes the message to the file
        /// </summary>
        /// <param name="message">message</param>
        public void Write(string message)
        {
            Write(message, EventLogEntryType.Information);
        }

        /// <summary>
        /// writes the message to the file
        /// </summary>
        /// <param name="message">message</param>
        /// <param name="entryType">Log Entry Type</param>
        public void Write(string message, EventLogEntryType entryType)
        {
            if (DisplayMessage)
            {
                System.Console.WriteLine(message);
            }
            if (_enableLog == true)
            {
                if (entryType == EventLogEntryType.Error)
                {
                    if (_includeDateTime == true)
                        _swLogFile.Write(string.Format("{0} Error: {1}", DateTime.Now.ToString(), message));
                    else
                        _swLogFile.Write(string.Format("{0} Error: {1}", "", message));

                }
                else
                {
                    if (_includeDateTime == true)
                        _swLogFile.Write(string.Format("{0} Info : {1}", DateTime.Now.ToString(), message));
                    else
                        _swLogFile.Write(string.Format("{0}", message));
                }
            }
        }

        /// <summary>
        /// WriteLine
        /// </summary>
        /// <param name="message">message to be written</param>
        public void WriteLine(string message)
        {
            this.WriteLine(message, EventLogEntryType.Information);
        }

        public void WriteLine(Exception e)
        {
            this.WriteLine(e, EventLogEntryType.Error);
        }

        public void WriteLine(Exception e, EventLogEntryType entryType)
        {
            this.WriteLine(string.Format("Error Type:{0}\n\tMessage: {1}\n\tStackTrace: {2}", e.GetType().ToString(), e.Message, e.StackTrace), entryType);
        }

        /// <summary>
        /// WriteLine
        /// </summary>
        /// <param name="message">message to be written</param>
        /// <param name="entryType">Event Log Entry Type - Info, Erro, etc.</param>
        public void WriteLine(string message, EventLogEntryType entryType)
        {
            if (_enableLog == true)
            {
                if (_includeDateTime == false)
                {
                    message = string.Format("{0}", message);
                }
                else
                {
                    message = string.Format("{0} {1}: {2}", DateTime.Now.ToString(), entryType.ToString(), message);
                }
            }
            if (DisplayMessage)
                Console.WriteLine(message);
            _swLogFile.WriteLine(message);
        }

        /// <summary>
        /// FileLogging
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="append"></param>
        /// <param name="includeDateTimeAndEntryType"></param>
        /// <param name="enable"></param>
        /// <param name="autoFlush"></param>
        public FileLogging(string filePath, bool append, bool includeDateTimeAndEntryType, bool enable, bool autoFlush)
        {
            _enableLog = enable;
            _includeDateTime = includeDateTimeAndEntryType;
            Open(filePath, append, autoFlush);
        }

        /// <summary>
        /// DisplayMessage
        /// </summary>
        public bool DisplayMessage = true;

        /// <summary>
        /// Enable/Disables log
        /// </summary>
        public bool Enable
        {
            get { return _enableLog; }
            set { _enableLog = value; }
        }

        /// <summary>
        /// closes log file
        /// </summary>
        public void Dispose()
        {
            if (false == _disposed && true == _enableLog && null != _swLogFile)
            {
                _swLogFile.Close();
                GC.SuppressFinalize(this);
                _disposed = true;
            }
        }

        #endregion Public Members

        #region Private Members

        private bool _enableLog, _includeDateTime, _disposed;
        private StreamWriter _swLogFile;

        /// <summary>
        /// destrunctor
        /// </summary>
        ~FileLogging()
        {
            Dispose();
        }

        /// <summary>
        /// method which opens the file
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="append"></param>
        /// <param name="autoFlush"></param>
        /// <returns></returns>
        private bool Open(string filePath, bool append, bool autoFlush)
        {
            bool bRet = false;
            if (_enableLog)
            {
                if (!Directory.Exists(Path.GetDirectoryName(filePath)))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(filePath));
                }
                _swLogFile = new StreamWriter(filePath, append);
                _swLogFile.AutoFlush = autoFlush;
                bRet = true;
                _disposed = false;
            }
 
            return bRet;
        }

        #endregion Private Members

    }
}