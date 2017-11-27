<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q06a.ascx.cs" Inherits="BCRA.Mobile.Q06a" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                6a of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="biopsyNum">
                How many breast biopsies (positive or negative) has the woman had?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="7"/>
                <select name="biopsyNum" id="biopsyNum" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option value="1">1</option> 
                    <option value="2">&gt; 1</option> 
                </select>
                
            </td>
        </tr>
        <tr>
            <td class="c">
                <input value="Next" type="submit" />
            </td>
        </tr>
        <tr>
            <td class="e h">
                <a href="Q6aex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>