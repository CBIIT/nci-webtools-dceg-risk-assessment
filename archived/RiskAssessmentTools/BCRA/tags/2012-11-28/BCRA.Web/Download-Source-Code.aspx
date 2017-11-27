<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Download Source Code - BCRA" %>
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
				</tr>	<tr>
					<td valign="top" colspan="5" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
				</tr>  
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="code-conditions.aspx">Terms &amp; Conditions</a></span></td>
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
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).</p>
<div class="maincontentbox">
    <div class="maincontentboxtitle">
    <img src="images/title-download-code.gif" width="210" height="16" alt="Download Source Code" /></div>
	<div class="maincontentboxtext">
			<h2>Download Source Code for the Breast Cancer Risk<br />
		  Calculation Engine</h2>
				  <p>The BCRA risk calculator may be updated periodically as new data or research becomes available. The algorithm was last updated in May 2011. The current software version is 3.0.</p>
					<p><strong>What You&rsquo;ll Download</strong><br />
    A ZIP file (46 KB) containing the source code and <a href="documentation.aspx">documentation</a> for the breast cancer risk calculation engine. The code is available as a C# class library.</p>
				  <p>By downloading, you accept our <a href="code-conditions.aspx">Terms &amp; Conditions</a>.</p>
				  <p><a href="files/BCRA_Source_Code.zip"><img src="Images/btn-accept.gif" alt="Accept &amp; Download" width="139" height="25" border="0" /></a></p>
    </div>
	</div>
</asp:Content>