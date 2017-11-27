<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="e" Title="NCI - Breast Cancer Risk Assessment Tool" Codebehind="e.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="q">
            Errors Occurred
        </td>
    </tr>
    <tr>
        <td class="h">
            <p>
                Unexpected errors occurred. Our technicians have been notified and are working to correct the situation. Please start over again by clicking the New Risk Calculation link below.
            </p>
        </td>
    </tr>
    <tr>
        <td class="e h">
            <a href="Q00.aspx?restart=true">New Risk Calculation</a>
        </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" runat="Server">
    <tr>
        <td class="e h">
            <a id="A1" runat="server" href="~/">&lt; BCRA Tool Home</a>
        </td>
    </tr>
</asp:Content>
