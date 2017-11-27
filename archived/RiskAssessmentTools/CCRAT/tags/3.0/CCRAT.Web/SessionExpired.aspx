<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SessionExpired.aspx.cs" Inherits="CCRAT.Web.Error" %>

<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
    <div class="maincontentboxtext-paddedText">
    <br /><br /><br />
        <span style="color: #a90101; font-size: 16px; font-weight: bold;">Session Expired. Your session has expired.  
    Please return to the <a href="tool.aspx">Colorectal Cancer Risk Assessment Tool</a> 
    </span>
    <br /><br /><br />
    </div>
</asp:Content>

