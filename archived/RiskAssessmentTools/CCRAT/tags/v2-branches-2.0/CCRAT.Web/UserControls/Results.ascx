<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Results.ascx.cs" Inherits="CCRAT.Web.UserControls.Results" %>
<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<div class="maincontentboxtext-paddedText results">
    <p>Your estimated risks of developing colorectal cancer are:</p>
    <br />
    <script type="text/javascript">
        function showAvgAlert(){
            alert('Average risk is calculated based on age, sex, and race/ethnicity.');
        }
    </script>
    <asp:PlaceHolder ID="ph5Year" runat="server">
        <p>
            <h2 style="display: inline;">Risk over the next 5 years</h2>
            <div class="risk-explanation">
                <p>Your risk: <span id="exp5YearRisk1" runat="server" /></p>                
                <%--<p><a class="grey-text" href="#" onclick="showAvgAlert();" id="modal5YrAnchor">Average</a> risk: <span id="exp5YearAvgRisk1" runat="server" /></p>--%>
                <p><a class="grey-text" href="def-avg-risk.aspx" onclick="popUp(event);return false;" id="modal5YrAnchor">Average</a> risk: <span id="exp5YearAvgRisk1" runat="server" /></p>                
            </div>
        </p>
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="ph10Year" runat="server">
        <p>
            <h2 style="display: inline;">Risk over the next 10 years</h2>
            <div class="risk-explanation">
                <p>Your risk: <span id="exp10YearRisk1" runat="server" /></p>
                <%--<p><a class="grey-text" href="#" onclick="showAvgAlert();" id="modal10YrAnchor">Average</a> risk: <span id="exp10YearAvgRisk1" runat="server" /></p>--%>
                <p><a class="grey-text" href="def-avg-risk.aspx" onclick="popUp(event);return false;" id="modal10YrAnchor">Average</a> risk: <span id="exp10YearAvgRisk1" runat="server" /></p>
            </div>
        </p>        
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="phLifeRisk" runat="server">
        <p>          
            <h2 style="display: inline;">Risk over a lifetime</h2>
            <div class="risk-explanation">
                <p>Your risk: <span id="expLifeRisk1" runat="server" /></p>
                <%--<p><a class="grey-text" href="#" onclick="showAvgAlert();" id="modalLifeTimeAnchor">Average</a> risk: <span id="expLifeYearAvgRisk1" runat="server" /></p>--%>
                <p><a class="grey-text" href="def-avg-risk.aspx" onclick="popUp(event);return false;" id="modalLifeTimeAnchor">Average</a> risk: <span id="expLifeYearAvgRisk1" runat="server" /></p>
            </div>
        </p>      
    </asp:PlaceHolder>   
    
    <asp:PlaceHolder ID="phWhatNext" runat="server">
        <h2 style="display: inline;">What to do next:</h2>
        <ul >
            <li>Discuss these results with your doctor</li>
            <li>Learn about <a class="grey-text" href="colorectal-cancer-risk.aspx">things that affect your risk</a></li>
            <li>Learn more <a class="grey-text" href="about-tool.aspx">about the tool</a></li>
        </ul>
    </asp:PlaceHolder>

    <%--place holder for displaying error messages if any--%>
    <asp:PlaceHolder ID="phErrorMsg" runat="server">
        <div>
            <h2 style="display: inline; color: red;">Error Message:&nbsp;&nbsp;<span id="errorMsg" runat="server" /></h2>
            <br />
        </div>
    </asp:PlaceHolder>
</div>

<asp:PlaceHolder ID="phTestVars" runat="server" Visible="false">
    <div style="border: 1px solid black; padding: 5px 5px 5px 5px; margin: 0 0 10px 16px;">
        <h3>
            Calculation Vars</h3>
        <asp:Literal ID="litTestVars" runat="server" />
    </div>
</asp:PlaceHolder>
<div class="highlight">These results are based on the following answers you provided:</div>