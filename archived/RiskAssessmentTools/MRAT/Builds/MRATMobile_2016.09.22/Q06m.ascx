<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q06m.ascx.cs" Inherits="MRAT.Mobile.Q06m" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 6 of 10:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">Ask the patient: Is your complexion light, medium, or dark?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Light</option>
            <option value="2">Medium</option>
            <option value="3">Dark</option>
        </select>
        <input type="hidden" id="q" name="q" value="6"/>
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
        <a href="Q6mex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink ID="footerlink" runat="server" />
