<%@ Control Language="C#" AutoEventWireup="true" Codebehind="Q09m.ascx.cs" Inherits="MRAT.Mobile.Q09m" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>
<tr>
    <td class="q">
        Question 9 of 10:
    </td>
</tr>
<tr>
    <td>
        <asp:label runat="server" AssociatedControlID="answer">How extensive is the freckling on the patient’s back and shoulders?</asp:label>
    </td>
</tr>
<tr>
    <td class="c">
        <select id="answer" name="answer" runat="server"> 
            <option selected="selected" value="-1000">Select</option>
            <option value="0">Absent</option>
            <option value="1">Mild</option>
            <option value="2">Moderate</option>
            <option value="3">Severe</option>
        </select>
        <input type="hidden" id="q" name="q" value="9" />
        <br />
        <input value="Next" type="submit" />        
    </td>
</tr>
<tr>
    <td class="c">
        <a href="Q9mex.aspx">Explanation</a>
    </td>
</tr>
<tr>
    <td>
        <br />
        Mild Freckling
        <br />
        <img src="i/mi_55.jpg" alt="Mild Freckling" />
        <br />
        <a href="freck-mild-ex.aspx">Enlarge Image</a>
    </td>
</tr>
<tr>
    <td>
        <br />
        Moderate Freckling
        <br />
        <img src="i/md_55.jpg" alt="Moderate Freckling" />
        <br />
        <a href="freck-moderate-ex.aspx">Enlarge Image</a>
    </td>
</tr>
<tr>
    <td>
        <br />
        Severe Freckling
        <br />
        <img src="i/sv1_55.jpg" alt="Severe Freckling" />
        <br />
        <a href="freck-severe-ex.aspx">Enlarge Image</a>
        <br />
        <br />
    </td>
</tr>
<tr>
    <td class="e h">
    </td>
</tr>

<uc:footerlink ID="footerlink" runat="server" />
