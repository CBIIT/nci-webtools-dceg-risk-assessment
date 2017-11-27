<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Results.ascx.cs" Inherits="CCRAT.Web.UserControls.Results" %>
<div class="maincontentboxtext-paddedText">
<p>
<em><strong>Reminder:</strong> 
    The Colorectal Cancer Risk Assessment Tool was designed for use by health professionals and their patients.  
    If you are not a health professional, you are encouraged to discuss these results and your personal risk of colorectal cancer with your healthcare provider. 
    The results are calculated based on data from non-Hispanic white men and women ages 50 to 85+.</em>
</p>
<p>    
<h2 style="display: inline;">Race/Ethnicity:</h2>&nbsp;&nbsp;Non-Hispanic white
</p>
<p>
<h2 style="display: inline;">Gender:</h2>&nbsp;&nbsp;<span id="gender" runat="server" />
</p>
<p>
<h2 style="display: inline;">Age:</h2>&nbsp;&nbsp;<span id="age" runat="server" />
</p>
<asp:PlaceHolder ID="ph5Year" runat="server">
    <p>
        <h2 style="display: inline;">5 Year Risk:</h2>&nbsp;&nbsp;<span id="main5YearRisk" runat="server" />
        <br />
        <div class="risk-explanation">
            <h3>Explanation:</h3>
            <p>Based on the information provided (see below), the estimated chance  for developing colorectal cancer over the next 5 years is <span id="exp5YearRisk" runat="server" />.</p>
        </div>
    </p>
</asp:PlaceHolder>

<asp:PlaceHolder ID="ph10Year" runat="server">
    <p>
        <h2 style="display: inline;">10 Year Risk:</h2>&nbsp;&nbsp;<span id="main10YearRisk" runat="server" />
        <br />
        <div class="risk-explanation">
            <h3>Explanation:</h3>
            <p>Based on the information provided (see below), the estimated chance  for developing colorectal cancer over the next 10 years is <span id="exp10YearRisk" runat="server" />.</p>
        </div>
    </p>
</asp:PlaceHolder>

<asp:PlaceHolder ID="phLifeRisk" runat="server">
    <p>
        <h2 style="display: inline;">Lifetime Risk:</h2>&nbsp;&nbsp;<span id="mainLifeRisk" runat="server" />
        <br />
        <div class="risk-explanation">
            <h3>Explanation:</h3>
            <p>Based on the information provided (see below), the estimated chance for developing colorectal cancer over the lifetime (to age 90) is <span id="expLifeRisk" runat="server" />.</p>
        </div>
    </p>
</asp:PlaceHolder>

<%--place holder for displaying error messages if any--%>
<asp:PlaceHolder ID="phErrorMsg" runat="server">
    <p>
        <h2 style="display: inline; color: red;">Error Message:&nbsp;&nbsp;<span id="errorMsg" runat="server" /></h2>
        <br />
    </p>
</asp:PlaceHolder>

</div>
<div style="background: #F7F7E2;margin-bottom: 8px; padding: 3px 20px 3px 5px; border-top: solid 1px #bbb; border-bottom: solid 1px #bbb; display: block; font-weight: bold;">These results are based upon the following answers:</div>
