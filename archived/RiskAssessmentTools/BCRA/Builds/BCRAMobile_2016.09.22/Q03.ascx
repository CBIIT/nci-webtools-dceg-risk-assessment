<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q03.ascx.cs" Inherits="BCRA.Mobile.Q03" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                3 of 7:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label runat="server" AssociatedControlID="ageMP">
                What is the woman's age at the time of her first menstrual period?
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td class="c">
                <input type="hidden" id="q" name="q" value="3"/>
                <select name="ageMP" id="ageMP" runat="server">
                    <option selected="selected" value="-1000">Select</option>
                    <option value="99">Unknown</option>
                    <option value="10">7 to 11</option>
                    <option value="13">12 to 13</option>
                    <option value="14">&gt; = 14</option>
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
                <a href="Q3ex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>