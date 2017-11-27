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
    public partial class Q03 : Question
    {
        protected override void OnInit(EventArgs e)
        {
            SessionKey = Manager.ageMP;
            ExplanationURL = "Q3ex.aspx";
            InputControl = this.ageMP;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Manager.CurrentQuestion == "3" && Request.Form.Count > 0 && Manager.valSet)
                {
                    Session[Manager.age] = Request.Form[1];
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
}