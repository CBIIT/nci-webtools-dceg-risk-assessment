using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CCRAT.Web.UserControls
{
    public abstract class  CCRATUserControl : System.Web.UI.UserControl
    {
        public abstract void Save();

        public void SaveAnswer(string key, string value)
        {
            Dictionary<string, string> inputs = new Dictionary<string, string>();

            //If session is not null, add/update value to session
            if (Session[CCRATString.CCRAT] != null)
            {
                inputs = (Dictionary<string, string>)Session[CCRATString.CCRAT];
            }

            if (inputs.ContainsKey(key))// update existing record
            {
                inputs[key] = value;
            }
            else //add new
            {
                inputs.Add(key, value);
            }

            //save inputs back to session
            Session[CCRATString.CCRAT] = inputs;
        }
    }
}
