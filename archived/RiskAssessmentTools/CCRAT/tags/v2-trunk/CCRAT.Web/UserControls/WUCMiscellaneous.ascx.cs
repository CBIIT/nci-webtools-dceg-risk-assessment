using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCMiscellaneous : CCRATUserControl
    {
        public string MoreThan100Cigs
        {
            get
            {
                return this.rblSmoked.SelectedValue;
            }
            set
            {
                this.rblSmoked.SelectedValue = value;
            }
        }
        public string StartSmoke
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
        public string StillSmoke
        {
            get
            {
                return this.rblSmokenow.SelectedValue;
            }
            set
            {
                this.rblSmokenow.SelectedValue = value;
            }
        }
        public string SmokeQuit
        {
            get
            {
                return this.ddlHowOldQuit.SelectedValue;
            }
            set
            {
                this.ddlHowOldQuit.SelectedValue = value;
            }
        }
        public string CigNumPerDay
        {
            get
            {
                return this.ddlAmtSmokeADay.SelectedValue;
            }
            set
            {
                this.ddlAmtSmokeADay.SelectedValue = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ///Fill in moderate activities
                this.ddlHowOld.Items.Add(new ListItem("-Select-", "NAN"));
                this.ddlHowOld.Items.Add(new ListItem("I have never smoked cigarettes regularly", "1"));
                                              
                for (int i = 6; i < 55; i++)
                {
                    ddlHowOld.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                ///Fill in moderate activities
                this.ddlHowOldQuit.Items.Add(new ListItem("-Select-", "NAN"));

                for (int i = 16; i < 55; i++)
                {
                    ddlHowOldQuit.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                this.rblSmoked.Attributes.Add("onClick", "javascript:showDivWithInput('" + this.rblSmoked.UniqueID + "','agestarted','Yes');");
                this.ddlHowOld.Attributes.Add("onChange", "javascript:showagestarted(this.value);");
                this.rblSmokenow.Attributes.Add("onClick", "javascript:showDivWithInput('" + this.rblSmokenow.UniqueID + "','agequit','No');");

                LoadControls();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showDivWithSmoke('" + this.rblSmoked.UniqueID + "','agestarted','Yes','" + this.StartSmoke + "','" + this.rblSmokenow.UniqueID + "','agequit','No');" +
                                "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadMiscDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadMiscDiv", scriptDemo);
        }

        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.CigNumPerDay))
                    this.ddlAmtSmokeADay.SelectedValue = inputs[CCRATString.CigNumPerDay];

                if (inputs.ContainsKey(CCRATString.SmokeQuit))
                    this.ddlHowOldQuit.SelectedValue = inputs[CCRATString.SmokeQuit];

                if (inputs.ContainsKey(CCRATString.StillSmoke))
                    this.rblSmokenow.SelectedValue = inputs[CCRATString.StillSmoke];

                if (inputs.ContainsKey(CCRATString.StartSmoke))
                    this.ddlHowOld.SelectedValue = inputs[CCRATString.StartSmoke];

                if (inputs.ContainsKey(CCRATString.MoreThan100Cigs))
                this.rblSmoked.SelectedValue = inputs[CCRATString.MoreThan100Cigs];
            }
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.MoreThan100Cigs, this.MoreThan100Cigs);
            SaveAnswer(CCRATString.StartSmoke, this.StartSmoke);
            SaveAnswer(CCRATString.StillSmoke, this.StillSmoke);
            SaveAnswer(CCRATString.SmokeQuit, this.SmokeQuit);
            SaveAnswer(CCRATString.CigNumPerDay, this.CigNumPerDay);

            SaveAnswer(CCRATString.LastCycle, string.Empty);
            SaveAnswer(CCRATString.Period, string.Empty);
            SaveAnswer(CCRATString.UsedEstrogen, string.Empty);
        }

        protected void ValidateControlSmokeStart(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(this.rblSmoked.SelectedIndex == 0 && this.ddlHowOld.SelectedIndex == 0);
        }

        protected void ValidateControlCurrentSmoke(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(this.ddlHowOld.SelectedIndex > 1 && string.IsNullOrEmpty(this.rblSmokenow.SelectedValue));
           
        }

        protected void ValidateControlQuit(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(this.rblSmokenow.SelectedIndex == 1 && this.ddlHowOldQuit.SelectedIndex == 0);
        }
        protected void ValidateControlSmokeAmt(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(this.ddlHowOld.SelectedIndex > 1 && this.ddlAmtSmokeADay.SelectedIndex == 0);

        }
    }
}