<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="_5yearex" Codebehind="5yearex.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <tr>
        <td class="h">
            <a href="Results.aspx">&lt; Back</a></td>
    </tr>
    <tr>
        <td class="h">
            <p>
                Based on the information provided, the woman's estimated risk for developing invasive breast cancer over the next 5 years is <%=fiveYearRiskThisWoman%>% compared to a risk of <%=fiveYearRiskAvgWoman%>% for a woman of the same age and race/ethnicity from the general U.S. population. This calculation also means that the woman's risk of NOT getting breast cancer over the next 5 years is <%=100.0 - fiveYearRiskThisWoman%>%. 
            </p>
        </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" Runat="Server">
    <tr>
        <td class="h">
            <a id="A1" href="Results.aspx">&lt; Back</a>
        </td>
    </tr>
</asp:Content>

