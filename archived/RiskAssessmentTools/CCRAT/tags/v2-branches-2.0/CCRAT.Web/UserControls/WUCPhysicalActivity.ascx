<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCPhysicalActivity.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCPhysicalActivity" %>


		<!-- QDIV -->
		<div id="qdiv"  class="question">
			<div class="qtext">
					<span class="sectiontitle">
					Over the <span class="bold">past 12 months</span>, in how many 
						<span class="bold">months</span>, if any, did you do any 
						kind of 
						<a href="javascript:toggle('definitionmod');" class="ref_link" id="definition_linkmod">moderate</a>

						physical activity?
                                        [<a href="javascript:toggle('more_mod');" id="more_" class="def_link_more" title="More about ">More</a>]
					<asp:RangeValidator ID="rfvModerateMonth" runat="server" 
                        ControlToValidate="ddlModerateActivities" Display="Dynamic" ErrorMessage="*" 
                        ValidationGroup="vgActivity" MaximumValue="12" MinimumValue="0" 
                        Type="Integer">Required</asp:RangeValidator>
					</span>
					<div class="qbreak" ></div>
                <asp:DropDownList ID="ddlModerateActivities" runat="server">
                </asp:DropDownList>
		        <div class="blankspace"> </div>
			</div>			
		</div>
	
		<!-- QDIV -->
		<div id="modappear" style="color: #000000;">
		<div id="qdiv"  class="question">
			<div class="qtextindent">
					<span class="sectiontitle">
					During those months, <span class="bold">on average</span>, about how many 
						<span class="bold">hours per week</span> did you do
						<a href="javascript:toggle('definitionmod2');" class="ref_link" id="definition_linkmod2">moderate</a>

						physical activities?
                                        [<a href="javascript:toggle('more_mod');" id="more_" class="def_link_more" title="More about ">More</a>]
				    <asp:CustomValidator ID="rfvModerateHour" runat="server" 
                            Display="Static" ErrorMessage="Required"  
                        OnServerValidate="ValidateControl" ControlToValidate="ddlMod"
                        ValidationGroup="vgActivity">Required</asp:CustomValidator>
					</span>
					<div class="qbreak" ></div>
                <asp:DropDownList ID="ddlMod" runat="server">
                    <asp:ListItem Text="-select-" Value="NAN"></asp:ListItem>
                    <asp:ListItem Text="Up to 1 hour per week" Value=".5"></asp:ListItem>
                    <asp:ListItem Text="Between 1-2 hours per week" Value="1.5"></asp:ListItem>
                    <asp:ListItem Text="Between 2-3 hours per week" Value="2.5"></asp:ListItem>
                    <asp:ListItem Text="Between 3-4 hours per week" Value="3.5"></asp:ListItem>
                    <asp:ListItem Text="More than 4 hours per week" Value="5"></asp:ListItem>
                </asp:DropDownList>					
		        <div class="blankspace"> </div>
			</div>
		</div>
    	</div>

		<!-- QDIV -->
		<div id="qdivVigorousActivities"  class="question">
			<div class="qtext">
				<span class="sectiontitle">
				Over the <span class="bold">past 12 months</span>, in how many 
					<span class="bold">months</span>, if any, did you do any 
					kind of 
					<a href="javascript:toggle('definitionvig');" class="ref_link" id="definition_linkvig">vigorous</a>
					physical activity?
                                    [<a href="javascript:toggle('more_mod');" id="more_" class="def_link_more" title="More about ">More</a>]
				<asp:RangeValidator ID="rfvVigourMonth" runat="server" 
                    ControlToValidate="ddlVigorousActivities" Display="Dynamic" ErrorMessage="*" 
                     MaximumValue="12" MinimumValue="0" 
                    Type="Integer"
                    ValidationGroup="vgActivity">Required</asp:RangeValidator>
				</span>
				<div class="qbreak" ></div>
				<asp:DropDownList ID="ddlVigorousActivities" runat="server">
                </asp:DropDownList>			
		        <div class="blankspace"> </div>		
			</div>			
		</div>
	    
		<!-- QDIV -->
		<div id="vigappear" style="color: #000000;">
		    <div id="qdivvigappear"  class="question">
			    <div class="qtextindent" >
				    <span class="sectiontitle">
				    During those months, <span class="bold">on average</span>, about how many 
					    <span class="bold">hours per week</span> did you do
					    <a href="javascript:toggle('definitionvig2');" class="ref_link" id="definition_linkvig2">vigorous</a>

					    physical activities?
                                        [<a href="javascript:toggle('more_mod');" id="more_" class="def_link_more" title="More about ">More</a>]
				    <asp:CustomValidator ID="rfvVigorousHour" runat="server" 
                        ControlToValidate="ddlVig" Display="Dynamic" ErrorMessage="*" 
                        OnServerValidate="ValidateControlVig" 
                        ValidationGroup="vgActivity">Required</asp:CustomValidator>
				    </span>
				    <div class="qbreak" ></div>
				     <asp:DropDownList ID="ddlVig" runat="server">
                        <asp:ListItem Text="-select-" Value="NAN"></asp:ListItem>
                        <asp:ListItem Text="Up to 1 hour per week" Value=".5"></asp:ListItem>
                        <asp:ListItem Text="Between 1-2 hours per week" Value="1.5"></asp:ListItem>
                        <asp:ListItem Text="Between 2-3 hours per week" Value="2.5"></asp:ListItem>
                        <asp:ListItem Text="Between 3-4 hours per week" Value="3.5"></asp:ListItem>
                        <asp:ListItem Text="More than 4 hours per week" Value="5"></asp:ListItem>
                    </asp:DropDownList>		
		            <div class="blankspace"> </div>    				
			    </div>
		    </div>
		</div>


