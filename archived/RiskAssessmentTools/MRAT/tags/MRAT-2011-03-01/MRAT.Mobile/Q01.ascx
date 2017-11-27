<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q01.ascx.cs" Inherits="MRAT.Mobile.Q01"%>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 1:
    </td>
</tr>
<tr>
    <td>
        <asp:label AssociatedControlID="answer" runat="server" id="label">Does the patient live in the Northern, Central, or Southern United States?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server">
            <option selected="selected" value="-1000">Select</option>
            <option value="0">North</option>
            <option value="1">Central</option>
            <option value="2">South</option>
        </select>

        <input type="hidden" id="q" name="q" value="1" />
        <br />
        <input value="Next" type="submit" id="btnNext" runat="server" />
    </td>
</tr>
<tr>
    <td class="c">
        <a id="A1" href="Q1ex.aspx">Explanation</a>
        <br />
        <img src="i/map-sm.gif" alt="100.gif" />
        <br />
        <a id="Q01i120" href="maplarge-ex.aspx">Enlarge Image</a>
    </td>
</tr>
<tr>
    <td>
        <br />
        Caution: This map is only a guide. The final choice of region should be made by
        the health care provider. The model on which the tool is based is valid only for
        residents of the continental United States.
    </td>
</tr>
<tr>
    <td class="e h">
    </td>
</tr>
<uc:footerlink ID="footerlink" runat="server" />
