<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q03.ascx.cs" Inherits="MRAT.Mobile.Q03" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 3 of <span id="lblY" runat="server">10</span>:
    </td>
</tr>
<tr>
    <td>
        What is the patient's race?
    </td>
</tr>
<tr>
    <td class="q">
        Note:
    </td>
</tr>
<tr>
    <td>
        This tool can only accurately calculate melanoma risk for patients who are non-Hispanic whites.
    </td>
</tr>
<tr>
    <td class="c">
        <input type="radio" id="answer" value="1" name="answer" runat="server"/>
        <asp:Label runat="server" AssociatedControlID="answer"><strong>Non-Hispanic White - </strong>Continue Risk Calculation</asp:Label>
        <br />
        <input type="radio" id="answerOther" value="2" name="answer" runat="server" />
        <asp:label runat="server" AssociatedControlID="answerOther"><strong>Other</strong> - End Risk Calculation</asp:label>
        <input type="hidden" id="q" name="q" value="3" />
        <br />
        <input value="Next" type="submit" id="btnNext" runat="server" />
    </td>
</tr>
<tr>
    <td>
        <em></em>
    </td>
</tr>
<tr>
    <td class="e h">
        <a href="Q3ex.aspx">Explanation</a>
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>
