<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="resimpact" Codebehind="resimpact.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <tr>
        <td class="h">
            <a href="Results.aspx">&lt; Back</a></td>
    </tr>
    <tr>
        <td class="h">
            <p>
                <asp:Label ID="lblBlack" Visible="false" runat="server">The tool may underestimate risk for African American women with one or more biopsies. </asp:Label>
                <asp:Label ID="lblHispanic" Visible="false" runat="server">Assessments for Hispanic women are subject to greater uncertainty than those for white and African women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.</asp:Label>
                <asp:Label ID="lblAsianOrPI" Visible="false" runat="server">Assessments for Asian or Pacific Islander women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.</asp:Label>
                <asp:Label ID="lblAmIndianOrAN" Visible="false" runat="server">Assessments for American Indian or Alaskan Native women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.</asp:Label>
                <asp:Label ID="lblUnknown" Visible="false" runat="server">This risk assessment was based on data for white females.</asp:Label>
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