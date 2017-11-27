<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="Result.aspx.cs" Inherits="CCRAT.Web.Result" %>

<%@ Register src="UserControls/WUCDemo.ascx" tagname="WUCDemo" tagprefix="uc1" %>
<%@ Register src="UserControls/WUCDiet.ascx" tagname="WUCDiet" tagprefix="uc2" %>
<%@ Register src="UserControls/WUCMedicalHistory.ascx" tagname="WUCMedicalHistory" tagprefix="uc3" %>
<%@ Register src="UserControls/WUCMedication.ascx" tagname="WUCMedication" tagprefix="uc4" %>
<%@ Register src="UserControls/WUCPhysicalActivity.ascx" tagname="WUCPhysicalActivity" tagprefix="uc5" %>
<%@ Register src="UserControls/WUCMiscellaneous.ascx" tagname="WUCMiscellaneous" tagprefix="uc6" %>
<%@ Register src="UserControls/WUCFamily.ascx" tagname="WUCFamily" tagprefix="uc7" %>
<%@ Register src="UserControls/WUCMiscWoman.ascx" tagname="WUCMiscWoman" tagprefix="uc8" %>
<%@ Register src="UserControls/WUCResult.ascx" tagname="WUCResult" tagprefix="uc9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <!-- Framework CSS -->
    <link href="style/demodata_overlay.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/results_overlay.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/results_overlay_popup.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/more_link.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/deflink.css" rel="stylesheet" type="text/css" />
  
    <link href="style/jqueryui.css" rel="stylesheet" type="text/css" media="screen" />
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
  <script type="text/javascript">
  <!--
      $(document).ready(function() {
          $("#tabs").tabs({ selected: 2 });

          $('.tabsinfo a').click(function() {
              switch_tabs($(this));
          });

          //$('#accordion').accordion({ collapsible: true, active: false, autoHeight: false });
          $('#higherRisk>li>div').hide();
          $('#higherRisk>li>a.ref_link_more').click(ToggleLi);

          $('#lowerRisk>li>div').hide();
          $('#lowerRisk>li>a.ref_link_more').click(ToggleLi);

      });

      function ToggleLi(event) {
          if ($(this).text() == 'More') {
              $(this).text('Less');
          } else
              $(this).text('More');

          var $nextDiv = $(this).siblings('div');
          var $visibleSiblings = $(this).parent().siblings().children('div:visible');

          ToggleMoreLess($visibleSiblings);
          $nextDiv.toggle();
          
          //if green, toggle red. Vice versa.
          var $grandparent = $(this).parent().parent();
          if ($grandparent.attr("id") == 'lowerRisk') {
              var $visibleAnotherSiblings = $('#higherRisk>li').children('div:visible');
              ToggleMoreLess($visibleAnotherSiblings);
          } else {
              var $visibleAnotherSiblings = $('#lowerRisk>li').children('div:visible');
              ToggleMoreLess($visibleAnotherSiblings);
          }
          return false;
      }

      function ToggleMoreLess($visibleAnotherSiblings) {
          if ($visibleAnotherSiblings.length) {
              $visibleAnotherSiblings.toggle();
              if ($visibleAnotherSiblings.siblings('a.ref_link_more').text() == 'More') {
                  $visibleAnotherSiblings.siblings('a.ref_link_more').text('Less');
              } else
                  $visibleAnotherSiblings.siblings('a.ref_link_more').text('More');
          }
      }
   //-->
  </script>
    <script src="script/data.js" type="text/javascript"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="cphMain" ID="cMain" runat="server">


 <div class="pagewrapper">
	        <div class="titlediv"> 
		        <div class="printtxt">
			        <div style="float: left;"><a href="#"><img src="/images/printer_ico.png" alt="print" border="0" onclick="window.open('printresults.aspx')" /></a></div>
		       	        <div style="float: right; padding-top: 2px;"><a href="#" onclick="window.open('printresults.aspx')">Send to printer</a></div>
			        <br class="clear" />
		        </div>
		        Colorectal Cancer Risk Assessment Tool 
	        </div>

		    <br class="clear" />
		    <div class="graphcontainer">
			    <div class="graph_howhigh" style="margin-left: 12px;">
			        <div id="tabs" >
                        <ul>
                            <li style="text-align:center"><a href="#tabs1" id="atab1" ><span class="titlebold">5 year risk</span><br />Average:<%=Input5yearAvg%>%<br />You: <%=Input5yearLow%>% - <%=Input5yearHigh%>%</a></li>                            
                            <li style="text-align:center"><a href="#tabs2"><span class="titlebold">10 year risk</span><br />Average:<%=Input10yearAvg%>%<br />You: <%=Input10yearLow%>% - <%=Input10yearHigh%>%</a></li>
                            <li style="text-align:center"><a href="#tabs3" class="defaulttab"><span class="titlebold">Lifetime risk</span><br />Average:<%=InputLTyearAvg%>%<br />You: <%=InputLTyearLow%>% - <%=InputLTyearHigh%>%</a></li>
                        </ul>
                        <div class="tab-content" id="tabs1"><uc9:WUCResult ID="WUCResult1" runat="server" /></div>
                        <div class="tab-content" id="tabs2"><uc9:WUCResult ID="WUCResult2" runat="server" />t</div>
                        <div class="tab-content" id="tabs3"><uc9:WUCResult ID="WUCResult" runat="server" /></div>    
			        </div>
			    </div>
				<div class="graph_williget" >
                    <div class="sectiontitle2" style="padding-top: 7px;">
                        <span style="color: #c00;">Factors that can make your risk of colorectal cancer higher include:</span>
                    </div>
                    <div class="redup" >
                <ul id="higherRisk">
                <li>Close relatives (parents, brothers, sisters, or children) who have had colorectal cancer [<a href="#" id="A1" class="ref_link_more" title="More about ">More</a>]
               <br style="line-height:5px;" />
	<div>
		<p>
