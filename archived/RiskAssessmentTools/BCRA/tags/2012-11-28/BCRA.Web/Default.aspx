<%@ Page MasterPageFile="BCRA.master" Language="C#" AutoEventWireup="true" Inherits="_Default" Title="Breast Cancer Risk Assessment Tool" Codebehind="Default.aspx.cs" %>

<%@ Register Src="PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphNav" ID="cntMail" runat="server">
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

<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server" >
<uc2:PageOptions ID="PageOptions1" EmailTitle="Breast Cancer Risk Assessment Tool" runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphMain" runat="server">
<p>
The Breast Cancer Risk Assessment Tool is an interactive tool designed by scientists at the National Cancer Institute (NCI) and the <a href="http://www.nsabp.pitt.edu/">National Surgical Adjuvant Breast and Bowel Project (NSABP)</a> to estimate a woman's risk of developing <a class="grey-text" href="def-ibc.html" onclick="popUp('def-ibc.html');return false;">invasive breast cancer</a>. The tool has been updated for African American women based on the Contraceptive and Reproductive Experiences (CARE) Study, and for Asian and Pacific Islander women in the United States based on the Asian American Breast Cancer Study (AABCS). See <a class="grey-text" href="about-tool.aspx">About the Tool</a> for more information.</p>

<p>
<strong>Before using the tool, please note the following:</strong>
</p>
<p>
</p>
<ul class="red-arrow">
	<li>The Breast Cancer Risk Assessment Tool was designed for use by health professionals. If you are not a health professional, you are encouraged to discuss the results and your personal risk of breast cancer with your doctor.
	<br /><br />
	</li>
	<li>Although the tool may accurately estimate a woman's risk of developing breast cancer, these risk estimates do not allow one to say precisely which woman will develop breast cancer. In fact, the distribution of risk estimates for women who develop breast cancer overlaps the estimates of risk for women who do not.
	<br /><br />
	</li>
	<li>The tool should not be used to calculate breast cancer risk for women who have already had a diagnosis of breast cancer, <a class="grey-text" href="def-lcis.html" onclick="popUp('def-lcis.html');return false;">lobular carcinoma in situ (LCIS)</a>, or <a class="grey-text" href="def-dcis.html" onclick="popUp('def-dcis.html');return false;">ductal carcinoma in situ (DCIS)</a>.
	<br /><br />
	</li>
	<li>The BCRA risk calculator may be updated periodically as new data or research becomes available.
	<br /><br />
	</li>
	<li>Although the tool has been used with success in clinics for women with strong family histories of breast cancer, more specific methods of estimating risk are appropriate for women known to have breast cancer-producing mutations in the BRCA1 or BRCA2 genes.
	<br /><br />
	</li>
	<li>Other factors may also affect risk and are not accounted for by the tool.  These factors include previous radiation therapy to the chest for the treatment of Hodgkin lymphoma or women who have recently immigrated to the United States from certain regions of Asia where breast cancer risk is low.  Further, the tool may not be appropriate for women living outside the United States. The tool's risk calculations assume that a woman is screened for breast cancer as in the general U.S. population.  A woman who does not have mammograms will have somewhat lower chances of a diagnosis of breast cancer.
    <br /><br />
    </li>
</ul>

