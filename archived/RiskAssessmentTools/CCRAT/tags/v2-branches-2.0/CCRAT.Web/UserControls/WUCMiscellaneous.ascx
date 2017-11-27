<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCMiscellaneous.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCMiscellaneous" %>


<!-- QDIV -->
    <div id="qdivSmoke"   class="question">
        <div class="qtext">
            <span class="sectiontitle">In your <span class="bold">entire lifetime</span>, altogether, have you smoked
<span class="bold">100 or more cigarettes</span>?
[<a href="javascript:toggle('more_smoke');" id="more_lk_smoke" class="def_link_more" title="More about ">More</a>]
            <asp:RequiredFieldValidator ID="rfvSmoke" runat="server" 
                ControlToValidate="rblSmoked" Display="Dynamic" ErrorMessage="*" 
                ValidationGroup="vgMisc">Required</asp:RequiredFieldValidator>
</span>
            <div class="qbreak" ></div>
            <asp:RadioButtonList ID="rblSmoked" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
            <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
            <asp:ListItem Text="No" Value="No"></asp:ListItem>
            <asp:ListItem Text="I don't know" Value="No"></asp:ListItem>
            </asp:RadioButtonList>
            <div class="blankspace"> </div>
        </div>
    </div>
  
    <!-- QDIV -->
    <div id="agestarted" style="color: #000000;">
        <div id="qdivagestarted"   class="question">
            <div class="qtextindent" >
                <span class="sectiontitle">
                How old were you when you started smoking cigarettes <span class="bold">on a regular basis</span>, that is, at least <span class="bold">one cigarette a day for six months or longer</span>?
                [<a href="javascript:toggle('more_smoke');" id="more_agestarted" class="def_link_more" title="More about ">More</a>]
                <asp:CustomValidator ID="rfvSmokeStart" runat="server"  OnServerValidate="ValidateControlSmokeStart"  
                    ControlToValidate="ddlHowOld" Display="Dynamic" ErrorMessage="*" 
                    ValidationGroup="vgMisc">Required</asp:CustomValidator>
                </span>
                <div class="qbreak"></div>
                <asp:DropDownList ID="ddlHowOld" runat="server">
                </asp:DropDownList>
                <div class="blankspace"> </div>
            </div>

            <!-- QDIV -->
            <div id="currentlysmoke" style="color: #000000;">
                <div id="qdivcurrentlysmoke"   class="question">
                    <div class="qtext" style="padding-left: 65px; width: 475px;">

                        <span class="sectiontitle">
                        Do you currently smoke cigarettes?
                        [<a href="javascript:toggle('more_smoke');" id="more_recently" class="def_link_more" title="More about ">More</a>]
                         <asp:CustomValidator ID="rfvSmokeNow" runat="server" 
                         Display="Dynamic" ErrorMessage="*" 
                         OnServerValidate="ValidateControlCurrentSmoke"    ValidationGroup="vgMisc">Required</asp:CustomValidator>
                         </span>
                         <div class="qbreak"></div>
                        <asp:RadioButtonList ID="rblSmokenow" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                        <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                        <asp:ListItem Text="No" Value="No"></asp:ListItem>
                        </asp:RadioButtonList>

                        <div class="blankspace"> </div>
                    </div>
                </div>

            <!-- QDIV -->

                <div id="agequit" style="color: #000000;">
                    <div id="qdivagequit"  class="question">
                        <div class="qtext" style="padding-left: 90px; width: 440px;">

                            <span class="sectiontitle">
                            How old were you when you quit smoking cigarettes completely?
                            [<a href="javascript:toggle('more_smoke');" id="more_quit" class="def_link_more" title="More about ">More</a>]
                            
                            <asp:CustomValidator ID="rfvQuit" runat="server"   OnServerValidate="ValidateControlQuit"    
                                ControlToValidate="ddlHowOldQuit" Display="Dynamic" ErrorMessage="*" 
                                ValidationGroup="vgMisc">Required</asp:CustomValidator>
                            
                            </span>
                            <div class="qbreak"></div>
                            <span class="italic">NOTE: If you quit smoking cigarettes completely more than one time, please tell us how old you were the last time you quit smoking completely.</span><br />
                            <asp:DropDownList ID="ddlHowOldQuit" runat="server">
                            </asp:DropDownList>   

                            <div class="blankspace"> </div>
                        </div>
                    </div>
                </div>
                <!-- QDIV -->
                <div id="howmany" style="color: #000000;">
                        <div id="qdiv"   class="question">
                            <div id="qtext" style="padding-left: 65px; width: 475px;">
                                <span class="sectiontitle">
                                Thinking back over the years you have smoked regularly, about <span class="bold">how many cigarettes have you usually smoked a day? </span>
                                        [<a href="javascript:toggle('more_smoke');" id="more_many" class="def_link_more" title="More about ">More</a>]
                                <asp:CustomValidator ID="rfvMedAspirin3" runat="server"  OnServerValidate="ValidateControlSmokeAmt"
                                    ControlToValidate="ddlAmtSmokeADay" Display="Dynamic" ErrorMessage="*" 
                                    ValidationGroup="vgMisc">Required</asp:CustomValidator>
                                </span>
<div class="qbreak"></div>
                                <asp:DropDownList ID="ddlAmtSmokeADay" runat="server">
                                <asp:ListItem Text="-select-" Value="NAN"></asp:ListItem>
                                <asp:ListItem Text="1 to 10 cigarettes a day" Value="1To10"></asp:ListItem>
                                <asp:ListItem Text="11to 20 cigarettes a day" Value="11To20"></asp:ListItem>
                                <asp:ListItem Text="More than 20 cigarettes a day" Value="GT20"></asp:ListItem>
                                </asp:DropDownList>		
                                <div class="blankspace"> </div>
                            </div>
                        </div>
                    </div>
           
              </div>
              
        </div>
    </div>



<div id="more_smoke" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definitionmod" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Smoking
    </div>
    <div class="stattable_more">
          Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
                    <br /><br />
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_smoke',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>