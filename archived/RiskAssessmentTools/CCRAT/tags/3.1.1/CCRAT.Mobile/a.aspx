<%@ Page Language="C#" MasterPageFile="CCRAT.Mobile.master" %>
<asp:Content ID="cMC" ContentPlaceHolderID="MC" runat="server">
    <div>
        <a id="top"></a>
        <h2>About the Tool</h2>
    </div>
    <div class="hr">
        <ul>
            <li><a href="#info" class="al">Information for New Users</a></li>
            <li><a href="a-e.aspx">Explaining the Results</a></li>
            <li><a href="a-a.aspx">About the Model</a></li>
            <li><a href="a-r.aspx">References</a></li>
        </ul>
    </div>
    <div>
        <a id="info"></a>
        <h2>Information for New Users</h2>
    </div>
    <div>
        <p>The Colorectal Cancer Risk Assessment Tool estimates the risk that a non-Hispanic white man or woman ages 50-85 will develop colorectal cancer.</p>
        <p>Before using the tool, please note the following:</p>
        <ul>
            <li>The Colorectal Cancer Risk Assessment Tool was designed for use by health professionals and their patients. If you are not a health professional, you are encouraged to discuss the results and your personal risk of colorectal cancer with your healthcare provider.</li>
            <li>It will take approximately five to eight minutes to complete the interactive tool and obtain your risk calculation.</li>
            <li>The tool should not be used to calculate colorectal cancer risk for individuals with ulcerative colitis, Crohn disease, familial adenomatous polyposis (FAP), Hereditary Nonpolyposis Colorectal Cancer (HNPCC) or a personal history of colorectal cancer.</li>
            <li>Additional dietary and physical activity factors and medication use may also affect risk and are not accounted for by the tool.</li>
            <li>For information to help you understand cancer risk visit <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov.</a> This interactive Web site helps patients and health professionals make informed decisions.</li>
        </ul>
    </div>
    <div>
        <label>&lt;&nbsp;Prev | </label><a href="a.aspx">Back to Top</a> | <a href="a-e.aspx">Next&nbsp;&gt;</a>
        <br />
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="f" runat="server" ID="cf">
    <div class="hlnk">
        <div>
            <a href="~/" runat="server" id="a1">CCRAT Home</a>
        </div>
    </div>
</asp:Content>
<asp:Content ID="cflink" ContentPlaceHolderID="flink" Visible="false" runat="server"></asp:Content>