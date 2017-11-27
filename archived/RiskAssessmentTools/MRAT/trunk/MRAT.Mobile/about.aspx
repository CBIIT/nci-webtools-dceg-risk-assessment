<%@ Page Language="C#" MasterPageFile="~/MRATMobile.Master" AutoEventWireup="true"%>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="h">
            <a id="A2" runat="server" href="~/">&lt; Back</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="top"></a>About the Tool
        </td>
    </tr>
    <tr>
        <td class="h">
            <ul>
                <li><a href="#info">Information for New Users</a></li>
                <li><a href="#explain">Explaining the Results</a></li>
                <li><a href="#about">About the Model</a></li>
            </ul>
<%--            <span class="r"><img src="i/red-li.gif" alt="red-li.gif" />&nbsp;&nbsp;</span> <a href="#info">Information for New Users</a><br />
            <span class="r"><img src="i/red-li.gif" alt="red-li.gif" />&nbsp;&nbsp;</span> <a href="#explain">Explaining the Results</a><br />
            <span class="r"><img src="i/red-li.gif" alt="red-li.gif" />&nbsp;&nbsp;</span> <a href="#about">About the Model</a><br />
--%>        </td>
    </tr>
    <tr>
        <td class="h2">
            <a id="info"></a>Information for New Users
        </td>
    </tr>    
    <tr>
        <td>
            <ul>
                <li style="padding-bottom: 7px;">
                    The melanoma risk calculator was designed for use by
                    health professionals during a routine physical examination that includes recording
                    of information about the patient’s personal and family medical history and an examination
                    of the skin on the patient’s back and shoulders. If you are not a health professional,
                    you are strongly encouraged to discuss the results obtained with this tool and your
                    personal risk of melanoma with your doctor. </li>
                <li style="padding-bottom: 7px;">
                    This tool should not be used to estimate melanoma risk
                    for people who have already had a diagnosis of melanoma, melanoma-in-situ, non-melanoma
                    skin cancer, or a family history of melanoma. These individuals should be in screening
                    and surveillance programs.
                </li>
               <li style="padding-bottom: 7px;">
                   The melanoma risk calculator was developed using data
                   from a large case-control study in the United States. Risks are estimated for non-Hispanic
                   whites only; data for other races/ethnicities are too limited to accurately estimate
                   risk. </li>
            </ul>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
    <tr>
        <td class="h2">
            <a id="explain"></a>Explaining the Results
        </td>
    </tr>
    <tr>
        <td>
            <p>
                The Melanoma Risk Assessment Tool will estimate an individual’s risk of developing
                melanoma during the next 5-year period and up to age 70 based on the risk factor
                information provided. Risk estimates calculated by the tool are estimates of absolute
                melanoma risk. Absolute melanoma risk is the chance or probability of developing
                melanoma in a defined age interval. Although an individual’s risk may be accurately
                estimated, these predictions do not allow one to say precisely who will develop
                melanoma.
            </p>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
    <tr>
        <td class="q">
        </td>
    </tr>
    <tr>
        <td class="h2">
            <a id="about"></a>About the Model
        </td>
    </tr>
    <tr>
        <td class="q">
        </td>
    </tr>
    <tr>
        <td>
            <p>
                The Melanoma Risk Assessment Tool is based on a statistical model. The model uses
                patient’s self-reported history and a brief physical exam by a health care professional.
                Data from a case-control study that involved 1,663 non-Hispanic white patients from
                clinics in Philadelphia, PA and San Francisco, CA were used in developing the model.
                This model has not been tested in large populations. In other words, the model has
                not been “validated” for all non-Hispanic whites. Researchers are conducting additional
                studies and welcome partnerships to validate this tool.
            </p>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>    
</asp:Content>
<asp:Content ID="bottomLink" ContentPlaceHolderID="BottomLink" runat="Server">
    <tr>
        <td class="h">
        </td>
    </tr>
    <tr>
        <td class="h">
            <a id="A1" runat="server" href="~/">&lt; Back</a>
        </td>
    </tr>
</asp:Content>
