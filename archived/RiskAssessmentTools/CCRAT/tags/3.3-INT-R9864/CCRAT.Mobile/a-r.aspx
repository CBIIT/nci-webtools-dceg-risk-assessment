<%@ Page Language="C#" MasterPageFile="CCRAT.Mobile.master" %>

<asp:Content ID="cMC" ContentPlaceHolderID="MC" runat="server">
    <div>
        <a id="top"></a>
        <h2>About the Tool</h2>
    </div>
    <div class="hr">
        <ul>
            <li><a href="a.aspx">Information for New Users</a></li>
            <li><a href="a-e.aspx">Explaining the Results</a></li>
            <li><a href="a-a.aspx">About the Model</a></li>
            <li><a href="#ref" class="al">References</a></li>
        </ul>
    </div>
    <div>
         <a id="ref"></a><h2>References</h2>
    </div>
    <div>
        <ol>
            <li>Freedman AN, Slattery ML, Ballard-Barbash R, Willis G, Cann B, Pee D, Gail, Pfeiffer RM. <a href="#">A colorectal cancer risk prediction tool for white men and women without known susceptibility.</a> J Clin Oncol</li>
            <li>Park Y, Freedman AN, Gail MH, Pee D, Hollenbeck A, Schatzkin A, Pfeiffer RM. <a href="#">Validation of a colorectal cancer risk prediction model among whites 50 years old and over.</a> J Clin Oncol</li>
        </ol>
    </div>
    <div>
        <a href="a-a.aspx">&lt; Prev</a> | <a href="a-r.aspx">Back to Top</a> | <label>Next&nbsp;&gt;</label>
        <br />
    </div>    
</asp:Content>
<asp:Content ID="cf" ContentPlaceHolderID="f" runat="server">
    <div class="hlnk">
        <div>
            <a href="~/" runat="server" id="a1">CCRAT Home</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="cflink" ContentPlaceHolderID="flink" Visible="false" runat="server"></asp:Content>