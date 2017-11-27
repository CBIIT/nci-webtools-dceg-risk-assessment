<%@ Page Language="C#" MasterPageFile="CCRAT.Mobile.master" %>

<asp:Content ID="cMC" ContentPlaceHolderID="MC" runat="server">
  <div>
        <a id="top"></a>
        <h2>About the Tool</h2>
    </div>
    <div class="h">
        <ul>
            <li><a href="a.aspx">Information for New Users</a></li>
            <li><a href="a-e.aspx">Explaining the Results</a></li>
            <li><a href="a-a.aspx">About the Model</a></li>
            <li><a href="a-r.aspx">References</a></li>
        </ul>
    </div>
    <div><a id="about"></a><h2>About the Model</h2></div>
    <div>                
        <p>The Colorectal Cancer Risk Assessment Tool is based on the first absolute risk model for colorectal cancer.  The model was developed using data from two large U.S. population-based case-control studies of colon and rectal cancer, cancer incidence data from 13 NCI Surveillance, Epidemiology, and End Results (SEER) registries, and from national mortality rates.  The Colorectal Cancer Risk Assessment Tool uses the respondent’s answers about risk and preventive factors to calculate that person’s absolute risk for developing colorectal cancer for a specific time period.</p>
        <p>The model was tested in a large population and has been shown to be accurate in predicting absolute risk. Because the majority of participants in the case-control studies were non-Hispanic white males and females, relative risks for other racial or ethnic groups could not be estimated.  Researchers are in the process of updating the tool by using SEER rates for minority populations to allow the tool to produce more accurate results for men and women in these populations.</p>
        <p>The risk calculator will be updated periodically as new data or research become available. In addition, the tool may prove useful to researchers who are designing research intervention studies.</p>
    </div>
    <div>
        <a href="a-e.aspx">&lt; Prev</a> | <a href="#top">Back to Top</a> | <a href="a-r.aspx">Next&nbsp;&gt;</a>
        <br />
        <a href="q.aspx?restart=true">Begin Risk Calculation</a>
    </div>
</asp:Content>
