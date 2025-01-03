﻿<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="Result.aspx.cs" Inherits="CCRAT.Web.Result" %>

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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
    <script language="javascript" type="text/javascript">
        function pop_up(href) {
            window.open(href, "_blank", "menubar=yes,status=yes, scrollbars=yes")
        }  
    </script>  
  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
  <script type="text/javascript">
  <!--
//      $(document).ready(function() {
//          $("#tabs").tabs({ selected: 0 });
//          $('.tabsinfo a').click(function() {
//              switch_tabs($(this));
//          });

//          //$('#accordion').accordion({ collapsible: true, active: false, autoHeight: false });
//          $('#higherRisk>li>div').hide();
//          $('#higherRisk>li>a.ref_link_more').click(ToggleLi);

//          $('#lowerRisk>li>div').hide();
//          $('#lowerRisk>li>a.ref_link_more').click(ToggleLi);

//      });

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

<div id="printArea" class="printBody" >
    <link href="style/print_output.css" rel="stylesheet" type="text/css" />
    <table cellpadding="0" cellspacing="0">
        <thead style="display: table-header-group;">
	        <tr>
		      <th align="left">
              		<img src="images/ccrat_head2.jpg" id="redHeading" />
		      </th>  
	        </tr>
        </thead>
        <tbody>
	        <tr>
		        <td>
                    <img src="images/stethoscope_s.jpg" id="stethoscope" />
                    <div id="heading" class="heading">
                         <div id="headingTextArea" class="headingTextArea">
                          <span class="headingText1">YOU HAVE COMPLETED YOUR ASSESSMENT. HERE ARE YOUR RESULTS:</span><br />
                          <span class="headingText2">If you would like more information about your risk assessment or colorectal cancer, 
                                                     please bring a copy of your results to your doctor.</span>
                        </div>
                        <div class="dottedLine"></div>
                    </div>
                    <div id="keyImage" class="keyImage"><img src="images/ccrat_key.gif" /></div>
                    
                    <div class="dottedLine"></div>
                 
                    <div id="fiveYear" class="graphArea">
                        <div id="fiveYearLeft" class="leftColumn" >
                            <div class="graphTextHeading">YOUR 5 YEAR RISK IS ESTIMATED TO BE <%=Formater(FiveYearRisk)%>%</div>
                            <div id="fiveYearGraph" class="graphContainer" > 
                                  <img src="<%=FiveYearGraphLine%>" alt="graph" class="graphLine" /> 
                                  <span class="fiveRiskText"  style="<%=FiveYearRiskTextLeft%>"><%=FiveYearRiskText%></span>
                                  <img src="images/ccrat_red_down_arrow.gif" alt="risk arrow" class ="fiveRiskArrow" style="<%=FiveYearRiskArrowLeft%>" />
                                  <span class="fiveAverageText" style="<%=FiveYearAverageTextLeft%>"><%=FiveYearAverageText%></span>
                                  <img src="images/ccrat_gray_up_arrow.gif" alt="average arrow" class="fiveAverageArrow" style="<%=FiveYearAverageArrowLeft%>" />  
                                  <span class="fiveRiskRangeText" style="<%=FiveYearRiskRangeTextLeft%>" ><%=FiveYearRiskRangeText%></span>
                                  <img src="images/ccrat_box.gif" alt="range box" class="fiveRangeBox" style="<%=FiveYearRiskRange%>" />
                            </div>
                        </div>
                        <div id="fiveYearRight" class="rightColumn">
                    Estimates are not exact. Your risk for developing colorectal cancer during the 
                    next 5 years is most likely <%=Formater(FiveYearRisk)%>% 
                    (or <%=Rounder(FiveYearRisk)%> out of every 100 people). However, it could be 
                    anywhere in the range of  
                    <%=Formater(FiveYearRiskRangeStart)%>%-<%=Formater(FiveYearRiskRangeEnd)%>% 
                    (or somewhere between <%=Rounder(FiveYearRiskRangeStart)%> 
                    and <%=Rounder(FiveYearRiskRangeEnd)%> out of every 100 people). 
                    For comparison, the average risk of a <%=Sex%> of your age and ethnicity 
                    is <%=Formater(FiveYearRiskAverage)%>%                        </div>
                    </div>
                    
                    <div class="dottedLine"></div>
                    
                        <div id="tenYear" class="graphArea">
                        <div id="tenYearLeft" class="leftColumn" >
                        <div class="graphTextHeading">YOUR 10 YEAR RISK IS ESTIMATED TO BE <%=Formater(TenYearRisk)%>%</div>
                        <div id="tenYearGraph" class="graphContainer" > 
                              <img src="<%=TenYearGraphLine%>" alt="graph" class="graphLine" /> 
                              <span class="tenRiskText"  style="<%=TenYearRiskTextLeft%>"><%=TenYearRiskText%></span>
                              <img src="images/ccrat_red_down_arrow.gif" alt="risk arrow" class ="tenRiskArrow" style="<%=TenYearRiskArrowLeft%>" />
                              <span class="tenAverageText" style="<%=TenYearAverageTextLeft%>"><%=TenYearAverageText%></span>
                              <img src="images/ccrat_gray_up_arrow.gif" alt="average arrow" class="tenAverageArrow" style="<%=TenYearAverageArrowLeft%>" />  
                              <span class="tenRiskRangeText" style="<%=TenYearRiskRangeTextLeft%>" ><%=TenYearRiskRangeText%></span>
                              <img src="images/ccrat_box.gif" alt="range box" class="tenRangeBox" style="<%=TenYearRiskRange%>" />
                        </div>                        </div>
                        <div id="tenYearRight" class="rightColumn">
                    Estimates are not exact. Your risk for developing colorectal cancer during the 
                    next 10 years is most likely <%=Formater(TenYearRisk)%>% 
                    (or <%=Rounder(TenYearRisk)%> out of every 100 people). However, it could be 
                    anywhere in the range of  
                    <%=Formater(TenYearRiskRangeStart)%>%-<%=Formater(TenYearRiskRangeEnd)%>% 
                    (or somewhere between <%=Rounder(TenYearRiskRangeStart)%> 
                    and <%=Rounder(TenYearRiskRangeEnd)%> out of every 100 people). 
                    For comparison, the average risk of a <%=Sex%> of your age and ethnicity 
                    is <%=Formater(TenYearRiskAverage)%>%                        </div>
                    </div>
                  
                      <div class="dottedLine"></div>
                
                    <div id="lifetimeYear" class="graphArea">
                        <div id="lifetimeLeft" class="leftColumn" >
                        <div class="graphTextHeading">YOUR LIFETIME RISK IS ESTIMATED TO BE <%=Formater(LifetimeRisk)%>%</div>
                        <div id="graph" class="graphContainer" > 
                          <img src="<%=LifetimeGraphLine%>" alt="graph" class="graphLine" /> 
                          <span class="lifetimeRiskText"  style="<%=LifetimeRiskTextLeft%>"><%=LifetimeRiskText%></span>
                          <img src="images/ccrat_red_down_arrow.gif" alt="risk arrow" class ="lifetimeRiskArrow" style="<%=LifetimeRiskArrowLeft%>" />
                          <span class="lifetimeAverageText" style="<%=LifetimeAverageTextLeft%>"><%=LifetimeAverageText%></span>
                          <img src="images/ccrat_gray_up_arrow.gif" alt="average arrow" class="lifetimeAverageArrow" style="<%=LifetimeAverageArrowLeft%>" />  
                          <span class="lifetimeRiskRangeText" style="<%=LifetimeRiskRangeTextLeft%>" ><%=LifetimeRiskRangeText%></span>
                          <img src="images/ccrat_box.gif" alt="range box" class="lifetimeRangeBox" style="<%=LifetimeRiskRange%>" />
                        </div>                        </div>
                        <div id="lifetimeRight" class="rightColumn">
                    Estimates are not exact. Your risk for developing colorectal cancer during 
                    your lifetime is most likely <%=Formater(LifetimeRisk)%>% 
                    (or <%=Rounder(LifetimeRisk)%> out of every 100 people). However, it could be 
                    anywhere in the range of  
                    <%=Formater(LifetimeRiskRangeStart)%>%-<%=Formater(LifetimeRiskRangeEnd)%>% 
                    (or somewhere between <%=Rounder(LifetimeRiskRangeStart)%> 
                    and <%=Rounder(LifetimeRiskRangeEnd)%> out of every 100 people). 
                    For comparison, the average risk of a <%=Sex%> of your age and ethnicity 
                    is <%=Formater(LifetimeRiskAverage)%>%                      </div>
                    </div>
                    
                    <div class="dottedLine"></div>
                 
                    <span class="reponsesHeading">SUMMARY OF RESPONSES</span>
                    <div id="responsesArea" class="reponses">
                        <%=Responses %>
                    </div>
                    
                    <div class="factorsPage">
                    
                    <div class="dottedLine"></div>	
                    <p><span class="topHeading">FACTORS THAT CAN MAKE YOUR RISK OF COLORECTAL CANCER HIGHER INCLUDE:</span></p>
                    
                <p><span class="pHeading">CLOSE RELATIVES (PARENTS, BROTHERS, SISTERS, OR CHILDREN) WHO HAVE HAD COLORECTAL CANCER.</span><br />
                If you have close relatives who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.<p>
                    
                <p><span class="pHeading">HISTORY OF COLORECTAL POLYPS</span><br />
                Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas.</p>
                
                <p><span class="pHeading">OBESITY</span><br />
                Height and weight are used to determine your body mass index (BMI). It can also be used to measure total body fat and whether a person is health weight. Your BMI suggests you are over weight but not necessarily obese, but obesity has been linked to a higher risk of colorectal cancer. </p>
                
                <p><span class="pHeading">CIGARETTE SMOKING</span><br />
                Increasing evidence from epidemiologic studies suggests that cigarette smoking, particularly long-term smoking, increases the risk of colorectal cancer. Smoking cigarettes is linked to an increased risk of developing colorectal adenomas (noncancerous tumors) and colorectal cancer. Cigarette smokers who have had surgery to remove colorectal adenomas have an increased risk for the adenomas to recur (come back).
                
                <p><span class="pHeading">INACTIVE LIFESTYLE</span><br />
                Some evidence suggests that a sedentary lifestyle may be associated with an increased risk of developing colorectal cancer.</p>
                
                <div class="dottedLine"></div> 
                 
                <p><span class="topHeading">FACTORS THAT CAN LOWER YOUR RISK OF COLORECTAL CANCER INCLUDE:</span></p>
                
                <p><span class="pHeading">COLORECTAL CANCER SCREENING</span><br />
                <p>Screening is checking for health problems before they cause symptoms. Colorectal cancer screening can detect polyps and nonpolypoid lesions (flat or slightly depressed areas of abnormal cell growth), and other conditions. Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas. Nonpolypoid lesions occur less often than polyps, but they can also develop into colorectal cancer. Finding and removing polyps or other areas of abnormal cell growth may be one of the most effective ways to prevent colorectal cancer development. For more information on colorectal cancer screening, visit http://www.cancer.gov/cancertopics/factsheet/detection/colorectal-screening.</p>
                
                <p><span class="pHeading">REGULAR USE OF ASPIRIN AND NSAID’S</span><br />
                <p>Studies have shown that aspirin and nonsteroidal anti-inflammatory drugs like Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen, or Nuprin can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. However, aspirin and NSAIDs can have other adverse effects. Do not take these medications without talking to your physician.</p>
                
                <p><span class="pHeading">A DIET HIGH IN VEGETABLES</span><br />
                <p>Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.</p>
                <br />
                </div>
                
                <div class="disclaimer">
                    <div class="dottedLine"></div>
                    <div class="disclaimerText">This information is for educational purposes only and should not be relied upon as medical advice. It has not been designed to replace a physician’s independent judgement about the appropriateness or risks of a procedure for a given patient. It is recommended that everyone above the age of 50 be screened for colorectal cancer.</div>	
                    <div class="dottedLine"></div>
                
                    <img src="images/ccrat_nci.jpg" />
                </div>
                <!-- </div> -->
		        </td>
	        </tr>
  		</tbody>
        <tfoot></tfoot>
	</table>        
