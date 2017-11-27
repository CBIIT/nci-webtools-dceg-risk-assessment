<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WillGet.aspx.cs" Inherits="CCRAT.Web.WillGet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link href="style/data.css" rel="stylesheet" type="text/css" media="screen" />
  <link href="style/def1000.css" rel="stylesheet" type="text/css" media="screen" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphMain" ID="cMain" runat="server">
<div class="pagewrapper">
	<div class="contentwrapper">
	        <div class="titlediv"> 
		        <div class="printtxt">
			        <div style="float: left;"><a href="#"><img src="/images/printer_ico.png" alt="print" border="0" /></a></div>
		       	        <div style="float: right; padding-top: 2px;"><a href="#">Send to printer</a></div>
			        <br class="clear" />
		        </div>
		        Colorectal Cancer Risk Assessment Tool 
	        </div>		
	        <br class="clear" />
		<div class="blankspace"> </div>

		<div class="graphcontainer">

			<div class="graph_williget">
				<div class="sectiontitle100">Will <span class="italic">I</span> get colorectal cancer?</div>
				<div class="sectionimg">
				<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="350" height="250" id="w8ssf" align="middle">
					<param name="allowscriptaccess" value="samedomain" />
					<param name="movie" value="risk_100_v6.swf" />
					<param name="quality" value="high" />

					<param name="bgcolor" value="#ffffff" />
					<param name=”wmode” value=”transparent” />
					<param NAME=FlashVars VALUE="input_high=20&input_low=8" />
					<embed src="risk_100_v6.swf" 
						quality="high" bgcolor="#ffffff" 
						width="350" height="250" 
						name="minef" 
						wmode="transparent"
						FlashVars="input_high=7&input_low=3"
						align="middle" 
						allowscriptaccess="samedomain" 
						type="application/x-shockwave-flash" 
						pluginspage="http://www.macromedia.com/go/getflashplayer" />
				</object>
				</div>
				<div class="liferisk">Your lifetime risk is estimated to be between 9% and 13%.  </div>
				<div class="centerexplan">

				<div class="sectionexplan">
					This means that somewhere between 9 and 13 out of every 100 <br />
					people <a href="javascript:toggle('definition');" class="ref_link" id="definition_link">similar to you</a> 
					will develop colorectal cancer during their <br /> 
					lifetimes.  However, <span class="bold"> we can't tell whether you or any one person <br />
					will develop cancer or not</span>.
				</div>

				</div>
			</div>
		<br class="clear" />
		</div>
		<div class="lowerbutton">
			<a href="result.aspx"><img src="/images/backtoresults.png" border="0" alt="back to results" /></a>
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
		<tr>
			<td class="gl">Smoked 100 cigarettes:</td>
			<td class="gr"><%=MoreThan100Cigs%> </td>
		</tr>
		<tr>
			<td class="wl">Relatives with colon or rectal cancer:</td>
			<td class="wr"><%=HasRelativeHadCC%> </td>
		</tr>
	</table>
   </div><!--stattable-->
</div><!--stats overlay-->
<br />
     </asp:Content>