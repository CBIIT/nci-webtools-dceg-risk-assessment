<%@ Page Language="C#" AutoEventWireup="true" Inherits="PopEmail" Codebehind="PopEmail.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
 <title>Colorectal Cancer Risk Assessment Tool</title>
 <meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />
 <meta http-equiv="imagetoolbar" content="false" />
 <meta name="description" content="" />
 <meta name="keywords" content="" />
 <meta name="MSSmartTagsPreventParsing" content="true" />
 <link href="stylesheets/CCRAT-style.css" rel="stylesheet" type="text/css" media="all" />
</head>
<body class="popup" style="margin: 0">
<!-- Content Headers -->
<div id="ncibannerpopup"><a href="javascript:window.close();"><img src="images/nci-banner-popup.gif" width="497" height="30" alt="National Cancer Institute, cancer.gov" border="0" /></a></div>
<!-- end Content Headers -->

<!-- Content box -->
<div id="popupcontent">
		<table border="0" cellpadding="10" cellspacing="0" width="100%">
			<tr>
				<td align="center" valign="top">
					<form id="emailForm" method="post" action="" runat="server">
						<input type="hidden" id="Url" runat="server">
						<input type="hidden" id="Document" runat="server" NAME="Document">
						
						<asp:Label ID="Title" Runat="server" CssClass="black-text-b"></asp:Label>

						<table cellpadding="0" cellspacing="0" border="0">
							<tr valign="middle">
								<td align="right" valign="middle" nowrap><asp:Label ID="lblToEmail" runat="server" AssociatedControlID="txtTo" /></td>
								<td align="left" valign="middle"><asp:TextBox id="txtTo" runat="server" /></td><td><asp:RequiredFieldValidator ID="toValid" ControlToValidate="txtTo" ErrorMessage=" (required valid e-mail)" Runat="server" EnableClientScript="True"></asp:RequiredFieldValidator></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr valign="middle">
								<td align="right" valign="middle" nowrap><asp:Label ID="lblFromEmail" runat="server" AssociatedControlID="txtFrom"/></td>
								<td align="left" valign="middle"><asp:TextBox id="txtFrom" runat="server" /></td><td><asp:RequiredFieldValidator ID="fromValid" ControlToValidate="txtFrom" ErrorMessage=" (required valid e-mail)" Runat="server" EnableClientScript="True"></asp:RequiredFieldValidator></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr valign="middle">
								<td align="right" valign="middle" nowrap><asp:Label ID="lblFromName" runat="server" AssociatedControlID="txtFromName" /></td>
								<td align="left" valign="middle"><asp:TextBox id="txtFromName" runat="server" /></td><td>&nbsp;</td>
							</tr>
						</table>
						<p>
						<asp:Button ID="btnSubmit" runat="server" />
						</p>
					</form>
					<asp:Label ID="lblConfirm" runat="server" Visible="false" />
				</TD>
			</TR>
		</TABLE>
    </div>
<!-- end Content box -->
<!-- #include file="analytics_include.html" -->
</body>
</html>
