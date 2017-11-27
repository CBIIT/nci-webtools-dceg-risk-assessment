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

public partial class PageOptions : System.Web.UI.UserControl
{

    string emailTitle = "";
    string emailLink = "";

    public string EmailTitle
    {
        get { return emailTitle; }
        set { emailTitle = value; }
    }

    public string EmailLink
    {
        get { return emailLink; }
        set { emailLink = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string emailUrl = String.Format("PopEmail.aspx?language={0}&title={1}&docurl={2}", 1, System.Web.HttpUtility.UrlEncode(emailTitle.Replace("&#153;", "__tm;")), System.Web.HttpUtility.UrlEncode(this.Request.Url.ToString().Replace("&", "__amp;")));
        lnkEmail.HRef = emailUrl;
        lnkEmail.Attributes.Add("onclick", "popUp('" + emailUrl + "');return false;");
    }
}
