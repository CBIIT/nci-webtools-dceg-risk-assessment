<%@ Page MasterPageFile="CCRAT.Mobile.master" Language="C#" AutoEventWireup="true" Inherits="CCRAT.Mobile.Default" Title="Colorectal Cancer Risk Assessment Tool" CodeBehind="Default.aspx.cs" EnableViewState="false"%>
<asp:Content ContentPlaceHolderID="P" Visible="false" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderID="mc" ID="cphMainContent" runat="server">
    <p>
        <strong>Colorectal Cancer Risk Assessment Tool</strong>
    </p>
    <p>
        An Interactive Tool for Measuring the Risk of Colorectal Cancer
    </p>
    <p>
        <a accesskey="5" href="a.aspx">About the Tool</a> - New users, please read!
    </p>
    <p>
        <input type="hidden" id="restart" name="restart" value="true" />
        <input value="Begin Risk Calculation" type="submit" />
    </p>
</asp:Content>
<asp:Content ContentPlaceHolderID="f" Visible="false" runat="server"></asp:Content>