<div class="maincontentbox">
  <div class="maincontentboxtitle">
  <ul> 
	<li class="left"><img src="images/title-risk-calculator.gif" width="137" height="18" alt="Risk Calculator" /></li><li>&nbsp;</li> 
  </ul> 
 </div>
 <div class="maincontentboxtext">
  <p>(Click a question number for a brief explanation, or <a href="about-tool.aspx">read all explanations</a>.)</p>
  <form name="risk" id="risk" action="RiskAssessment.aspx" method="get">
  <table width="466" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td valign="top" width="19"><a href="about-tool.aspx#q1">1</a>.</td>
	  <td valign="top" width="330" colspan="2"><label for="history">Does the woman have a medical history of any breast cancer or of </label> <a class="grey-text" href="def-dcis.html" onclick="popUp('def-dcis.html');return false;">ductal carcinoma in situ (DCIS)</a> or <a class="grey-text" href="def-lcis.html" onclick="popUp('def-lcis.html');return false;">lobular carcinoma in situ (LCIS)</a>?</td>
	  <td valign="top" width="8">&nbsp;</td>
	  <td valign="top" width="109" align="right">
	  <select id="history" name="history" onchange="checkHistory()">
	  <option value="">Select</option>
	  <option value="1">Yes</option>
	  <option value="0">No</option>
	  </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top"><a href="about-tool.aspx#q2">2</a>.</td>
	  <td valign="top" colspan="2"><label for="current_age">What is the woman's age?</label><br />
		<em>This tool only calculates risk for women 35 years of age or older.</em></td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="current_age" name="current_age" size="1" onchange="checkAge()">
         <option value="99">Select</option>
         <option value="34">&lt; 35</option>
         <option value="35">35</option>
         <option value="36">36</option>
         <option value="37">37</option>
         <option value="38">38</option>
         <option value="39">39</option>
         <option value="40">40</option>
         <option value="41">41</option>
         <option value="42">42</option>
         <option value="43">43</option>
         <option value="44">44</option>
         <option value="45">45</option>
         <option value="46">46</option>
         <option value="47">47</option>
         <option value="48">48</option>
         <option value="49">49</option>
         <option value="50">50</option>
         <option value="51">51</option>
         <option value="52">52</option>
         <option value="53">53</option>
         <option value="54">54</option>
         <option value="55">55</option>
         <option value="56">56</option>
         <option value="57">57</option>
         <option value="58">58</option>
         <option value="59">59</option>
         <option value="60">60</option>
         <option value="61">61</option>
         <option value="62">62</option>
         <option value="63">63</option>
         <option value="64">64</option>
         <option value="65">65</option>
         <option value="66">66</option>
         <option value="67">67</option>
         <option value="68">68</option>
         <option value="69">69</option>
         <option value="70">70</option>
         <option value="71">71</option>
         <option value="72">72</option>
         <option value="73">73</option>
         <option value="74">74</option>
         <option value="75">75</option>
         <option value="76">76</option>
         <option value="77">77</option>
         <option value="78">78</option>
         <option value="79">79</option>
         <option value="80">80</option>
         <option value="81">81</option>
         <option value="82">82</option>
         <option value="83">83</option>
         <option value="84">84</option>
         <option value="85">85</option>
       </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top"><a href="about-tool.aspx#q3">3</a>.</td>
	  <td valign="top" colspan="2"><label for="age_at_menarche">What was the woman's age at the time of her first</label> <a class="grey-text" href="def-menst.html" onclick="popUp('def-menst.html');return false;">menstrual period</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="age_at_menarche" name="age_at_menarche" size="1">
        <option value="999">Select</option> 
        <option value="99">Unknown</option> 
        <option value="10">7 to 11</option> 
        <option value="13">12 to 13</option> 
        <option value="14">&gt; =14</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	 <tr>
      <td valign="top"><a href="about-tool.aspx#q4">4</a>.</td>
	  <td valign="top" colspan="2"><label for="age_at_first_live_birth">What was the woman's age at the time of her first live birth of a child?</label></td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="age_at_first_live_birth" name="age_at_first_live_birth" size="1">
        <option value="999">Select</option>
        <option value="99">Unknown</option> 
        <option value="0">No births</option> 
        <option value="15">&lt; 20</option> 
        <option value="22">20 to 24</option> 
        <option value="27">25 to 29</option> 
        <option value="30">&gt; =30</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	 <tr>
      <td valign="top"><a href="about-tool.aspx#q5">5</a>.</td>
	  <td valign="top" colspan="2"><label for="related_with_breast_cancer">How many of the woman's first-degree relatives - mother, sisters, daughters - have had breast cancer?</label></td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="related_with_breast_cancer" name="related_with_breast_cancer" size="1">
        <option value="999">Select</option> 
        <option value="99">Unknown</option> 
        <option value="0">0</option> 
        <option value="1">1</option> 
        <option value="2">&gt; 1</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top"><a href="about-tool.aspx#q6">6</a>.</td>
	  <td valign="top" colspan="2"><label for="ever_had_biopsy">Has the woman ever had a breast</label> <a class="grey-text" href="def-biopsy.html" onclick="popUp('def-biopsy.html');return false;">biopsy</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="ever_had_biopsy" name="ever_had_biopsy" size="1" onchange="checkBiopsy()">
        <option value="999">Select</option> 
        <option value="99">Unknown</option> 
        <option value="0">No</option> 
        <option value="1">Yes</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top" width="19">&nbsp;</td>
	  <td valign="top" width="19"><a href="about-tool.aspx#q6">6a</a>.</td>
	  <td valign="top" width="311"><label for="previous_biopsies">How many breast biopsies (positive or negative) has the woman had?</label></td>
	  <td valign="top" width="8">&nbsp;</td>
	  <td valign="top" width="109" align="right">
	  <select id="previous_biopsies" name="previous_biopsies" size="1">
        <option value="999">Select</option> 
        <option value="1">1</option> 
        <option value="2">&gt; 1</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
      <td valign="top">&nbsp;</td>
	  <td valign="top"><a href="about-tool.aspx#q6">6b</a>.</td>
	  <td valign="top"><label for="biopsy_with_hyperplasia">Has the woman had at least one breast biopsy with</label> <a class="grey-text" href="def-ah.html" onclick="popUp('def-ah.html');return false;">atypical hyperplasia</a>?</td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right">
	  <select id="biopsy_with_hyperplasia" name="biopsy_with_hyperplasia" size="1">
        <option value="999">Select</option> 
        <option value="99">Unknown</option> 
        <option value="0">No</option> 
        <option value="1">Yes</option> 
      </select>
	  </td>
    </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
	<td colspan="5">
	<table cellpadding="0" cellspacing="0"  width="466">
		<tr>
		  <td valign="top" width="19"><a href="about-tool.aspx#q7">7</a>.</td>
			<td valign="top"  width="229"  colspan="2"><label for="race">What is the woman's race/ethnicity?</label></td>
			<td valign="top" width="8">&nbsp;</td>
			<td valign="top" align="right" width="210">
			<select id="race" name="race" size="1" onchange="checkEthnicity()" style="width: 210px;">
					<option value="999">Select</option> 
					<option value="1">White</option> 
					<option value="2">African American</option> 
					<option value="3">Hispanic</option> 
					<option value="4">Asian-American</option>
					<option value="5">American Indian or Alaskan Native</option> 
					<option value="6">Unknown</option> 
				</select>
			</td>
			</tr>
	        <tr>
	          <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="20" alt="" /></td>
	        </tr>
	        <tr>
      <td valign="top">&nbsp;</td>
	  <td valign="top"><a href="about-tool.aspx#q7a">7a</a>.</td>
	  <td valign="top"><label for="sub_ethnicity">What is the sub race/ethnicity?</label></td>
	  <td valign="top">&nbsp;</td>
	  <td valign="top" align="right" width="210">
	          <select id="subrace" name="subrace" size="1" style="width: 210px;">
                <option value="999">Select</option> 
                <option value="7">Chinese</option> 
                <option value="8">Japanese</option> 
                <option value="9">Filipino</option> 
                <option value="10">Hawaiian</option> 
                <option value="11">Other Pacific Islander</option> 
                <option value="12">Other Asian-American</option> 
              </select>
	          </td>
            </tr>
	        <tr>
	          <td valign="top" colspan="5"><img src="images/spacer.gif" width="4" height="20" alt="" /></td>
	        </tr>			
		</table>
		</td>    
  </tr>
	<tr>
	  <td valign="top" background="images/questions-divider.gif" colspan="5"><img src="images/questions-divider.gif" width="4" height="20" alt="" /></td>
	</tr>
	<tr>
	  <td valign="top" colspan="5" align="right"><a href="javascript:calculate();"><img src="images/calculate-risk.gif" width="102" height="17" alt="Calculate Risk" /></a></td>
	</tr>
  </table>
  </form>
 </div>
 
 
</div>
</asp:Content>
