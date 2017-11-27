<%@ Page Title="" Language="C#" MasterPageFile="BCRA.master" AutoEventWireup="true" CodeBehind="Redirect.aspx.cs" Inherits="BCRA.Web.Redirect" %>
<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="cphNav" ID="cntMail" runat="server">
    <table width="194" cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td class="navrow" valign="top" width="10">
                &nbsp;
            </td>
            <td valign="middle" width="13">
                &nbsp;
            </td>
            <td valign="middle" width="164">
                <a href="Default.aspx" class="current">Get Started with the Risk Tool</a>
            </td>
            <td valign="top" width="7">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="4" bgcolor="#E4E4D3">
                <img src="images/spacer.gif" width="1" height="1" alt="" />
            </td>
        </tr>
        <tr>
            <td class="navrow" valign="top">
                &nbsp;
            </td>
            <td valign="middle">
                &nbsp;
            </td>
            <td valign="middle">
                <a href="about-tool.aspx">About the Tool</a>
            </td>
            <td valign="top">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="4" bgcolor="#E4E4D3">
                <img src="images/spacer.gif" width="1" height="1" alt="" />
            </td>
        </tr>
        <tr>
            <td class="navrow" valign="top">
                &nbsp;
            </td>
            <td valign="middle">
                &nbsp;
            </td>
            <td valign="middle">
                <a href="breast-cancer-risk.aspx">Breast Cancer Risk Factors</a>
            </td>
            <td valign="top">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="4" bgcolor="#E4E4D3">
                <img src="images/spacer.gif" width="1" height="1" alt="" />
            </td>
        </tr>
        <tr>
            <td class="navrow" valign="top">
                &nbsp;
            </td>
            <td valign="middle">
                &nbsp;
            </td>
            <td valign="middle">
                <a href="download-source-code.aspx">Download Source Code</a>
            </td>
            <td valign="top">
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphMain" runat="server">
<asp:Panel ID="pnlRedirectText" runat="server">
The cancer.gov site website has been optimized for mobile use. As a result, a mobile
        Breast Cancer Risk Assessment tool is no longer necessary. Please update your bookmarks
        to <a href='/bcrisktool'>http://www.cancer.gov/bcrisktool</a>.
</asp:Panel>
</asp:Content>