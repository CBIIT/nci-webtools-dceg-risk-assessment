<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Popup.Master"  CodeBehind="tool.aspx.cs" Inherits="CCRAT.Web.tool" %>
<%@ Register src="UserControls/WUCDemo.ascx" tagname="WUCDemo" tagprefix="uc1" %>
<%@ Register src="UserControls/WUCDiet.ascx" tagname="WUCDiet" tagprefix="uc2" %>
<%@ Register src="UserControls/WUCMedicalHistory.ascx" tagname="WUCMedicalHistory" tagprefix="uc3" %>
<%@ Register src="UserControls/WUCMedication.ascx" tagname="WUCMedication" tagprefix="uc4" %>
<%@ Register src="UserControls/WUCPhysicalActivity.ascx" tagname="WUCPhysicalActivity" tagprefix="uc5" %>
<%@ Register src="UserControls/WUCMiscellaneous.ascx" tagname="WUCMiscellaneous" tagprefix="uc6" %>
<%@ Register src="UserControls/WUCFamily.ascx" tagname="WUCFamily" tagprefix="uc7" %>
<%@ Register src="UserControls/WUCMiscWoman.ascx" tagname="WUCMiscWoman" tagprefix="uc8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="style/data.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/more_link.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/deflink.css" rel="stylesheet" type="text/css" media="screen" />    
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script> 

</asp:Content>
<asp:Content ContentPlaceHolderID="cphMain" ID="cMain" runat="server">
     <div class="pagewrapper">
         <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
     
        <asp:MultiView ID="mvQuestion" runat="server" Visible="true" ActiveViewIndex="0">	
            <asp:View ID="vDemo" runat="server">	
                 <div class="contentwrapper" id="divDemo">
                    <div class="titlediv"> 
                        <div>
	                        <div style="float: left;">Demographics - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 1 of 7</span></div>
                        </div>
	                    <br class="clear" />
                    </div>	            
                    <uc1:WUCDemo ID="WUCDemo" runat="server" />
                    <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnCancel" runat="server" AlternateText="Cancel" OnClick="btnCancel_click" ImageUrl="~/images/cancel.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToDiet" runat="server" ValidationGroup="vgDemo"  AlternateText="Next" OnClick="btnNextToDiet_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>
                </div>
            </asp:View>
            <asp:View ID="vDiet" runat="server">	
                <div class="contentwrapper">
                    <div class="titlediv"> 
                        <div>
	                        <div style="float: left;">Diet - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 2 of 7</span></div>
                        </div>
	                    <br class="clear" />
                    </div>	
                    <uc2:WUCDiet ID="WUCDiet" runat="server" />
                    <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToDemo" runat="server" AlternateText="Back" OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToHistory" runat="server" ValidationGroup="vgDiet"  AlternateText="Next"  OnClick="btnNextToHistory_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>
                 </div>
            </asp:View>
            <asp:View ID="vHistory" runat="server">     
                <div class="contentwrapper">
                    <div class="titlediv"> 
	                    <div>
		                    <div style="float: left;">Medical History - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 3 of 7</span></div>
	                    </div>
	                    <br class="clear" />
                    </div>               
                    <uc3:WUCMedicalHistory ID="WUCMedicalHistory" runat="server" />      
                    	                        <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToDiet" runat="server" AlternateText="Back"  OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToMed" runat="server"  ValidationGroup="vgHistory" AlternateText="Next"  OnClick="btnNextToMedication_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div> 
                </div>       
            </asp:View>
           <asp:View ID="vMedication" runat="server">     
       	        <div class="contentwrapper">
                    <div class="titlediv"> 
	                    <div>
		                    <div style="float: left;">Medications - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 4 of 7</span></div>
	                    </div>
	                    <br class="clear" />
                    </div>   
                    <uc4:WUCMedication ID="WUCMedication" runat="server" />
                    	                        <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToHistory" runat="server" AlternateText="Back"  OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToPhysical" runat="server" ValidationGroup="vgMed" AlternateText="Next"  OnClick="btnNextToPhysical_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>
           	   </div>
            </asp:View>
            <asp:View ID="vPhysical" runat="server">      
                <div class="contentwrapper">
                    <div class="titlediv"> 
	                    <div>
		                    <div style="float: left;">Physical Activity - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 5 of 7</span></div>
	                    </div>
	                    <br class="clear" />
                    </div>            
                    <uc5:WUCPhysicalActivity ID="WUCPhysicalActivity" runat="server" /> 
                    	                        <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToMed" runat="server" AlternateText="Back"  OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToMisc" runat="server" ValidationGroup="vgActivity" AlternateText="Next"  OnClick="btnNextToMisc_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>	                   
                </div>               
            </asp:View>                
            <asp:View ID="vMiscellaneous" runat="server">   
        	     <div class="contentwrapper">
                    <div class="titlediv"> 
	                    <div>
		                    <div style="float: left;">Miscellaneous - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 6 of 7</span></div>
	                    </div>
	                    <br class="clear" />
                    </div>               
                    <uc6:WUCMiscellaneous ID="WUCMiscellaneous" runat="server" />
                    <uc8:WUCMiscWoman ID="WUCMiscWoman" runat="server" />  
                    	                        <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToPhysical" runat="server" AlternateText="Back"  OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnNextToFamily" runat="server" ValidationGroup="vgMisc" AlternateText="Next"  OnClick="btnNextToFamily_click" ImageUrl="~/images/next.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>
            	</div>
            </asp:View>           
            <asp:View ID="vFamily" runat="server">  
        	    <div class="contentwrapper">
                    <div class="titlediv"> 
	                    <div>
		                    <div style="float: left;">Family - <span class="sectionsequence">Colorectal Cancer </span></div>
	                        <div style="float: right;"><span class="sectionsequence">Section 7 of 7</span></div>
	                    </div>
	                    <br class="clear" />
                    </div>                
                    <uc7:WUCFamily ID="WUCFamily" runat="server" />   
                    <br class="clear" />
                    <div class="lowerbutton">
                        <asp:ImageButton ID="imgBtnBackToMisc" runat="server" AlternateText="Back"  OnClick="btnBack_click" ImageUrl="~/images/back.png" border="0" />
                        &nbsp;
		                <asp:ImageButton ID="imgBtnCalculate" runat="server" ValidationGroup="vgFamily"  AlternateText="Calculate" OnClick="btnCalculate_Click" ImageUrl="~/images/calculate.png" border="0" />
                    </div>
                    <div class="blankspace"> </div>  
                </div>     
            </asp:View>
            
        </asp:MultiView>  
    </div>  		
    <br />
</asp:Content>