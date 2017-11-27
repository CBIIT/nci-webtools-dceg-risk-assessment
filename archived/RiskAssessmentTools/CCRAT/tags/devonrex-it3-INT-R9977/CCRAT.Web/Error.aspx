<%@ Page Language="C#" MasterPageFile="CCRAT.master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="CCRAT.Web.Error" %>

<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server"><span style="margin: 0; padding:0; color: #ffffff; font-weight: bold; font-size: 16px;">Errors Occurred</span></asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleRight" ID="cBoxTitleRight" runat="server"><asp:HyperLink ID="lnlNewCal" NavigateUrl="~/default.aspx" runat="server">New Risk Calculation</asp:HyperLink></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
    <div class="maincontentboxtext-paddedText">
        <span style="color: #a90101; font-size: 16px; font-weight: bold;">Unexpected errors occurred. Our technicians have been notified and are working to correct the situation.</span>
    </div>
</asp:Content>
