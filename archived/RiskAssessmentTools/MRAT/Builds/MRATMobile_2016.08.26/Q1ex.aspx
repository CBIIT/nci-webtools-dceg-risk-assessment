<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MRATMobile.Master" CodeBehind="Q1ex.aspx.cs" Inherits="MRAT.Mobile.Q1ex" %>
<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="h">
            <a href="Q00.aspx">&lt; Back</a></td>
    </tr>
    <tr>
        <td class="h">
            <p>
                <a id="q1"></a><strong>About the Question</strong><br />
                Melanoma is more common in people who live in areas that large amounts of UV radiation
                from the sun. For example, melanoma is more common in California than in Minnesota, where
                the sun is not as strong.
            </p>
            <p>
                <strong>About the Map</strong>
                <br />
                This image is a map of the continental United States which is divided into three
                distinct areas:
                <br />
                 <a href="maplarge2-ex.aspx">Northern</a> | <a href="maplarge2-ex.aspx">Central</a> | <a href="maplarge2-ex.aspx">Southern</a>                 
            </p>
            <p>
                <img src="i/map-north.gif" alt="nothern region" /> <strong>Northern</strong>
                <br />
                Washington, Oregon, Montana, North Dakota, South Dakota, Minnesota, Wisconsin, Michigan, Iowa, Illinois, Indiana, Ohio, Maryland, Pennsylvania, New York, New Jersey, Vermont, Rhode Island, Connecticut, Massachusetts, New Hampshire, and Maine.
            </p>
            <p>
                <img src="i/map-central.gif" alt="map-central" /><strong>Central</strong>
                <br />
                <a href="map-CA-ex.aspx">Northern California</a>, Idaho, Utah, Wyoming, Nebraska, Kansas, Oklahoma, Arkansas, Missouri, Tennessee, Kentucky, West Virginia, Virginia, Delaware, North Carolina, and South Carolina.
            </p>
            <p>
                <img src="i/map-south.gif" alt="souther region" /><strong>Southern</strong>
                <br />
                <a href="map-CA-ex.aspx">Southern California</a>, Nevada, Arizona, New Mexico, Colorado, Texas, Louisiana, Mississippi, Alabama, Georgia, and Florida.                
            </p>
        </td>
    </tr>
</asp:Content>
<asp:Content ID="bottomLink" ContentPlaceHolderID="BottomLink" runat="Server">
    <tr>
        <td class="h">
            <a id="A1" href="Q00.aspx">&lt; Back</a>
        </td>
    </tr>
</asp:Content>