If you have close relatives who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
		</p>
	</div> </li>
	<li>History of colorectal polyps [<a href="#" id="A2" class="ref_link_more" title="More about ">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas.
		</p>
	</div></li>
	<li>Obesity [<a href="#" id="A3" class="ref_link_more" title="More about ">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Obesity has been linked to a higher risk of colorectal cancer. 
		</p>
	</div>
	</li>
	<li>Cigarette Smoking [<a href="#" id="A4" class="ref_link_more" title="More about ">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Increasing evidence from epidemiologic studies suggests that cigarette smoking, particularly long-term smoking, increases the risk of colorectal cancer.
        </p>
        <p>
        Smoking cigarettes is linked to an increased risk of developing colorectal adenomas (noncancerous tumors) and colorectal cancer. Cigarette smokers who have had surgery to remove colorectal adenomas have an increased risk for the adenomas to recur (come back).
		</p>
	</div>
</li>

	<li>Inactive Lifestyle [<a href="#" id="A5" class="ref_link_more" title="More about ">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Some evidence suggests that a sedentary lifestyle may be associated with an increased risk of developing colorectal cancer.
		</p>
	</div>
                      </li>
                      </ul>
                    </div>
                    <div class="sectiontitle2">
                        <span style="color: #0c0;">Factors that can lower your risk of colorectal cancer include:</span>
                    </div>
                   
                    <div class="greendown" >
                                      
                                        <ul id="lowerRisk">
                                        <li>Colorectal cancer screening
                                        [<a href="#" id="less_screening" class="ref_link_more" title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div>
					<p>Screening is checking for health problems before they cause symptoms. Colorectal cancer screening can detect polyps and nonpolypoid lesions (flat or slightly depressed areas of abnormal cell growth), and other conditions. Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas. Nonpolypoid lesions occur less often than polyps, but they can also develop into colorectal cancer.  </p><p>Finding and removing polyps or other areas of abnormal cell growth may be one of the most effective ways to prevent colorectal cancer development. </p>
                             </div>     
                                   </li>
                                        <li>Regular use of aspirin and NSAID’s
                                        [<a href="#" id="less_aspirin" class="ref_link_more"title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div><p>Studies have shown that aspirin and nonsteroidal anti-inflammatory drugs like ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. However, aspirin and NSAIDs can have other adverse effects.  Do not take these medications without talking to your physician.</p>
					</div></li>
                                        <li>Maintaining a healthy weight
                                        [<a href="#" id="less_weight" class="ref_link_more" title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div><p>Obesity has been linked to a higher risk of colorectal cancer.</p></div>
					</li>
                                        <li>Regular, vigorous exercise (all activities that cause sweating and heavy  breathing)
                                        [<a href="#" id="less_exercise" class="ref_link_more" title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div><p>There is convincing evidence that physical activity is associated with a reduced risk of cancers of the colon. The magnitude of the protective effect appears greatest with high-intensity activity, although the optimal levels and duration of exercise are still difficult to determine due to differences between studies, making comparisons difficult. It is estimated that 30 to 60 minutes of moderate to vigorous physical activity per day is needed to protect against colon cancer. It is not yet clear at this time whether physical activity has a protective effect for rectal cancer, adenomas, or polyp recurrence</p>
                     </div>                   </li>
                                        <li>A diet high in vegetables
                                        [<a href="#" id="less_vegetables" class="ref_link_more" title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div><p>Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer. </p>
                     </div>                   </li>
                                        <li>Hormone replacement therapy use in women
                                        [<a href="#" id="less_hormone" class="ref_link_more" title="More about ">More</a>]
					<br style="line-height:5px;" />
					<div><p>Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used hormone replacement therapy (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
</p>
<p>
Studies have shown that hormone replacement therapy (HRT) that includes both estrogen and progesterone lowers the risk of colorectal cancer in postmenopausal women. HRT with estrogen alone does not lower the risk.
</p>
                   </div>                     </li>

                                        </ul>
					<br />
                                      
                                </div>
                </div>
		</div>

		<br class="clear" />

		<div class="blankspace" style="height: 12px;"> </div>
			<div style="background-color: #fff; padding: 5px 40px 5px 0; margin-left: 12px; margin-right:12px; border: 1px solid #000;">

			<center>
			<a href="javascript:toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#defaulttab'));" id="definition_link"><img src="/images/editpersonalbold.png" border=0 /></a>
			 <asp:ImageButton ID="imgBtnStartOver" runat="server" AlternateText="Start Over" OnClick="btnStartOver_click" ImageUrl="~/images/startoverbold.png" border="0" />
			</center>
			</div>
		<br class="clear" />
		</div>
		
<div class="blankspace" style="height: 8px;"> </div>


<div id="def_more_d1" style="display: none;" class="lb_containerResult"><!-- lightbox -->
<div class="popup_container_more"><!-- centered box -->
    <div id="stat_container_more">
	Close relatives who have had colorectal cancer
    </div>
    <div id="stattable_more">
	If you have close relatives who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
    </div>
    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('def_more_d1',event); 
			return false;" class="close_butt_more">X Close</a>

    </div>
</div>
</div>


<div id="def_more_d2" style="display: none;" class="lb_containerResult"><!-- lightbox -->
<div  class="popup_container_more"><!-- centered box -->
    <div id="stat_container_more">
	History of colorectal polyps
    </div>
    <div id="stattable_more">
	Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas.
    </div>

    <div class="close_butt_more">
          <a href="#definition_link" onclick="toggle('def_more_d2',event); 
			return false;" class="close_butt_more">X Close</a>
    </div>
</div>
</div>

<div id="definitionEdit" style="display: none;" class="lb_containerResult" runat="server"><!-- lightbox -->
    <div class="popup_container_result"><!-- centered box -->
        <div class="titlediv">
	    Colorectal Cancer Risk Assessment Tool
        </div>

        <div class="stattable_result">
	        <div id="navbar" style="width: 542px; margin-left: -1px; padding-bottom: 10px;">	
	        <ul class="tabsinfo">
                        <li><a href="#" rel="print_demographics" id="defaulttab">Demo-<br>graphics </a></li>
                        <li><a href="#" rel="print_diet">Diet<br />&nbsp;</a></li>
                        <li><a href="#" rel="print_medhistory">Medical<br />History </a></li>
                        <li><a href="#" rel="print_medications">Medications<br />&nbsp; </a></li>
                        <li><a href="#" rel="print_activity">Physical<br />Activity </a></li>
                        <li><a href="#" rel="print_miscmale">Misc<br />&nbsp; </a></li>
                        <li><a href="#" rel="print_family">Family<br />&nbsp; </a></li>
             </ul>
              <div id="print_demographics" class="tabinfo-content">
                    <uc1:WUCDemo ID="WUCDemo" runat="server" />
                </div>
                 <div id="print_diet" class="tabinfo-content">
                    <uc2:WUCDiet ID="WUCDiet" runat="server" />
                </div>
               <div id="print_medhistory" class="tabinfo-content">
                    <uc3:WUCMedicalHistory ID="WUCMedicalHistory" runat="server" />      
                </div>
                <div id="print_medications" class="tabinfo-content">

                    <uc4:WUCMedication ID="WUCMedication" runat="server" />
                </div>
                <div id="print_activity" class="tabinfo-content">

                    <uc5:WUCPhysicalActivity ID="WUCPhysicalActivity" runat="server" /> 
                </div>
                <div id="print_miscmale" class="tabinfo-content">
                    <uc6:WUCMiscellaneous ID="WUCMiscellaneous" runat="server" />
                    <uc8:WUCMiscWoman ID="WUCMiscWoman" runat="server" />  
                </div>
               <div id="print_family" class="tabinfo-content">

                    <uc7:WUCFamily ID="WUCFamily" runat="server" />   
                </div>
            </div>
           
        </div> 
        <div id="Div2" style="text-align: right; padding-right: 10px;">
	            <a href="#definition_link" onclick="toggle('ctl00_cphMain_definitionEdit',event); 
			    document.getElementById('definition_link').focus(); 
			    return false;" class="close_butt">
			    <img src="/images/sm_cancel.png" border=0 /></a>&nbsp;
	            <asp:ImageButton ID="imgBtnCalculate" runat="server"  AlternateText="Calculate" OnClick="btnCalculate_Click" ImageUrl="~/images/calculate.png" border="0" />
		        <div class="blankspace"> </div>
        </div>
    </div>
</div>

<br />
<input type="hidden" id="txtGender" runat="server" />
</asp:Content>