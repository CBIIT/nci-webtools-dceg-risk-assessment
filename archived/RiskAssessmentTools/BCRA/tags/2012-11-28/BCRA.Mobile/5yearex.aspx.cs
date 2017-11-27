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

public partial class _5yearex : System.Web.UI.Page
{
    protected double fiveYearRiskThisWoman = 0;
    protected double fiveYearRiskAvgWoman = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        fiveYearRiskThisWoman = double.Parse(Session["fiveYearRiskThisWoman"].ToString());
        fiveYearRiskAvgWoman = double.Parse(Session["fiveYearRiskAvgWoman"].ToString());
    }
}
