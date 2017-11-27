<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCMedicalHistory.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCMedicalHistory" %>

		<!-- QDIV -->
		<div id="qdiv" class="question">
			<div class="qtext">
				<span class="sectiontitle">
				During the <span class="bold">past 10 years</span>, did you have a 
					<a href="javascript:toggle('definitionColonoscope');" class="ref_link" id="definitionColonoscope_link">colonoscopy</a>,
					<a href="javascript:toggle('definitionsig');" class="ref_link" id="definition_linksig">sigmoidoscopy</a>,
					or both?
	[<a href="javascript:toggle('more_colonSig');" id="more_XYZ_g" class="def_link_more" title="More about ">More</a>]
				<asp:RequiredFieldValidator ID="rfvColon" runat="server" 
                    ControlToValidate="rblColonoscopy" Display="Dynamic" ErrorMessage="Please select during the past 10 years, did you have a colonoscopy,sigmoidoscopy, or both" 
                    ValidationGroup="vgHistory">Required</asp:RequiredFieldValidator>
				</span>
				<div class="qbreak" ></div>
                <asp:RadioButtonList ID="rblColonoscopy" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                    <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                    <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                </asp:RadioButtonList>         
                <div class="blankspace"> </div>  		
			</div>
        </div>
		<!-- QDIV -->
		<div id="divappearHistory" style="color: #000000;">
		    <div class="question">
			    <div class="qtextindent">
				    <span class="sectiontitle">
				    In the past 10 years 
					    did a healthcare provider tell you that you had a 
					    <span class="bold">colon or rectal</span> 
					    <a href="javascript:toggle('definitionpol');" class="ref_link" id="definition_linkpol">polyp</a>?
		    [<a href="javascript:toggle('more_colorRectal');" id="more_ZYX_g" class="def_link_more" title="More about ">More</a>]
				    <asp:CustomValidator ID="rfvPolyp" runat="server" 
                            Display="Static" ErrorMessage="Required"  
                        OnServerValidate="ValidateControl"
                        ValidationGroup="vgHistory">Required</asp:CustomValidator>
				    </span>
				    <div class="qbreak" ></div>
                    <asp:RadioButtonList ID="rblPolyp" runat="server" RepeatLayout="flow" RepeatDirection="Vertical">
                         <asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
                    <asp:ListItem Text="No" Value="No"></asp:ListItem>
                    <asp:ListItem Text="I don't know" Value="DontKnow"></asp:ListItem>
                    </asp:RadioButtonList>
			    </div>
		    </div>
        </div>

<div id="definitionColonoscope" style="display:none;" class="colonoscopy_c">
    <div class="def_container">
        <div class="def_top_left">
                Colonoscopy
        </div>
        <div class="def_top_right">
                <a href="#definitionColonoscope_link" onclick="toggle('definitionColonoscope',event); 
                        document.getElementById('definitionColonoscope_link').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>

   <div class="stattable">
	Examination of the inside of the colon using a colonoscope, inserted into the rectum. A colonoscope is a thin, tube-like instrument with a light and a lens for viewing. It may also have a tool to remove tissue to be checked under a microscope for signs of disease.	
   </div><!--stattable-->
</div><!--stats overlay-->
<asp:ValidationSummary ID="VgDemoSummaryRequiredFields" runat="server" ShowMessageBox="True" ValidationGroup="vgHistory" ShowSummary="False" />

<div id="definitionsig" style="display:none;" class="sigmoidoscopy_c">
    <div class="def_container">
        <div class="def_top_left">
                Sigmoidoscopy
        </div>
        <div class="def_top_right">

                <a href="#definition_linksig" onclick="toggle('definitionsig',event); 
                        document.getElementById('definition_linksig').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>
        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
		Examination of the lower colon using a sigmoidoscope, inserted into the rectum. A sigmoidoscope is a thin, tube-like instrument with a light and a lens for viewing. It may also have a tool to remove tissue to be checked under a microscope for signs of disease. Also called proctosigmoidoscopy.
   </div><!--stattable-->
</div><!--stats overlay-->

<div id="definitionpol" style="display:none;" class="polyp_c">
    <div class="def_container">
        <div class="def_top_left">
                Polyp
        </div>
        <div class="def_top_right">
                <a href="#definition_linkpol" onclick="toggle('definitionpol',event); 
                        document.getElementById('definition_linkpol').focus(); 
                        return false;" class="close_butt">
                        <span style="color:white">X</span></a>
        </div>

        <div style="clear:both;"></div>
   </div>
   <div class="stattable">
		A polyp is a small growth, like a skin tag, that develops on the inside of the colon or rectum.
   </div><!--stattable-->
</div><!--stats overlay-->


<div id="more_colonSig" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definitionColon" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Sigmoidoscopy and colonoscopy
    </div>
    <div class="stattable_more">
              In a sigmoidoscopy, your doctor looks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your doctor can remove it using the sigmoidoscope. Then, he or she will send that piece of tissue to the lab for testing.  In a colonoscopy, your doctor looks inside the rectum and entire colon using a long, lighted tube called a <a href="#" onclick="javascript:pop_up('def-colonoscope.aspx');" class="grey-text">colonoscope</a>. Using a colonoscope, your doctor can remove any polyps he or she sees. The procedure to remove polyps is called a polypectomy.  Having this procedure will reduce your risk of colorectal cancer because polyps that can grow into cancer are removed.
      <br /><br />
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_colonSig',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>


<div id="more_colorRectal" style="display: none;" class="lb_container"><!-- lightbox -->
<div id="definitioncolorRectal" class="popup_container_more"><!-- centered box -->
    <div class="stat_container_more">
        Colorectal
    </div>
    <div class="stattable_more">
       Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are not cancer, but some can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.
             <br /><br />
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('more_colorRectal',event);
                        return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>
    <script language="javascript" type="text/javascript">
           function pop_up(href) {
               window.open(href, "_blank", "menubar=yes, height=200, width=500, status=yes, scrollbars=yes")
           }  
    </script>