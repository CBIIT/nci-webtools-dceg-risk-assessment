<%@ Page Language="C#" MasterPageFile="CCRAT.Mobile.master" %>

<asp:Content ID="cMC" ContentPlaceHolderID="MC" runat="server">
    <div>
        <a id="top"></a>
        <h2>About the Tool</h2>
    </div>
    <div class="h">
        <ul>
            <li><a href="a.aspx">Information for New Users</a></li>
            <li><a href="#ex">Explaining the Results</a></li>
            <li><a href="a-a.aspx">About the Model</a></li>
            <li><a href="a-r.aspx">References</a></li>
        </ul>
    </div>
    <div>
        <a id="explain"></a><h2>Explaining the Results</h2>
    </div>
    <div>
        <p>The Colorectal Cancer Risk Assessment Tool estimates the risk of developing colorectal cancer for non-Hispanic white men and women ages 50 to 85 during the next 5-year and 10-year period up to age 90 (lifetime risk) based on the risk and protective factor information provided. Risk estimates increase with age because the risk of developing colorectal cancer increases with age.</p>
        <p>Risk estimates calculated by the tool are estimates of absolute colorectal cancer risk. Absolute colorectal cancer risk is the probability of developing colorectal cancer in a defined age interval. One way to evaluate the accuracy of the risk estimate is to determine whether it correctly predicts average risk in non-Hispanic white men and women with the same risk factors and age. The Colorectal Cancer Risk Assessment Tool predicts such average risk well.</p>
        <p>At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov.</a></p>
        <p>While risk may be accurately estimated for non-Hispanic white men and women ages 50 to 85, these predictions do not allow one to say precisely which people will develop colorectal cancer. The tool is designed to help patients and their healthcare providers make informed choices about when and how screening should take place.</p>
    </div>
    <div>
        <a href="a.aspx">&lt; Prev</a> | <a href="a-e.aspx">Back to Top</a> | <a href="a-a.aspx">Next&nbsp;&gt;</a>
        <br />
        <a href="q.aspx?restart=true">Begin Risk Calculation</a>
    </div>
</asp:Content>
