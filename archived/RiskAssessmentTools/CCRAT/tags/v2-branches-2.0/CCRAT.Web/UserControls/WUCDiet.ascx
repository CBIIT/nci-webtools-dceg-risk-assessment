<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCDiet.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCDiet" %>

<!-- QDIV -->
<div id="qdivDemo"  class="question">
	<div class="qtext">
		<span class="sectiontitle">
		In the <span class="bold">past 30 days</span>, about how many
			<span class="bold">servings per week</span> of
			<a href="javascript:toggle('definitionVeg');" class="ref_link" id="definitionVeg_link">vegetables</a> 
			or leafy green salads
			did you eat?
                            [<a href="javascript:toggle('more_servings');" id="more_servings_g" class="def_link_more" title="More about ">More</a>]
			<asp:RangeValidator ID="rfvVeggie" runat="server" 
            ControlToValidate="ddlVeggie" Display="Dynamic" ErrorMessage="*" 
            ValidationGroup="vgDiet" MaximumValue="11" MinimumValue="0" Type="Double">Required</asp:RangeValidator>
			</span>
			<br>
			<span class="italic">NOTE: If you have eaten vegetables in the past 30 days, you will define serving size in the next question.</span>
		<div class="qbreak"></div>
        <asp:DropDownList ID="ddlVeggie" runat="server">
            <asp:ListItem Text="-select-" Value="NAN"></asp:ListItem>
            <asp:ListItem Text="None" Value="0"></asp:ListItem>
            <asp:ListItem Text="Less than 1 serving per week" Value=".5"></asp:ListItem>
            <asp:ListItem Text="1-2 servings per week" Value="1.5"></asp:ListItem>
            <asp:ListItem Text="3-4 servings per week" Value="3.5"></asp:ListItem>
            <asp:ListItem Text="5-6 servings per week" Value="5.5"></asp:ListItem>
            <asp:ListItem Text="7-10 servings per week" Value="8.5"></asp:ListItem>
            <asp:ListItem Text="More than 10 servings per week" Value="11"></asp:ListItem>
            </asp:DropDownList>
		
        <div class="blankspace"> </div>
	</div>
</div>
<!-- QDIV -->
<div id="divappearDiet" style="color: #000000;">
    <div id="qdiv"  class="question">
	    <div class="qtextindent">
		    <span class="sectiontitle">
		    In the <span class="bold">past 30 days</span>, how much did you usually eat in
			    <span class="bold">each serving </span> of
			    <a href="javascript:toggle('definitionVeg');" class="ref_link" id="definition_link2">vegetables</a> 
			    or leafy green salads?
                                [<a href="javascript:toggle('more_servings_det');" id="more_servings_det_g" class="def_link_more" title="More about ">More</a>]
		    <asp:CustomValidator ID="rfvVegieAmt" runat="server" 
                ControlToValidate="ddlVeggieAmt" Display="Dynamic" ErrorMessage="*" 
                ValidationGroup="vgDiet" OnServerValidate="ValidateControl" >Required</asp:CustomValidator>
		    </span>

		    <div class="qbreak"></div>
		    <asp:DropDownList ID="ddlVeggieAmt" runat="server">
                <asp:ListItem Text="-select-" Value="NAN"></asp:ListItem>
                <asp:ListItem Text="1/2 cup or less" Value=".25"></asp:ListItem>
                <asp:ListItem Text="Between 1/2 cup and 1 1/2 cups" Value="1"></asp:ListItem>
                <asp:ListItem Text="Between 1 1/2 cups and 3 cups" Value="2.25"></asp:ListItem>
                <asp:ListItem Text="Between 3 cups and 5 cups" Value="4"></asp:ListItem>
                <asp:ListItem Text="More than 5 cups" Value="6"></asp:ListItem>
            </asp:DropDownList>							
	    </div>
    </div>
</div>


<div id="definitionVeg" style="display:none;" class="vegetables_c">
    <div class="def_container">
	<div class="def_top_left">
		Vegetables
	</div>
	<div class="def_top_right">
		<a href="#definitionVeg_link" onclick="toggle('definitionVeg',event); 
			document.getElementById('definitionVeg_link').focus(); 
			return false;" class="close_butt">
			<span style="color:white">X</span></a>
	</div>
	<div style="clear:both;"></div>
   </div>
   <div class="stattable">
	INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads.
	<br /><br />
	DO NOT INCLUDE fried vegetables like French fries or fried potatoes.
   </div><!--stattable-->

</div><!--stats overlay-->

<div id="definitionVeg2" style="display:none;" class="vegetables_c2">
    <div class="def_container">
	<div class="def_top_left">
		Vegetables
	</div>
	<div class="def_top_right">
		<a href="#definitionVeg_link2" onclick="toggle('definitionVeg2',event); 
			document.getElementById('definitionVeg_link2').focus(); 
			return false;" class="close_butt">
			<span style="color:white">X</span></a>

	</div>
	<div style="clear:both;"></div>
   </div>
   <div class="stattable">
	INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads.
	<br /><br />
	DO NOT INCLUDE fried vegetables like French fries or fried potatoes.
   </div><!--stattable-->
</div><!--stats overlay-->



<!-- Definition DIVs -->

<div id="more_servings" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definition3" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Diet
    </div>
    <div class="stattable_more">
Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
<br /><br />
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_servings',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>

<div id="more_servings_det" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definition4" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Diet
    </div>
    <div class="stattable_more">
Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
<br /><br />
    </div>
    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_servings_det',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>

<!-- End def divs -->


