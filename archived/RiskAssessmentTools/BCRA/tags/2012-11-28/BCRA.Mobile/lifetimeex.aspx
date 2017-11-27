<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="lifetimeex" Codebehind="lifetimeex.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <tr>
        <td class="h">
            <a href="Results.aspx">&lt; Back</a></td>
    </tr>
    <tr>
        <td class="h">
            <p>
                Based on the information provided, the woman's estimated risk for developing invasive breast cancer over her lifetime (to age 90) is <%=lifetimeRiskThisWoman%>% compared to a risk of <%=lifetimeRiskAvgWoman%>% for a woman of the same age and race/ethnicity from the general U.S. population. 
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

