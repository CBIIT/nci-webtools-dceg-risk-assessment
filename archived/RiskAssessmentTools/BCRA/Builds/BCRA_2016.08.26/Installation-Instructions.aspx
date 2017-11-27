<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Installation Instructions - BCRA" %>
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
					<td valign="middle" width="12">&nbsp;</td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="download-software.aspx">Download PDA Software</a></span></td>
					<td valign="top" width="7">&nbsp;</td>
				</tr>	<tr>
					<td valign="top" colspan="5" bgcolor="#E4E4D3"><img src="images/spacer.gif" width="1" height="1" alt="" /></td>
				</tr>  
				<tr onmouseover="this.bgColor='#ffffff'" onmouseout="this.bgColor='#F2F5F8'">
					<td  class="navrow" valign="top" width="10">&nbsp;</td>
					<td valign="middle" width="13">&nbsp;</td>
					<td valign="middle" width="12"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
					<td valign="middle" width="152"><span class="subnavrow"><a href="installation-instructions.aspx" class="current">Installation Instructions</a></span></td>
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
 					<p><strong>Please Note</strong>: The downloadable Pocket PC version of the risk assessment tool has not been updated with the new, 
			more accurate risk information for African American women (the CARE model). NCI will be discontinuing the 
			Pocket PC version in the Spring of 2008 but will continue to support and update the Web and Mobile Web versions of 
			the Breast Cancer Risk Assessment Tool.</p>

			<h2>Installation Instructions</h2>
			<ol class="install-instruct">
			    <li>Confirm that the .NET Compact Framework 2.0 is installed on your Pocket PC. 
			    If not, you will need to download and install the framework. 
			    See the <a href="#FAQ">Frequently Asked Questions</a> for step-by-step instructions.</li>
			    <li>Place your Pocket PC in its cradle.</li>
			    <li>Save the BCRAMobileSetup.exe file to a folder on your PC. 
			    Once the download completes, double-click on the file and follow the installation instructions. 
			    The BCRA Pocket PC application will be installed directly to the device.</li>
			    <li>The BCRA Pocket PC application is now installed on your Pocket PC and a program icon has been placed in the Pocket PC’s Programs folder. Please tap the program icon on your Pocket PC to launch the BCRA Pocket PC application.</li>
			    <li>Periodically you may need to download and install updates to the BCRA Pocket PC application. The application will remind you to check for updates every six months.</li>
			</ol>
			<div class="FAQ">
			    <a name="FAQ"></a>
			    <h2>Common Installation Problems / Frequently Asked Questions (FAQ)</h2>
			    <h3>I can't run the BCRAMobileSetup.exe file on my PC.</h3>
			    If you do not have Administrator privileges on your PC, you may need to contact your computer systems support staff to assist with the installation process.
    			
    			<h3>Why do I get an error when I try to synchronize my Pocket PC?</h3>
    			Synchronization errors are often caused by insufficient memory. To check the memory on your Pocket PC, see the instructions below.
    			
    			<a name="FAQ_CheckMem"></a>
			    <h3>How do I make sure my Pocket PC has enough memory to meet the system requirements?</h3>
			    To check the existing memory:
			    <ol>
			        <li>Open the Pocket PC’s Start menu.</li>
                    <li>Select Settings.</li>
                    <li>Select System.</li>
                    <li>Select Memory to view your current memory usage.</li>
			    </ol>
			    To free additional memory on your Pocket PC, you may have to remove unused programs and files.  To remove programs:
			    <ol>
                    <li>Go to the Pocket PC’s Start menu</li>
                    <li>Select Settings.</li>
                    <li>Select the System tab.</li>
                    <li>Select Remove Programs.</li>
                    <li>Tap a program that you want to delete and then tap Remove.  Use File Explorer to remove data files that are no longer needed.</li>
			    </ol>
    			
			    <h3>I ran the Installer and synchronized my Pocket PC, but I can't find the BCRA Pocket PC application.</h3>
			    It's possible that the BCRA Pocket PC application did not completely install during synchronization.
			    <ol>
                    <li>Synchronize again and check whether the application was successfully installed.</li>
                    <li>If not, check if there is enough memory available memory on your Pocket PC. You may have to free up additional memory to successfully complete the installation process.</li>
                    <li>If the BCRA Pocket PC application still has not been installed on your Pocket PC, run BCRAMobileSetup.exe again and proceed as directed.  Allow the setup program to repair the application.</li>
			    </ol>
    			
			    <h3>How do I re-install the BCRA Pocket PC application after I perform a Hard Reset on my Pocket PC?</h3>
			    A Hard Reset removes all applications and data from your Pocket PC. To re-install the BCRA Pocket PC application, cradle your Pocket PC, run BCRAMobileSetup.exe, and follow the on-screen instructions.  Allow the setup program to repair the application.
    			
			    <h3>I purchased a new Pocket PC and want to install the BCRA Pocket PC application on it.</h3>
			    Cradle your new Pocket PC, run BCRAMobileSetup.exe, and follow the on-screen instructions.  Allow the setup program to repair the application.
    			
    			<a name="FAQ_CF"></a>
			    <h3>How do I confirm that the .NET Compact Framework 2.0 is installed on my Pocket PC?</h3>
			    <ol>
                    <li>Open the Pocket PC’s Start menu.</li>
                    <li>Select Settings.</li>
                    <li>Select System.</li>
                    <li>Select Remove Programs.</li>
                    <li>See if Microsoft<sup class="trademark">&reg;</sup> .NET CF 2.0 appears in the list of programs</li>
                    <li><strong>Do not delete any programs.</strong> Exit the screen.</li>
			    </ol>
    			
			    <h3>How do I install the .NET Compact Framework 2.0 on my Pocket PC?</h3>
			    <ol>
                    <li>Download the <a href="http://www.microsoft.com/downloads/details.aspx?familyid=9655156b-356b-4a2c-857c-e62f50ae9a55&displaylang=en" target="new">Compact Framework</a> from the Microsoft<sup class="trademark">&reg;</sup> website to your PC.</li>
                    <li>Double-click on the NETCFSetupv2.msi file and follow the installation instructions.</li>
                </ol>
            </div>
            
            <p><a href="#top">Back to Top</a></p>

            <cite>Microsoft and Windows are either registered trademarks or trademarks of Microsoft Corporation in the United States and/or other countries.</cite>
        </div>
	</div>


</asp:Content>