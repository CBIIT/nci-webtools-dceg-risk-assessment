<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MRATMobile.Master" CodeBehind="Default.aspx.cs" Inherits="MRAT.Mobile.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="q">
                Melanoma Risk Assessment Tool
        </td>
    </tr>
    <tr>
        <td>
            <p>
                An interactive tool designed by scientists at the National Cancer Institute (NCI), the University of Pennsylvania, and the University of California, San Francisco, to estimate a person's <a href="about.aspx#explain">absolute risk</a> of developing invasive melanoma. The tool helps clinicians identify individuals at higher risk of melanoma in order to plan appropriate screening interventions with them.
            </p>
						<p>The MRAT risk calculator may be updated periodically as new data or research becomes available.</p>
            <p>
                <a href="about.aspx">About the Tool</a> - New users, please read!
            </p>
        </td>
    </tr>
    <tr>
        <td class="b h">
            <input type="hidden" id="restart" name="restart" value="true" />
            <input value="Begin Risk Calculation" type="submit" />
        </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" runat="server">
</asp:Content>
