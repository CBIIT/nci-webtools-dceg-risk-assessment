<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Mobile Access - BCRA" %>
<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<script runat="server">

</script>

<asp:Content ContentPlaceHolderID="cphNav" ID="cntNav" runat="server">
<table width="194" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td  class="navrow" valign="top" width="10">&nbsp;</td>
	<td valign="middle" width="13">&nbsp;</td>
	<td valign="middle" width="164"><a href="Default.aspx">Risk Calculator</a></td>
	<td valign="top" width="7">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" colspan="4" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr>
  <tr>
    <td class="navrow" valign="top">&nbsp;</td>
	<td valign="middle">&nbsp;</td>
	<td valign="middle"><a href="about-tool.aspx" class="current">About the Tool</a></td>
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
  <%--<tr>
    <td bgcolor="#F2F5F8" valign="top" colspan="4">
	 		 <table width="194" cellspacing="0" cellpadding="0" border="0" class="subnav">
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="download-software.aspx">Download PDA Software</a></span></td>
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
  </tr>--%>
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
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).
</p>
<div class="maincontentbox">
    <div class="maincontentboxtitle"><img src="images/title-mobile-access.gif" width="128" height="16" alt="Mobile Access" /></div>
	<div class="maincontentboxtext">
	    <h2>Breast Cancer Risk Assessment Tool for Mobile Devices</h2>
		<div style="margin: 0; padding: 0; height: 320px;"><img align="right" src="Images/ms-treo2.jpg" width="175" height="272" style="margin-top: 20px;" /><br />
		    <strong>Mobile device users have:					</strong>
			<ul class="red-arrow">
			    <li style="padding-bottom: 10px;">Mobile Web (all mobile devices) <br />
				    <a href="http://www.cancer.gov/bcrisktoolmobile">http://www.cancer.gov/bcrisktoolmobile</a></li> 
				<%--<li><a href="download-software.aspx">Download and install</a> the tool on your Windows<sup class="trademark">&reg;</sup> Pocket PC<strong>*</strong></li>--%>
			</ul>
			<p><strong>* Please Note</strong>: If you are looking for the downloadable Pocket PC version of the risk assessment tool, the tool has been discontinued as stated in an earlier notice.</p>
		</div>
	</div>
</div>

</asp:Content>