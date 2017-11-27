<%@ Page Language="C#" MasterPageFile="CCRAT.master" AutoEventWireup="true" CodeBehind="colorectal-cancer-risk.aspx.cs" Inherits="CCRAT.Web.colorectal_cancer_risk" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server"><img src="images/colorectal-cancer-risk.gif" width="190" height="18" alt="About the Tool" /></asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleRight" ID="cBoxTitleRight" runat="server"><asp:HyperLink ID="lnlNewCal" NavigateUrl="~/default.aspx" runat="server">New Risk Calculation</asp:HyperLink></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
<div class="maincontentboxtext-paddedText">
    Anything that increases the chance of developing a disease is called a risk factor and anything that decreases the chance of developing a disease is called a protective factor. Risk and protective factors for colorectal cancer include the following:
    <br />
    <br />
    <p>
    <strong>Protective Factors</strong>
    <ul class="red-arrow" style="margin-top: 0;">
        <li>hormone replacement therapy use in women</li>
        <li>regular use of aspirin/non-steroidal anti-inflammatory drug (NSAID)</li>
        <li>colorectal cancer screening</li>
        <li>high vegetable intake</li> 
        <li>regular, vigorous exercise (all activities that cause sweating and heavy breathing)</li>
        <li>maintaining a healthy weight</li>
    </ul>
    </p>
    <p>
    <strong>Risk Factors</strong>
        <ul class="red-arrow" style="margin-top: 0;">
            <li>age (risk increases with age)</li>
            <li>race or ethnicity (African Americans and whites have a higher overall risk of getting colorectal cancer than other racial and ethnic groups)</li>
            <li>history of colorectal polyps</li>
            <li>first-degree relatives (parents, brothers, sisters, or children) with a history of colorectal cancer</li>
            <li>cigarette smoking</li>
            <li>inactive lifestyle</li>
            <li>obesity</li>
        </ul>
    </p>
    <p>
    Diets low in calcium and dietary fiber and high in alcohol have also been related to an increased risk of colorectal cancer in some studies. The measurement of these dietary factors requires a lengthy, detailed assessment that is not practical in most clinical settings and was not included in the tool. 
    </p>
    <p>
    Individuals with a personal history of colorectal cancer should not use this tool to calculate their risk.
    </p>
    <p>
    Individuals with ulcerative colitis, Crohn disease, familial adenomatous polyposis (FAP), or Hereditary Nonpolyposis Colorectal Cancer (HNPCC) have a very high risk of colorectal cancer and the tool should not be used to calculate their risk.
    <ul class="red-arrow">
        <li>Hereditary Nonpolyposis Colorectal Cancer (HNPCC) is the most common type of inherited (genetic) colorectal cancer. It accounts for about 2 percent of all colorectal cancer cases. It is caused by changes in an HNPCC gene. Most people with an altered HNPCC gene develop colorectal cancer, and the average age at diagnosis of colorectal cancer is 44.</li>
        <li>Familial adenomatous polyposis (FAP) is a rare, inherited condition in which hundreds of polyps form in the colon and rectum. It is caused by a change in a specific gene called APC. Unless FAP is treated, it usually leads to colorectal cancer by age 40. FAP accounts for less than 1 percent of all colorectal cancer cases.</li>
        <li>Ulcerative colitis or Crohn disease causes inflammation of the colon and an individual with this condition for many years is at increased risk of developing colorectal cancer.</li>
    </ul>
    <p>
    Researchers are conducting additional studies to gather more data and to determine whether including information on other risk factors can strengthen the Colorectal Cancer Risk Assessment Tool. Based on current knowledge, the tool accurately estimates colorectal cancer risk on average.
    </p>
    <p>
    For more information about colorectal cancer, visit <a href="http://www.cancer.gov/cancertopics/prevention-genetics-causes/colon-and-rectal">Colon and Rectal Cancer: Prevention, Genetics, Causes</a>. 
    </p>
</div>
</asp:Content>