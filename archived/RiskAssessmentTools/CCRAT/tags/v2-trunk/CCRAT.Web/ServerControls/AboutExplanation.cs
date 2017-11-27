using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT
{
    public class AboutExplanation : WebControl
    {
        private AEQuestionCollection _questions = new AEQuestionCollection();
        private AEExplanation _explanation = new AEExplanation();

        private string _overrideQuestionHeading = string.Empty;
        private bool _hideSeparator = false;

        public bool HideSeparator
        {
            get { return _hideSeparator; }
            set { _hideSeparator = value; }
        }

        public string OverrideQuestionHeading
        {
            get { return _overrideQuestionHeading; }
            set { _overrideQuestionHeading = value; }
        }

        public AEQuestionCollection Questions
        {
            get
            {
                return _questions;
            }
        }

        public AEExplanation Explanation
        {
            get
            {
                return _explanation;
            }
            set
            {
                _explanation = value;
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            /*        <h3>Questions:</h3>
        <ul>
            <li>What is your age? (Please note that this tool only calculates risk for men and women age 50 to 85.)</li>
        </ul>
        <h3>Explanation:</h3>
        <p>
        Colorectal cancer is more likely to occur as people get older. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.    
        </p>
        <div class="line"></div>
        */
            writer.RenderBeginTag(HtmlTextWriterTag.H3);
            if (string.IsNullOrEmpty(_overrideQuestionHeading))
                writer.Write("Questions:");
            else
                writer.Write(_overrideQuestionHeading);
            writer.RenderEndTag();

            if (Questions.Count > 0)
            {
                writer.RenderBeginTag(HtmlTextWriterTag.Ul);
                Questions.ForEach(q =>
                {
                    writer.RenderBeginTag(HtmlTextWriterTag.Li);
                    writer.Write(q.Text);
                    writer.RenderEndTag();
                });
                writer.RenderEndTag();
            }

            writer.RenderBeginTag(HtmlTextWriterTag.H3);
            writer.Write("Explanation:");
            writer.RenderEndTag();

            writer.RenderBeginTag(HtmlTextWriterTag.P);
            writer.Write(_explanation.Text);
            writer.RenderEndTag();

            if (!_hideSeparator)
            {
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "line");
                writer.RenderBeginTag(HtmlTextWriterTag.Div);
                writer.RenderEndTag();
            }
        }
    }
}
