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

namespace BCRA.Mobile
{
    public partial class Q07a : Question
    {
        protected override void OnInit(EventArgs e)
        {
            SessionKey = Manager.subrace;
            ExplanationURL = "Q7aex.aspx";
            InputControl = this.subrace;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Manager.CurrentQuestion == "10" && Request.Form.Count > 0 && Manager.valSet)
            {
                if (Manager.PreviousQuestion == "10")
                    Session[Manager.subrace] = Request.Form[1];
                else if (Manager.PreviousQuestion == "9")
                    Session[Manager.race] = Request.Form[1];

                //Session[Manager.subrace] = Request.Form[1];

            }

            //select previous value if any
            if (Manager.valSet == true)
            {
                SetPreviousValue();
            }
            else
            {
                Session[SessionKey] = null;
            }
        }
    }
}