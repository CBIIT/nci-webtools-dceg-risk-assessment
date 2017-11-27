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
    public class QuestionSeparator : QuestionItemBase
    {
        /// <summary>
        /// Gets or Sets a flag indicating if this QuestionSeparator is a section separator.
        /// </summary>
        public bool IsSectionSeparator
        {
            get { return (bool)(ViewState["IsSectionSeparator"] ?? false); }
            set { ViewState["IsSectionSeparator"] = value; }
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

        protected override void AddAttributesToRender(HtmlTextWriter writer)
        {
            base.AddAttributesToRender(writer);
            if (IsSectionSeparator && GroupManager.DisplayMode != QuestionDisplayModes.Results)
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "questionSectionSeparator");
            else
                writer.AddAttribute(HtmlTextWriterAttribute.Class, "questionSeparator");
        }
    }
}
