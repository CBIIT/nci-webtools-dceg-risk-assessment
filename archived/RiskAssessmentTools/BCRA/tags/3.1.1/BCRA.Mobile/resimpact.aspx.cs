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
using NCI.DCEG.BCRA;
using NCI.BCPT.Engine;

public partial class resimpact : System.Web.UI.Page
{
    protected string race = String.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        int intRace = Convert.ToInt32((Session["race"]));
        switch (intRace)
        {
            case 1:
                race = "White";
                break;
            case 2:
                race = "African American";
                this.lblBlack.Visible = true;
                break;
            case 3:
                race = "Hispanic";
                this.lblHispanic.Visible = true;
                break;
            case 4:
                race = "Asian or Pacific Islander";
                this.lblAsianOrPI.Visible = true;
                break;
            case 5:
                race = "American Indian or Alaskan Native";
                this.lblAmIndianOrAN.Visible = true;
                break;
            case 6:
                race = "Unknown";
                this.lblUnknown.Visible = true;
                break;
            default:
                race = "Unknown";
                this.lblUnknown.Visible = true;
                break;
        }

    }
}
