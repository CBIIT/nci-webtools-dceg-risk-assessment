<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q06f.ascx.cs" Inherits="MRAT.Mobile.Q06f" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 6 of 8:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">Ask the patient: After repeated and prolonged exposure to sunlight, at the age you
        are now, would your skin become very brown and deeply tanned, moderately tanned,
        lightly tanned or not tan at all?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Very brown and deeply tanned</option>
            <option value="2">Moderately tanned</option>
            <option value="3">Lightly tanned</option>
            <option value="4">No tan at all</option>
        </select>
        <input type="hidden" id="q" name="q" value="6" />
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
        <a href="Q6fex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>