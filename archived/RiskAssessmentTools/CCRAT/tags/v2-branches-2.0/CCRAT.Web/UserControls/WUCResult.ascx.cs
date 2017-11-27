using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace CCRAT.Web.UserControls
{
    public partial class WUCResult : System.Web.UI.UserControl
    {
        public string InputHigh { get; set; }
        public string InputLow { get; set; }
        public string InputHighRound { get; set; }
        public string InputLowRound { get; set; }
        public string InputAvg { get; set; }
        public string Years { get; set; }
        public string Comparison { get; set; }
        public string Age { get; set; }
        public string PeopleTotal { get; set; }
        public string Race { get; set; }
        public string Gender { get; set; }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
           
      
        }
    }
}