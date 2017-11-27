<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WillGet.aspx.cs" Inherits="CCRAT.Web.WillGet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link href="style/data.css" rel="stylesheet" type="text/css" media="screen" />
  <link href="style/def1000.css" rel="stylesheet" type="text/css" media="screen" />
  
    <style type="text/css">
        #w8ssf
        {
            width: 650px;
            height: 390px;
            margin-left: 0px;
            text-align:center;
        }
    </style>

</asp:Content>
<asp:Content ContentPlaceHolderID="cphMain" ID="cMain" runat="server">
<div class="pagewrapper">
	<div class="contentwrapper">
	        <!--
	        <div class="titlediv"> 
	       	    <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a href="#" style="color: #fff;font-weight: normal;" onclick="javascript:pop_up1('printresults.aspx');" >Send to printer</a></div>
		        <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a href="#" style="color: #fff;font-weight: normal;"><img src="images/printer_ico.png" alt="print" border="0" onclick="javascript:pop_up1('printresults.aspx');" /></a></div>		       	        
		        Colorectal Cancer Risk Assessment Tool 
	        </div>		
	        -->
	        <br class="clear" />
		<div class="blankspace"> </div>


				<div class="sectiontitle100">Will <span class="italic">I</span> get colorectal cancer?</div>
				<div class="sectionimg" id="SecImg" runat="server">
				<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
                        codebase="https://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" 
                        id="w8ssf" align="middle">
					<param name="allowscriptaccess" value="samedomain" />
					<param name="movie" value="<%=FlashImage %>" />
					<param name="quality" value="high" />

					<param name="bgcolor" value="#ffffff" />
					<param name="wmode" value="transparent" />
					<param NAME=FlashVars VALUE="input_high=<%=InputHigh %>&input_low=<%=InputLow %>" />
					<embed src="<%=FlashImage %>" 
						quality="high" bgcolor="#ffffff" 
						width="600" height="390" 
						name="minef" 
						wmode="transparent"
						flashvars="input_high=<%=InputHigh %>&input_low=<%=InputLow %>"
						align="middle" 
						allowscriptaccess="samedomain" 
						type="application/x-shockwave-flash" 
						pluginspage="https://get.adobe.com/flashplayer" />
				</object>

				</div>
				
								<div id="DivPeopleSimilar" class="PeopleSimilar" runat="server">
				<%=persons %> People<br /><a href="javascript:toggle('definition');">similar to you</a>
				</div>
				
<div id="prnLifeRisk">
				<div class="liferisk" style="font-weight: normal; background-color: #fff;" >
					Your <span class="bold"><%=Years %> risk</span> is estimated 
					to be <span class="bold"><%=InputAbsolute%>%</span>.
				</div>
				
				<div class="centerexplan">

				<div class="sectionexplan">
					This means that somewhere between <%=InputLowRound %> and <%=InputHighRound%> out of every <%=persons %> <br />
					people <a href="javascript:toggle('definition');" class="ref_link" id="definition_link">similar to you</a> 
					will develop colorectal cancer during their <br /> 
					lifetimes.  However, <span class="bold"> we can't tell whether you or any one person <br />
					will develop cancer or not</span>.
				</div>
</div>
		<br />
		</div>
		<div class="lowerbuttonwilliget">
			<a href="result.aspx"><img src="images/backtoresults.png" border="0" alt="back to results" /></a>
		</div>
		<div class="blankspace"> </div>
</div>
</div>

<div id="definition" style="display:none;" class="popup_container">
    <div id="stat_container">
	<div id="stat_top_left">
		Data you entered:
	</div>
	<div id="stat_top_right">
		<a href="#definition_link" onclick="toggle('definition',event); 
			document.getElementById('definition_link').focus(); 
			return false;" class="close_butt">

			Close <span style="color:red">X</span></a>
	</div>
	<div style="clear:both;"></div>
   </div>
   <div id="stattable">
	<table class="stats">
		<tr>
			<td class="wl">Ethnicity:</td>

			<td class="wr"><%=Race %></td>
		</tr>
		<tr>
			<td class="gl">Age:</td>
			<td class="gr"><%=Age %></td>
		</tr>
		<tr>

			<td class="wl">Sex:</td>
			<td class="wr"><%=Gender %></td>
		</tr>
		<tr>
			<td class="gl">Height:</td>
			<td class="gr"><%=Feet %> ft <%=Inch %> in</td>
		</tr>

		<tr>
			<td class="wl">Weight:</td>
			<td class="wr"><%=Weight%> lbs</td>
		</tr>
		<tr>
			<td class="gl">Servings/week of vegetable or leafy greens:</td>
			<td class="gr"><%=Veggie%> </td>

		</tr>
		<tr>
			<td class="wl">Colonoscopy or sigmoidoscopy</td>
			<td class="wr"><%=Colonoscopy %> </td>
		</tr>
		<tr>
			<td class="gl">Medications containing aspirin:</td>

			<td class="gr"><%=Aspirin%> </td>
		</tr>
		<tr>
			<td class="wl">Medications NOT containing aspirin:</td>
			<td class="wr"><%=Ibuprofen%> </td>
		</tr>
		<tr>

			<td class="gl">Months of moderate exercise:</td>
			<td class="gr"><%=ModerateActivities%> </td>
		</tr>
		<tr>
			<td class="wl">Avg. hours/week of moderate exercise:</td>
			<td class="wr"><%=ModerateHours%> </td>
		</tr>

		<tr>
			<td class="gl">Months of vigorous exercise:</td>
			<td class="gr"><%=VigorousActivities%> </td>
		</tr>
		<tr>
			<td class="wl">Avg. hours/week of vigorous exercise:</td>
			<td class="wr"><%=VigorousHours%> </td>

		</tr>
		<tr id="trCigSmoking" runat="server" visible="false">
			<td class="gl">Smoked 100 cigarettes:</td>
			<td class="gr"><%=MoreThan100Cigs%> </td>
		</tr>
		<tr id="trStillHavePeriods" runat="server" visible="false">
			<td class="gl">Still have periods:</td>
			<td class="gr"><%=StillHavePeriods%> </td>
		</tr>
		
		<tr id="trLastPeriod" runat="server" visible="false">
			<td class="wl">Last period:</td>
			<td class="wr"><%=LastPeriod%> </td>
		</tr>	
		<tr id="trFemaleHormones" runat="server" visible="false">
			<td class="gl">Used estrogen,progestin,or other female hormones:</td>
			<td class="gr"><%=FemaleHormones%> </td>
		</tr>	

		<tr>
			<td class="wl">Relatives with colon or rectal cancer:</td>
			<td class="wr"><%=HasRelativeHadCC%> </td>
		</tr>
	</table>
   </div><!--stattable-->
</div><!--stats overlay-->
<br />
    <div id="definition1000"  class="lb_containerResult" runat="server">
        <!-- lightbox -->
        <div id="definition2" class="popup_container_more">
            <!-- centered box -->
            <div id="1000notice">
                Your risk is too small to be shown on a graph of 100 people. This graph of 1000
                people will help you visualize your risk.
            </div>
            <div class="close_butt_more" style="padding-top: 30px;">
                <a href="#definition_link1000" onclick="toggle('ctl00_cphMain_definition1000',event);
                        
                        return false;" style="color: #060; padding: 1px 4px; border: 1px solid #999;
                    text-decoration: none; background-color: #eee;">OK </a>
            </div>
        </div>
    </div>

</asp:Content>
