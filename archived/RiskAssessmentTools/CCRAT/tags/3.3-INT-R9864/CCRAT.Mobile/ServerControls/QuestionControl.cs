using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Mobile
{
    #region QuestionControl
    [ParseChildren(false)]
    public class QuestionControl : QuestionItemBase
    {
        private static readonly object AnswerValidationEvent = new object();

        private string _answer = string.Empty;
        private bool _hasAnswerBeenSet = false;

        /// <summary>
        /// Adds or removes a handler for the ValidateAnswer event that is raised when
        /// the questions need to be redrawn.
        /// </summary>
        public event EventHandler AnswerValidation
        {
            add { Events.AddHandler(AnswerValidationEvent, value); }
            remove { Events.RemoveHandler(AnswerValidationEvent, value); }
        }

        public string AnswerUnit;
        //{
        //    get { return (string)ViewState["AnswerUnit"] ?? string.Empty; }
        //    set { ViewState["AnswerUnit"] = value; }
        //}

        /// <summary>
        /// Gets or sets the question text.
        /// </summary>
        public string QuestionText
        {
            get
            {
                return (string)ViewState["QuestionText"] ?? string.Empty;
            }
            set
            {
                ViewState["QuestionText"] = value;
            }
        }

        /// <summary>
        /// Gets or sets additional text for this question.
        /// </summary>
        public string AdditionalQuestionText;
        //{
        //    get
        //    {
        //        return (string)ViewState["AdditionalQuestionText"] ?? string.Empty;
        //    }
        //    set
        //    {
        //        ViewState["AdditionalQuestionText"] = value;
        //    }
        //}

        /// <summary>
        /// Gets or sets a flag that determines if the AdditionalQuestionText should be shown
        /// above the question.  If true, the AdditionalQuestionText is shown above the question,
        /// if false it is show below the question.
        /// </summary>
        public bool ShowAdditionalTextAboveQuestion;
        //{
        //    get { return (bool)(ViewState["ShowAdditionalTextAboveQuestion"] ?? false); }
        //    set { ViewState["ShowAdditionalTextAboveQuestion"] = value; }
        //}

        /// <summary>
        /// Gets or sets explanation text
        /// </summary>
        public string ExplanationText;
        //{
        //    get { return (string)viewstate["explanationtext"] ?? string.empty; }
        //    set { viewstate["explanationtext"] = value; }
        //}

        /// <summary>
        /// Gets or sets the ID of the QuestionExplanation associated with this QuestionControl.
        /// </summary>
        public string QuestionExplanationID;
        //{
        //    get { return (string)ViewState["QuestionExplanationID"] ?? string.Empty; }
        //    set { ViewState["QuestionExplanationID"] = value; }
        //}

        /// <summary>
        /// Gets or sets the error text should this control have an error.
        /// </summary>
        public string ErrorText;
        //{
        //    get
        //    {
        //        return (string)ViewState["ErrorText"] ?? string.Empty;
        //    }
        //    set
        //    {
        //        ViewState["ErrorText"] = value;
        //    }
        //}

        /// <summary>
        /// Gets and sets the control ID of the associated drop down list of this question.
        /// </summary>
        public string AssociatedDropDownID;
        //{
        //    get { return (string)ViewState["AssociatedDropDownID"] ?? string.Empty; }
        //    set { ViewState["AssociatedDropDownID"] = value; }
        //}

        /// <summary>
        /// Gets or sets a value indicating if the question text should be used as a label for the control
        /// with the ID of AssociatedDropDownID
        /// </summary>
        public bool IsQuestionTextLabelForAssociatedControl;
        //{
        //    get { return (bool)(ViewState["IsQuestionTextLabelForAssociatedControl"] ?? false); }
        //    set { ViewState["IsQuestionTextLabelForAssociatedControl"] = value; }
        //}

        /// <summary>
        /// Gets whether or not this question has been answered by the user.
        /// </summary>
        public bool HasBeenAnswered
        {
            get { return (!string.IsNullOrEmpty(Answer)); }
        }

        /// <summary>
        /// Gets the answer to this question as a string.
        /// </summary>
        public string Answer
        {
            get
            {
                //Setting the answer will take precendece over an associated dropdown.
                if (_hasAnswerBeenSet)
                {
                    return _answer;
                }
                else
                {
                    if (!String.IsNullOrEmpty(AssociatedDropDownID))
                    {
                        DropDownList ddl = AssociatedDropDown;
                        if (AssociatedDropDown.SelectedValue.ToUpper() == "NAN")
                            return string.Empty;
                        else
                            return AssociatedDropDown.SelectedValue;
                    }
                    return string.Empty;
                }
            }
            set
            {
                _answer = value;
                _hasAnswerBeenSet = true;
            }
        }

        public bool SkipForDeterminingIfCompleted;
        //{
        //    get
        //    {
        //        return (bool)(ViewState["SkipForDeterminingIfCompleted"] ?? false);
        //    }
        //    set
        //    {
        //        ViewState["SkipForDeterminingIfCompleted"] = value;
        //    }
        //}

        /// <summary>
        /// Gets or Sets whether or not we stop showing questions when the question has been unanswered.
        /// </summary>
        public bool StopOnUnansweredQuestion;
        //{
        //    get { return (bool)(ViewState["StopOnUnansweredQuestion"] ?? false); }
        //    set { ViewState["StopOnUnansweredQuestion"] = value; }
        //}

        private QuestionGroupManager GroupManager
        {
            get
            {
                Control parent = this.Parent;

                while (parent != null)
                {
                    if (parent is QuestionGroupManager)
                        return (QuestionGroupManager)parent;
                    else
                        parent = parent.Parent;
                }

                throw new Exception("QuestionGroupManager could not be found.");
            }
        }

        public QuestionGroup ParentGroup
        {
            get
            {
                Control parent = this.Parent;

                while (parent != null)
                {
                    if (parent is QuestionGroup)
                        return (QuestionGroup)parent;
                    else
                        parent = parent.Parent;
                }

                throw new Exception("Parent QuestionGroup could not be found.");
            }
        }

        private DropDownList AssociatedDropDown
        {
            get
            {
                if (!string.IsNullOrEmpty(AssociatedDropDownID))
                {
                    Control ctrl = FindControl(AssociatedDropDownID);
                    if (ctrl != null && ctrl is DropDownList)
                        return (DropDownList)ctrl;
                    else if (ctrl == null)
                        throw new Exception("There is no DropDownList with the ID of " + AssociatedDropDownID + " for QuestionControl " + this.UniqueID);
                    else
                        throw new Exception("The control with the ID of " + AssociatedDropDownID + " for QuestionControl " + this.UniqueID + " is not a DropDownList.");
                }
                return null;
            }
        }

        public void ValidateAnswer()
        {
            OnAnswerValidation(new EventArgs());
        }

        protected virtual void OnAnswerValidation(EventArgs e)
        {
            EventHandler handler = (EventHandler)Events[AnswerValidationEvent];
            if (handler != null)
                handler(this, e);
        }

        protected override void RenderContents(HtmlTextWriter writer)
        {

            if (GroupManager.DisplayMode == QuestionDisplayModes.QuestionExplanation)
            {
                //RenderExplanation(writer);
            }
            else if (GroupManager.DisplayMode == QuestionDisplayModes.Results)
            {
                //RenderResultContents(writer);
            }
            else
            {
                RenderQuestioningContents(writer);
            }

        }

        private void RenderResultContents(HtmlTextWriter writer)
        {
            string answerText = Answer;

            if (!string.IsNullOrEmpty(AssociatedDropDownID))
            {
                answerText = AssociatedDropDown.SelectedItem.Text;
            }

            writer.AddAttribute(HtmlTextWriterAttribute.Class, "r-qt");
            writer.RenderBeginTag(HtmlTextWriterTag.Div);
            writer.Write(QuestionText);
            writer.RenderEndTag();
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "r-at");
            writer.RenderBeginTag(HtmlTextWriterTag.Div);
            writer.Write(answerText);

            if (!string.IsNullOrEmpty(AnswerUnit))
            {
                writer.Write("&nbsp;");
                writer.Write(AnswerUnit);
            }
            writer.RenderEndTag();
        }

        private void RenderQuestioningContents(HtmlTextWriter writer)
        {

            //Render additional text above question
            if (ShowAdditionalTextAboveQuestion && !string.IsNullOrEmpty(AdditionalQuestionText))
            {
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "q-at2");
                writer.RenderBeginTag(HtmlTextWriterTag.P);
                writer.Write(AdditionalQuestionText);
                writer.RenderEndTag();
            }

            //Render Question Text
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "q-qt");
            writer.RenderBeginTag(HtmlTextWriterTag.P);
            RenderQuestionText(writer);
            writer.RenderEndTag();

            if (!ShowAdditionalTextAboveQuestion && !string.IsNullOrEmpty(AdditionalQuestionText))
            {
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "q-at");
                writer.RenderBeginTag(HtmlTextWriterTag.Div);
                writer.Write(AdditionalQuestionText);
                writer.RenderEndTag();
            }

            //Questions
            //if (!ShowAdditionalTextAboveQuestion && !string.IsNullOrEmpty(AdditionalQuestionText))
            //{
            //    writer.AddAttribute(HtmlTextWriterAttribute.Class, "q-ctl2");
            //    writer.RenderBeginTag(HtmlTextWriterTag.Div);
            //}
            //else
            {
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "q-ctl");
                writer.RenderBeginTag(HtmlTextWriterTag.Div);
            }

            foreach (Control c in this.Controls)
            {
                c.RenderControl(writer);
            }
            writer.RenderEndTag();

            //Error
            //RenderError(writer);
        }

        private void RenderError(HtmlTextWriter writer)
        {
            if (Page.IsPostBack) //Errors can only occur on postback
            {
                //If the question has not been answered and there is error text and this is the current question group
                //and we did not just change to that question group, then show the error text.
                if (
                    !HasBeenAnswered
                    //&& !string.IsNullOrEmpty(ErrorText)
                    && !(GroupManager.CurrentQuestionGroup == ParentGroup.QuestionGroupNum && GroupManager.HasCurrentQuestionGroupChanged))
                {
                    writer.AddAttribute(HtmlTextWriterAttribute.Class, "err");
                    writer.RenderBeginTag(HtmlTextWriterTag.Div);
                    if (string.IsNullOrEmpty(ErrorText))
                    {
                        writer.Write("You must answer this question.");
                    }
                    else
                    {
                        writer.Write(ErrorText);
                    }
                    writer.RenderEndTag();
                }
            }
        }
  
        private void RenderQuestionText(HtmlTextWriter writer)
        {
            string controlID = string.Empty;

            if (IsQuestionTextLabelForAssociatedControl && !string.IsNullOrEmpty(AssociatedDropDownID))
            {
                controlID = AssociatedDropDown.ClientID;
            }

            if (!string.IsNullOrEmpty(controlID))
            {
                writer.AddAttribute(HtmlTextWriterAttribute.For, controlID);
                writer.RenderBeginTag(HtmlTextWriterTag.Label);
            }
            else
            {
                writer.RenderBeginTag(HtmlTextWriterTag.Span);
            }

            writer.Write(QuestionText);
            writer.RenderEndTag();
        }
    }
    #endregion QuestionControl
}