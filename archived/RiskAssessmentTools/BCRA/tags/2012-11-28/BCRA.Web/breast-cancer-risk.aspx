<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="Breast Cancer Risk - BCRA"%>

<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<script runat="server">

</script>

<asp:Content ContentPlaceHolderID="cphNav" ID="cntNav" runat="server">
<table width="194" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td  class="navrow" valign="top" width="10">&nbsp;</td>
	<td valign="top" width="13">&nbsp;</td>
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
	<td valign="middle"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
	<td valign="middle"><a href="breast-cancer-risk.aspx" class="current">Breast Cancer Risk</a></td>
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
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool" runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphMain" ID="cntMain" runat="server">
<p>
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).
</p>

<div class="maincontentbox">
  <div class="maincontentboxtitle">
  <ul> 
	<li class="left"><img src="images/breast-cancer-risk.gif" width="169" height="18" alt="Breast Cancer Risk" /></li>  
	<li><a href="Default.aspx">New Risk Calculation</a></li> 
  </ul> 
 </div>
 <div class="maincontentboxtext">
<p>Anything that increases the chance of developing a disease is called a risk factor. Risk factors for breast cancer include the following:</p>

<ul class="red-arrow">
	<li>age</li>
	<li>age at the start of <a class="grey-text" href="def-menst.html" onclick="popUp('def-menst.html');return false;">menstruation</a></li>
	<li>age at first live birth</li>
	<li>number of first-degree relatives (mother, sisters, daughters) with breast cancer</li>
	<li>number of previous breast <a class="grey-text" href="def-biopsy.html" onclick="popUp('def-biopsy.html');return false;">biopsies</a> (whether positive or negative)</li>
	<li>at least one breast biopsy with <a class="grey-text" href="def-ah.html" onclick="popUp('def-ah.html');return false;">atypical hyperplasia</a></li>
</ul>

<p>Other risk factors, such as age at menopause, dense breast tissue on a mammogram, use of birth control pills or hormone replacement therapy, a high-fat diet, drinking alcohol, low physical activity, obesity, or environmental exposures, are not included in risk estimates with the Breast Cancer Risk Assessment Tool for three reasons: evidence is not conclusive or researchers cannot accurately determine how much these factors contribute to the calculation of risk for an individual woman, or adding these factors does not increase the accuracy of the tool appreciably. </p> 

<p>Breast cancer may also be caused by inherited gene mutations. Hereditary breast cancers account for approximately 5% to 10% of all breast cancers. Specific hereditary predispositions for breast cancer, such as inheriting a mutation in either the BRCA1 or BRCA2 gene, are not taken into account in risk estimates with the Breast Cancer Risk Assessment Tool. Although the tool performs well in clinics where women have a strong family history of breast cancer, more specific methods for projecting risk are appropriate if a woman is known to carry a breast cancer-producing mutation in BRCA1 or BRCA2.  </p> 

<p>Researchers are, however, conducting additional studies to gather more data and to determine whether including information on other risk factors can strengthen the statistical model, called the <a href="about-tool.aspx#gail">Gail model</a>, upon which the Breast Cancer Risk Assessment Tool is based. Nonetheless, the current model estimates breast cancer risk accurately on average.</p>   

<p>For more information on breast cancer risk, please visit <a href="http://www.cancer.gov/cancertopics/prevention-genetics-causes/breast">Breast Cancer: Prevention, Genetics, Causes</a>.</p> 
 </div>
 
 
</div>

</asp:Content>
