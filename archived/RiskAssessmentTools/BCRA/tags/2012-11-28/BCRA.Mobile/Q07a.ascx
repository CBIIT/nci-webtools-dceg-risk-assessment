<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Q07a.ascx.cs" Inherits="BCRA.Mobile.Q07a" %>
<%@ Register Src="~/footer.ascx" TagPrefix="uc" TagName="footerlink" %>

<form action="Q00.aspx" method="post">
        <tr>
            <td class="q">
                7a of 7a:
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" AssociatedControlID="subrace">
                What is the woman's sub race/ethnicity?
                </asp:Label>
            </td>
        </tr>

        <tr>
            <td class="c">
            <input type="hidden" id="q" name="q" value="10"/>
	          <select id="subrace" name="subrace" runat="server">
                <option selected="selected" value="-1000">Select</option> 
                <option value="7">Chinese</option> 
                <option value="8">Japanese</option> 
                <option value="9">Filipino</option> 
                <option value="10">Hawaiian</option> 
                <option value="11">Other Pacific Islander</option> 
                <option value="12">Other Asian-American</option> 
              </select>
                
            </td>
        </tr>
        <tr>
            <td class="c">
                <input value="Calculate Risk" type="submit" />
            </td>
        </tr>
        <tr>
            <td class="e h">
                <a href="Q7aex.aspx">Explanation</a>
            </td>
        </tr>
    </form>
    <uc:footerlink id="footerlink" runat="server"/>