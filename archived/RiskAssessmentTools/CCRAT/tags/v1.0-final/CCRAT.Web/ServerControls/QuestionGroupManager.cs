using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace CCRAT
{
    public enum QuestionDisplayModes
    {
        Questioning = 1,
        Results = 2
    }

    /// <summary>
    /// This control manages the current question group and fires all of the events to move
    /// question groups from one group to another.  It is a little nicer having this 150+ lines
    /// of code in here instead of the code behind of the page or user control that holds all
    /// of the question groups.
    /// </summary>
    [ParseChildren(false)]
    public class QuestionGroupManager : WebControl
    {
        private List<QuestionGroup> _questionGroups = new List<QuestionGroup>();
        private bool _hasCurrentQuestionGroupChanged = false;

        /// <summary>
        /// Gets whether or not the CurrentQuestionGroup has changed for this postback.
        /// </summary>
        public bool HasCurrentQuestionGroupChanged
        {
            get { return _hasCurrentQuestionGroupChanged; }
        }

        public bool HaveAllQuestionsBeenAnswered
        {
            get
            {

                foreach (QuestionGroup g in _questionGroups)
                {
                    //Only check those that are visible
                    if (g.Visible)
                    {
                        foreach (QuestionControl qc in g.Questions)
                        {
                            if (!qc.SkipForDeterminingIfCompleted && !qc.HasBeenAnswered)
                                return false;
                        }
                    }
                }

                return true;
            }
        }

        public int CurrentQuestionGroup
        {
            get { return (int)(ViewState["CurrentQuestionGroup"] ?? 1); }
            set
            {
                if (CurrentQuestionGroup != value)
                    _hasCurrentQuestionGroupChanged = true;

                ViewState["CurrentQuestionGroup"] = value;
            }
        }

        private QuestionDisplayModes _displayMode = QuestionDisplayModes.Questioning;

        public QuestionDisplayModes DisplayMode
        {
            get { return _displayMode; }
            set { _displayMode = value; }
        }


        protected override HtmlTextWriterTag TagKey
        {
            get
            {
                return HtmlTextWriterTag.Div;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            //Create Array of Question Controls
            int questionGroupNum = 1;
            foreach (Control ctrl in this.Controls)
            {
                if (ctrl is QuestionGroup)
                {
                    ((QuestionGroup)ctrl).QuestionGroupNum = questionGroupNum;
                    _questionGroups.Add((QuestionGroup)ctrl);
                    questionGroupNum++;
                }
            }

            if (!Page.IsPostBack)
            {
                //Only show the items in the first question group, no matter what.
                _questionGroups.ForEach(qg =>
                {
                    if (CurrentQuestionGroup >= qg.QuestionGroupNum)
                        qg.Visible = true;
                    else
                        qg.Visible = false;
                });
            }
        }

        protected override void AddAttributesToRender(HtmlTextWriter writer)
        {
            base.AddAttributesToRender(writer);
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "questions");
        }

        public void RefreshQuestions(Control sender)
        {
            int firstInvalidQuestionGroup = ValidateAnswers();

            if (firstInvalidQuestionGroup != 0)
            {
                //There are errors! So only redraw questions up until the first
                //question group with an error.
                RedrawQuestionsForError(firstInvalidQuestionGroup);
            }
            else
            {
                QuestionGroup answeredQuestionGroup = GetAnsweredQuestionGroup((Control)sender);

                if (answeredQuestionGroup.HasQuestionGroupAnsweredHandler)
                {
                    //This is the handler that will skip to questions based on the answer
                    //of the answeredQuestionGroup
                    answeredQuestionGroup.AnswerQuestionGroup();
                }
                else
                {
                    //There is no special handler so move to the next question group if
                    //the current questiongroup was just answered.
                    if (answeredQuestionGroup.QuestionGroupNum == CurrentQuestionGroup)
                        CurrentQuestionGroup++;
                }

                //Draw the questions that are supposed to draw.
                RedrawQuestions();
            }
        }

        private QuestionGroup GetAnsweredQuestionGroup(Control ctrl)
        {
            //Since the control that caused the postback has to be in a QuestionControl, which is in a QuestionGroup, we can
            //Loop through the parents until we get to the containing QuestionGroup and return
            //that control's QuestionGroup number.
            Control qc = ctrl.Parent;

            while (qc != null)
            {
                if (qc is QuestionGroup)
                    break;
                else
                    qc = qc.Parent;
            }

            if (qc != null) //This must be the question control
                return ((QuestionGroup)qc);
            else
                throw new Exception("Could not determine the QuestionGroup from the answered control.");
        }

        /// <summary>
        /// This loops through the controls to see if there are any hard errors.
        /// </summary>
        /// <returns></returns>
        public int ValidateAnswers()
        {
            int firstInvalidQuestionGroup = 0;

            //Basically, only look at items which have been answered. (Obviously looking forward
            //at unanswered questions would cause an error)
            _questionGroups.Where(gg => CurrentQuestionGroup >= gg.QuestionGroupNum)
                .ToList<QuestionGroup>()
                .ForEach(qg =>
                {
                    foreach (Control ctrl in qg.Controls)
                    {
                        if (ctrl is QuestionControl)
                        {
                            ((QuestionControl)ctrl).ValidateAnswer();

                            //If the question has not been answered && We are supposed to stop when it has been unanswered, then we need to store the first error
                            //index.
                            if ((!((QuestionControl)ctrl).HasBeenAnswered && ((QuestionControl)ctrl).StopOnUnansweredQuestion) && firstInvalidQuestionGroup == 0)
                                firstInvalidQuestionGroup = qg.QuestionGroupNum;
                        }
                    }
                });

            return firstInvalidQuestionGroup;
        }

        private void RedrawQuestions()
        {
            //It should be noted that RedrawQuestion can change the CurrentQuestionGroup.
            _questionGroups.ForEach(qg =>
            {
                if (CurrentQuestionGroup >= qg.QuestionGroupNum)
                    qg.RedrawQuestion();
                else
                    qg.Visible = false;
            });
        }

        private void RedrawQuestionsForError(int finalQuestionGroup)
        {
            _questionGroups.ForEach(qg =>
            {
                if (finalQuestionGroup >= qg.QuestionGroupNum)
                    qg.RedrawQuestion();
                else
                    qg.Visible = false;
            });
        }

    }
}
