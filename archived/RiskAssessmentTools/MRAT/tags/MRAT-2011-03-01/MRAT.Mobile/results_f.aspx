<%@ Page Language="C#" MasterPageFile="~/MRATMobile.Master" AutoEventWireup="true" CodeBehind="results_f.aspx.cs" Inherits="MRAT.Mobile.results_f" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
       <td class="q">
           <strong class="riskestimate">The Five-Year Absolute Risk of Melanoma is <asp:Label ID="lblResults" runat="server"></asp:Label>
           </strong>. For every 1,000 <asp:Label runat="server" ID="lblSex" /> living in this region with these characteristics, on average <asp:Label runat="server" ID="lblAvg" /> will develop melanoma in the next 5 years.
					 <p>The MRAT risk calculator may be updated periodically as new data or research becomes available.</p>
        </td>
    </tr>   
    <tr>
        <td class="c">
            <a href="resultex.aspx">Explanation</a>
        </td>
    </tr>
   <tr>
        <td class="e h">
            <a href="Q00.aspx?restart=true">New Risk Calculation</a>
        </td>
    </tr>
</asp:Content>