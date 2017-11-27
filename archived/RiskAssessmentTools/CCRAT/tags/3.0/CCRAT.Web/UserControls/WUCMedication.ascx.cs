using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCMedication : CCRATUserControl
    {
        public string Aspirin
        {
            get
            {
                return this.rblAspirin.SelectedValue;
            }
            set
            {
                this.rblAspirin.SelectedValue = value;
            }
        }

        public string Ibuprofen
        {
            get
            {
                return this.rblNoaspirin.SelectedValue;
            }
            set
            {
                this.rblNoaspirin.SelectedValue = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["MedicationValid"] = "True";
                LoadControls();
            }
        }

        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                if (inputs.ContainsKey(CCRATString.Ibuprofen))
                    this.rblNoaspirin.SelectedValue = inputs[CCRATString.Ibuprofen];

                if (inputs.ContainsKey(CCRATString.Aspirin))
                    this.rblAspirin.SelectedValue = inputs[CCRATString.Aspirin];
            }
        }

        public override void Save()
        {
            SaveAnswer(CCRATString.Aspirin, this.Aspirin);
            SaveAnswer(CCRATString.Ibuprofen, this.Ibuprofen);
        }

        protected void ValidateControl(object sender, ServerValidateEventArgs args)
        {
            rfvMedAspirin.Validate();
            rfvMedNoAspirin.Validate();

            if (rfvMedAspirin.IsValid == false)
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMedication1", "<script>alert('Please select have you taken medications containing aspirin.');</script>");
                Session["FocusTab"] = "Medicationtab";
            }
            if (rfvMedNoAspirin.IsValid == false)
            {
                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CustomValidationMedication2", "<script>alert('Please select in the past 30 days have you taken medications that do not contain aspirin');</script>");
                Session["FocusTab"] = "Medicationtab";
            }

        }
    }
}