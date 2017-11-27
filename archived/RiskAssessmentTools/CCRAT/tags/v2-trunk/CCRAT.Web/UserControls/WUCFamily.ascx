<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCFamily.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCFamily" %>

		<!-- QDIV -->
		<div id="qdivFamily"  class="question">
			<div class="qtext">
					<span class="sectiontitle">
					Think only about your <span class="bold">biological mother and father, full brothers and sisters, and your biological sons or daughters</span>.  At <span class="bold">any time in their lives</span>, did any of these relatives ever have <span class="bold">cancer of the colon or rectum</span> (cancer of the lower intestine)?
                                        [<a href="javascript:toggle('more_relatives');" id="more_" class="def_link_more" title="More about ">More</a>]
					<asp:RequiredFieldValidator ID="rfvRelative" runat="server" 
                        ControlToValidate="rblRelativescancer" Display="Dynamic" ErrorMessage="*" 
                        ValidationGroup="vgFamily">Required</asp:RequiredFieldValidator>
                        
					</span>
					<div class="qbreak" ></div>
                    <asp:RadioButtonList ID="rblRelativescancer" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                        <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                    </asp:RadioButtonList>
                               
		            <div class="blankspace"> </div>
			</div>
		</div>
		<!-- QDIV -->
		<div id="divappearFamily" style="color: #000000;">
		    <div id="qdivFamilyColon"  class="question">
			    <div class="qtextindent">
					<span class="sectiontitle">
					 <span class="bold">How many</span> of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?
                                        [<a href="javascript:toggle('more_relatives_det');" id="more_" class="def_link_more" title="More about ">More</a>]
		
                         <asp:CustomValidator ID="rfvRelativeAmt" runat="server" 
                     Display="Dynamic" ErrorMessage="*" 
                ValidationGroup="vgFamily" OnServerValidate="ValidateControl" >Required</asp:CustomValidator>
					</span>
					<div class="qbreak" ></div>
                    <asp:RadioButtonList ID="rblRelativescancerAmt" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                        <asp:ListItem Text="1" Value="One"></asp:ListItem>
                        <asp:ListItem Text="2 or more" Value="TwoPlus"></asp:ListItem>
                        <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                    </asp:RadioButtonList>
		            <div class="blankspace"> </div>
			    </div>    		
		        <br class="clear" />
		    </div>
		</div>


