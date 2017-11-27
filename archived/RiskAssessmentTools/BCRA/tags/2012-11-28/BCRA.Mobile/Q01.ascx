<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q01.ascx.cs" Inherits="BCRA.Mobile.Q01" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx"method="post">
<tr>
        <td class="q">
            1 of 7:
        </td>
    </tr>
    <tr>
        <td>
            Does the woman have a medical history of any breast cancer or of ductal carcinoma
            in situ (DCIS) or lobular carcinoma in situ (LCIS)?
        </td>
    </tr>
    <tr>
        <td><br />
            <b>Note:</b> If yes, this tool cannot calculate an accurate risk for breast cancer.<br />
        </td>
    </tr>
    <tr>
        <td class="c">
            
            <input type="hidden" id="q" name="q" value="1"/>
            <input id="historyOfBC" value="No" type="radio" runat="server" name="historyOfBC" />
                <asp:Label runat="server" AssociatedControlID="historyOfBC"><b>No</b> - Continue Risk Calculation</asp:Label>
                <br />
            <input id="historyOfBC2" value="Yes" type="radio" runat="server" name="historyOfBC" />
                <asp:Label runat="server" AssociatedControlID="historyOfBC2"><b>Yes</b> - End Risk Calculation</asp:Label>
                <br />
                <br />
            <input type="hidden" id="Hidden1" name="Hidden1" value="-1000" runat="server"/>
            
            <input value="Next" type="submit" />
            
        </td>
    </tr>
    <tr>
        <td class="e h">
            <a href="Q1ex.aspx">Explanation</a>
        </td>
    </tr>
</form>

<uc:footerlink id="footerlink" runat="server"/>