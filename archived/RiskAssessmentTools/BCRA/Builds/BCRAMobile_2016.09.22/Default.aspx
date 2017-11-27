<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="_Default" Codebehind="Default.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="q">
                Breast Cancer Risk Assessment Tool
        </td>
    </tr>
    <tr>
        <td>
            <p>
                The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing invasive breast cancer. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS). See <a class="grey-text" href="about.aspx">About the Tool</a> for more information.</p>
            <p>
                The BCRA risk calculator may be updated periodically as new data or research becomes available. The algorithm was last updated in 2011.</p>
            <p>
            <a href="About.aspx">About the Tool</a> - New users, please read!</p>
        </td>
    </tr>
    <tr>
        <td class="b h">
            <form action="Q00.aspx?restart=true" method="post">
            <input value="Begin Risk Calculation" type="submit"/>
            </form>
            </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" runat="server">
</asp:Content>
