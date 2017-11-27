<%@ Page Language="C#" MasterPageFile="CCRAT.Mobile.master" %>

<asp:Content ID="cMC" ContentPlaceHolderID="MC" runat="server">
    <div>
        <a id="top"></a>
        <h2>About the Tool</h2>
    </div>
    <div class="h">
        <ul>
            <li><a href="a.aspx">Information for New Users</a></li>
            <li><a href="a-e.aspx">Explaining the Results</a></li>
            <li><a href="a-a.aspx">About the Model</a></li>
            <li><a href="#ref">References</a></li>
        </ul>
    </div>
    <div>
         <a id="ref"></a><h2>References</h2>
    </div>
    <div>
        <ul>
        <li>Freedman AN, Slattery ML, Ballard-Barbash R, Willis G, Cann B, Pee D, Gail, Pfeiffer RM. A colorectal cancer risk prediction tool for white men and women without known susceptibility.  J Clin Oncol [In press]</li>
        <li>Park Y, Freedman AN, Gail MH, Pee D, Hollenbeck A, Schatzkin A, Pfeiffer RM. Validation of a colorectal cancer risk prediction model among whites 50 years old and over. J Clin Oncol [In press].</li>
        </ul>
    </div>
    <div>
        <a href="a-a.aspx">&lt; Prev</a> | <a href="a-r.aspx">Back to Top</a> | <label>Next&nbsp;&gt;</label>
        <br />
        <a href="q.aspx?restart=true">Begin Risk Calculation</a>
    </div>    
</asp:Content>
