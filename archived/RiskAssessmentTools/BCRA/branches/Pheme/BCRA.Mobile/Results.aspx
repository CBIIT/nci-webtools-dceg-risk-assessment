<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="Results" Codebehind="Results.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <tr>
        <td>
            <p>
                <b>Race/Ethnicity:</b> <%=race%>
            </p>
			    <p>The BCRA risk calculator may be updated periodically as new data or research becomes available.  The algorithm was last updated in 2011.</p>
<%--            <p>
                <a href="resimpact.aspx" runat="server" id="impactlink" visible="false">How this may impact results</a>
            </p>
--%>        </td>
    </tr>
    <tr>
        <td class="q">
            5 Year Risk
        </td>
    </tr>
    <tr>
        <td>
            
            <ul class="r">
                <li>
                    <span class="bk">This woman (age <%=age%>) : <%=fiveYearRiskThisWoman%>%</span>
                </li>
                <li>
                    <span class="bk">Average woman (age <%=age%>) : <%=fiveYearRiskAvgWoman%>%</span>
                </li>
            </ul>

            <a href="5yearex.aspx">Explanation</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            Lifetime Risk
        </td>
    </tr>
    <tr>
        <td>
            <ul class="r">
                <li>
                    <span class="bk">This woman (age to 90): <%=lifetimeRiskThisWoman%>%</span>
                </li>
                <li>
                    <span class="bk">Average woman (age to 90): <%=lifetimeRiskAvgWoman%>%</span>
                </li>
            </ul>
            
            <a href="lifetimeex.aspx">Explanation</a>
        </td>
    </tr>
    <tr>
        <td>
            <p>
             <b>Reminder:</b> The Breast Cancer Risk Assessment Tool was designed for use by health professionals. If you are not a health professional, you are encouraged to discuss these results and your personal risk of breast cancer with your doctor.
           </p>
        </td>
    </tr>
    <tr>
        <td class="e h">
            <a href="Q00.aspx?restart=true">New Risk Calculation</a>
        </td>
    </tr>
</asp:Content>
