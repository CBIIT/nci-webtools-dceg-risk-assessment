using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCMedicalHistory : CCRATUserControl
    {
        public string Colonoscopy
        {
            get
            {
                return this.rblColonoscopy.SelectedValue;
            }
            set
            {
                this.rblColonoscopy.SelectedValue = value;
            }
        }
        public string Polyp
        {
            get
            {
                return this.rblPolyp.SelectedValue;
            }
            set
            {
                this.rblPolyp.SelectedValue = value;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["FocusTab"] = "";

            if (!IsPostBack)
            {
                Session["MedicalHistValid"] = "True";

                this.rblColonoscopy.Attributes.Add("onClick", "javascript:showDivWithInput('" + this.rblColonoscopy.UniqueID + "','divappearHistory','Yes');");
                LoadControls();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { " +
                                "   showDivWithInput('" + this.rblColonoscopy.UniqueID + "','divappearHistory','Yes');" +
                                "      });</script>";

            if (!this.Page.ClientScript.IsClientScriptBlockRegistered("loadHistoryDiv"))
                this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadHistoryDiv", scriptDemo);
        }

        private void LoadControls()
        {


            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.Colonoscopy))
                    this.rblColonoscopy.SelectedValue = inputs[CCRATString.Colonoscopy];

                if (inputs.ContainsKey(CCRATString.Polyp))
                    this.rblPolyp.SelectedValue = inputs[CCRATString.Polyp];
            }
        }

        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = !(string.IsNullOrEmpty(this.rblPolyp.SelectedValue) && this.rblColonoscopy.SelectedIndex == 0);
            if (args.IsValid == false)
            {
                Session["FocusTab"] = "Medicaltab";
                //Session["MedicalHistValid"] = "False";
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMedical1", "<script>alert('Please select in the past 10 years did a healthcare provider tell you that you had a colon or rectal polyp');</script>");
            }
            rfvColon.Validate();
            if (rfvColon.IsValid == false)
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMedical2", "<script>alert('Please select during the past 10 years, did you have a colonoscopy,sigmoidoscopy, or both');</script>");
                Session["FocusTab"] = "Medicaltab";
            }



        }

        public override void Save()
        {

            SaveAnswer(CCRATString.Colonoscopy, this.Colonoscopy);
            SaveAnswer(CCRATString.Polyp, this.Polyp);
        }
    }
}