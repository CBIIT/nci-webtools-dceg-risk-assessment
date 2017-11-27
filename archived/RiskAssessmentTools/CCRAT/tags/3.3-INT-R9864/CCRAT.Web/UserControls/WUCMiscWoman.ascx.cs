using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCMiscWoman : CCRATUserControl
    {
        public string Period
        {
            get
            {
                return this.rblPeriod.SelectedValue;
            }
            set
            {
                this.rblPeriod.SelectedValue = value;
            }
        }
        public string UsedEstrogen
        {
            get
            {
                return this.rblUsedEstrogen.SelectedValue;
            }
            set
            {
                this.rblUsedEstrogen.SelectedValue = value;
            }
        }
        public string LastCycle
        {
            get
            {
                return this.ddlHowOld.SelectedValue;
            }
            set
            {
                this.ddlHowOld.SelectedValue = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["FocusTab"] = "";

            if (!IsPostBack)
            {
                Session["MisWomenValid"] = "True";

                this.rblPeriod.Attributes.Add("onClick", "javascript:showDivWithInput('" + this.rblPeriod.UniqueID + "','qLastCycle','No');");
                this.ddlHowOld.Attributes.Add("onChange", "javascript:showDivEstrogen(this.value,'usedEstrogen','" + this.rblUsedEstrogen.UniqueID + "');");

                LoadControls();
            }

        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showWomanMisc('" + this.rblPeriod.UniqueID + "','qLastCycle','Yes','"+this.LastCycle + "','usedEstrogen','" + this.rblUsedEstrogen.UniqueID + "');" +
                              "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadWomanDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadWomanDiv", scriptDemo);
        }

        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.LastCycle))
                    this.ddlHowOld.SelectedValue = inputs[CCRATString.LastCycle];

                if (inputs.ContainsKey(CCRATString.UsedEstrogen))
                    this.rblUsedEstrogen.SelectedValue = inputs[CCRATString.UsedEstrogen];

                if (inputs.ContainsKey(CCRATString.Period))
                    this.rblPeriod.SelectedValue = inputs[CCRATString.Period];
            }
        }

        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {

            rfvPeriod.Validate();
            if (rfvPeriod.IsValid == false)
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMiscwomen2", "<script>alert('Please select do you still have periods');</script>");
                Session["FocusTab"] = "Misctab";

            }

            args.IsValid = !(this.rblPeriod.SelectedIndex != 0 && this.ddlHowOld.SelectedIndex == 0);
            if (args.IsValid == false && rfvPeriod.IsValid == true)
            {
                //Session["MisWomenValid"] = "False";
                Session["FocusTab"] = "Misctab";

                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMiscwomen1", "<script>alert('Please select when did you have your last period');</script>");

            }


        }

        protected void ValidateControlEstrogen(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = (this.ddlHowOld.SelectedIndex == 3 && !string.IsNullOrEmpty(this.rblUsedEstrogen.SelectedValue)) 
                || (this.ddlHowOld.SelectedIndex != 3) ;
            if (args.IsValid == false)
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMiscwomen3", "<script>alert('Please select during the past 2 years, have you used estrogen, progestin, or other female hormones');</script>");
                Session["FocusTab"] = "Misctab";

            }
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.LastCycle, this.LastCycle);
            SaveAnswer(CCRATString.Period, this.Period);
            SaveAnswer(CCRATString.UsedEstrogen, this.UsedEstrogen);

            SaveAnswer(CCRATString.MoreThan100Cigs, string.Empty);
            SaveAnswer(CCRATString.StartSmoke, string.Empty);
            SaveAnswer(CCRATString.StillSmoke, string.Empty);
            SaveAnswer(CCRATString.SmokeQuit, string.Empty);
            SaveAnswer(CCRATString.CigNumPerDay, string.Empty);
        }
    }
}