</div>
 <div class="pagewrapper">
	        <div class="titlediv"> 
	       	       <!-- <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a style="color: #fff;font-weight: normal;" title="Print Page" href="#" onclick="javascript:pop_up1('printresults.aspx');">Send to printer</a></div>
		            <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a style="color: #fff;font-weight: normal;" title="Print Page" href="#"><img src="images/printer_ico.png" alt="print" border="0" onclick="javascript:pop_up1('printresults.aspx');" /></a></div> -->
	       	        <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a style="color: #fff;font-weight: normal;" title="Print Page" href="#" onclick="javascript:window.print();">Send to printer</a></div>
		            <div style="float: right;font-family: arial, helvetica, sans;font-size: 10pt;"><a style="color: #fff;font-weight: normal;" title="Print Page" href="#"><img src="images/printer_ico.png" alt="print" border="0" onclick="javascript:window.print();" /></a></div> 
		       	        
		        Colorectal Cancer Risk Assessment Tool 
	        </div>

		    <br class="clear" />
		    <div class="graphcontainer">
			    <div class="graph_howhigh" style="margin-left: 12px;">
			        <div id="tabs" >
                        <ul>
                            <li style="text-align:center"><a href="#tabs1" id="5yeartab" data-five-year-risk="<%=Input5yearRisk%>"><span class="titlebold">5 year risk</span><br />Average:<%=Input5yearAvg%>%<br />You: <%=Input5yearAbs %>%</a></li>                            
                            <li style="text-align:center"><a href="#tabs2" id="10yeartab" data-ten-year-risk="<%=Input10yearRisk%>"><span class="titlebold">10 year risk</span><br />Average:<%=Input10yearAvg%>%<br />You: <%=Input10yearAbs %>%</a></li>
                            <li style="text-align:center"><a href="#tabs3" class="defaulttab" id="Lifetab" data-lifetime-risk="<%=InputLifeRisk%>"><span class="titlebold">Lifetime risk</span><br />Average:<%=InputLTyearAvg%>%<br />You: <% =InputLifeAbs%>%</a></li>
                        </ul>
                        <div class="tab-content" id="tabs1"><uc9:WUCResult ID="WUCResult1" runat="server" /></div>
                        <div class="tab-content" id="tabs2"><uc9:WUCResult ID="WUCResult2" runat="server" /></div>
                        <div class="tab-content" id="tabs3"><uc9:WUCResult ID="WUCResult" runat="server" /></div>    
			        </div>
			    </div>
				<div class="graph_williget" >
                    <div class="sectiontitle2" style="padding-top: 7px;">
                        <span style="color: #c00;">Factors that can make your risk of colorectal cancer higher include:</span>
                    </div>
                    <div class="redup" >
                <ul id="higherRisk">
                <li>Close relatives (parents, brothers, sisters, or children) who have had colorectal cancer [<a href="#" id="A1" class="ref_link_more" title="More About Close relatives who have had colorectal cancer">More</a>]
               <br style="line-height:5px;" />
	<div>
		<p>
