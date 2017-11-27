<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCMedication.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCMedication" %>

		<!-- QDIV -->
		<div id="qdivAspirin"  class="question">
			<div class="qtext">
					<span class="sectiontitle">
					During the <span class="bold">past 30 days</span>, have you taken medications containing aspirin at
						least 3 times a week, such as:
                                        [<a href="javascript:toggle('more_aspirin');" id="more_1" class="def_link_more" title="More about ">More</a>]
					<asp:RequiredFieldValidator ID="rfvMedAspirin" runat="server" 
                        ControlToValidate="rblAspirin" Display="Dynamic" ErrorMessage="*" 
                        ValidationGroup="vgMed">Required</asp:RequiredFieldValidator>
					<br />
					</span>
						- Bufferin <br />
						- Bayer <br />
						- Excedrin <br />
						- Other generic form <br />
					<span class="italic"> NOTE: Do NOT include TYLENOL </span>
					<div class="qbreak" ></div>
					<asp:RadioButtonList ID="rblAspirin" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                        <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                    </asp:RadioButtonList>                
		        <div class="blankspace"> </div>
			</div>
		</div>
		<!-- QDIV -->
		<div id="qdivNoaspirin"  class="question">
			<div class="qtext">
					<span class="sectiontitle">
					During the <span class="bold">past 30 days</span>, have you taken medications that
						<span class="bold">do NOT contain aspirin</span> at
						least 3 times a week, such as:
                                        [<a href="javascript:toggle('more_aspirin');" id="more_2" class="def_link_more" title="More about ">More</a>]
					<asp:RequiredFieldValidator ID="rfvMedNoAspirin" runat="server" 
                        ControlToValidate="rblNoaspirin" Display="Dynamic" ErrorMessage="*" 
                        ValidationGroup="vgMed">Required</asp:RequiredFieldValidator>
					<br />
					</span>
						- Advil <br />
						- Aleve <br />
						- Celebrex <br />
						- Ibuprofen <br />
						- Motrin <br />
						- Naproxen <br />
						- Nuprin <br />
					<span class="italic"> NOTE: Do NOT include TYLENOL </span>
					<div class="qbreak" ></div>
					   <asp:RadioButtonList ID="rblNoaspirin" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                    <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                </asp:RadioButtonList>
			</div>
		    <br class="clear" />
		</div>



<div id="more_aspirin" style="display: none;" class="lb_container"><!-- lightbox -->
    <div id="definitionaspirin" class="popup_container_more"><!-- centered box -->
        <div class="stat_container_more">
            Title
        </div>
        <div class="stattable_more">
                    Studies have shown that aspirin and drugs called NSAIDs can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. (NSAID stands for nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drug.)
                       <br /><br />
        </div>

        <div class="close_butt_more">
              <a href="#definition_link" onclick="toggle('more_aspirin',event);
                            return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>


