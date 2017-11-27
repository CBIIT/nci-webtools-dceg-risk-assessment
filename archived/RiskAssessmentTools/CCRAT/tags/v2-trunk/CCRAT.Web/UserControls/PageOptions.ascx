<%@ Control Language="C#" AutoEventWireup="true" Inherits="PageOptions" Codebehind="PageOptions.ascx.cs" %>

<div id="pageoptions">
<ul>
	<li class="title">Page Options</li>
	<li><a href="javascript:print()"><img src="images/print-icon.gif" width="22" height="12" alt="Print Page" style="vertical-align: middle" />Print Page</a></li>
	<li><a id="lnkEmail" onclick="popUp(event);return false;" runat="server"><img src="images/email-icon.gif" width="23" height="10" alt="Email Page" style="vertical-align: middle" />Email Page</a></li>
</ul>
</div>
