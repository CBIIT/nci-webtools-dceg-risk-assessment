<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q06.ascx.cs" Inherits="BCRA.Mobile.Q06" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                6 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="biopsy">
                Has the woman ever had a breast biopsy?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="6"/>
                <select name="biopsy" id="biopsy" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option value="99">Unknown</option>
                    <option value="0">No</option>
                    <option value="1">Yes</option>
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
                <a href="Q6ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>