<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Download Software - BCRA" %>
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
		<td valign="middle"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
		<td valign="middle"><a href="mobile-access.aspx" class="current">Mobile Access</a></td>
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
					<td valign="middle" width="12"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="download-software.aspx" class="current">Download PDA Software</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	<tr>
					<td valign="top" colspan="5" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
				</tr>  
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="installation-instructions.aspx">Installation Instructions</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	
				<tr>
					<td valign="top" colspan="5" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
				</tr>
					<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="terms-conditions.aspx">Terms &amp; Conditions</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>
			</table>
		</td>
  </tr>
<!-- end Subnav --> 
	<tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
	  <td valign="middle">&nbsp;</td>
	  <td valign="middle"><a href="download-source-code.aspx">Download Source Code</a></td>
	  <td valign="top">&nbsp;</td>
  </tr>
</table>
</asp:Content>

<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool" runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphMain" ID="cntMain" runat="server">

<p>
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study.
</p>
<div class="maincontentbox">
  <div class="maincontentboxtitle"><img src="images/title-mobile-access.gif" width="128" height="16" alt="Mobile Access" /></div>
 		<div class="maincontentboxtext">
			<h2>Download PDA Software</h2>
				  <h3>Download the Breast Cancer Risk Assessment Tool for Windows<sup class="trademark">&reg;</sup> Pocket PC</h3>
				  <div>
			<p><strong>Please Note</strong>: The downloadable Pocket PC version of the risk assessment tool has not been updated with the new, 
			more accurate risk information for African American women (the CARE model). NCI will be discontinuing the 
			Pocket PC version in the Spring of 2008 but will continue to support and update the Web and Mobile Web versions of 
			the Breast Cancer Risk Assessment Tool.</p>
				    <strong>Mobile Operating System: </strong>Windows Mobile<sup class="trademark">&reg;</sup> Version 5.0 for Pocket PC <br />
				    <strong>Device Memory: </strong>(<a href="Installation-Instructions.aspx#FAQ_CheckMem">more info</a>)
				    <ul class="requirements-list">
				        <li>1.5 MB of free program memory</li>
				        <li>0.5 MB of free storage memory</li>
				    </ul>
				    <strong>Desktop OS (for installation): </strong>Windows<sup class="trademark">&reg;</sup> 2000/XP/Vista<sup class="trademark">&trade;</sup><br />
				    <strong>Syncing Software</strong>
				    <ul class="requirements-list">
				        <li><strong>Windows<sup class="trademark">&reg;</sup> XP or older: </strong><a href="http://www.microsoft.com/windowsmobile/activesync/default.mspx" target="new">ActiveSync<sup class="trademark">&reg;</sup> version 4.0 or newer</a></li>
				        <li><strong>Windows Vista<sup class="trademark">&trade;</sup>: </strong><a href="http://www.microsoft.com/windowsmobile/devicecenter.mspx" target="new">Windows Mobile<sup class="trademark">&reg;</sup> Device Center</a></li>
				    </ul>
				    <strong>Microsoft<sup class="trademark">&reg;</sup> .NET Compact Framework 2.0 </strong>(<a href="Installation-Instructions.aspx#FAQ_CF">more info</a>)<br />
				    <strong>License:</strong> Free<br />
				    <strong>File Size: </strong>0.6 MB<br />
				    <br />
	                <a href="installation-instructions.aspx">Installation Instructions</a>
	              </div>
				  <p>By downloading, you accept our <a href="terms-conditions.aspx">Terms &amp; Conditions</a>.</p>
					<p><a href="files/BCRAMobileSetup.exe"><img src="Images/btn-accept.gif" alt="Accept &amp; Download" width="139" height="25" border="0" /></a></p>
				<cite> Microsoft, Windows, and Vista are either registered trademarks or trademarks of Microsoft Corporation in the United States and/or other countries.</cite>	
 		</div>
	</div>


</asp:Content>