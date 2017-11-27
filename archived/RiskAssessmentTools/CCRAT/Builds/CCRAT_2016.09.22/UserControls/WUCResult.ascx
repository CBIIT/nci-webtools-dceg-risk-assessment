<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCResult.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCResult" %>

              
				<div class="sectiontitle" style="background-color: #fff; padding-top: 8px;">
					What is <i>my</i> <%=Years %> risk?
				</div>

				<div class="sectionimg" style="background-color: #fff; ">
				<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="https://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="320" height="230" align="middle" id="final_dyn_v3.swf" >
					<param name="allowscriptaccess" value="samedomain" />
					<param name="movie" value="Flash/final_dyn_v4.swf" />
					<param name="quality" value="high" />
			                <param name="wmode" value="transparent" />
					<param name="bgcolor" value="#ffffff" />
					<param NAME=FlashVars VALUE="input_high=<%=InputHigh %>&input_low=<%=InputLow %>&input_avg=<%=InputAvg %>" />
					<embed src="Flash/final_dyn_v4.swf" 
						quality="high" bgcolor="#ffffff" 
						width="290" height="230" 
						name="final_dyn_v4.swf" 
						FlashVars="input_high=<%=InputHigh %>&input_low=<%=InputLow %>&input_avg=<%=InputAvg %>"
			                        wmode="transparent"
						align="middle" 
						allowscriptaccess="samedomain" 
						type="application/x-shockwave-flash" 
						pluginspage="https://get.adobe.com/flashplayer" />

				</object>
				</div>
				<div class="risk_text" style="font-weight: normal; background-color: #fff;">
					Your <span class="bold"><%=Years %> risk</span> is estimated 
					to be <span class="bold"><%=InputAbsolute %>%</span>.
				</div>
				<div class="sectionexplan" style="background-color: #fff;">
					Estimates are not exact.  Your risk for<br /> developing colorectal cancer 
					during your<br /> lifetime is most likely in the <span class="bold">range of 
					<%=InputLow %>%-<%=InputHigh %>%</span><br /> (or somewhere between <span class="bold"><%=InputLowRound %> and <%=InputHighRound %> out 
					of <br />every <%=PeopleTotal %></span> people) but may be higher or lower.  <br>This means your risk is 
					<span class="bold"><%=Comparison%> the <br />average risk</span> for all 
					 <%=Race%> <%=Gender%> <br>aged <%=Age%>  - which is <span class="bold">approximately <%=InputAvg %>%</span>.
				</div>

			<div id="lowerbutton_left" style="background-color: #fff; ">
			<center>
			<!--<a href="willget.aspx"><img src="/images/williget.png" border="0" alt="Does this mean I will get colorectal cancer" /></a>-->
			<a href="willget.aspx?Y=<%=Years %>&IL=<%=InputLow %>&IH=<%=InputHigh %>&ILB=<%=InputLowRound %>&IHB=<%=InputHighRound %>&IA=<%=InputAbsolute %>"><img  src="images/williget.png" border="0" alt="Does this mean I will get colorectal cancer" /></a>
			
			</center>
			<br />
			</div>

