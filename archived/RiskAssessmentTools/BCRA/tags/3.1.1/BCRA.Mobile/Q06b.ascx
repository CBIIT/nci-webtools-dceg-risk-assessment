<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q06b.ascx.cs" Inherits="BCRA.Mobile.Q06b" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                6b of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="biopsyAH">
                Has the woman had at least one breast biopsy with atypical hyperplasia?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="8"/>
                <select name="biopsyAH" id="biopsyAH" runat="server">
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
                <a href="Q6bex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>