<div id="definitionmod" style="display:none;" class="moderate_c">
    <div class="def_container">
        <div class="def_top_left">
                Moderate Activity
        </div>
        <div class="def_top_right">
                <a href="#definition_linkmod" onclick="toggle('definitionmod',event); 
                        document.getElementById('definition_linkmod').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
	       Moderate activities DO NOT cause you to sweat or breathe hard.
		<br /><br />
		Some examples include vacuuming, gardening, easy walking for exercise, and so on.
   </div><!--stattable-->
</div><!--stats overlay-->

<div id="definitionmod2" style="display:none;" class="moderate_c2">
    <div class="def_container">
        <div class="def_top_left">
                Moderate Activity
        </div>
        <div class="def_top_right">
                <a href="#definition_linkmod2" onclick="toggle('definitionmod2',event); 
                        document.getElementById('definition_linkmod2').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
	       Moderate activities DO NOT cause you to sweat or breathe hard.
		<br /><br />
		Some examples include vacuuming, gardening, easy walking for exercise, and so on.
   </div><!--stattable-->
</div><!--stats overlay-->

<div id="definitionvig" style="display:none;" class="vigorous_c">
    <div class="def_container">
        <div class="def_top_left">
                Vigorous Activity
        </div>
        <div class="def_top_right">
                <a href="#definition_linkvig" onclick="toggle('definitionvig',event); 
                        document.getElementById('definition_linkvig').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
		Vigorous activities include all activities that DO cause you to sweat or breathe hard.
		<br /><br />

		Some examples include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt.
   </div><!--stattable-->
</div><!--stats overlay-->

<div id="definitionvig2" style="display:none;" class="vigorous_c2">
    <div class="def_container">
        <div class="def_top_left">
                Vigorous Activity
        </div>
        <div class="def_top_right">
                <a href="#definition_linkvig2" onclick="toggle('definitionvig2',event); 
                        document.getElementById('definition_linkvig2').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
		Vigorous activities include all activities that DO cause you to sweat or breathe hard.
		<br /><br />

		Some examples include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt.
   </div><!--stattable-->
</div><!--stats overlay-->

<div id="more_mod" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definitionmod" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Physical Activity
    </div>
    <div class="stattable_more">
              Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
              <br /><br />
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_mod',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>



