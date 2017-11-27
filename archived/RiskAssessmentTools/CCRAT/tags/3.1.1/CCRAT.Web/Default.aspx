<%@ Page MasterPageFile="NewCCRAT.master" MaintainScrollPositionOnPostback="true" Language="C#" AutoEventWireup="true" Inherits="CCRAT.Web.Default"
    Title="Colorectal Cancer Risk Assessment Tool" CodeBehind="Default.aspx.cs" %>

<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>

<asp:Content ContentPlaceHolderID="cphAdditionHeadElements" runat="server">    
    <script src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.3/prototype.js" type="text/javascript"></script>
    <script src="script/DHtmlModalPopup.js" type="text/javascript"></script>    
    <script language="javascript" type="text/javascript">
           function pop_up(href) {
               window.open(href, "_blank", "menubar=yes, height=845, width=720, status=yes, scrollbars=yes")
           }  
    </script>
    <style type="text/css">
        a.button:link, a.button:visited
        {
          margin: 2px 5px 2px 5px;
          padding: 12px;
          width: 195px;
          height:30px;
          border: 1px solid #cccccc;
          background: #7792C3;
          text-align: center;
          text-decoration: none;
          font: normal 18px arial;
          color: white;
          vertical-align:text-bottom;
        }

        a.button:hover
        {
          background: #4D4D4D;
        }

        a.button:active
        {
          border-bottom: 1px solid #eeeeee;
          border-top: 1px solid black;
          border-right: 1px solid #eeeeee;
          border-left: 1px solid black;
        }
        </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>

<asp:Content ContentPlaceHolderID="cphMainContent" ID="cMainContent" runat="server">
    <asp:PlaceHolder ID="phToolNotes" runat="server">
        <p class="thingsToKnow">
            <strong>Things to know before using this tool:</strong>
        </p>
        <ul class="red-arrow">
            <li>The Colorectal Cancer Risk Assessment Tool was designed for use by doctors and other health providers with their patients.  If you are not a health provider, take these results to your doctor or other health provider to discuss your personal risk of colorectal cancer.  (Colorectal cancer is another way to say colon and rectal cancer).</li>
            <li>This tool can estimate the risk of colorectal cancer for men and women who are:
                <ul>
                    <li><a href="def-age-range.aspx" onclick="popUp(event);return false;">Between the ages of 50 and 85</a></li>
                    <li>African American</li>
                    <li>Asian American/Pacific Islander</li>
                    <li>Hispanic/Latino</li>
                    <li>White</li>
                </ul>
                <p>This tool does not yet apply to American Indians and Alaska Natives, but we are working to improve the tool for use by these groups of people.</p>
                <p>If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, please click <a href="def-other-races.aspx" onclick="popUp(event);return false;">here</a> for more information about race, ethnicity, and how we developed this tool.</p>

            </li>
            <li>This tool cannot accurately estimate risk of colorectal cancer for people who have the following problems:
                <ul>
                    <li>Ulcerative colitis</li>
                    <li>Crohn disease</li>
                    <li>Familial adenomatous polyposis (FAP)</li>
                    <li>Hereditary Nonpolyposis Colorectal Cancer (HNPCC)</li>
                    <li>Personal history of colorectal cancer</li>
                </ul>
            </li>            
            <li>It will take about 5 to 8 minutes to answer all the questions and obtain your risk estimate.</li>
        </ul>
        
    <div style="margin:24px 0 0 20px; text-align:center;">
        <a href="#"  onclick="javascript:pop_up('tool.aspx');" class="button" title="Launch Calculator"  >Risk Calculator ></a>
		<%--<img src="/images/intro_launch.png" id="intro_launch"  onclick="javascript:pop_up('tool.aspx');" alt="Risk Calculator" title="Launch Calculator"  border="0" />--%>
	</div>
     <br />   
    </asp:PlaceHolder>
    
</asp:Content>

