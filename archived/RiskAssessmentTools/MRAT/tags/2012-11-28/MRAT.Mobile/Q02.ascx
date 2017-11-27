<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q02.ascx.cs" Inherits="MRAT.Mobile.Q02"%>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 2:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">What is the patient's gender?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Male</option>
            <option value="2">Female</option>
        </select>
        <input type="hidden" id="q" name="q" value="2" />
        <br />
        <%--<input value="Next" type="submit" runat="server" />--%>
        <input value="Next" type="submit" id="btnNext" runat="server" />
    </td>
</tr>
<tr>
    <td>
        <a href="Q2ex.aspx">Explanation</a>
    </td>
</tr>
<tr>
    <td>
        <br />
        Please note: This tool uses gender-specific risk models. It requires different information
        of male patients than female patients. The answer to this question will determine
        what other questions are asked.
    </td>
</tr>
<tr>
    <td class="e h">     
    </td>
</tr>
<uc:footerlink id="footerlink" runat="server"/>
