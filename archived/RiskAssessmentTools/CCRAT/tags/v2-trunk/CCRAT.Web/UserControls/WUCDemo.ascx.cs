using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCDemo : CCRATUserControl
    {
        #region property 
        public string Gender {
            get
            {
               return this.rblSex.SelectedValue;
            }
            set
            {
               this.rblSex.SelectedValue = value  ;
            }
        }
        public string Race
        {
            get
            {
                return this.rblRace.SelectedValue;
            }
            set
            {
                this.rblRace.SelectedValue = value;
            }
        }
        public string Hispanic
        {
            get
            {
                return this.rblhispanic.SelectedValue;
            }
            set
            {
                this.rblhispanic.SelectedValue = value;
            }
        }
        public string Age
        {
            get
            {
                return this.ddlCurrentAge.SelectedValue;
            }
            set
            {
                this.ddlCurrentAge.SelectedValue = value;
            }
        }
        public string Feet
        {
            get
            {
                return this.txtFeet.Text;
            }
            set
            {
                this.txtFeet.Text = value;
            }
        }
        public string Inch
        {
            get
            {
                return this.txtInch.Text;
            }
            set
            {
                this.txtInch.Text = value;
            }
        }
        public string Weight
        {
            get
            {
                return this.txtWeight.Text;
            }
            set
            {
                this.txtWeight.Text = value;
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Fill in current age
                ddlCurrentAge.Items.Add(new ListItem("Select", "NAN"));
                for (int i = 50; i < 86; i++)
                {
                    ddlCurrentAge.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                this.rblhispanic.Attributes.Add("onChange", "javascript:showDivWithInput('" + this.rblhispanic.UniqueID + "','qdivRace','No');");


                LoadControls();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
                string scriptDemo = "   <script type=\"text/javascript\">$(document).ready(function() { "+
                                    "   showDivHispanic('" + rblhispanic.UniqueID + "', 'qdivRace', 'No'); " +
                                    "      });</script>";

                if(!this.Page.ClientScript.IsClientScriptBlockRegistered("loadDemoDiv"))
                    this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "loadDemoDiv", scriptDemo);
        }

        private void LoadControls()
        {
            if (Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
                if (inputs.ContainsKey(CCRATString.Hispanic))
                    this.rblhispanic.SelectedValue = inputs[CCRATString.Hispanic];

                if (inputs.ContainsKey(CCRATString.Race))
                    this.rblRace.SelectedValue = inputs[CCRATString.Race];

                if (inputs.ContainsKey(CCRATString.Gender))
                    this.rblSex.SelectedValue = inputs[CCRATString.Gender];

                if (inputs.ContainsKey(CCRATString.Age))
                    this.ddlCurrentAge.SelectedValue = inputs[CCRATString.Age];

                if (inputs.ContainsKey(CCRATString.Feet))
                    this.txtFeet.Text = inputs[CCRATString.Feet];

                if (inputs.ContainsKey(CCRATString.Inch))
                    this.txtInch.Text = inputs[CCRATString.Inch];

                if (inputs.ContainsKey(CCRATString.Weight))
                    this.txtWeight.Text = inputs[CCRATString.Weight];
            }
        }

        protected void ValidateRace(object sender, ServerValidateEventArgs args)
        {
            args.IsValid = (this.rblhispanic.SelectedIndex == 0 || (this.rblhispanic.SelectedIndex == 1 && !string.IsNullOrEmpty(this.rblRace.SelectedValue)));

            //  args.IsValid = (this.rblhispanic.SelectedIndex==0 || (this.rblhispanic.SelectedIndex==1 && !string.IsNullOrEmpty(this.rblRace.SelectedValue)));

        }

        public override void Save()
        {
            SaveAnswer(CCRATString.Race, this.Race);
            SaveAnswer(CCRATString.Gender, this.Gender);
            SaveAnswer(CCRATString.Age, this.Age);
            SaveAnswer(CCRATString.Hispanic, this.Hispanic);
            SaveAnswer(CCRATString.Feet, this.Feet);
            SaveAnswer(CCRATString.Inch, this.Inch);
            SaveAnswer(CCRATString.Weight, this.Weight);
        }
    }
}