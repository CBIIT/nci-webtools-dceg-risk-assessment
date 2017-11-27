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
    public partial class Q07 : Question

    {
        protected override void OnInit(EventArgs e)
        {
            SessionKey = Manager.race;
            ExplanationURL = "Q7ex.aspx";
            InputControl1 = this.race;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Manager.CurrentQuestion == "9" && Request.Form.Count > 0 && Manager.valSet)
                {
                    if (Manager.PreviousQuestion == "6")
                        Session[Manager.biopsy] = Request.Form[1];
                    else if (Manager.PreviousQuestion == "8")
                        Session[Manager.biopsyAH] = Request.Form[1];
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
        protected void race_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (race.SelectedIndex == 4)
            {
                lblSubmitQ9.Value = "Next";
            }
            else
            {
                lblSubmitQ9.Value = "Calculate Risk";

            }
        }

    }
}