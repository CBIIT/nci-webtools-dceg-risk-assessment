<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="e" Title="Untitled Page" Codebehind="e.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="q">
            Errors Occurred
        </td>
    </tr>
    <tr>
        <td class="h">
            <p>
                Unexpected errors occurred. Our technicians have been notified and are working to correct the situation.
                
            </p>
        </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" runat="Server">
    <tr>
        <td class="e h">
            <a id="A1" runat="server" href="~/">&lt; CCRAT Tool Home</a>
        </td>
    </tr>
</asp:Content>
