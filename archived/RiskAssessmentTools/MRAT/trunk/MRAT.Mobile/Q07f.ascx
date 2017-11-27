<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q07f.ascx.cs" Inherits="MRAT.Mobile.Q07f" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 7 of 8:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">How many moles less than or equal to 5mm in diameter are on the patient’s back?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Less than five</option>
            <option value="2">Five to eleven</option>
            <option value="3">Twelve or more</option>
        </select>
        <input type="hidden" id="q" name="q" value="7" />
        <br />
        <input value="Next" type="submit" />
    </td>
</tr>
<tr>
    <td>
        <em></em>
    </td>
</tr>
<tr>
    <td class="e h">
        <a href="Q7fex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>