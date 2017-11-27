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
    public partial class results_m : System.Web.UI.Page
    {
        #region Fields
        GenderType _sex;
        int _region
            , _race
            , _age
            , _sunburn
            , _complexion
            , _large_moles
            , _small_moles_males
            , _freckling
            , _solar_damage;
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
        /// Calculates Absolute Risks
        /// </summary>
        private void Calculate()
        {
            _region = int.Parse(Session[Manager.region].ToString());
            _sex = (GenderType)Session[Manager.sex];
            _race = int.Parse(Session[Manager.race].ToString());
            _age = int.Parse(Session[Manager.age].ToString());
            _sunburn = int.Parse(Session[Manager.sunburn].ToString());
            _complexion = int.Parse(Session[Manager.complexion].ToString());
            _large_moles = int.Parse(Session[Manager.largemoles].ToString());
            _small_moles_males = int.Parse(Session[Manager.smallmolesmales].ToString());
            _freckling = int.Parse(Session[Manager.freckling].ToString());
            _solar_damage = int.Parse(Session[Manager.solardamage].ToString());

            lblSex.Text = _sex.ToString();
            if (_sex.Equals(GenderType.Male))
            {
                _result = Utils.processMale(_region, (int)_sex, _race, _age, _sunburn, _complexion, _large_moles, _small_moles_males, _freckling, _solar_damage);
                lblResults.Text = (Math.Round(_result, MRAT.Mobile.Manager.ReadConfigValue("decimals", 2))) + "%";
            }

            lblAvg.Text = ((Math.Round(_result, MRAT.Mobile.Manager.ReadConfigValue("decimals", 2))) * 1000).ToString();

        }
        #endregion Methods
    }
}
