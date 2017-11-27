using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace CCRAT.Web
{
    public partial class tool : System.Web.UI.Page
    {
        Dictionary<string, string> inputs;

        protected void Page_Load(object sender, EventArgs e)
        {

        }



        protected void btnCancel_click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect(this.Page.Request.Url.ToString());
        }

        protected void btnNextToDiet_click(object sender, ImageClickEventArgs e)
        {
            //Check input's validity
            if (Page.IsValid)
            {
                //Save the input in Session variable
                this.WUCDemo.Save();
                //Go to next page
                this.mvQuestion.ActiveViewIndex = 1;
            }
        }

 
        protected void btnNextToHistory_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                this.WUCDiet.Save();

                this.mvQuestion.ActiveViewIndex = 2;
            }
        }


        protected void btnNextToMedication_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                this.WUCMedicalHistory.Save();

                this.mvQuestion.ActiveViewIndex = 3;
            }
        }



        protected void btnNextToPhysical_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                this.WUCMedication.Save();

                this.mvQuestion.ActiveViewIndex = 4;
            }
        }


        protected void btnNextToMisc_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                this.WUCPhysicalActivity.Save();

                //Switch view depending on gender
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
                if (inputs[CCRATString.Gender].ToLower() == "male")
                {
                    this.WUCMiscellaneous.Visible = true;
                    this.WUCMiscWoman.Visible = false;
                }
                else
                {
                    this.WUCMiscellaneous.Visible = false;
                    this.WUCMiscWoman.Visible = true;
                }
                this.mvQuestion.ActiveViewIndex = 5;
            }
        }
       

        protected void btnNextToFamily_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
                if (inputs[CCRATString.Gender].ToLower() == "male")
                {
                   this.WUCMiscellaneous.Save();
                }
                else
                {
                    this.WUCMiscWoman.Save();
                }

                this.mvQuestion.ActiveViewIndex = 6;
            }
        }
  
        protected void btnBack_click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                this.mvQuestion.ActiveViewIndex = this.mvQuestion.ActiveViewIndex - 1;
            }
        }

        protected void btnCalculate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid && Session[CCRATString.CCRAT] != null)
            {
                this.WUCFamily.Save();

                Response.Redirect("result.aspx");
            }
        }
       

    }
}
