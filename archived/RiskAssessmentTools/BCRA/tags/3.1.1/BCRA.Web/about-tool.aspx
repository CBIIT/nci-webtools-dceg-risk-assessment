<%@ Page MasterPageFile="BCRA.master" Language="C#" Title="About The Tool - BCRA" %>

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
	<td valign="middle"><img src="images/red-arrow.gif" width="5" height="7" alt="" /></td>
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
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS).</p>


<div class="maincontentbox">
<a name="questions"></a>
  <div class="maincontentboxtitle">
  <ul> 
	<li class="left"><img src="images/about_the_tool.gif" width="146" height="20" alt="About The Tool" /></li><li><a href="Default.aspx">New Risk Calculation</a></li></ul> 
 </div>
 <div class="content-anchors">
	<ul>
		<li><a href="#eq">Explaining the Questions</a>  &nbsp;|&nbsp; </li>
 		<li><a href="#explaining">Explaining the Results</a>  &nbsp;|&nbsp; </li> 
 		<li><a href="#gail">About the Gail Model</a>  &nbsp;|&nbsp; </li>
 		<li><a href="#references">References</a></li></ul>
 </div>
 <div class="maincontentboxtext">

<a name="eq"></a>
<h2>Explaining the Questions</h2><br />
    <p>
        <strong>Question 1:</strong><br /> 
<em>Does the woman have a medical history of any breast cancer or of ductal carcinoma in situ (DCIS) or lobular carcinoma in situ (LCIS)?</em>
    </p>
<p>
<strong>Explanation</strong><br /> 
A medical history of <a class="grey-text" href="def-dcis.html" onclick="popUp('def-dcis.html');return false;">ductal carcinoma in situ (DCIS)</a> or <a class="grey-text" href="def-lcis.html" onclick="popUp('def-lcis.html');return false;">lobular carcinoma in situ (LCIS)</a> increases the risk of developing invasive breast cancer. The method used by the Breast Cancer Risk Assessment Tool to calculate the risk of invasive breast cancer is not accurate for women with a history of DCIS or LCIS. In addition, the tool cannot accurately predict the risk of another breast cancer for women who have a medical history of breast cancer.
</p>
<p>
<a name="q2"></a>
<strong>Question 2:</strong><br />  
<em>What is the woman's age?</em>
</p>
<p>
<strong>Explanation</strong><br /> 
The risk of developing breast cancer increases with age. The great majority of breast cancer cases occur in women older than age 50. Most cancers develop slowly over time. For this reason, breast cancer is more common among older women. 
</p>
<p>
<strong>Note:</strong> <em>This tool only calculates risk for women 35 years of age or older.</em>
</p>
<p>
<a name="q3"></a>
<strong>Question 3:</strong><br />  
<em>What was the woman's age at time of her first <a class="grey-text" href="def-menst.html" onclick="popUp('def-menst.html');return false;">menstrual period</a>?</em>
</p>
<p>
<strong>Explanation</strong><br /> 
Women who had their first menstrual period before age 12 have a slightly increased risk of breast cancer. The levels of the female hormone estrogen change with the menstrual cycle. Women who start menstruating at a very young age have a slight increase in breast cancer risk that may be linked to their longer lifetime exposure to estrogen. 
</p>
<p>
<a name="q4"></a>
<strong>Question 4:</strong><br />  
<em>What was the woman's age at her first live birth of a child?</em> </p>
<p>
<strong>Explanation</strong><br /> 
Risk depends on many factors, including age at first live birth and family history of breast cancer. The relationship of these two factors in white women is shown in the following table of relative risks.
</p>
<p>Relative Risk of Developing Breast Cancer*</p>

<table width="400" cellpadding="5" cellspacing="0" border="1">
	<tr>
		<td valign="top" rowspan="2">Age at first<br /> live birth</td>
		<td valign="top" colspan="3"># of affected relatives</td>
	</tr>
	<tr>
		<td valign="top">0</td>
		<td valign="top">1</td>
		<td valign="top">2 or more</td>
	</tr>
	<tr>
		<td valign="top">20 or younger</td>
		<td valign="top">1</td>
		<td valign="top">2.6</td>
		<td valign="top">6.8</td>
	</tr>
	<tr>
		<td valign="top">20-24</td>
		<td valign="top">1.2</td>
		<td valign="top">2.7</td>
		<td valign="top">5.8</td>
	</tr>
	<tr>
		<td valign="top">25-29 or no child</td>
		<td valign="top">1.5</td>
		<td valign="top">2.8</td>
		<td valign="top">4.9</td>
	</tr>
	<tr>
		<td valign="top">30 or older</td>
		<td valign="top">1.9</td>
		<td valign="top">2.8</td>
		<td valign="top">4.2</td>
	</tr>
</table>


<p>For women with 0 or 1 affected relative, risks increase with age at first live birth. For women with 2 or more first degree relatives, risks decrease with age at first live birth. </p> 

