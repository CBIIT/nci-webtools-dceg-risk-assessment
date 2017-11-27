<%@ Page MasterPageFile="CCRAT.master" MaintainScrollPositionOnPostback="true" Language="C#" AutoEventWireup="true" Inherits="CCRAT.Web.Default"
    Title="Colorectal Cancer Risk Assessment Tool" CodeBehind="Default.aspx.cs" %>

<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphAdditionalNotes" ID="cAdditionalNotes" runat="server">
    <asp:PlaceHolder ID="phToolNotes" runat="server">
        <p class="thingsToKnow">
            <strong>Things to know before using this tool:</strong>
        </p>
        <ul class="red-arrow">
            <li>It can only estimate the risk of colorectal cancer for men and women who are:
                <ul>
                    <li>White</li>
                    <li>Between the ages of 50 and 85
                    </li>
                </ul>
            </li>
            <li>
                The tool will be updated by spring 2009 for use by African Americans, Hispanics, and Asian Americans.  
                Until the tool is updated, you can access another <a href="http://www.diseaseriskindex.harvard.edu/update/hccpquiz.pl?lang=english&func==home&quiz=colon">online risk assessment tool</a> developed at the Harvard School of Public Health.
            </li>        
            <li>It cannot accurately estimate colorectal cancer risk for people who have the following problems:
                <ul>
                    <li>Ulcerative colitis</li>
                    <li>Crohn disease</li>
                    <li>Familial adenomatous polyposis (FAP)</li>
                    <li>Hereditary Nonpolyposis Colorectal Cancer (HNPCC)</li>
                    <li>Personal history of colorectal cancer</li>
                </ul>
            </li>
            <li>This tool also does not account for your diet or physical activity.</li>
            <li>This tool should be used by health professionals with their patients. If you are not a health professional, please discuss the results with your doctor. He or she is in the best position to help you understand your risk of colorectal cancer.</li>
            <li>It will take about 5 to 8 minutes to answer all the questions in the tool and obtain your risk calculation.</li>            
            <li>The Colorectal Cancer Risk Assessment Tool will be updated as new data or research become available.</li>
            <li>For information to help you understand cancer risk, visit <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>. This Web site helps patients and health professionals make informed decisions.</li>
        </ul>
    </asp:PlaceHolder>
</asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server"><asp:Image ID="imgQuestionBoxTitle" ImageUrl="~/images/title-risk-calculator.gif" width="137" height="18" AlternateText="Risk Calculator" runat="server" /><asp:Image ID="imgResults" ImageUrl="~/images/title-results.gif" width="268" height="18" AlternateText="Risk Calculator" runat="server" /></asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleRight" ID="cBoxTitleRight" runat="server"><asp:Literal ID="litEmpty" runat="server">&nbsp;</asp:Literal><asp:HyperLink ID="lnlExpResults" NavigateUrl="~/about-tool.aspx#explaining" runat="server">About the results</asp:HyperLink></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
    <asp:PlaceHolder ID="phToolView" runat="server" />
</asp:Content>
