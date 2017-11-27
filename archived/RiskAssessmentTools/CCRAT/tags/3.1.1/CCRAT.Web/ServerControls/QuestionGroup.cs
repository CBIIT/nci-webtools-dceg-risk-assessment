using System;
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
using System.Collections.Generic;

namespace CCRAT
{
    [ParseChildren(false)]
    public class QuestionGroup : WebControl
    {

        private static readonly object QuestionGroupAnsweredEvent = new object();
        private static readonly object QuestionRedrawEvent = new object();

        private int _questionGroupNum = -1;

        /// <summary>
        /// Adds or removes a handler for the QuestionRedraw event that is raised when
        /// the questions need to be redrawn.
        /// </summary>
        public event EventHandler QuestionRedraw
        {
            add { Events.AddHandler(QuestionRedrawEvent, value); }
            remove { Events.RemoveHandler(QuestionRedrawEvent, value); }
        }

        /// <summary>
        /// Adds or removes a handler for the QuestionGroupAnswered event that is raised when
        /// a question group has been answered.
        /// </summary>
        public event EventHandler QuestionGroupAnswered
        {
            add { Events.AddHandler(QuestionGroupAnsweredEvent, value); }
            remove { Events.RemoveHandler(QuestionGroupAnsweredEvent, value); }
        }

        /// <summary>
        /// Gets whether or not this question group has an event handler for the
        /// QuestionGroupAnswered event.
        /// </summary>
        public bool HasQuestionGroupAnsweredHandler
        {
            get { return (Events[QuestionGroupAnsweredEvent] != null); }
        }

        /// <summary>
        /// Gets or sets the question group this QuestionControl belongs to.
        /// </summary>
        public int QuestionGroupNum
        {
            get { return _questionGroupNum; }

            set { _questionGroupNum = value; }
        }

        /// <summary>
        /// Normally the FirstTimeQuestionGroupAnswered event is raised only if this is the current
        /// question and this is the first time answering it.  This means that anytime it is answered
        /// the event should be raised.  I guess the event should be called, CurrentQuestionGroupAnswered.
        /// </summary>
        public bool AlwaysTreatAnswerAsFirstTime
        {
            get
            {
                return (bool)(ViewState["AlwaysTreatAnswerAsFirstTime"] ?? false);
            }
            set
            {
                ViewState["AlwaysTreatAnswerAsFirstTime"] = value;
            }
        }

        public QuestionControl[] Questions
        {
            get
            {
                List<QuestionControl> questions = new List<QuestionControl>();

                foreach (Control c in this.Controls)
                {
                    if (c is QuestionControl)
                        questions.Add((QuestionControl)c);
                }

                return questions.ToArray();
            }
        }

        public void RedrawQuestion()
        {
            OnQuestionRedraw(new EventArgs());
        }

        public void AnswerQuestionGroup()
        {
            OnQuestionGroupAnswered(new EventArgs());
        }

        protected virtual void OnQuestionRedraw(EventArgs e)
        {
            EventHandler handler = (EventHandler)Events[QuestionRedrawEvent];
            if (handler != null)
                handler(this, e);
            else
                this.Visible = true; //QuestionRedraw sets the visibility.  If there is no handler, then
            //mark this control as visible, otherwise, the handler will mark it
            //as being visible.
        }

        protected virtual void OnQuestionGroupAnswered(EventArgs e)
        {
            EventHandler handler = (EventHandler)Events[QuestionGroupAnsweredEvent];
            if (handler != null)
                handler(this, e);
        }

        protected override void Render(HtmlTextWriter writer)
        {
            base.RenderContents(writer);
        }
    }
}
