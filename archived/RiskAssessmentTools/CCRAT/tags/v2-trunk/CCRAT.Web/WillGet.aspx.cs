using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCRAT.Web
{
    public partial class WillGet : System.Web.UI.Page
    {
        public string Hispanic { get; set; }
        public string Race { get; set; }
        public string Gender { get; set; }
        public string Feet { get; set; }
        public string Inch { get; set; }
        public string Weight { get; set; }
        public string Age { get; set; }

        public string Veggie { get; set; }
        public string Colonoscopy { get; set; }
        public string Aspirin { get; set; }
        public string Ibuprofen { get; set; }

        public string ModerateActivities { get; set; }
        public string ModerateHours { get; set; }
        public string VigorousActivities { get; set; }
        public string VigorousHours { get; set; }

        public string MoreThan100Cigs { get; set; }
        public string HasRelativeHadCC { get; set; }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[CCRATString.CCRAT] != null)
                {
                    Dictionary<string, string> inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];

                    if (inputs.ContainsKey(CCRATString.Hispanic))
                    {
                        this.Race = CCRATString.Hispanic;
                    }
                    else
                    {
                        if (inputs.ContainsKey(CCRATString.Race))
                            this.Race = inputs[CCRATString.Race];
                    }

                    if (inputs.ContainsKey(CCRATString.Gender))
                        this.Gender = inputs[CCRATString.Gender];

                    if (inputs.ContainsKey(CCRATString.Feet))
                        this.Feet = inputs[CCRATString.Feet];

                    if (inputs.ContainsKey(CCRATString.Inch))
                        this.Inch = inputs[CCRATString.Inch];

                    if (inputs.ContainsKey(CCRATString.Weight))
                        this.Weight = inputs[CCRATString.Weight];

                    if (inputs.ContainsKey(CCRATString.Age))
                        this.Age = inputs[CCRATString.Age];


                    if (inputs.ContainsKey(CCRATString.Veggie))
                        this.Veggie = inputs[CCRATString.Veggie];

                    if (inputs.ContainsKey(CCRATString.Colonoscopy))
                        this.Colonoscopy = inputs[CCRATString.Colonoscopy];

                    if (inputs.ContainsKey(CCRATString.Aspirin))
                        this.Aspirin = inputs[CCRATString.Aspirin];

                    if (inputs.ContainsKey(CCRATString.Ibuprofen))
                        this.Ibuprofen = inputs[CCRATString.Ibuprofen];

              
                    if (inputs.ContainsKey(CCRATString.ModerateActivities))
                        this.ModerateActivities = inputs[CCRATString.ModerateActivities];

                    if (inputs.ContainsKey(CCRATString.ModerateHours))
                        this.ModerateHours = inputs[CCRATString.ModerateHours];

                    if (inputs.ContainsKey(CCRATString.VigorousActivities))
                        this.VigorousActivities = inputs[CCRATString.VigorousActivities];

                    if (inputs.ContainsKey(CCRATString.VigorousHours))
                        this.VigorousHours = inputs[CCRATString.VigorousHours];

                    if (inputs.ContainsKey(CCRATString.MoreThan100Cigs))
                        this.MoreThan100Cigs = inputs[CCRATString.MoreThan100Cigs];

                    if (inputs.ContainsKey(CCRATString.HasRelativeHadCC))
                        this.HasRelativeHadCC = inputs[CCRATString.HasRelativeHadCC];
                }
            }
        }
    }
}
