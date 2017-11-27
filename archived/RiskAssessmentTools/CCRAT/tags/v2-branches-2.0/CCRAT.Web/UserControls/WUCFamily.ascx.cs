using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCFamily : CCRATUserControl
    {


        public string HasRelativeHadCC
        {
            get
            {
                return this.rblRelativescancer.SelectedValue;
            }
            set
            {
                this.rblRelativescancer.SelectedValue = value;
            }
        }
        public string NumRelativesHavingCC
        {
            get
            {
                return this.rblRelativescancerAmt.SelectedValue;
            }
            set
            {
                this.rblRelativescancerAmt.SelectedValue = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.rblRelativescancer.Attributes.Add("onClick", "javascript:showDivWithInput('" + this.rblRelativescancer.UniqueID + "','divappearFamily','Yes');");
                LoadControls();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showDivWithInput('" + this.rblRelativescancer.UniqueID + "','divappearFamily','Yes');" +
                                "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadFamilyDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadFamilyDiv", scriptDemo);
        }

        private void LoadControls()
        {

            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.NumRelativesHavingCC))
                    this.rblRelativescancerAmt.SelectedValue = inputs[CCRATString.NumRelativesHavingCC];


                if (inputs.ContainsKey(CCRATString.HasRelativeHadCC))
                    this.rblRelativescancer.SelectedValue = inputs[CCRATString.HasRelativeHadCC];
            }
        }
        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(this.rblRelativescancer.SelectedIndex == 0 && string.IsNullOrEmpty(this.rblRelativescancerAmt.SelectedValue));
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.NumRelativesHavingCC, this.NumRelativesHavingCC);
            SaveAnswer(CCRATString.HasRelativeHadCC, this.HasRelativeHadCC);
        }
    }
}