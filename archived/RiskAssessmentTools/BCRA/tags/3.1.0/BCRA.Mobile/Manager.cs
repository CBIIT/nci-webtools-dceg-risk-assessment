
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Collections.Specialized;

namespace BCRA.Mobile
{
    public class Manager
    {

        #region Fields & constants

        public const string historyOfBC = "historyOfBC";
        public const string age = "age";
        public const string ageMP = "ageMP";
        public const string ageLB = "ageLB";
        public const string relativeNum = "relativeNum";
        public const string biopsy = "biopsy";
        public const string biopsyNum = "biopsyNum";
        public const string biopsyAH = "biopsyAH";
        public const string race = "race";
        public const string subrace = "subrace";

        private const string currentQuestion = "CurrentQuestion";
        private const string previousQuestion = "PreviousQuestion";

        //other constants
        public const string DefaultSelectionValue = "-1000";

        public static bool valSet = false;



        #endregion Fields

        #region Properties
        /// <summary>
        /// returns current question nubmer from session
        /// </summary>
        public static string CurrentQuestion
        {
            get
            {
                if (HttpContext.Current.Session[currentQuestion] != null)
                    return HttpContext.Current.Session[currentQuestion].ToString();
                else
                    return string.Empty;
            }
            set
            {
                PreviousQuestion = CurrentQuestion;
                HttpContext.Current.Session[currentQuestion] = value;
                //PreviousQuestion = (Int32.Parse(CurrentQuestion) - 1).ToString();
            }
        }

        public static string PreviousQuestion
        {
            get
            {
                if (HttpContext.Current.Session[previousQuestion] != null)
                    return HttpContext.Current.Session[previousQuestion].ToString();
                else
                    return string.Empty;
            }
            set
            {
                HttpContext.Current.Session[previousQuestion] = value;
            }
        }
        #endregion Properties

        #region Methods

        /// <summary>
        /// clears session state collection 
        /// </summary>
        public static void ClearSession()
        {

            HttpContext.Current.Session.Clear();
        }

