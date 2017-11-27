<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCMiscWoman.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCMiscWoman" %>

		<!-- QDIV -->
		<div id="qdivWoman"   class="question">
			<div class="qtext">
					<span class="sectiontitle">
					Do you still have periods?
	                                        [<a href="javascript:toggle('defStillHavePeriods');" id="more_defStillHavePeriods" class="def_link_more" title="More about ">More</a>]

					<asp:RequiredFieldValidator ID="rfvPeriod" runat="server" 
                        ControlToValidate="rblPeriod" Display="Dynamic" ErrorMessage="*" 
                        ValidationGroup="vgMisc">Required</asp:RequiredFieldValidator>

					</span>
                                        <div class="qbreak" ></div>
                <asp:RadioButtonList ID="rblPeriod" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                </asp:RadioButtonList>
                               
		        <div class="blankspace"> </div>
			</div>
		</div>
		
        <!-- QDIV -->
		<div id="qLastCycle" style="color: #000000;">
                <div id="qdivLastCycle"   class="question">
                        <div class="qtextindent">
					<span class="sectiontitle">
When did you have your last period?
	                                        <%--[<a href="javascript:toggle('defLastCycle');" id="more_defLastCycle" class="def_link_more" title="More about ">More</a>]--%>
                                		    <asp:CustomValidator ID="rfvLastPeriod" runat="server" 
                ControlToValidate="ddlHowOld" Display="Dynamic" ErrorMessage="*" 
                ValidationGroup="vgMisc" OnServerValidate="ValidateControl" >Required</asp:CustomValidator>
                                        </span>
                                        <div class="qbreak"></div>
                            <asp:DropDownList ID="ddlHowOld" runat="server">
                            <asp:ListItem Text="-Select-" Value="NAN"></asp:ListItem>
                            <asp:ListItem Text="1 year ago or less" Value="LT1"></asp:ListItem>
                            <asp:ListItem Text="More than 1 year ago but less than 2 years ago" Value="GT1LT2"></asp:ListItem>
                            <asp:ListItem Text="2 years ago or more" Value="GT2"></asp:ListItem>
                            </asp:DropDownList>
                <div class="blankspace"> </div>
                        </div>
                </div>
	
                <!-- QDIV -->
		<div id="usedEstrogen" style="color: #000000;">
                <div id="qdivusedEstrogen"   class="question">
                        <div class="qtext" style="padding-left: 65px; width: 465px;">
                        
                	<span class="sectiontitle">
					During the past 2 years, have you used estrogen, progestin, or other female hormones?
	                                        <%--[<a href="javascript:toggle('defUsedEstrogen');" id="more_" class="def_link_more" title="More about ">More</a>]--%>
		
                                <asp:CustomValidator ID="rfvUsedEstrogen" runat="server" 
                Display="Dynamic" ErrorMessage="*" 
                ValidationGroup="vgMisc" OnServerValidate="ValidateControlEstrogen" >Required</asp:CustomValidator>
					<br />

                                        </span>
                                        <div class="additionalTextBottom">
			These hormones may be given as hormone pills, oral contraceptives, shots, skin patches, vaginal creams, or as vaginal suppositories.
		</div><div class="qbreak"></div>
                                         <asp:RadioButtonList ID="rblUsedEstrogen" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                </asp:RadioButtonList>
                               
                <div class="blankspace"> </div>
                          </div>
                </div>
	
	</div>
</div>



<div id="defStillHavePeriods" style="display:none;" class="vegetables_c">
    <div class="def_container">
	<div class="def_top_left">
		Miscellaneous Women
	</div>
	<div class="def_top_right">

		<a href="#definition_link" onclick="toggle('defStillHavePeriods',event);" class="close_butt">
			<span style="color:white">X</span></a>
			
			<%--document.getElementById('more_defStillHavePeriods').focus(); 
			return false;--%>
	</div>
	<div style="clear:both;"></div>
   </div>
   <div class="stattable">
	Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used hormone replacement therapy (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
	<%--<a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text"></a>--%>
   </div><!--stattable-->

</div><!--stats overlay-->