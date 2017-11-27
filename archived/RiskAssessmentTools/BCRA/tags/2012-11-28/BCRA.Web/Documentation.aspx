<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Documentation - BCRA" %>
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
					<td valign="middle" width="12"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="documentation.aspx" class="current">Documentation</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	
				<tr>
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
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).
</p>
<div class="maincontentbox">
  <div class="maincontentboxtitle"><img src="images/title-download-code.gif" width="210" height="16" alt="Download Source Code" /></div>
	<div class="maincontentboxtext">        
        <h2>Documentation</h2>
		<h3>Breast Cancer Risk Assessment Tool, Source Code download Read Me File</h3>
		<p>The BCRA risk calculator may be updated periodically as new data or research becomes available. The algorithm was last updated in May 2011. The current software version is 3.0</p>
	    <p> Download the zip file and unpack it an appropriate directory. The zip file will contain the following two files:</p> 
        <ul class="red-arrow">
            <li>This readme file.</li>
            <li>The NCI.DCEG.BCRA.zip file which contains the source code.</li>
        </ul>
		<p>Unzip the NCI.DCEG.BCRA.zip file into an appropriate directory, you should see the<br />following files:</p>
		<ul class="red-arrow">
			    <li>NCI.DCEG.BCRA.sln: The Visual Studio 2005 solution file. You can double click and run this solution in order to test the breast cancer risk assessment calculation engine.</li>
			    <li>NCI.DCEG.BCRA.ConsoleSample: A sample console application demonstrating the usage of the code.</li>
			    <li>NCI.DCEG.BCRA: A class library project that contains the breast cancer risk assessment calculation engine.</li>
	    </ul>
        <p><a href="download-source-code.aspx"></a></p>
  </div>
	</div>
</asp:Content>