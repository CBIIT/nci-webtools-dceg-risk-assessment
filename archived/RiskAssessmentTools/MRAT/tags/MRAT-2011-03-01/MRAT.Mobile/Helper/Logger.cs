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
namespace Logger
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
        /// <param name="Message">Message</param>
        public void Write(string Message)
        {
            Write(Message, EventLogEntryType.Information);
        }
        /// <summary>
        /// writes the message to the file
        /// </summary>
        /// <param name="Message">Message</param>
        /// <param name="entryType">Log Entry Type</param>
        public void Write(string Message, EventLogEntryType entryType)
        {
            if (DisplayMessage)
            {
                System.Console.WriteLine(Message);
            }
            if (m_bEnableLog == true)
            {
                if (entryType == EventLogEntryType.Error)
                {
                    if (m_bWithDateTime == true)
                        m_swLogFile.Write(string.Format("{0} Error: {1}", DateTime.Now.ToString(), Message));
                    else
                        m_swLogFile.Write(string.Format("{0} Error: {1}", "", Message));

                }
                else
                {
                    if (m_bWithDateTime == true)
                        m_swLogFile.Write(string.Format("{0} Info : {1}", DateTime.Now.ToString(), Message));
                    else
                        m_swLogFile.Write(string.Format("{0}", Message));
                }
            }
        }

        /// <summary>
        /// WriteLine
        /// </summary>
        /// <param name="Message">Message to be written</param>
        public void WriteLine(string Message)
        {
            this.WriteLine(Message, EventLogEntryType.Information);
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
        /// <param name="Message">Message to be written</param>
        /// <param name="entryType">Event Log Entry Type - Info, Erro, etc.</param>
        public void WriteLine(string Message, EventLogEntryType entryType)
        {
            if (m_bEnableLog == true)
            {
                if (m_bWithDateTime == false)
                {
                    Message = string.Format("{0}", Message);
                }
                else
                {
                    Message = string.Format("{0} {1}: {2}", DateTime.Now.ToString(), entryType.ToString(), Message);
                }
            }
            if (DisplayMessage)
                Console.WriteLine(Message);
            m_swLogFile.WriteLine(Message);
        }
        /// <summary>
        /// FileLogging
        /// </summary>
        /// <param name="FilePath"></param>
        /// <param name="Append"></param>
        /// <param name="WithDateTime"></param>
        /// <param name="Enable"></param>
        /// <param name="AutoFlush"></param>
        public FileLogging(string FilePath, bool Append, bool WithDateTimeAndEntryType, bool Enable, bool AutoFlush)
        {
            m_bEnableLog = Enable;
            m_bWithDateTime = WithDateTimeAndEntryType;
            Open(FilePath, Append, AutoFlush);
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
            get { return m_bEnableLog; }
            set { m_bEnableLog = value; }
        }
        /// <summary>
        /// closes log file
        /// </summary>
        public void Dispose()
        {
            if (false == m_bDisposed && true == m_bEnableLog && null != m_swLogFile)
            {
                m_swLogFile.Close();
                GC.SuppressFinalize(this);
                m_bDisposed = true;
            }
        }

        #endregion Public Members

        #region Private Members
        private bool m_bEnableLog, m_bWithDateTime, m_bDisposed;
        private StreamWriter m_swLogFile;
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
        /// <param name="FilePath"></param>
        /// <param name="Append"></param>
        /// <param name="AutoFlush"></param>
        /// <returns></returns>
        private bool Open(string FilePath, bool Append, bool AutoFlush)
        {
            bool bRet = false;
            try
            {
                if (m_bEnableLog)
                {
                    m_swLogFile = new StreamWriter(FilePath, Append);
                    m_swLogFile.AutoFlush = AutoFlush;
                    bRet = true;
                    m_bDisposed = false;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
            }
            finally
            {
            }
            return bRet;
        }

        #endregion Private Members

    }
}