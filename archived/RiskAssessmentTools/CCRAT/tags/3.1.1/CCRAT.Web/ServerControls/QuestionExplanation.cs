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
    [ParseChildren(false)]
    public class QuestionExplanation : QuestionItemBase
    {

        protected override void Render(HtmlTextWriter writer)
        {
            if (this.Controls.Count > 0)
                base.Render(writer);
        }

        protected override void AddAttributesToRender(HtmlTextWriter writer)
        {
            base.AddAttributesToRender(writer);
            writer.AddStyleAttribute(HtmlTextWriterStyle.Display, "none");
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "helpText");
        }

        protected override void RenderContents(HtmlTextWriter writer)
        {            
            writer.AddStyleAttribute(HtmlTextWriterStyle.MarginRight, "5px");
            writer.AddAttribute(HtmlTextWriterAttribute.Src, "images/helplink_image.gif");
            writer.AddAttribute(HtmlTextWriterAttribute.Alt, "");
            writer.AddAttribute(HtmlTextWriterAttribute.Align, "left");
            writer.RenderBeginTag(HtmlTextWriterTag.Img);
            writer.RenderEndTag();

            base.RenderContents(writer);

            writer.AddAttribute(HtmlTextWriterAttribute.Href, "#" + this.ClientID + this.ClientIDSeparator + "helpLink");
            writer.AddAttribute(HtmlTextWriterAttribute.Onclick, "ToggleHelpLink('" + this.ClientID + "'); return false;");
            writer.AddAttribute(HtmlTextWriterAttribute.Id, this.ClientID + this.ClientIDSeparator + "helpLink");
            writer.RenderBeginTag(HtmlTextWriterTag.A);
            writer.Write("Hide Explanation");
            writer.RenderEndTag();
        }
    }
}
