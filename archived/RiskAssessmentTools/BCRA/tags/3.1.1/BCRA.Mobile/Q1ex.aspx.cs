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

public partial class Q1ex : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        BCRA.Mobile.Manager.CurrentQuestion = "1";
        // Initialize all variables so we don't get object reference errors afterwards.
        //Session["age"] = "";
        //Session["menstage"] = "";
        //Session["birthage"] = "";
        //Session["relBC"] = "";
        //Session["biopsy"] = "";
        //Session["numBiopsy"] = "";
        //Session["ahBiopsy"] = "";
        //Session["ethnicity"] = "";
    }
}
