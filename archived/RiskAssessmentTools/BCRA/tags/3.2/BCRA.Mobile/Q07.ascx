<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q07.ascx.cs" Inherits="BCRA.Mobile.Q07" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

 <form action="Q00.aspx" method="post" runat="server">
        <tr>
            <td class="q">
                7 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="race">
                What is the woman's race/ethnicity?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="9" />
        <asp:DropDownList name="race" ID="race" runat="server" 
            onselectedindexchanged="race_SelectedIndexChanged" AutoPostBack="true">
                    <asp:ListItem Selected="True" Value="-1000">Select</asp:ListItem>
                    <asp:ListItem Value="1">White</asp:ListItem>
                    <asp:ListItem Value="2">African American</asp:ListItem>
                    <asp:ListItem Value="3">Hispanic</asp:ListItem>
                    <asp:ListItem Value="4">Asian-American</asp:ListItem>
                    <asp:ListItem Value="5">American Indian or Alaskan Native</asp:ListItem>
                    <asp:ListItem Value="6">Unknown</asp:ListItem>                
                </asp:DropDownList> 
             
                
<%--                <select name="race" id="race" runat="server" onserverchange="race_ServerChange">        
                    <option selected="selected" value="-1000">Select</option>
                    <option value="1">White</option>
                    <option value="2">African American</option>
                    <option value="3">Hispanic</option>
                    <option value="4">Asian-American</option>
                    <option value="5">American Indian or Alaskan Native</option>
                    <option value="6">Unknown</option>
                </select>--%>
            </td>
        </tr>

        
        <tr>
            <td class="c">
                <input value="Calculate Risk" id="lblSubmitQ9" name="lblSubmitQ9" type="submit" runat="server" onclick="window.Analytics_CalculateRiskConversionEvent();" />
            </td>
        </tr>
        <tr>
            <td class="e h">
                <a href="Q7ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>