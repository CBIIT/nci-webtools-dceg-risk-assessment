<%@ Page Language="C#" MasterPageFile="CCRAT.master" AutoEventWireup="true" %>

<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="cphPageOptions" ID="Content1" runat="server">
    <uc2:PageOptions ID="PageOptions2" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphNav" ID="cntNav" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server">
    <img src="images/title-download-code.gif" alt="Download SAS and Gauss Code" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphMain" ID="cntMain" runat="server">
    <div class="maincontentbox">
        <div class="maincontentboxtext-paddedText">
            <h2>
                Download SAS and Gauss Code for the Colorectal Cancer Risk<br />
                Calculation Engine</h2>
            <p>
                The CCRAT may be updated periodically as new data or research becomes available.
                The algorithm was last updated in June 2010. The current software version is 1.0.</p>
            <p>
                <h2>
                    What You&rsquo;ll Download</h2>
                <br />
                <p>
                    <strong>Colon Cancer Risk Assessment Tool SAS Macro</strong></p>
                <p>
                    The CCRAT SAS macro allows the user to project absolute colon cancer risk according
                    to NCI’s Colon Cancer Risk Assessment Tool (CCRAT) algorithm in batch mode. Risk
                    factor data and projection interval ages can be entered for a group of men or women,
                    and corresponding absolute risk projections will be returned. This program may be
                    useful for research purposes when one needs risk projections for an entire study
                    population.</p>
                <p>
                    You can download ZIP files containing the macro code and <a href="http://dceg.cancer.gov/bb/tools/ccratsasmacro/readme">
                        documentation</a> for the colorectal cancer risk calculation engine. Separate
                    downloads are available for male and female macros.</p>
                <p>
                    By downloading, you accept our <a href="http://dceg.cancer.gov/bb/tools/ccratsasmacro/license">
                        Terms &amp; Conditions</a>.</p>
                <!--<p><a href="files/BCRA_Source_Code.zip"><img src="Images/btn-accept.gif" alt="Accept &amp; Download" width="139" height="25" border="0" /></a></p>-->
                <p>
                    <b>SAS Macro Downloads</b></p>
                <ul type="disc">
                    <li><a href="http://dceg.cancer.gov/files/tools/Men_CRC_RAM.zip">Men_CRC_RAM.zip</a></li>
                    <li><a href="http://dceg.cancer.gov/files/tools/Women_CRC_RAM.zip">Women_CRC_RAM.zip</a></li>
                </ul>
                </ul>
                <p>
                    Save these files in an appropriate folder on your disk.</p>
                <ul>
                    <li><a href="http://dceg.cancer.gov/bb/tools/ccratsasmacro/readme">Readme</a></li>
                    <li><a href="http://dceg.cancer.gov/bb/tools/ccratsasmacro/license">License Agreement</a></li>
                </ul>
                <br />
                <p>
                    <strong>Colon Cancer Risk Assessment Tool Gauss Program</strong></p>
                <p>
                    The CCRAT Gauss Program is an executable that allows the user to project absolute
                    colon cancer risk according to NCI’s Colon Cancer Risk Assessment Tool (CCRAT) algorithm
                    in the batch mode. It also computes 95% confidence intervals for the risk projections.
                    Risk factor data and projection interval ages can be entered for a group of men
                    or women, and corresponding absolute risk projections will be returned. This program
                    may be useful for research purposes when one needs risk projections for an entire
                    study population. The program requires either a 32-bit or a 64-bit system.</p>
                <p>
                    You can download ZIP files containing the program code for the colorectal cancer
                    risk calculation engine. Separate downloads are available for male and female programs.
                    Documentation for the <a href="http://dceg.cancer.gov/files/tools/M_CRCAbsRsk_32bit_ReadMe.fil">
                        male</a> and <a href="http://dceg.cancer.gov/files/tools/W_CRCAbsRsk_32bit_ReadMe.fil">
                            female</a> programs is also available.</p>
                <p>
                    By downloading, you accept our <a href="http://dceg.cancer.gov/bb/tools/ccratgauss/license">
                        Terms &amp; Conditions</a>.</p>
                <p>
                    <b>Gauss Program Downloads</b></p>
                <ul>
                    <li>Males: <a href="http://dceg.cancer.gov/files/tools/M_CRCAbsRsk_32bit.zip">M_CRCAbsRsk_32bit.zip
                        (44.9 MB)</a></li>
                    <li>Females: <a href="http://dceg.cancer.gov/files/tools/W_CRCAbsRsk_32bit.zip">W_CRCAbsRsk_32bit.zip
                        (44.2 MB)</a></li>
                </ul>
                <p>
                    Save these files in an appropriate folder on your disk.</p>
                <ul>
                    <li><a href="http://dceg.cancer.gov/files/tools/M_CRCAbsRsk_32bit_ReadMe.fil" target="_blank">
                        Male Model Readme</a></li>
                    <li><a href="http://dceg.cancer.gov/files/tools/W_CRCAbsRsk_32bit_ReadMe.fil" target="_blank">
                        Female Model Readme</a></li>
                    <li><a href="http://dceg.cancer.gov/bb/tools/ccratgauss/license">License Agreement</a></li>
                </ul>
        </div>
    </div>
</asp:Content>
