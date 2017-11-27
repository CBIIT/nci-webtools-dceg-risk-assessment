<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Terms &amp; Conditions - BCRA" %>
<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<script runat="server">

</script>

<asp:Content ContentPlaceHolderID="cphNav" ID="cntNav" runat="server">
<table width="194" cellspacing="0" cellpadding="0" border="0">
	<tr>
    <td  class="navrow" valign="top" width="10">&nbsp;</td>
		<td valign="middle" width="13">&nbsp;</td>
		<td width="164" valign="middle"><a href="Default.aspx">Risk Calculator</a></td>
		<td valign="top" width="7">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
		<td valign="middle">&nbsp;</td>
		<td valign="middle"><a href="about-tool.aspx">About the Tool</a></td>
		<td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
		<td valign="middle">&nbsp;</td>
		<td valign="middle"><a href="breast-cancer-risk.aspx">Breast Cancer Risk</a></td>
		<td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
		<td valign="middle"></td>
		<td valign="middle"><a href="mobile-access.aspx">Mobile Access</a></td>
		<td valign="top">&nbsp;</td>
  </tr>
	<tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
	  <td valign="middle"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
	  <td valign="middle"><a href="download-source-code.aspx" class="current">Download Source Code</a></td>
	  <td valign="top">&nbsp;</td>
  </tr> 
  <tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
<!-- Subnav -->  
 <tr>
    <td bgcolor="#F2F5F8" valign="top" colspan="4">
	 		 <table width="194" cellspacing="0" cellpadding="0" border="0" class="subnav">
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="documentation.aspx">Documentation</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	
				<tr>
					<td valign="top" colspan="5" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
				</tr>  
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="code-conditions.aspx" class="current">Terms &amp; Conditions</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	
			</table>
		</td>
  </tr>
<!-- end Subnav --> 
</table>
</asp:Content>

<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool" runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphMain" ID="cntMain" runat="server">
<p>
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).
</p>
<div class="maincontentbox">
  <div class="maincontentboxtitle"><img src="images/title-download-code.gif" width="210" height="16" alt="Download Source Code" /></div>
	<div class="maincontentboxtext">
			<h2>Terms &amp; Conditions</h2>
			<h3>Source Code for Breast Cancer Risk Calculation Engine</h3>
			<p><strong>Non-Proprietary Software Transfer Agreement</strong><br />
	  Provider: National Institutes of Health (NIH), National Cancer Institute (hereinafter &quot;NCI&quot;)</p>
			<p>By accepting Software, Recipient agrees to the terms of this Agreement.</p>
			<p>The Software transferred under this agreement was created by Federal Government employees in the course of official duties. Transfer of Software to Recipient does not constitute endorsement by the NCI of the Recipient or any product, service or company and no endorsement should be inferred. SOFTWARE IS NOT INTENDED FOR TREATING OR DIAGNOSING HUMAN SUBJECTS.</p>
			<p>The BCRA risk calculator may be updated periodically as new data or research becomes available.</p>			
			<p>Software is supplied AS IS, without any accompanying services or improvements from NIH. SOFTWARE IS SUPPLIED TO RECIPIENT WITH NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING ANY WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. NCI makes no representations that the use of Software will not infringe any patent or proprietary rights of third parties.</p>
			<p>All risk as to quality and performance of Software is with Recipient. In no event will the United States Government or NCI be liable to Recipient for damages arising out of the use or inability to use Software, including but not limited to loss of data or data being rendered inaccurate or losses sustained by Recipient or third parties</p>
		</div>
	</div>
</asp:Content>