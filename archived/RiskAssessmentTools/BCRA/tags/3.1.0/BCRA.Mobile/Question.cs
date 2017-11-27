using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace BCRA.Mobile
{
    /// <summary>
    /// BCRA question base class
    /// </summary>
    public class Question : System.Web.UI.UserControl
    {

        #region Fields

        private int _currentQuestion = 0;
        private int _gender = 0;
        private string _sessionKey = string.Empty;
        private HtmlSelect _ctrl = null; //ddl input control
        private DropDownList _ctrl1 = null; //ddl input control

        private string _redirectURL = string.Empty;
        private string _explanationURL = string.Empty;

        #endregion Fields

        #region Properties
        public int CurrentQuestion
        {
            get { return _currentQuestion; }
            set { _currentQuestion = value; }
        }

        public int NextQuestion
        {
            get { return _currentQuestion++; }
            //set { }
        }

        public int PrevQuestion
        {
            get { return _currentQuestion--; }
            //set { }
        }

        public int Gender
        {
            get { return _gender; }
            set { _gender = value; }
        }

        //public bool IsLastQuestion
        //{
        //    get
        //    {
        //        if (_gender == Constants.MALE && _currentQuestion == 10)
        //            return true;
        //        else if (_gender == Constants.FEMALE && _currentQuestion == 8)
        //            return true;
        //        else
        //            return false;
        //    }
        //}

        public bool IsFirstQuestion
        {
            get
            {
                if (_currentQuestion == 1)
                    return true;
                else
                    return false;
            }
        }

        public string SessionKey
        {
            get { return _sessionKey; }
            set { _sessionKey = value; }
        }

        public HtmlSelect InputControl
        {
            get { return _ctrl; }
            set { _ctrl = value; }
        }

        public DropDownList InputControl1
        {
            get { return _ctrl1; }
            set { _ctrl1 = value; }
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
        /// <summary>
        /// Validates control's current state
        /// </summary>
        /// <param name="redirect"></param>
        /// <returns></returns>
        public bool ValidateCurrentState(bool redirect)
        {
            //redirect the user to a next question iif s/he's made a valid selection
            //otherwise take him/her to the same page
            if (!InputControl.Value.Equals(Manager.DefaultSelectionValue))
            {
                HttpContext.Current.Session[SessionKey] = InputControl.Value;
                if (redirect)
                {
                    HttpContext.Current.Response.Redirect(RedirectURL);
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// sets it to previous value if any
        /// </summary>
        /// <returns></returns>
        public virtual void SetPreviousValue()
        {
            if (Session[_sessionKey] != null && _sessionKey!="race")
            {
                _ctrl.SelectedIndex = _ctrl.Items.IndexOf(_ctrl.Items.FindByValue(Session[_sessionKey].ToString()));
            }
            else if (Session[_sessionKey] == null && _sessionKey == "race")
            {

            }
            else
            {
                _ctrl1.SelectedIndex = _ctrl1.Items.IndexOf(_ctrl1.Items.FindByValue(Session[_sessionKey].ToString()));

            }
        }
        #endregion methods
    }
}