<p>* Adapted from Table 1, Gail MH, Brinton LA, Byar DP, Corle DK, Green SB, Shairer C, Mulvihill JJ: Projecting individualized probabilities of developing breast cancer for white females who are being examined annually. J Natl Cancer Inst 81(24):1879-86, 1989. [PubMed Abstract]
</p>
<p>
<a name="q5"></a>
<strong>Question 5:</strong><br />  
<em>How many of the woman's first-degree relatives - mother, sisters, daughters &nbsp;- have had breast cancer?</em>
</p>
<p>
<strong>Explanation</strong><br /> 
Having one or more first-degree relatives (mother, sisters, daughters) who have had breast cancer increases a woman's chances of developing this disease.
</p>
<p>
<a name="q6"></a>
<strong>Question 6:</strong><br />  
<em>Has the woman ever had a breast <a class="grey-text" href="def-biopsy.html" onclick="popUp('def-biopsy.html');return false;">biopsy</a>?</em><br />
<a name="q6a"></a>
<em>6a: How many previous breast biopsies (positive or negative) has the woman had?</em><br />
<a name="q6b"></a>
<em>6b: Has the woman had at least one breast biopsy with <a class="grey-text" href="def-ah.html" onclick="popUp('def-ah.html');return false;">atypical hyperplasia</a>?</em>
</p>
<p>
<strong>Explanation</strong><br /> 
Women who have had breast biopsies have an increased risk of breast cancer, especially if their biopsy specimens showed atypical hyperplasia. Women who have a history of breast biopsies are at increased risk because of whatever breast changes prompted the biopsies. Breast biopsies themselves do not cause cancer.
</p>
<p>
<a name="q7"></a>
<strong>Question 7:</strong><br />  
<em>If known, please indicate the woman's race/ethnicity.</em>
</p>
<p>
<strong>Explanation</strong><br /> 
The original Breast Cancer Risk Assessment Tool was based on data from white women.  But race/ethnicity can influence the calculation of  breast cancer risk. The model for African American women was derived from the Women’s Contraceptive and Reproductive Experiences (CARE) Study (see reference 5) and NCI’s SEER Program. The model for Asian and Pacific Islander women in the United States was derived from the Asian American Breast Cancer Study (AABCS) and NCI’s SEER Program (see reference 6).  For Hispanic women, part of the model is derived from white women who participated in the Breast Cancer Detection Demonstration Project and from SEER data. The risk estimates for Hispanic women are therefore subject to greater uncertainty than those for white women. Calculations for American Indian and Alaskan Native women are based entirely on data for white women and may not be accurate. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations.
</p>
<p>
<strong>Note:</strong> <em>If the woman's race/ethnicity is unknown, the tool will use data for white females to estimate the predicted risk.</em>
</p> 
<p>
<a name="q7a"></a>
<strong>Question 7a:</strong><br />  
<em>What is the sub race/ethnicity?</em>
</p>
<p>
<strong>Explanation</strong><br /> 
To calculate breast cancer risk using Asian-American as the race/ethnicity, the sub race/ethnicity needs to be known. If the sub-category of race/ethnicity is not known, then “Unknown” should be selected in Question 7, rather than Asian-American.  The “Other Asian American” category includes women of Asian Indian/Pakistani, Korean, Vietnamese, Laotian, and Kampuchean descent.  The “Other Pacific Islander” category includes women of Guamanian, Samoan, and Tongan descent.
</p>
<p>
<a href="#top">Back to Top</a>
</p>

<a name="explaining"></a>
<h2>Explaining the Results</h2>

<p>The Breast Cancer Risk Assessment Tool will estimate a woman's risk of developing invasive breast cancer during the next 5-year period and up to age 90 (lifetime risk) based on the woman's age and the risk factor information provided. For comparison, the tool will then calculate 5-year and lifetime risk estimates for a woman of the same age who is at average risk for developing breast cancer. Lifetime risk estimates are higher than 5-year estimates because breast cancer risk increases with years at risk.</p>

<p>Although the tool may accurately estimate a woman's risk of developing breast cancer, these risk estimates do not allow one to say precisely which woman will develop breast cancer. In fact, the distribution of risk estimates for women who develop breast cancer overlaps the estimates of risk for women who do not.</p>

<p>Risk estimates calculated by the tool are estimates of absolute breast cancer risk. Absolute breast cancer risk is the chance or probability of developing invasive breast cancer in a defined age interval.  One way to evaluate the accuracy of the risk estimate is to determine whether it correctly predicts average risk in a group of women with the same risk factors and age.  The Breast Cancer Risk Assessment Tool does predict such average risks well. </p>

<p>Although a woman's risk may be accurately estimated, these predictions do not allow one to say precisely which woman will develop breast cancer.  In fact, the distribution of risk estimates for women who develop breast cancer overlaps the estimates of risk for women who do not.  </p>

<p>The BCRA risk calculator may be updated periodically as new data or research becomes available.</p>

