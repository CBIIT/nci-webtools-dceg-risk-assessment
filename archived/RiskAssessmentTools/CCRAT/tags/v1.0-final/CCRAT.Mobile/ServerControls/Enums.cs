using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace CCRAT.Mobile
{
    public enum QuestionDisplayModes
    {
        Questioning = 1,
        Results = 2,
        QuestionExplanation = 3,/* question explanation*/
        ResultExplanation = 4,   /* results explanation*/
        SectionHeader = 5       /*section header*/
    }
}
