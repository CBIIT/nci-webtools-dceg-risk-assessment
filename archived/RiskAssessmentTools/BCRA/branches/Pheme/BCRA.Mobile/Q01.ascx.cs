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
    public partial class Q01 : Question
    {
        protected override void OnInit(EventArgs e)
        {
            //SessionKey = Manager.historyOfBC;
            ExplanationURL = "Q1ex.aspx";
            //InputControl = this.historyOfBC;
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                if (Request.QueryString.Count > 0 && bool.Parse(Request.QueryString["restart"]))
                {
                    Manager.ClearSession();
                    Manager.ResetSessionVars();
                }
                //else
                //{
                //    SetPreviousValue();
                //}
                Manager.CurrentQuestion = "1";
            }
            
        }
    }
}