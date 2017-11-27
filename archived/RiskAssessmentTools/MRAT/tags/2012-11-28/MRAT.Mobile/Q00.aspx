<%@ Page Language="C#" MasterPageFile="~/MRATMobile.Master" AutoEventWireup="true" Codebehind="Q00.aspx.cs" Inherits="MRAT.Mobile.Q00" Title="Melanoma Risk Assessment Tool" EnableViewState="true"%>
<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">    
    <asp:PlaceHolder ID="phUserControl" runat="server">
        <tr>
            <td class="">
                <asp:Label ID="lblError" Visible="false" runat="server" ForeColor="red" Text="You must answer this question."></asp:Label>
            </td>
        </tr>
    </asp:PlaceHolder>
</asp:Content>
<asp:Content ID="bottomLink" ContentPlaceHolderID="BottomLink" runat="server">
</asp:Content>
