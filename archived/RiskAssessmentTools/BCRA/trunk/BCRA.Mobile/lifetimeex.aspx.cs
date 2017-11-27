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

public partial class lifetimeex : System.Web.UI.Page
{
    protected double lifetimeRiskThisWoman = 0;
    protected double lifetimeRiskAvgWoman = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        lifetimeRiskThisWoman = (double.Parse)(Session["lifetimeRiskThisWoman"].ToString());
        lifetimeRiskAvgWoman = (double.Parse)(Session["lifetimeRiskAvgWoman"].ToString());
    }
}
