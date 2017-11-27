<%@ Page Language="C#" AutoEventWireup="true" Codebehind="Index.aspx.cs" Inherits="MRAT.Index" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Melanoma Risk Assessment Tool</title>
    <meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />
    <meta http-equiv="imagetoolbar" content="false" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <meta name="MSSmartTagsPreventParsing" content="true" />
    <link href="style/mrat-style.css" rel="stylesheet" type="text/css" media="all" />
    <link href="style/mrat-style-print.css" rel="stylesheet" type="text/css" media="print" />

    <script src="script/calculator.js" type="text/javascript"></script>

    <script type="text/javascript">
<!-- Begin
function popUp(URL) {
day = new Date();
id = day.getTime();
eval("page" + id + " = window.open(URL, '" + id + "', 'toolbar=0,scrollbars=0,location=0,statusbar=1,menubar=0,resizable=1,width=497,height=262,left = 391.5,top = 381');");
}
// End -->
    </script>

</head>
<body onload="pageSetup();">
<a name="top"></a>
    <div id="center">
        <!-- Content Headers -->
        <div id="divncibanner">
            <img src="images/nci-banner.gif" alt="nci-banner" width="759" height="39" border="0" usemap="#ncibanner" />
        </div>
        <div id="mratbanner">
            <img src="images/mrat-banner-1.gif" width="436" height="119" alt="Melanoma Risk Assessment Tool" /><img
                src="images/mrat-banner-2.jpg" width="323" height="119" alt="Melanoma Risk Assessment Tool" /></div>
        <!-- end Content Headers -->
        <div id="main">
            <!-- Leftnav -->
            <div id="leftnav">
                <div class="north">
                    <div class="east">
                        <div class="south">
                            <div class="west">
                                <div class="ne">
                                    <div class="se">
                                        <div class="sw">
                                            <div class="nwleftnav">
                                                <div id="navigation">
                                                    <a href="#endnav" title="Skip navigation" class="hide">Skip navigation</a>
                                                    <div id="leftnavcontainer">
                                                        <ul>
                                                            <li class="on"><a href="index.aspx">Risk Calculator</a></li>
                                                            <li><a href="about-tool.html">About the Tool</a></li>
                                                            <li><a href="melanoma-cancer-risk.html">Melanoma Cancer Risk</a></li>
                                                        	<li><a href="mobile-access.html">Mobile Access</a></li>
                                                    		<li class="lastni"><a href="download-source-code.html">Download Source Code</a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div id="pageoptions">
                                                    <ul>
                                                        <li class="title">Page Options</li>
                                                        <li><a href="javascript:print()">
                                                            <img src="images/print-icon.gif" width="22" height="12" alt="Print Page" style="vertical-align: middle" />Print
                                                            Page</a></li>
                                                        <li><a id="lnkEmail" runat="server">
                                                            <img src="images/email-icon.gif" width="23" height="10" alt="Email Page" style="vertical-align: middle" />Email
                                                            Page</a></li>
                                                    </ul>
                                                </div>
                                                <!-- Quick Links -->
                                                <!-- #Include file="QuickLinks.ascx"-->
                                                <div id="needhelp">
                                                    <a href="http://www.cancer.gov/help">
                                                        <img src="images/1800.jpg" width="164" height="68" alt="Need help? Call 1-800-4-CANCER" /></a>
                                                </div>
                                                <a name="endnav"></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end Leftnav -->
            <!-- Content box -->
            <div id="content">
                <div class="north">
                    <div class="east">
                        <div class="south">
                            <div class="west">
                                <div class="ne">
                                    <div class="se">
                                        <div class="sw">
                                            <div class="nwcontent">
                                                <p>
                                                    An interactive tool designed by scientists at the National Cancer Institute (NCI),
                                                    the University of Pennsylvania, and the University of California, San Francisco,
                                                    to estimate a person's <a href="about-tool.html#results">absolute risk</a> of
                                                    developing invasive melanoma. The tool helps clinicians identify individuals at
                                                    higher risk of melanoma in order to plan appropriate screening interventions with
                                                    them.</p>
                                                <p>
                                                    <a href="http://dceg.cancer.gov/melanomarisktool_prvw/fears_all.html">JCO Publication</a></p>
                                                <p>
                                                    <strong>Before using the tool, please note the following: </strong>
                                                </p>
                                                <p>
                                                    <ul class="red-arrow">
                                                        <li>The melanoma risk calculator was designed for use by health professionals during
                                                            a routine physical examination that includes recording of information about the
                                                            patient's personal and family medical history and an examination of the skin on
                                                            the patient's back and shoulders. If you are not a health professional, you are
                                                            strongly encouraged to discuss the results obtained with this tool and your personal
                                                            risk of melanoma with your doctor. </li>
                                                        <br />
                                                        <br />
																												<li>The MRAT risk calculator may be updated periodically as new data or research becomes available.</li>
																												<br />
                                                        <br />
                                                        <li>This tool should not be used to estimate melanoma risk for people who have already
                                                            had a diagnosis of melanoma, melanoma-in-situ, non-melanoma skin cancer, or a family
                                                            history of melanoma. These individuals should be in screening and surveillance programs.
                                                        </li>
                                                        <br />
                                                        <br />
                                                        <li>The melanoma risk calculator was developed using data from a large case-control
                                                            study in the United States. Risks are estimated for non-Hispanic whites only; data
                                                            for other races/ethnicities are too limited to accurately estimate risk. </li>
                                                        <br />
                                                        <br />
                                                        <li>A recent version of Internet Explorer, Firefox, or Netscape is recommended. </li>
                                                        <br />
                                                        <br />
                                                        <li>For information to help your patients understand cancer risk visit <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>. This interactive Web site will help your patients make informed decisions about how to lower their risk.
                                                        </li>
                                                    </ul>
                                                </p>
                                                <div class="maincontentbox">
                                                    <div class="maincontentboxtitle">
                                                        <ul>
                                                            <li class="left">
                                                                <img src="images/title-questions.gif" width="92" height="18" alt="Questions" /></li>
                                                            <li>&nbsp;</li>
                                                        </ul>
                                                    </div>
                                                    <div class="maincontentboxtext">
                                                        <p>
                                                            (Click a question number for a brief explanation, or <a id="q0" href="about-tool.html">
                                                                read all explanations</a>.)</p>
                                                        <form name="risk" action="">
                                                            <table width="466" cellspacing="0" cellpadding="0" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_region" class="grp_region" style="display: block; width: 100%">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q1" href="about-tool.html#q1">1</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="region">Does the patient live in the Northern, Central, or Southern United States?</label></td>
                                                                                    <td valign="top" width="8">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" width="109" align="left">
                                                                                        <select id="region" name="region" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="0">North</option>
                                                                                            <option value="1">Central</option>
                                                                                            <option value="2">South</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" colspan="4">
                                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <br />
                                                                                    <img src="images/us-regions.gif" width="349" height="219" alt="Map of US geographic regions."
                                                                                        title="Map of US geographic regions." longdesc="dlink.html#map" />
                                                                                    <br />
                                                                                    <a href="#q2">
                                                                                        <img src="images/spacer.gif" alt="Skip map explanation, go to question 2." width="1"
                                                                                            height="1" border="0" /></a></td>
                                                                                <td valign="top">
                                                                                    &nbsp;&nbsp;&nbsp;</td>
                                                                                <td valign="top">
                                                                                    <p>
                                                                                        <br />
                                                                                        Caution: This map is only a guide. The final choice of region should be made by
                                                                                        the health care provider. The model on which the tool is based is valid only for
                                                                                        residents of the continental United States.</p>
                                                                                    <p>
                                                                                        [ <a href="dlink.html#map">Map Explanation</a> ]
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_sex" class="grp_sex" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q2" href="about-tool.html#q2">2</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="sex">What is the patient's gender?</label>
                                                                                        <br />
                                                                                        <em>Please note: This tool uses gender-specific risk models.&nbsp; It requires different
                                                                                            information of male patients than female patients.&nbsp; The answer to this question
                                                                                            will determine what other questions are asked below.</em></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="right">
                                                                                        <select id="sex" name="sex" onchange="handleSex();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Male</option>
                                                                                            <option value="2">Female</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_race" class="grp_race" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q3" href="about-tool.html#q3">3</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="race">What is the patient's race?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="right">
                                                                                        <select id="race" name="race" onchange="handleRace();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Non-Hispanic White</option>
                                                                                            <option value="2">Other</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_age" class="grp_age" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q4" href="about-tool.html#q4">4</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="age">What is the patient's age?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="right">
                                                                                        <select id="age" name="age" onchange="handleAge();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="under20">19 or younger</option>
                                                                                            <option value="20">20</option>
                                                                                            <option value="21">21</option>
                                                                                            <option value="22">22</option>
                                                                                            <option value="23">23</option>
                                                                                            <option value="24">24</option>
                                                                                            <option value="25">25</option>
                                                                                            <option value="26">26</option>
                                                                                            <option value="27">27</option>
                                                                                            <option value="28">28</option>
                                                                                            <option value="29">29</option>
                                                                                            <option value="30">30</option>
                                                                                            <option value="31">31</option>
                                                                                            <option value="32">32</option>
                                                                                            <option value="33">33</option>
                                                                                            <option value="34">34</option>
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
                                                                                            <option value="more70">71 and older</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_sunburn" class="grp_sunburn" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q5" href="about-tool.html#q5">5</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="sunburn">Ask the patient: Did you ever get a blistering sunburn?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="right">
                                                                                        <select id="sunburn" name="sunburn" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Yes</option>
                                                                                            <option value="2">No</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                    <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_complexion" class="grp_complexion" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q6" href="about-tool.html#q6">6</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="complexion">Ask the patient: Is your complexion light, medium, or dark?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="right">
                                                                                        <select id="complexion" name="complexion" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Light</option>
                                                                                            <option value="2">Medium</option>
                                                                                            <option value="3">Dark</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_tanning" class="grp_tanning" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q7" href="about-tool.html#q7f">7</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="tanning">Ask the patient: After repeated and prolonged exposure to sunlight, at the age you
                                                                                        are now, would your skin become very brown and deeply tanned, moderately tanned,
                                                                                        lightly tanned or not tan at all?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="tanning" name="tanning" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Very brown and deeply tanned</option>
                                                                                            <option value="2">Moderately tanned</option>
                                                                                            <option value="3">Lightly tanned</option>
                                                                                            <option value="4">No tan at all</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_large_moles" class="grp_large_moles" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q8" href="about-tool.html#q8">8</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="large_moles">How many moles larger than 5mm in diameter are on the patient's back?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="large_moles" name="large_moles" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Less than two</option>
                                                                                            <option value="2">Two or more</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_small_moles_males" class="grp_small_moles_males" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q9m" href="about-tool.html#q9">9</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="small_moles_males">How many moles less than or equal to 5mm in diameter are on the patient's back?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="small_moles_males" name="small_moles_males" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Less than seven</option>
                                                                                            <option value="2">Seven to sixteen</option>
                                                                                            <option value="3">Seventeen or more</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_small_moles_females" class="grp_small_moles_females" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q9f" href="about-tool.html#q9f">9</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="small_moles_females">How many moles less than or equal to 5mm in diameter are on the patient's back?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="small_moles_females" name="small_moles_females" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Less than five</option>
                                                                                            <option value="2">Five to eleven</option>
                                                                                            <option value="3">Twelve or more</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_freckling" class="grp_freckling" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q10" href="about-tool.html#q10">10</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="freckling">How extensive is the freckling on the patient's back and shoulders?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="freckling" name="freckling" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="0">Absent</option>
                                                                                            <option value="1">Mild</option>
                                                                                            <option value="2">Moderate</option>
                                                                                            <option value="3">Severe</option>
                                                                                        </select>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" colspan="4">
                                                                                        <img src="images/freckling.jpg" alt="Examples of freckling on patients' backs." width="403"
                                                                                            height="115" border="0" usemap="#Map" hspace="18" vspace="5" /></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <div id="grp_solar_damage" class="grp_solar_damage" style="display: block">
                                                                            <table width="100%">
                                                                                <tr>
                                                                                    <td valign="top" width="19">
                                                                                        <a id="q11" href="about-tool.html#q11">11</a>.</td>
                                                                                    <td valign="top" width="330">
                                                                                        <label for="solar_damage">Does the patient have severe solar damage on the shoulders?</label></td>
                                                                                    <td valign="top">
                                                                                        &nbsp;
                                                                                    </td>
                                                                                    <td valign="top" align="left">
                                                                                        <select id="solar_damage" name="solar_damage" onchange="defaultHandler();">
                                                                                            <option selected="selected" value="-1000">Select</option>
                                                                                            <option value="1">Yes</option>
                                                                                            <option value="2">No</option>
                                                                                        </select>
                                                                                        <br />
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="4" align="left">
                                                                                        <img src="images/shoulders.jpg" alt="Example of severe solar damage to the shoulders."
                                                                                            width="192" height="106" border="0" hspace="22" usemap="#Map2" />
                                                                                        <map name="Map2" id="Map2">
                                                                                            <area shape="rect" coords="0,32,111,106" href="images/mratSevereLrg2.jpg" alt="Image of severe solar damage" target="_blank"
                                                                                                title="Image of severe solar damage" />
                                                                                        </map>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td valign="top" background="images/questions-divider.gif" colspan="4">
                                                                                        <img src="images/spacer.gif" width="4" height="33" alt="" /></td>
                                                                                </tr>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" colspan="4" align="right">
                                                                        <a href="javascript:CalculateRisk();">
                                                                            <img src="images/calculate-risk.gif" width="102" height="17" alt="Calculate Risk" /></a></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" colspan="4">
                                                                        <p>
                                                                            <a href="#top">Back to Top</a></p>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- end Content box -->
        </div>
        <!-- Footer -->
        <div id="footer">
            <a href="http://www.cancer.gov">NCI Home</a>&nbsp;|&nbsp;<a href="http://www.cancer.gov/contact">Contact
                Us</a>&nbsp;|&nbsp;<a href="http://www.cancer.gov/policies">Policies</a>&nbsp;|&nbsp;<a
                    href="http://www.cancer.gov/policies/page4">Accessibility</a><br />
            <br />
            A Service of the National Cancer Institute<br />
            <a href="http://www.hhs.gov/">
                <img src="images/footer-hhs.gif" width="45" height="47" alt="United States Department of Health and Human Services" /></a>
            <a href="http://www.nih.gov/">
                <img src="images/footer-nih.gif" width="47" height="47" alt="National Institutes of Health" /></a>
            <a href="http://www.firstgov.gov/">
                <img src="images/footer-firstgov.gif" width="99" height="47" alt="FirstGov.gov" /></a>
        </div>
        <!-- end Footer -->
    </div>
    <map name="Map" id="Map">
        <area shape="rect" coords="2,28,114,111" href="images/mratMildLrg.jpg" target="_blank" title="Image of mild freckling" alt="Image of mild freckling" />
        <area shape="rect" coords="148,29,257,110" href="images/mratModLrg.jpg" target="_blank" title="Image of moderate freckling" alt="Image of moderate freckling" />
        <area shape="rect" coords="288,29,399,110" href="images/mratSevereLrg.jpg" target="_blank" title="Image of severe freckling" alt="Image of severe freckling" />
    </map>
    <map name="Map3" id="Map3">
        <area shape="rect" coords="1,32,112,106" href="images/mratSevereLrg2.jpg" target="_blank" title="Image of severe solar damage" alt="Image of severe solar damage" />
    </map>
    <!-- Image coordinate map -->
	    <map name="ncibanner" id="ncibanner">
		    <area shape="rect" coords="5,1,286,38" href="http://www.cancer.gov/" alt="National Cancer Institute" />
		    <area shape="rect" coords="486,11,659,32" href="http://www.nih.gov/" alt="U.S. National Institutes of Health" />
		    <area shape="rect" coords="661,11,757,32" href="http://www.cancer.gov/" alt="www.cancer.gov" />
	    </map>
	    <map name="internal-footer" id="internal-footer">
		    <area shape="circle" coords="17,17,17" href="http://www.hhs.gov/" alt="U.S. Department of Health &amp; Human Services" />
		    <area shape="circle" coords="65,17,17" href="http://www.nih.gov/" alt="National Institutes of Health" />
		    <area shape="rect" coords="93,0,176,30" href="http://www.usa.gov/" alt="USA.gov" />
	    </map>      
	<!-- end Image coordinate map -->
</body>
</html>
