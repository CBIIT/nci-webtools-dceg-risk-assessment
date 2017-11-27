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

namespace MRAT.Mobile
{
    /// <summary>
    /// MRAT question base class
    /// </summary>
    public class MratQuestion : System.Web.UI.UserControl
    {

        #region Fields

        private int _question = 0;
        private int _answer = -1000;
        private GenderType _gender = GenderType.Unknown;
        private string _sessionKey = string.Empty;   
        private Control _ctrl = null; //ddl input control
        private string _redirectURL = string.Empty;
        private string _explanationURL = string.Empty;

        #endregion Fields

        #region constructors

        public MratQuestion()
        {
    
        }    
   
        public MratQuestion(int question, int answer, string sessionKey)
        {
            SessionKey = sessionKey;
            Question = question;

            object o = null;
            
            //get the answer from session if it's a GET method
            o = HttpContext.Current.Session[SessionKey];
            if (answer != Manager.DefaultSelectionValue || o == null || (int)o == Manager.DefaultSelectionValue)
                Answer = answer;
            else
                Answer = (int)o;
            o = null;

            o = HttpContext.Current.Session[Manager.sex];
            if (_question > 2 && o != null)
            {
                _gender = (GenderType)(o);
            }
            o = null;
        }

        #endregion constructors

        protected override void  OnLoad(EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                bool restart = false;
                if(Request.Params["restart"] != null )
                    restart = bool.Parse(Request.Params["restart"]);
                if (restart == true)
                {
                    Manager.ClearSession();
                }

                //set the previous value if available
                SetPreviousValue();
            }
        }

        #region Properties

        /// <summary>
        /// Gets or sets current question number
        /// </summary>
        public int Question
        {
            get 
            {
                return _question; 
                //return (ViewState[Manager.QUESTION] != null) ? (int)ViewState[Manager.QUESTION] : Manager.DefaultSelectionValue;
            }
            set
            {
                _question = value;
                ViewState[Manager.QUESTION] = value;
                Manager.CurrentQuestion = value;
            }
        }

        /// <summary>
        /// gets or sets current question's answer
        /// </summary>
        public int Answer
        {
            get 
            {
                //return (ViewState[Manager.ANSWER] != null) ? (int)ViewState[Manager.ANSWER] : Manager.DefaultSelectionValue;
                return _answer;
            }
            set 
            { 
                _answer = value;
                ViewState[Manager.ANSWER] = value;
                HttpContext.Current.Session[_sessionKey] = value;
            }
        }

        public string SessionKey
        {
            get { return _sessionKey; }
            set { _sessionKey = value; }
        }

        public int NextQuestion
        {
            get 
            {
                if (IsValid() == false || IsLastQuestion)
                    return _question;
                else
                    return (_question + 1); 
            }
        }

        public static string ControlToLoad(int question, GenderType gender)
        {
            if (question > 4 && gender != 0)
            {
                return Manager.QUESTION + question.ToString("00") + ((gender.Equals(GenderType.Male)) ? "m" : "f") + ".ascx";
            }
            else
            {
                return Manager.QUESTION + question.ToString("00") + ".ascx";
            }

        }

        public int PrevQuestion
        {
            get { 
                return (IsFirstQuestion) ? _question : _question - 1; }
        }

        public GenderType Gender
        {
            get { return _gender; }
            set { _gender = value; }
        }

        public bool IsLastQuestion
        {
            get
            {
                if (_gender == GenderType.Male && _question == Manager.MaleQuestions)
                    return true;
                else if(_gender == GenderType.Female && _question == Manager.FemaleQuestions)
                    return true;
                else
                    return false;
            }
        }

        public bool IsFirstQuestion
        {
            get
            {
                if (_question == 1)
                    return true;
                else 
                    return false;
            }
        }

        /// <summary>
        /// Returns true if the request is from another question 
        /// otherwise false if it is a GET method (back button from explanation/image is clicked)
        /// </summary>
        /// <returns></returns>
        public bool IsFromQuestion()
        {
            bool ret = false;
            
            HttpRequest request = HttpContext.Current.Request;
            
            ret =  (request.UrlReferrer ?? request.Url).LocalPath.EndsWith("ex.aspx", StringComparison.OrdinalIgnoreCase)
                && request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase);

            return ret;
         
        }

        public Control InputControl
        {
            get { return _ctrl; }
            set { _ctrl = value; }
        }

        public string RedirectURL
        {
            get { return _redirectURL; }
            set { _redirectURL = value; }
        }

        public string ExplanationURL
        {
            get { return _explanationURL; }
            set { _explanationURL = value; }
        }

        #endregion Properties

        #region Methods
      
        public bool IsValid()
        {
            return IsValid(false);
        }
        /// <summary>
        /// checks if it's a acceptable input value
        /// </summary>
        /// <param name="redirect"></param>
        /// <returns></returns>
        public bool IsValid(bool redirect)
        {
            //redirect the user to a next question iif s/he's made a valid selection
            //otherwise take him/her to the same page
            bool ret = false;

            HttpContext httpContext = HttpContext.Current;

            if (IsFromQuestion() == false && Answer.Equals(Manager.DefaultSelectionValue) == false)
            {
                httpContext.Session[SessionKey] = Answer;
                if (redirect)
                    httpContext.Response.Redirect(RedirectURL);
                ret = true;
            }    
      
            return ret;
        }

        /// <summary>
        /// sets it to previous value if any
        /// </summary>
        /// <returns></returns>
        public virtual void  SetPreviousValue()
        {
            if (_ctrl != null && HttpContext.Current.Session[_sessionKey] != null)
            {
                string value = HttpContext.Current.Session[_sessionKey].ToString();
                if (!value.Equals(Manager.DefaultSelectionValue.ToString(), StringComparison.OrdinalIgnoreCase))
                {
                    //TODO: handle it for question 3 which is of radio button type
                    if (_ctrl.GetType() == typeof(HtmlSelect))
                    {
                        HtmlSelect ctl = (HtmlSelect)_ctrl;
                        ctl.SelectedIndex = ctl.Items.IndexOf(ctl.Items.FindByValue(value));
                    }
                    else if (_ctrl.GetType() == typeof(HtmlInputRadioButton))
                    {
                        HtmlInputRadioButton ctl = (HtmlInputRadioButton)_ctrl;
                        if (value.Equals("1"))
                        {
                            ctl.Checked = true;
                            ctl.Value = value;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// sets it to previous value if any
        /// </summary>
        /// <param name="valueSet"></param>
        public virtual void SetPreviousValue(bool valueSet)
        {
            if (valueSet == true)
            {
                SetPreviousValue();
            }
            else
            {   //clear from session
                Session[_sessionKey] = null;
            }           
        }

        /// <summary>
        /// Saves current state of the question in session
        /// </summary>
        public void Save()
        {
            if (_question != Manager.DefaultSelectionValue)
                Manager.CurrentQuestion = _question;

            if(_answer != Manager.DefaultSelectionValue)
                HttpContext.Current.Session[SessionKey] = _answer;
        }
        #endregion methods
    }
}
