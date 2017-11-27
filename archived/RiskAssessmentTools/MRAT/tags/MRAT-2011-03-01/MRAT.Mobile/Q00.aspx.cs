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
using System.IO;

namespace MRAT.Mobile
{
    public partial class Q00 : System.Web.UI.Page
    {
        protected MratQuestion _ctrl;

        private string CurrentControlName
        {
            get 
            { 
                return (ViewState["CurrentQuestionName"] == null) ? string.Empty : ViewState["CurrentQuestionName"].ToString(); 
            }
            set 
            { 
                ViewState["CurrentQuestionName"] = value; 
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            BuildCurrentQuestion(phUserControl);           
        }

        /// <summary>
        /// Loads current question 
        /// </summary>
        /// <param name="phUserControl"></param>
        private void BuildCurrentQuestion(PlaceHolder phUserControl)
        {
            bool transfer = false;
            try
            {
                int question = Manager.CurrentQuestion;
                int answer = Manager.DefaultSelectionValue;
                GenderType gender = GenderType.Unknown;
                bool restart = false;

                string page = string.Empty; // page to load
                
                HttpRequest request = HttpContext.Current.Request;
                string referrerOrUrl = (request.UrlReferrer ?? request.Url).LocalPath;

                if (Helper.GetRequestValue("restart", false) == true)
                {
                    restart = true;
                    question = 1;
                    Manager.ClearSession();
                }
                else if (Request[Manager.QUESTION] != null)
                {
                    question = int.Parse(Request[Manager.QUESTION]);

                    if (Request[Manager.ANSWER] != null)
                        answer = int.Parse(Request[Manager.ANSWER]);
                }

                if (Session[Manager.sex] != null)
                    gender = (GenderType)(Session[Manager.sex]);

                string sessionKey = string.Empty;

                string controlToLoad = MratQuestion.ControlToLoad(question, gender);

                sessionKey = Manager.GetSessionKey(controlToLoad);

                _ctrl = new MratQuestion(question, answer, sessionKey);

                // 1.end risk calculation and redirect to home page if user selects other as race
                if (question == 3 && answer == 2)
                {
                    Manager.ClearSession();
                    page = "Default.aspx";
                    transfer = true;
                }
                // 2.check and redirect to results page 
                else if(_ctrl.IsValid() == true && _ctrl.IsLastQuestion == true)
                {
                    _ctrl.Save();
                    if(_ctrl.Gender == GenderType.Male)
                        page = "results_m.aspx";
                    else
                        page = "results_f.aspx";
                    transfer = true;
                }
                // 3.check if it is a GET method (back button from explanation/image is clicked)
                else if (request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase) && (request.UrlReferrer ?? request.Url).LocalPath.EndsWith("ex.aspx"))
                {
                    question = Manager.CurrentQuestion;
                    if (referrerOrUrl.EndsWith("resultex.aspx"))
                    {
                        if (gender.Equals(GenderType.Male))
                        {
                            transfer = true;
                            page = "results_m.aspx";
                        }
                        else if (gender.Equals(GenderType.Female))
                        {
                            transfer = true;
                            page = "results_f.aspx";
                        }
                    }                      
                }
                
                // 4.decide which page or question should be loaded
                if (transfer == true && string.IsNullOrEmpty(page) == false)
                {
                    HttpContext.Current.Server.Transfer(page, true);
                }
                else
                {
                    //get the next question number to be laoded
                    int nextQ = _ctrl.NextQuestion;

                    //get the path of the next control to be loaded
                    string next = string.Empty;
                    next = MratQuestion.ControlToLoad(nextQ, _ctrl.Gender);

                    //display the error message by making the label control visible
                    if (restart == false && _ctrl.IsValid() == false && request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase) == false)
                    {
                        if (_ctrl.Question == _ctrl.NextQuestion)
                            lblError.Visible = true;
                    }

                    _ctrl.Save();

                    //add the control to the place holder control
                    _ctrl = (MratQuestion)LoadControl(next);
                    this.phUserControl.Controls.Add(_ctrl);

                    //set the current control name in the viewstate 
                    CurrentControlName = next;
                }                
            }
            catch (System.Threading.ThreadAbortException ex)
            {               
                ; //this was caused by transfer/execute and can be ignored
            }
        }
        
    }
}
