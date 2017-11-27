<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q05m.ascx.cs" Inherits="MRAT.Mobile.Q05m" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 5 of 10:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">Ask the patient: Did you ever get a blistering sunburn?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Yes</option>
            <option value="2">No</option>
        </select>
        <input type="hidden" id="q" name="q" value="5"/>
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
        <a href="Q5mex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>