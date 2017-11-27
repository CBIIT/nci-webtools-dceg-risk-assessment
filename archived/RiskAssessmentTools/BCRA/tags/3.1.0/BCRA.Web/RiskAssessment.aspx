<%@ Page MasterPageFile="BCRA.master" Language="C#" AutoEventWireup="true" Inherits="RiskAssessment" Title="Results - BCRA" Codebehind="RiskAssessment.aspx.cs" %>

<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphNav" ID="cntNav" runat="server">
<table width="194" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td  class="navrow" valign="top" width="10">&nbsp;</td>
	<td valign="middle" width="13"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
	<td valign="middle" width="164"><a href="Default.aspx" class="current">Risk Calculator</a></td>
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
	<td valign="middle">&nbsp;</td>
	<td valign="middle"><a href="mobile-access.aspx">Mobile Access</a></td>
	<td valign="top">&nbsp;</td>
  </tr>
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
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool Results" runat="server" />
</asp:Content>


<asp:Content ContentPlaceHolderID="cphMain" ID="cntMail" runat="server">
<p>
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS). See <a class="grey-text" href="about-tool.aspx">About the Tool</a> for more information.
</p>

<div class="maincontentbox">
  <div class="maincontentboxtitle">
  <ul> 
	<li class="left"><img src="images/title-results.gif" width="215" height="18" alt="Results (Breast Cancer Risk)" /></li><li><a href="Default.aspx">New Risk Calculation</a></li></ul> 
 </div>
 <div class="maincontentboxtext">
  <p><em><strong>Reminder:</strong> The Breast Cancer Risk Assessment Tool was designed for use by health professionals. If you are not a health professional, you are encouraged to discuss these results and your personal risk of breast cancer with your doctor.</em></p>  
  <p></p>
  <h2>Race/Ethnicity:</h2>
  <asp:Label ID="lblEthWhite" runat="server" Visible="false"> 
     <p> 
       White
    </p>
  </asp:Label>
  <asp:Label ID="lblEthBlack" runat="server" Visible="false"> 
    <p>
    The tool may underestimate risk for African American women with one or more biopsies. 
    </p>
  </asp:Label>
  <asp:Label ID="lblEthHispanic" runat="server" Visible="false">
    <p>
    Assessments for Hispanic women are subject to greater uncertainty than those for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.
    </p>
  </asp:Label>
  <asp:Label ID="lblEthAsian" runat="server" Visible="false">
  <p>This is Test</p>
    <%--<p>
    Assessments for Asian or Pacific Islander women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.
    </p>--%>
  </asp:Label>
  <asp:Label ID="lblEthNative" runat="server" Visible="false">
    <p>
    Assessments for American Indian or Alaskan Native women are uncertain and are based on data for white women. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.
    </p>
  </asp:Label>
  <asp:Label ID="lblEthUnknown" runat="server" Visible="false">
    <p>
    This risk assessment was based on data for white females. 
    </p>
  </asp:Label>
  <h2>5 Year Risk</h2>
    	<ul class="gray-bg">
  			<li>This woman (age <asp:Label ID="lblCurrentAge" runat="server" />) <asp:Label ID="lbl5YrAbsoluteRisk" runat="server" /></li><li>Average woman (age <asp:Label ID="lblCurrentAge2" runat="server" />): <asp:Label ID="lbl5YrAveragRisk" runat="server" /></li></ul>
	
	<h3>Explanation</h3>
	<p>
	Based on the information provided (see below), the woman's estimated risk for developing invasive breast cancer over the next 5 years is <asp:Label ID="lbl5YrAbsoluteRisk2" runat="server" /> compared to a risk of <asp:Label ID="lbl5YrAveragRisk2" runat="server" /> for a woman of the same age and race/ethnicity from the general U.S. population. This calculation also means that the woman's risk of NOT getting breast cancer over the next 5 years is <asp:Label ID="lbl5YrEstimatedRiskForNotGettingCancer" runat="server" />.
	</p>
	<h2>Lifetime Risk</h2>
		<ul class="gray-bg">
			<li>This woman (to age 90): <asp:Label ID="lblLifetimeAbsoluteRisk90" runat="server" /></li><li>Average woman (to age 90): <asp:Label ID="lblLifeTimeAverageRisk90" runat="server" /></li></ul>
	<h3>Explanation</h3>
	<p>
	Based on the information provided (see below), the woman's estimated risk for developing invasive breast cancer over her lifetime (to age 90) is <asp:Label ID="lblLifetimeAbsoluteRisk902" runat="server" /> compared to a risk of <asp:Label ID="lblLifeTimeAverageRisk902" runat="server" /> for a woman of the same age and race/ethnicity from the general U.S. population.
	</p>
	</div>
	<span style="background: #F7F7E2; padding: 3px 20px; border-top: solid 1px #bbb; border-bottom: solid 1px #bbb; display: block; font-weight: bold;">These results are based upon the following answers:</span>
	<div class="maincontentboxtext">
	<p></p>
  <form action="">
  <table width="466" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" width="330" colspan="2">Does the woman have a medical history of any breast cancer or of <a class="grey-text" href="def-dcis.html" onclick="popUp('def-dcis.html');return false;">ductal carcinoma in situ (DCIS)</a> or <a class="grey-text" href="def-lcis.html" onclick="popUp('def-lcis.html');return false;">lobular carcinoma in situ (LCIS)</a>?</td>
	  <td valign="top" width="8">&nbsp;</td>
	  <td valign="top" width="109" align="right">
	  <b><asp:Label ID="lblAnsHistory" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">What is the woman's age?<br />
		</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsAge" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">What was the woman's age at the time of her first <a class="grey-text" href="def-menst.html" onclick="popUp('def-menst.html');return false;">menstrual period</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsPeriod" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	 <tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">What was the woman's age at the time of her first live birth of a child?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsBirth" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	 <tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">How many of the woman's first-degree relatives - mother, sisters, and/or daughters - have had breast cancer?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsRelatives" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">Has the woman ever had a breast <a class="grey-text" href="def-biopsy.html" onclick="popUp('def-biopsy.html');return false;">biopsy</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsBiopsy" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="10" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px">&nbsp;</td> 
	  <td valign="top" style="width: 19px">a</td>
	  <td valign="top" width="311">How many breast biopsies (positive or negative) has the woman had?</td>
	  <td valign="top" width="8">&nbsp;</td>
	  <td valign="top" width="109" align="right">
	    <b><asp:Label ID="lblAnsNumBiopsies" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="10" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px">&nbsp;</td>
	  <td valign="top" style="width: 19px">b</td>
	  <td valign="top">Has the woman had at least one breast biopsy with <a class="grey-text" href="def-ah.html" onclick="popUp('def-ah.html');return false;">atypical hyperplasia</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	    <b><asp:Label ID="lblAnsHyp" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" style="width: 19px"></td>
	  <td valign="top" colspan="2">What is the woman's race/ethnicity?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right" nowrap>
	    <b><asp:Label ID="lblAnsRace" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False" EnableViewState="False" /></b>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5" style="height: 33px"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
  </table>
  </form>
 </div>
</div>
  <table width="500" cellspacing="0" cellpadding="0" border="0">
	<tr>	  
	  <td valign="top" colspan="5" align="right" style="height: 17px"><br/><a href="Default.aspx"><img src="images/calculate-risk-new.gif" width="150" height="17" alt="New Risk Calculation" /></a></td>
	</tr>  
  </table>
</asp:Content>
