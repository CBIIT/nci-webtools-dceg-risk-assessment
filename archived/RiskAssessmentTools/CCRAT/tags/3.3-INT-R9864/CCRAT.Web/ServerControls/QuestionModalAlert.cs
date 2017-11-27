using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT
{
    [ParseChildren(false)]
    [ToolboxData("<{0}:QuestionModalAlert runat=server></{0}:QuestionModalAlert>")]
    public class QuestionModalAlert : QuestionItemBase
    {
        private string _associatedQuestionControlID = string.Empty;
        private string _showIfValue = string.Empty;
        private bool _canShow = false;

        public string AssociatedQuestionControlID
        {
            get { return _associatedQuestionControlID; }
            set { _associatedQuestionControlID = value; }
        }

        public string ShowIfValue
        {
            get { return _showIfValue; }
            set { _showIfValue = value; }
        }

        public bool CanShow
        {
            get { return _canShow; }
            set { _canShow = value; }
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

        private QuestionGroup ParentGroup
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

        private QuestionControl AssociatedQuestionControl
        {
            get
            {
                QuestionControl associatedQuestionControl = null;

                if (ParentGroup != null)
                {
                    //See if the Parent Group we are in has the associated question control.
                    //(It should)
                    associatedQuestionControl =
                        ParentGroup.Questions.SingleOrDefault(
                            question => question.ID == AssociatedQuestionControlID);

                    if (associatedQuestionControl == null)
                        throw new Exception("Could not find associated question control with the ID: " + AssociatedQuestionControlID);
                }
                else
                {
                    throw new Exception("Could not find parent question group of this QuestionModalAlert");
                }

                return associatedQuestionControl;
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            if (_canShow && AssociatedQuestionControl.Answer == _showIfValue)
            {
                this.Style.Add(HtmlTextWriterStyle.Display, "none");
                this.Style.Add(HtmlTextWriterStyle.Direction, "ltr");
                base.Render(writer);
            }
        }

        public override void RenderBeginTag(HtmlTextWriter writer)
        {
            
            base.RenderBeginTag(writer);

            //Anchor for focus
            writer.AddAttribute(HtmlTextWriterAttribute.Class, "focus-anchor");
            writer.AddAttribute(HtmlTextWriterAttribute.Id, ClientID + ClientIDSeparator + "focusAnchor");
            writer.AddAttribute(HtmlTextWriterAttribute.Name, UniqueID + IdSeparator + "focusAnchor");
            writer.RenderBeginTag(HtmlTextWriterTag.A);
            writer.Write("&nbsp;");
            writer.RenderEndTag();

            writer.RenderBeginTag(HtmlTextWriterTag.H3);
            writer.Write("Important Information");
            writer.RenderEndTag();

            writer.AddAttribute(HtmlTextWriterAttribute.Class, "contents");
            writer.RenderBeginTag(HtmlTextWriterTag.Div);
        }

        public override void RenderEndTag(HtmlTextWriter writer)
        {

            writer.RenderEndTag();

            //Close Link

            writer.AddAttribute(HtmlTextWriterAttribute.Class, "close-area");
            writer.RenderBeginTag(HtmlTextWriterTag.Div);
            writer.AddAttribute(HtmlTextWriterAttribute.Id, this.ClientID + this.ClientIDSeparator + "closeLink");
            writer.AddAttribute(HtmlTextWriterAttribute.Href, "#");
            writer.AddAttribute(HtmlTextWriterAttribute.Title, "Please continue");
            writer.RenderBeginTag(HtmlTextWriterTag.A);
            writer.Write("Please continue");
            writer.RenderEndTag();
            writer.RenderEndTag();
            
            base.RenderEndTag(writer);
            RenderScriptBlock(writer);
        }

        private void RenderScriptBlock(HtmlTextWriter output)
        {
            output.AddAttribute(HtmlTextWriterAttribute.Type, "text/javascript");
            output.RenderBeginTag(HtmlTextWriterTag.Script);

            //output.Write("var ");
            //output.Write(ClientID);
            //output.Write("_obj = new ModalPopup('");
            //output.Write(ClientID);
            //output.Write("', ");
            //output.Write("false"); //Open item client id.  No need since we will open it.
            //output.Write(", ");
            //output.Write("'");
            //output.Write(this.ClientID + this.ClientIDSeparator + "closeLink");
            //output.Write("', ");

            //Options
//            output.Write("{");

            //output.Write(String.Format("width: {0},", "200"));
            //output.Write(String.Format("height: {0}", "200"));

            /*
            output.Write(String.Format("overlayOpacity: {0}, ", OverlayOpacity.ToString()));
            output.Write(String.Format("zIndex: {0}", ZIndex.ToString()));

            if (OverlayColor != Color.Empty)
                output.Write(String.Format(", overlayBackgroundColor: '{0}'", ColorTranslator.ToHtml(OverlayColor)));

            if (!string.IsNullOrEmpty(OnClientBeforeOpen))
                output.Write(RenderCallback("beforeOpen", OnClientBeforeOpen));

            if (!string.IsNullOrEmpty(OnClientAfterOpen))
                output.Write(RenderCallback("afterOpen", OnClientAfterOpen));

            if (!string.IsNullOrEmpty(OnClientBeforeClose))
                output.Write(RenderCallback("beforeClose", OnClientBeforeClose));

            if (!string.IsNullOrEmpty(OnClientAfterClose))
                output.Write(RenderCallback("afterClose", OnClientAfterClose));
            */
            //output.Write("});");
            //output.Write("document.observe('dom:loaded', function() {");
            //output.Write(ClientID);
            //output.Write("_obj.open();});");

            output.Write(string.Format(@"
                var {0}_obj = new ModalPopup('{0}', false, '{0}{1}closeLink', {{}});
                document.observe('dom:loaded', function() {{
                    {0}_obj.open();
                    document.location = ""#{2}{3}focusAnchor"";
                }});
            ", ClientID, ClientIDSeparator, UniqueID, IdSeparator));


            output.RenderEndTag();
        }
    }
}
