using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Specialized;
namespace BCRA.Mobile
{
    public partial class Q00 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            LoadQuestion(this.phUserControl);
        }

        /// <summary>
        /// Loads current question 
        /// </summary>
        /// <param name="phUserControl"></param>
        private void LoadQuestion(PlaceHolder phUserControl)
        {
            bool valueSet;
            try
            {
                Question ctrl = (Question)LoadControl(Manager.GetQuestionToLoad(out valueSet));
                phUserControl.Controls.Add(ctrl);
                if (valueSet == false)
                {
                    lblError.Visible = true;
                    // HttpContext.Current.Response.Write(Manager.GetErrorMessage());
                }
            }
            catch (System.Threading.ThreadAbortException ex)
            {
                ; //this was caused by transfer/execute and can be ignored            
            }
        }
    }
}
