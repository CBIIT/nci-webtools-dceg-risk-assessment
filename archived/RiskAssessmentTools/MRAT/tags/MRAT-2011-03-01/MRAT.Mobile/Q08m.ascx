<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q08m.ascx.cs" Inherits="MRAT.Mobile.Q08m" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 8 of 10:
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
            <option value="1">Less than seven</option>
            <option value="2">Seven to sixteen</option>
            <option value="3">Seventeen or more</option>
        </select>
        <input type="hidden" id="q" name="q" value="8" />
        <br />
        <input value="Next" type="submit" />
    </td>
</tr>

<tr>
    <td class="e h">
        <a href="Q8mex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>