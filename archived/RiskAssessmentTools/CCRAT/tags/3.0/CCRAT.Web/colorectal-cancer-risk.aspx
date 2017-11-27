<%@ Page Language="C#" MasterPageFile="CCRAT.master" AutoEventWireup="true" CodeBehind="colorectal-cancer-risk.aspx.cs" Inherits="CCRAT.Web.colorectal_cancer_risk" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server"><img src="images/colorectal-cancer-risk-factors.gif" width="255" height="18" alt="colorectal cancer risk factors" /></asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleRight" ID="cBoxTitleRight" runat="server"><asp:HyperLink ID="lnlNewCal" NavigateUrl="~/default.aspx" runat="server">New Risk Calculation</asp:HyperLink></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
<div class="maincontentboxtext-paddedText">
    <%--<h2>Factors that can cause colorectal cancer and protect against it</h2>--%>
    <p>Studies show that certain factors can make your risk of colorectal cancer higher and others can make it lower.</p>
    <p><strong>Factors that can lower your risk of colorectal cancer include:</strong></p>
    <ul class="red-arrow" style="margin-top: 0;">
        <li>colorectal cancer screening</li>
        <li>regular use of aspirin and NSAID’s (which stands for non-steroidal anti-inflammatory drug)</li>
        <li>maintaining a healthy weight</li>
        <li>regular, vigorous exercise (all activities that cause sweating and heavy breathing)</li>
        <li>a diet high in vegetables</li>
        <li>hormone replacement therapy use in women</li>
    </ul>
    <p><strong>Factors that can make your risk of colorectal cancer higher include:</strong></p>
    <ul class="red-arrow" style="margin-top: 0;">
        <li>close relatives (parents, brothers, sisters, or children) who have had colorectal cancer</li>
        <li>history of colorectal polyps</li>
        <li>obesity</li>
        <li>cigarette smoking</li>
        <li>inactive lifestyle</li>
    </ul>
    <p>If you have had colorectal cancer, you should not use this tool to estimate your risk of recurrence.</p>
    <p>If you have a problem such as ulcerative colitis, Crohn disease, familial adenomatous polyposis (FAP), or Hereditary Nonpolyposis Colorectal Cancer (HNPCC), you should not use this tool to estimate your risk. These problems make your risk of colorectal cancer much higher.</p>
    <ul class="red-arrow" style="margin-top: 0;">
        <li>HNPCC is the most common type of genetic colorectal cancer. It accounts for about 2 percent of all colorectal cancer cases. It is caused by changes in an HNPCC gene. Most people with these changes in the HNPCC gene develop colorectal cancer, and the average age at diagnosis is 44.</li>
        <li>FAP is a rare, genetic disease in which hundreds of polyps form in the colon and rectum. It is caused by a change in a gene called APC. Unless FAP is treated, it usually leads to colorectal cancer by age 40. FAP accounts for less than 1 percent of all colorectal cancer cases.</li>
        <li>Ulcerative colitis and Crohn disease both cause inflammation of the colon. If you have either of these diseases over many years, you have a higher risk of colorectal cancer.</li>
    </ul>    
    <p>Researchers are conducting more studies to gather more data and to determine if including information on other risk factors can strengthen the Colorectal Cancer Risk Assessment Tool.</p>
    <p>For more information about colorectal cancer, visit <a href="http://www.cancer.gov/cancertopics/prevention-genetics-causes/colon-and-rectal">Colon and Rectal Cancer: Prevention, Genetics, Causes.</a></p>
</div>
</asp:Content>