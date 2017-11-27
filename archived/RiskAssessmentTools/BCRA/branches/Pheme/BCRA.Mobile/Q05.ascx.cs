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
    public partial class Q05 : Question
    {
        protected override void OnInit(EventArgs e)
        {
            SessionKey = Manager.relativeNum;
            ExplanationURL = "Q5ex.aspx";
            InputControl = this.relativeNum;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Manager.CurrentQuestion == "5" && Request.Form.Count > 0 && Manager.valSet)
            {
                Session[Manager.ageLB] = Request.Form[1];
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