        public static void ResetSessionVars()
        {
            HttpContext.Current.Session[historyOfBC] = "";
            HttpContext.Current.Session[age] = "";
            HttpContext.Current.Session[ageMP] = "";
            HttpContext.Current.Session[ageLB] = "";
            HttpContext.Current.Session[relativeNum] = "";
            HttpContext.Current.Session[biopsy] = "";
            HttpContext.Current.Session[biopsyNum] = "";
            HttpContext.Current.Session[biopsyAH] = "";
            HttpContext.Current.Session[race] = "";
            HttpContext.Current.Session[subrace] = "";


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
        /// Gets current question to be loaded
        /// </summary>
        /// <param name="gender"></param>
        /// <param name="valueSet"></param>
        /// <returns></returns>
        public static string GetQuestionToLoad(out bool valueSet)
        {
            valueSet = true;
            valSet = valueSet;
            int question = 1;
            string q = String.Empty;

            if (HttpContext.Current.Request.QueryString.Count > 0 && bool.Parse(HttpContext.Current.Request.QueryString["restart"]))
            {
                question = 1;
            }
            else
            {
                if (HttpContext.Current.Request.Form.Count > 1 && HttpContext.Current.Request.Form[0] != null)
                    if (Manager.CurrentQuestion == "9")
                    {
                        question = int.Parse(HttpContext.Current.Request.Form["q"]);
                    }
                    else
                    {
                        question = int.Parse(HttpContext.Current.Request.Form["q"]);
                    }

                if (HttpContext.Current.Request.Form.Count > 0)
                {
                    if ((question == 1) && (HttpContext.Current.Request.Form[1].ToUpper().Equals("YES")))
                    {
                        HttpContext.Current.Server.Transfer("Default.aspx", false);
                    }
                }

                //check if it is a GET method (back button is clicked)
                if (HttpContext.Current.Request.HttpMethod.ToUpper().Equals("GET") && (HttpContext.Current.Request.UrlReferrer ?? HttpContext.Current.Request.Url).LocalPath.EndsWith("ex.aspx"))
                {
                    question = int.Parse(Manager.CurrentQuestion);
                }
                else if (HttpContext.Current.Request.HttpMethod.ToUpper().Equals("POST") && HttpContext.Current.Request.Form.Count > 0 && HttpContext.Current.Request.Form[1] == Manager.DefaultSelectionValue)
                {
                    //reload current page
                    valueSet = false;
                    valSet = valueSet;
                }

                //else if (question == 9)
                //{
                //    if (HttpContext.Current.Request.Form[1] == Manager.DefaultSelectionValue)// && HttpContext.Current.Request.Form[2] != Manager.DefaultSelectionValue)
                //    {
                //        valueSet = false;
                //        valSet = valueSet;
                //    }
                //}
                else if (question == 9)
                {
                    NameValueCollection postedValues = HttpContext.Current.Request.Form;
                    String nextKey;
                    bool postBackfromdd = false;
                    string race=string.Empty;

                    if (postedValues["__EVENTTARGET"].Contains("race"))
                    {
                        postBackfromdd = true;
                    }

                    for (int i = 0; i < postedValues.AllKeys.Length; i++)
                    {
                        nextKey = postedValues.AllKeys[i];
                        if (nextKey.Substring(0, 1) != "__")
                        {
                            if (nextKey.Contains("race"))
                            {
                                race = postedValues[i];
                            }
                        }
                    }

                    if (race == "-1000")
                    {
                        //reload current page
                        valueSet = false;
                        valSet = valueSet;

                    }
                    else if (race != "4" && postBackfromdd==false)
                    {
                        HttpContext.Current.Server.Transfer("results.aspx", true);
                    }

                    else if (race == "4" && postBackfromdd == false)
                    {
                        question++;
                    }


                }
                else if (question == 10)
                {
                    if (HttpContext.Current.Request.Form[1] == Manager.DefaultSelectionValue)
                    {
                        valueSet = false;
                        valSet = valueSet;

                    }

                    else
                    {
                        HttpContext.Current.Server.Transfer("results.aspx", true);

                    }

                }
                else if (!(HttpContext.Current.Request.UrlReferrer ?? HttpContext.Current.Request.Url).LocalPath.EndsWith("ex.aspx")
                         && HttpContext.Current.Request.HttpMethod.ToUpper().Equals("POST") && !(HttpContext.Current.Request.Form[1] == Manager.DefaultSelectionValue))
                {
                    question++;
                }
 
            }

            switch (question)
            {
                case 1:
                    q = "Q01.ascx";
                    break;
                case 2:
                    q = "Q02.ascx";
                    break;
                case 3:
                    q = "Q03.ascx";
                    break;
                case 4:
                    q = "Q04.ascx";
                    break;
                case 5:
                    q = "Q05.ascx";
                    break;
                case 6:
                    q = "Q06.ascx";
                    break;
                case 7:
                    if (HttpContext.Current.Request.Form.Count > 0)
                    {
                        if ((HttpContext.Current.Request.Form[1].ToString().Equals("0")) || (HttpContext.Current.Request.Form[1].ToString().Equals("99")))
                        {
                            q = "Q07.ascx";
                            question = 9;
                        }
                        else if ((HttpContext.Current.Session[biopsy].ToString().Equals("1")) || (HttpContext.Current.Request.Form[1].ToString().Equals("1")))
                        {
                            q = "Q06a.ascx";
                        }
                        else
                        {
                            q = "Q07.ascx";
                            question = 9;
                        }
                    }
                    else
                    {
                        if (HttpContext.Current.Session[biopsy].ToString().Equals("1"))
                            q = "Q06a.ascx";
                        else
                        {
                            q = "Q07.ascx";
                            question = 9;
                        }
                    }
                    break;
                case 8:
                    q = "Q06b.ascx";
                    break;
                case 9:
                    q = "Q07.ascx";
                    break;
                case 10:
                    q = "Q07a.ascx";
                    break;

                default:
                    q = "Q01.ascx";
                    break;
            }
            Manager.CurrentQuestion = question.ToString();
            return q;
        }

        #endregion Methods

    }
}
