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

namespace MRAT.Mobile
{
    public partial class results_f : System.Web.UI.Page
    {
        #region Fields
        GenderType _sex;
        int _region
            , _race
            , _age
            , _complexion
            , _tanning
            , _small_moles_females
            , _freckling;
        protected double _result;
        #endregion

        #region Methods
        /// <summary>
        /// Form Load Event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {               
                Calculate();
            }
        }

        /// <summary>
        /// Calculates the Absoulte Risks
        /// </summary>
        private void Calculate()
        {
          
            _region = int.Parse(Session[Manager.region].ToString());
            _sex = (GenderType)Session[Manager.sex];
            _race = int.Parse(Session[Manager.race].ToString());
            _age = int.Parse(Session[Manager.age].ToString());
            _complexion = int.Parse(Session[Manager.complexion].ToString());
            _tanning = int.Parse(Session[Manager.tanning].ToString());
            _small_moles_females = int.Parse(Session[Manager.smallmolesfemales].ToString());
            _freckling = int.Parse(Session[Manager.freckling].ToString());

            if(_sex==GenderType.Female)
                lblSex.Text = "women";

            if (_sex.Equals(GenderType.Female))
            {
                _result = Utils.processFemale(_region,(int)_sex, _race, _age, _complexion, _tanning, _small_moles_females, _freckling);
                lblResults.Text = (Math.Round(_result, MRAT.Mobile.Manager.ReadConfigValue("decimals", 2))) + "%";
            }
            lblAvg.Text = ((Math.Round(_result, MRAT.Mobile.Manager.ReadConfigValue("decimals", 2))) * 10).ToString();

        }
        #endregion Methods
    }

}
