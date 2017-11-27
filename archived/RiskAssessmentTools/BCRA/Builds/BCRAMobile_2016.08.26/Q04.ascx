<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q04.ascx.cs" Inherits="BCRA.Mobile.Q04" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                4 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" AssociatedControlID="ageLB">
                What was the woman's age at the time of her first live birth of a child?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="4"/>
                <select name="ageLB" id="ageLB" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option value="99">Unknown</option>
                    <option value="0">No births</option>
                    <option value="15">&lt; 20</option>
                    <option value="22">20 to 24</option>
                    <option value="27">25 to 29</option>
                    <option value="30">&gt; =30</option>
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
                <a href="Q4ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>