<p>
<a href="#top">Back to Top</a>
</p>

<a name="gail"></a>
<h2>About the Gail Model</h2>
    <p>
        The Breast Cancer Risk Assessment Tool is based on a statistical model known as the "Gail model," which is named after Dr. Mitchell Gail, Senior Investigator in the Biostatistics Branch of NCI's Division of Cancer Epidemiology and Genetics. The model uses a woman's own personal medical history (number of previous breast biopsies and the presence of atypical hyperplasia in any previous breast biopsy specimen), her own reproductive history (age at the start of menstruation and age at the first live birth of a child), and the history of breast cancer among her first-degree relatives (mother, sisters, daughters) to estimate her risk of developing invasive breast cancer over specific periods of time. Data from the Breast Cancer Detection Demonstration Project (BCDDP), which was a joint NCI and American Cancer Society breast cancer screening study that involved 280,000 women aged 35 to 74 years, and from NCI's Surveillance, Epidemiology, and End Results (SEER) Program were used in developing the model. Estimates for African American women were based on data from the Women’s Contraceptive and Reproductive Experiences (CARE) Study and from SEER data. CARE participants included 1,607 women with invasive breast cancer and 1,637 without. Estimates for Asian and Pacific Islander women in the United States were based on data from the Asian American Breast Cancer Study (AABCS) and SEER data. AABCS participants included 597 Asian and Pacific Islander women with invasive breast cancer, and 966 women without breast cancer.
    </p>
    <p>
        The Gail model has been tested in large populations of white women and has been shown to provide accurate estimates of breast cancer risk. In other words, the model has been "validated" for white women. It has also been tested in data from the Women’s Health Initiative for African American women, and the model performs well, but may underestimate risk in African American women with previous biopsies.The model has been validated for Asian and Pacific Islander women in the WHI and data from SEER. The model still needs to be validated for Hispanic women and other subgroups, and results should be interpreted by a health care provider for women with special risk factors, such as women treated for Hodgkin’s disease with radiation to the chest and carriers of gene mutations that increase breast cancer risk. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to test and improve the model.
    </p>

    <p>
        The BCRA risk calculator may be updated periodically as new data or research becomes available. The algorithm was last updated in 2011.
    </p>
<p>
<a href="#top">Back to Top</a>
</p>

<a name="references"></a>
<h2>References</h2>

<ol>
	<li>Gail MH, Brinton LA, Byar DP, Corle DK, Green SB, Shairer C, Mulvihill JJ: Projecting individualized probabilities of developing breast cancer for white females who are being examined annually. J Natl Cancer Inst 81(24):1879-86, 1989. [<a href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=2593165&query_hl=4&itool=pubmed_docsum">PubMed Abstract</a>]</li><br /><br />
	<li>Costantino JP, Gail MH, Pee D, Anderson S, Redmond CK, Benichou J, Wieand HS: Validation studies for models projecting the risk of invasive and total breast cancer incidence. J Natl Cancer Inst 91(18):1541-8, 1999. [<a href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=10491430&query_hl=3&itool=pubmed_docsum">PubMed Abstract</a>]</li><br /><br />
	<li>Gail MH, Costantino JP, Bryant J, Croyle R, Freedman L, Helzlsouer K, Vogel V: Weighing the risks and benefits of tamoxifen treatment for preventing breast cancer. J Natl Cancer Inst 91(21):1829-46, 1999. [<a href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=10547390&query_hl=5&itool=pubmed_docsum">PubMed Abstract</a>]</li><br /><br />
	<li>Rockhill B, Spiegelman D, Byrne C, Hunter DJ, Colditz GA: Validation of the Gail et al. model of breast cancer risk prediction and implications for chemoprevention. J Natl Cancer Inst 93(5):358-66, 2001. [<a href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=11238697&query_hl=7&itool=pubmed_docsum">PubMed Abstract</a>]</li><br /><br /> 
    <li>Gail MH, Costantino JP, Pee D, Bondy M, Newman L, Selvan M, Anderson GL, Malone KE, Marchbanks PA, McCaskill-Stevens W, Norman SA, Simon MS, Spirtas R, Ursin G, and Bernstein L. Projecting Individualized Absolute Invasive Breast Cancer Risk in African American Women. J Natl Cancer Inst 99(23):1782-1792, 2007. [<a href="http://www.ncbi.nlm.nih.gov/pubmed/11238697?dopt=Abstract">PubMed Abstract</a>]</li><br /><br />
    <li>Matsuno RK, Costantino JP, Ziegler RG, Anderson GL, Li H, Pee D, Gail MH. Projecting Individualized Absolute Invasive Breast Cancer Risk in Asian and Pacific Island American Women. J Natl Cancer Inst 2011. doi:10.1093/jnci/djr154</li>
</ol>
<p>
<a href="#top">Back to Top</a>
</p>

 </div>
 
 
</div>

</asp:Content>