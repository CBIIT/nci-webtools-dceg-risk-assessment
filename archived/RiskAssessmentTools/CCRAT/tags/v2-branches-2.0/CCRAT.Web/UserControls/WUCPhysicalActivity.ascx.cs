using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCPhysicalActivity : CCRATUserControl
    {
        public string ModerateActivities
        {
            get
            {
                return this.ddlModerateActivities.SelectedValue;
            }
            set
            {
                this.ddlModerateActivities.SelectedValue = value;
            }
        }

        public string ModerateHours
        {
            get
            {
                return this.ddlMod.SelectedValue;
            }
            set
            {
                this.ddlMod.SelectedValue = value;
            }
        }
        public string VigorousActivities
        {
            get
            {
                return this.ddlVigorousActivities.SelectedValue;
            }
            set
            {
                this.ddlVigorousActivities.SelectedValue = value;
            }
        }

        public string VigorousHours
        {
            get
            {
                return this.ddlVig.SelectedValue;
            }
            set
            {
                this.ddlVig.SelectedValue = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ////Fill in moderate activities
                ddlModerateActivities.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 0; i < 13; i++)
                {
                    ddlModerateActivities.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                ddlVigorousActivities.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 0; i < 13; i++)
                {
                    ddlVigorousActivities.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }
                this.ddlModerateActivities.Attributes.Add("onChange", "javascript:showDiv(this.value,'modappear','"+ this.ddlMod.ClientID+"');");
                this.ddlVigorousActivities.Attributes.Add("onChange", "javascript:showDiv(this.value,'vigappear','"+ this.ddlVig.ClientID + "');");

                LoadControls();
            }
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showDiv('"+ this.ModerateActivities + "','modappear','" + this.ddlMod.ClientID + "');" +
                                "   showDiv('"+ this.VigorousActivities + "','vigappear','" + this.ddlVig.ClientID + "');" +
                                "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadWomanDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadWomanDiv", scriptDemo);
        }
        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.ModerateActivities))
                    this.ddlModerateActivities.SelectedValue = inputs[CCRATString.ModerateActivities];

                if (inputs.ContainsKey(CCRATString.ModerateHours))
                    this.ddlMod.SelectedValue = inputs[CCRATString.ModerateHours];

                if (inputs.ContainsKey(CCRATString.VigorousActivities))
                    this.ddlVigorousActivities.SelectedValue = inputs[CCRATString.VigorousActivities];

                if (inputs.ContainsKey(CCRATString.VigorousHours))
                    this.ddlVig.SelectedValue = inputs[CCRATString.VigorousHours];
            }
        }


        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {
            if (this.ddlModerateActivities.SelectedValue !="0" && this.ddlMod.SelectedIndex == 0)
            {
                args.IsValid = false;
            }
        }

        protected void ValidateControlVig(object sender, ServerValidateEventArgs args)
        {
            if (this.ddlVigorousActivities.SelectedValue != "0" && this.ddlVig.SelectedIndex == 0)
            {
                args.IsValid = false;
            }
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.ModerateActivities, this.ModerateActivities);
            SaveAnswer(CCRATString.ModerateHours, this.ModerateHours);
            SaveAnswer(CCRATString.VigorousActivities, this.VigorousActivities);
            SaveAnswer(CCRATString.VigorousHours, this.VigorousHours);
        }
    }
}