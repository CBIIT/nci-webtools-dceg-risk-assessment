<%@ Page Language="C#" AutoEventWireup="true" Codebehind="results_m.aspx.cs" Inherits="MRAT.results_m" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Results - MRAT</title>
    <meta http-equiv="Content-type" content="text/html; charset=iso-8859-1" />
    <meta http-equiv="imagetoolbar" content="false" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <meta name="MSSmartTagsPreventParsing" content="true" />
    <link href="style/mrat-style.css" rel="stylesheet" type="text/css" media="all" />
    <link href="style/mrat-style-print.css" rel="stylesheet" type="text/css" media="print" />

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
<body>
    <div id="center">
        <!-- Content Headers -->
        <div id="divncibanner">
            <img src="images/nci-banner.gif" alt="nci-banner" width="759" height="39" border="0" usemap="#ncibanner" />
        </div>
        <div id="mratbanner">
            <img src="images/mrat-banner-2.jpg" width="759" height="119" alt="Melanoma Risk Assessment Tool" />
        </div>
        <!-- end Content Headers -->
        <!--bof last modified date and version -->
            <p class="version">Last modified date: 09/10/2008</p>
        <!--eof last modified date and version -->        
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
                                                            <li class="on"><a href="default.aspx">Risk Calculator</a></li>
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
                                                <div class="maincontentbox">
                                                    <div class="maincontentboxtitle">
                                                        <ul>
                                                            <li class="left">
                                                                <img src="images/title-results.gif" width="248" height="18" alt="Results (Melanoma Cancer Risk)" /></li>
                                                            <li><a href="default.aspx">Calculate Risk for New Patients</a></li>
                                                        </ul>
                                                    </div>
                                                    <div class="maincontentboxtext">
                                                        <strong class="riskestimate">The Five-Year <a href="about-tool.html#explaining">Absolute
                                                            Risk</a> of Melanoma is
                                                            <asp:Label runat="server" ID="lblResult" /></strong>. For every 1,000 <asp:Label runat="server" ID="lblSex" /> living in this region with these characteristics, on average <asp:Label runat="server" ID="lblAvg" /> will develop melanoma in the next 5 years.
                                                            
                                                            <span style="background: #F7F7E2;
                                                                margin: 6px 0; padding: 3px 20px; border-top: solid 1px #bbb; border-bottom: solid 1px #bbb;
                                                                display: block; font-weight: bold;">These results are based upon the following answers:</span>
                                                        <p>
                                                            (Click a question number for a brief explanation, or <a href="about-tool.html">read
                                                                all explanations</a>.)</p>
                                                        <form action="">
                                                            <table width="466" cellspacing="0" cellpadding="0" border="0">
                                                                <tr>
                                                                    <td valign="top" width="19">
                                                                        <a href="about-tool.html#q1">1</a>.</td>
                                                                    <td valign="top" width="330" colspan="2">
                                                                        Does the patient live in the Northern, Central, or Southern United States?</td>
                                                                    <td valign="top" width="8">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" width="109" align="right">
                                                                        <asp:Label ID="lblRegion" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False"
                                                                            EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q2">2</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        What is the patient's gender?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblGender" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False"
                                                                            EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q3">3</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        What is the patient's race?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblRace" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False"
                                                                            EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q4">4</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        What is the patient's age?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblAge" runat="server" BorderStyle="Ridge" BorderWidth="0px" Enabled="False"
                                                                            EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q5m">5</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        Has the patient ever had a blistering sunburn?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblBlisterinSunBurn" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" ToolTip="(for males only)" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q6m">6</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        Is the patient's complexion light, medium, or dark?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblComplexion" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q7m">7</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        How many moles larger than 5mm in diameter are on the patient's back?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblLargerMoles" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" ToolTip="(for males only)" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q8m">8</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        How many moles less than or equal to 5mm in diameter are on the patient's back?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblSmallMoles" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q9m">9</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        How extensive is the freckling on the patient's back and shoulders?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblFreckling" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" background="images/questions-divider.gif" colspan="5">
                                                                        <img src="images/questions-divider.gif" width="4" height="33" alt="" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <a href="about-tool.html#q10m">10</a>.</td>
                                                                    <td valign="top" colspan="2">
                                                                        Does the patient have severe solar damage on the shoulders?</td>
                                                                    <td valign="top">
                                                                        &nbsp;
                                                                    </td>
                                                                    <td valign="top" align="right">
                                                                        <asp:Label ID="lblSolarDamage" runat="server" BorderStyle="Ridge" BorderWidth="0px"
                                                                            Enabled="False" EnableViewState="False" ToolTip="(for males only)" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" colspan="5" align="right">
                                                                        <a href="default.aspx">
                                                                            <img src="images/calculate-risk-new.gif" width="202" height="17" vspace="10" alt="Calculate Risk for New Patients" /></a></td>
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
            <br />
            <img src="images/footer-logos.gif" width="176" height="34" alt="footer-logos" border="0" usemap="#internal-footer" />
        </div>        
        <!-- end Footer -->
        
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
    </div>
<!--#include file="analytics_include.html" -->
</body>
</html>
