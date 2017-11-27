using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace MRAT.Mobile
{
    /// <summary>
    /// Mrat.Mobile.Manager
    /// </summary>
    public class Manager
    {
        #region Fields & constants
        //constants for session keys
        public const string region = "region";
        public const string sex = "sex";
        public const string race = "race";
        public const string age = "age";
        public const string sunburn = "sunburn";
        public const string complexion = "complexion";
        public const string tanning = "tanning";
        public const string largemoles = "large_moles";
        public const string smallmolesmales = "small_moles_males";
        public const string smallmolesfemales = "small_moles_females";
        public const string freckling = "freckling";
        public const string solardamage = "solar_damage";

        public const int MaleQuestions = 10;
        public const int FemaleQuestions = 8;
        public static bool ValueSet = false;
        
        private const string currentQuestion = "CurrentQuestion";
        private const string currentQuestionAndValue = "CurrentQuestionAndValue";

        public const string QUESTION = "q";
        public const string ANSWER = "ctl00$MainContent$ctl00$answer";


        //other constants
        public const int DefaultSelectionValue = -1000;

        #endregion Fields

        #region Methods

        /// <summary>
        /// clears session state collection 
        /// </summary>
        public static void ClearSession()
        {
            HttpContext.Current.Session.Clear();
        }

        /// <summary>
        /// clears value of a given key from session
        /// </summary>
        /// <param name="name"></param>
        public static void ClearSession(string key)
        {
            HttpContext.Current.Session[key] = null;
        }

        /// <summary>
        /// Reads configuration value
        /// </summary>
        /// <param name="Name"></param>
        /// <param name="DefaultValue"></param>
        /// <returns></returns>
        public static int ReadConfigValue(string Name, int DefaultValue)
        {
            int retval = DefaultValue;
            object o = System.Configuration.ConfigurationManager.AppSettings[Name];
            retval = (o != null || int.TryParse(o.ToString(), out retval)) ? Convert.ToInt32(o) : DefaultValue;
            return retval;
        }

        /// <summary>
        /// Reads configuration value
        /// </summary>
        /// <param name="Name"></param>
        /// <param name="DefaultValue"></param>
        /// <returns></returns>
        public static string ReadConfigValue(string Name, string DefaultValue)
        {
            string o = ConfigurationManager.AppSettings[Name];
            return (o != null) ? Convert.ToString(o) : DefaultValue;
        }
       
        /// <summary>
        /// returns the error message to be displayed when option is blank in the drop down list
        /// </summary>
        /// <returns></returns>
        public static string GetErrorMessage()
        {
            return "<p style='color:red'>You must answer this question.</p>";
        }

        /// <summary>
        /// returns current question nubmer from session
        /// </summary>
        public static int CurrentQuestion
        {
            get
            {
                if (HttpContext.Current.Session[currentQuestion] != null)
                    return int.Parse(HttpContext.Current.Session[currentQuestion].ToString());
                else
                    return 1;
            }
            set
            {
                HttpContext.Current.Session[currentQuestion] = value;
            }
        }

        public static string GetSessionKey(string controlToLoad)
        {
            string sessionKey = string.Empty;
            switch (controlToLoad.ToLower())
            {
                case "q01.ascx": 
                    sessionKey = Manager.region; 
                    break;
                case "q02.ascx":
                    sessionKey = Manager.sex;
                    break;
                case "q03.ascx":
                    sessionKey = Manager.race;
                    break;
                case "q04.ascx":
                    sessionKey = Manager.age;
                    break;
                case "q05f.ascx":
                    sessionKey = Manager.complexion;
                    break;
                case "q05m.ascx":
                    sessionKey = Manager.sunburn;
                    break;
                case "q06f.ascx":
                    sessionKey = Manager.tanning;
                    break;
                case "q06m.ascx":
                    sessionKey = Manager.complexion;
                    break;
                case "q07f.ascx":
                    sessionKey = Manager.smallmolesfemales;
                    break;
                case "q07m.ascx":
                    sessionKey = Manager.largemoles;
                    break;
                case "q08f.ascx":
                    sessionKey = Manager.freckling;
                    break;
                case "q08m.ascx":
                    sessionKey = Manager.smallmolesmales;
                    break;
                case "q09m.ascx":
                    sessionKey = Manager.freckling; break;
                case "q10m.ascx":
                    sessionKey = Manager.solardamage;
                    break;
            }
            return sessionKey;

        }

        public static string GetBackURL()
        {
            string backURL = (HttpContext.Current.Request.UrlReferrer ?? HttpContext.Current.Request.Url).LocalPath;
            if (!String.IsNullOrEmpty(backURL))
            {
                backURL = System.IO.Path.GetFileName(HttpContext.Current.Server.MapPath(backURL));
            }
            return backURL;
        }

        #endregion Methods
    }

}