If you have close relatives who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
		</p>
	</div> </li>
	<li>History of colorectal polyps [<a href="#" id="A2" class="ref_link_more" title="History of colorectal polyps">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas.
		</p>
	</div></li>
	<li>Obesity [<a href="#" id="A3" class="ref_link_more" title="More about Obesity">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Obesity has been linked to a higher risk of colorectal cancer. 
		</p>
	</div>
	</li>
	<li>Cigarette Smoking [<a href="#" id="A4" class="ref_link_more" title="More about Cigarette Smoking">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Increasing evidence from epidemiologic studies suggests that cigarette smoking, particularly long-term smoking, increases the risk of colorectal cancer.
        </p>
        <p>
        Smoking cigarettes is linked to an increased risk of developing colorectal adenomas (noncancerous tumors) and colorectal cancer. Cigarette smokers who have had surgery to remove colorectal adenomas have an increased risk for the adenomas to recur (come back).
		</p>
	</div>
</li>

	<li>Inactive Lifestyle [<a href="#" id="A5" class="ref_link_more" title="More about Inactive Lifestyle">More</a>]<br style="line-height:5px;" />
	<div>
		<p>
		Some evidence suggests that a sedentary lifestyle may be associated with an increased risk of developing colorectal cancer.
		</p>
	</div>
                      </li>
                      </ul>
                    </div>
                    <div class="sectiontitle2">
                        <span style="color: #197F07;">Factors that can lower your risk of colorectal cancer include:</span>
                    </div>
                   
                    <div class="greendown" >
                                      
                                        <ul id="lowerRisk">
                                        <li>Colorectal cancer screening
                                        [<a href="#" id="less_screening" class="ref_link_more" title="More about Colorectal cancer screening">More</a>]
					<br style="line-height:5px;" />
					<div>
					<p>Screening is checking for health problems before they cause symptoms. Colorectal cancer screening can detect polyps and nonpolypoid lesions (flat or slightly depressed areas of abnormal cell growth), and other conditions. Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas. Nonpolypoid lesions occur less often than polyps, but they can also develop into colorectal cancer.  </p><p>Finding and removing polyps or other areas of abnormal cell growth may be one of the most effective ways to prevent colorectal cancer development. </p>
                             </div>     
                                   </li>
                                        <li>Regular use of aspirin and NSAID’s
                                        [<a href="#" id="less_aspirin" class="ref_link_more"title="More about use of aspirin and NSAID’s">More</a>]
					<br style="line-height:5px;" />
					<div><p>Studies have shown that aspirin and nonsteroidal anti-inflammatory drugs like ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. However, aspirin and NSAIDs can have other adverse effects.  Do not take these medications without talking to your physician.</p>
					</div></li>
                                        <li>Maintaining a healthy weight
                                        [<a href="#" id="less_weight" class="ref_link_more" title="More about Maintaining a healthy weight">More</a>]
					<br style="line-height:5px;" />
					<div><p>Obesity has been linked to a higher risk of colorectal cancer.</p></div>
					</li>
                                        <li>Regular, vigorous exercise (all activities that cause sweating and heavy  breathing)
                                        [<a href="#" id="less_exercise" class="ref_link_more" title="More about Regular, vigorous exercise benefits">More</a>]
					<br style="line-height:5px;" />
					<div><p>There is convincing evidence that physical activity is associated with a reduced risk of cancers of the colon. The magnitude of the protective effect appears greatest with high-intensity activity, although the optimal levels and duration of exercise are still difficult to determine due to differences between studies, making comparisons difficult. It is estimated that 30 to 60 minutes of moderate to vigorous physical activity per day is needed to protect against colon cancer. It is not yet clear at this time whether physical activity has a protective effect for rectal cancer, adenomas, or polyp recurrence</p>
                     </div>                   </li>
                                        <li>A diet high in vegetables
                                        [<a href="#" id="less_vegetables" class="ref_link_more" title="More about diet high in vegetables">More</a>]
					<br style="line-height:5px;" />
					<div><p>Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer. </p>
                     </div>                   </li>
                                        <li>Hormone replacement therapy use in women
                                        [<a href="#" id="less_hormone" class="ref_link_more" title="More about Hormone replacement therapy use in women">More</a>]
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
			<a href="javascript:toggle('ctl00_cphMain_definitionEdit');switch_tabs($('#defaulttab'));" id="definition_link"><img src="images/editpersonalbold.png" border=0 /></a>
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
                        <li><a href="#" rel="print_diet" id="Diettab">Diet<br />&nbsp;</a></li>
                        <li><a href="#" rel="print_medhistory" id="Medicaltab">Medical<br />History </a></li>
                        <li><a href="#" rel="print_medications" id="Medicationtab">Medications<br />&nbsp; </a></li>
                        <li><a href="#" rel="print_activity" id="Physicaltab">Physical<br />Activity </a></li>
                        <li><a href="#" rel="print_miscmale" id="Misctab">Misc<br />&nbsp; </a></li>
                        <li><a href="#" rel="print_family" id="Familytab">Family<br />&nbsp; </a></li>
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
			    <img src="images/sm_cancel.png" border="0" /></a>&nbsp;
	            <asp:ImageButton ID="imgBtnCalculate" runat="server"  AlternateText="Calculate" OnClick="btnCalculate_Click" ImageUrl="~/images/calculate.png" border="0" />
		        <div class="blankspace"> </div>
        </div>
    </div>
</div>
    <div id="RequiredField"  class="lb_containerResult" runat="server">
        <!-- lightbox -->
        <div id="definition2" class="popup_container_moreMsg">
            <!-- centered box -->
            <div id="RequiredFieldMessage" runat="server">
                
            </div>
            <div class="close_butt_more" style="padding-top: 30px;">
                <a href="#RequiredField" onclick="toggle('ctl00_cphMain_RequiredField',event);
                        
                        return false;" style="color: #060; padding: 1px 4px; border: 1px solid #999;
                    text-decoration: none; background-color: #eee;">OK </a>
            </div>
        </div>
    </div>
<br />
<input type="hidden" id="txtGender" runat="server" />
</asp:Content>