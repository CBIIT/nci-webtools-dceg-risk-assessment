using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCDiet : CCRATUserControl
    {
        public string Veggie
        {
            get
            {
                return this.ddlVeggie.SelectedValue;
            }
            set
            {
                this.ddlVeggie.SelectedValue = value;
            }
        }
        public string VeggieAmount
        {
            get
            {
                return this.ddlVeggieAmt.SelectedValue;
            }
            set
            {
                this.ddlVeggieAmt.SelectedValue = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.ddlVeggie.Attributes.Add("onChange", "javascript:showDiv(this.value,'divappearDiet','" + this.ddlVeggieAmt.ClientID + "');");



                LoadControls();
            }

        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showDiv('"+ this.Veggie +"','divappearDiet','" + this.ddlVeggieAmt.ClientID + "');" +
                                "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadDietDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadDietDiv", scriptDemo);
        }


        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.Veggie))
                    this.ddlVeggie.SelectedValue = inputs[CCRATString.Veggie];

                if (inputs.ContainsKey(CCRATString.VeggieAmount))
                    this.ddlVeggieAmt.SelectedValue = inputs[CCRATString.VeggieAmount];
            }
        }

        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {
            if (this.ddlVeggie.SelectedIndex > 1 && this.ddlVeggieAmt.SelectedIndex == 0)
            {
                args.IsValid = false;
            }
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.Veggie, this.Veggie);
            SaveAnswer(CCRATString.VeggieAmount, this.VeggieAmount);
        }
    }
}