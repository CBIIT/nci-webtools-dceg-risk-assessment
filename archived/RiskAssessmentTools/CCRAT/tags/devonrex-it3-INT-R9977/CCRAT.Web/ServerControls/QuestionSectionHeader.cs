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

namespace CCRAT
{
    public class QuestionSectionHeader : QuestionItemBase
    {
        /// <summary>
        /// Gets or sets the question text.
        /// </summary>
        public string SectionText
        {
            get
            {
                return (string)ViewState["SectionText"] ?? string.Empty;
            }
            set
            {
                ViewState["SectionText"] = value;
            }
        }

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


        protected override void Render(HtmlTextWriter writer)
        {
            if (GroupManager.DisplayMode != QuestionDisplayModes.Results)
                RenderContents(writer);
        }

        protected override void RenderContents(HtmlTextWriter writer)
        {            
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "SectionHeader");
            writer.RenderBeginTag(HtmlTextWriterTag.Div);
            writer.Write(SectionText);
            writer.RenderEndTag();
        }
    }
}
