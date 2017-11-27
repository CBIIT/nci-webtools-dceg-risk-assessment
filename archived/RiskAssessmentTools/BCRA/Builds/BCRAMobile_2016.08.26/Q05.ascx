<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q05.ascx.cs" Inherits="BCRA.Mobile.Q05" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                5 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="relativeNum">
                How many of the woman's first-degree relatives - mother, sisters, daughters - have had breast cancer?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="5"/>
                <select name="relativeNum" id="relativeNum" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option value="99">Unknown</option> 
                    <option value="0">0</option> 
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
                <a href="Q5ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>