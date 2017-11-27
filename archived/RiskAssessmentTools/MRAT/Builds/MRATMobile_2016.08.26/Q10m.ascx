<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q10m.ascx.cs" Inherits="MRAT.Mobile.Q10m" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 10 of 10:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">Does the patient have severe solar damage on the shoulders?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="1">Yes</option>
            <option value="2">No</option>
        </select>
        <input type="hidden" id="q" name="q" value="10" />
        <br />
        <input value="Calculate Risk" type="submit" />        
    </td>
</tr>
<tr>
    <td>
        <em></em>
    </td>
</tr>
<tr>
    <td class="e h">
        <a href="Q10mex.aspx">Explanation</a>
        <br />
        Example of Severe Solar Damage
        <br />
        <img src="i/sv2_55.jpg" alt="Example of Severe Solar Damage" />
        <br />
        <a href="solar-damageex.aspx">Enlarge Image</a>
    </td>
</tr>
<uc:footerlink ID="footerlink" runat="server" />
