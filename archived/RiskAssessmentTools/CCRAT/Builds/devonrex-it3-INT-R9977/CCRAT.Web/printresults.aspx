<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="printresults.aspx.cs" Inherits="CCRAT.Web.printresults" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Colorectal Cancer Risk Assessment Tool-Print Results</title>
        <link href="style/PrintResult.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/results_overlay.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/results_overlay_popup.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/more_link.css" rel="stylesheet" type="text/css" media="screen" />
    <link href="style/deflink.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form id="form1" runat="server">
    <div class="nci-logo">
        <a href="/">NATIONAL CANCER INSTITUTE<br> <span>at the National Institutes of Health</span></a>
	</div>
    <div id="center-page">
    <div style="text-align:center;height:30px;padding-top:10px;background-color:#DAD9D4"><span style=" font-family:Sans-Serif; color:#000000; font-size:16px;"><b>Colorectal Cancer Risk Assessment Tool</b></span></div>
        <div id="main" class="fontstyle">
            <div id="left">
                <div id="padding" class="padding">
                    Your <b>5 Years risk</b> is estimated to be <b>
                        <%=InputFiveAbsolute %>%</b>.
                <br />
                    Estimates are not exact. Your risk for developing colorectal cancer during your lifetime is most likely in the <b>range of <%=InputLow5 %>%-<%=InputHigh5 %>%</b>(or somewhere between <b><%=InputLowRound5 %> and <%=InputHighRound5 %> out of every <%=PeopleTotal5 %></b> people) but may be higher or lower.This means your risk is <b>
                        <%=Comparison5%> the average risk</b> for all
                    <%=Race%>
                    <%=Gender%> aged
                    <%=Age%>
                    - which is <b>approximately
                        <%=InputAvg5 %>%</b>.<br /><br />
                </div>
            </div>
            <div id="middle">
                <div id="Div1" class="padding">
                
                    Your <b>10 Years risk</b> is estimated to be <b>
                        <%=InputTenAbsolute %>%</b>.
                <br />
                    Estimates are not exact. Your risk for developing colorectal cancer during your lifetime is most likely in the <b>range of
                        <%=InputLow10 %>%-<%=InputHigh10 %>%</b> (or somewhere between <b>
                        <%=InputLowRound10 %>
                        and
                        <%=InputHighRound10 %>
                        out of
                        
                        every
                        <%=PeopleTotal10 %></b> people) but may be higher or lower.
                    
                    This means your risk is <b>
                        <%=Comparison10%>
                        the average risk</b> for all
                    <%=Race%>
                    <%=Gender%>
                    
                    aged
                    <%=Age%>
                    - which is <b>approximately
                        <%=InputAvg10 %>%</b>.<br /><br />
                </div>                        
            </div>            
            <div id="right">
                <div id="Div2" class="padding">
            
                    Your <b>lifetime risk</b> is estimated to be <b>
                        <%=InputLifeAbsolute %>%</b>.
                <br />
                Estimates are not exact. Your risk for developing colorectal cancer during your
                lifetime is most likely in the <b>range of
                    <%=InputLowlt %>%-<%=InputHighlt %>%</b> (or somewhere between <b>
                    <%=InputLowRoundlt %>
                    and
                    <%=InputHighRoundlt %>
                    out of
                    
                    every
                    <%=PeopleTotallt %></b> people) but may be higher or lower.
                
                This means your risk is <b>
                    <%=Comparisonlt%>
                    the
                    
                    average risk</b> for all
                <%=Race%>
                <%=Gender%>
                
                aged
                <%=Age%>
                - which is <b>approximately
                    <%=InputAvglt %>%</b>.<br /><br />
                </div>                    
            </div>
        </div>
        <br />
<div>&nbsp;</div>
        <div class="fontstyle">
        
				<b>Does this mean I will get colorectal cancer?</b>
				
				<div>
					Somewhere between <%=InputLowlt %>% and <%=InputHighlt %>% out of every <%=personslt %> 
					people similar to you will develop colorectal cancer during their  
					lifetimes.  However, we can't tell whether you or any one person
					will develop cancer or not.
				</div>
        </div>
        <br />
        <hr />
        <br />
        <div  style="padding-top: 7px;" class="fontstyle">
                        <span class="sectiontitle2" style="color: #c00;">Factors that can make your risk of colorectal cancer higher include:<br /></span>
                        
                <br />
                 <span class="sectiontitle2">&bull; Close relatives (parents, brothers, sisters, or children) who have had colorectal cancer.</span>
              
               <p style="padding-left: 25px;">If you have close relatives who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
                </p>
        </div>
               
             <br />
        <div class="fontstyle">                        
                
	               <span class="sectiontitle2">&bull; History of colorectal polyps</span>
               
               <p style="padding-left: 20px;">Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas.</p>
        </div>    
        
        
             <br />
        <div class="fontstyle">                        
                
	                <span class="sectiontitle2">&bull; Obesity</span>
               
               <p style="padding-left: 20px;">Height and weight are used to determine your body mass index (BMI). It can also be used to measure total body fat and whether a person is health weight. Your BMI suggests you are over weight but not necessarily obese, but obesity has been linked to a higher risk of colorectal cancer.</p>
        </div>                           
             <br />

        <div class="fontstyle">                        
                
	                <span class="sectiontitle2">&bull; Cigarette Smoking</span>
               
               <p style="padding-left: 20px;">Increasing evidence from epidemiologic studies suggests that cigarette smoking, particularly long-term smoking, increases the risk of colorectal cancer.</p>
        </div>     
                     <br />

                <div class="fontstyle">                        
                
	                <span class="sectiontitle2">&bull; Cigarette Smoking</span>
               
               <p style="padding-left: 20px;">Increasing evidence from epidemiologic studies suggests that cigarette smoking, particularly long-term smoking, increases the risk of colorectal cancer.Smoking cigarettes is linked to an increased risk of developing colorectal adenomas (noncancerous tumors) and colorectal cancer. Cigarette smokers who have had surgery to remove colorectal adenomas have an increased risk for the adenomas to recur (come back).</p>
                       
                     <br />

                <div class="fontstyle">                        
                
	                <span class="sectiontitle2">&bull; Inactive Lifestyle</span>
               
               <p style="padding-left: 20px;">Some evidence suggests that a sedentary lifestyle may be associated with an increased risk of developing colorectal cancer.</p>

        </div> 
        <br />
        <hr />
        <br />
       <div class="sectiontitle2">
          <span style="color: #197F07;" class="fontstyle">Factors that can lower your risk of colorectal cancer include:</span>
       </div>
       <br />
                <div class="fontstyle">                        
                <span class="sectiontitle2">&bull; Colorectal cancer screening</span>
               
               <p style="padding-left: 20px;">Screening is checking for health problems before they cause symptoms. Colorectal cancer screening can detect polyps and nonpolypoid lesions (flat or slightly depressed areas of abnormal cell growth), and other conditions. Polyps are abnormal growths that protrude from the inner wall of the colon or rectum. They are relatively common in people over age 50. Most polyps are benign (noncancerous), but experts believe that the majority of colorectal cancers develop in polyps known as adenomas. Nonpolypoid lesions occur less often than polyps, but they can also develop into colorectal cancer.  Finding and removing polyps or other areas of abnormal cell growth may be one of the most effective ways to prevent colorectal cancer development.</p>
</div>                       
                     <br />

                <div class="fontstyle">                        
                <span class="sectiontitle2">&bull; Regular use of aspirin and NSAID’s</span>
               <p style="padding-left: 20px;">Studies have shown that aspirin and nonsteroidal anti-inflammatory drugs like ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. However, aspirin and NSAIDs can have other adverse effects.  Do not take these medications without talking to your physician.</p>

</div>

                     <br />

                <div class="fontstyle">                        
                <span class="sectiontitle2">&bull; A diet high in vegetables</span>
               <p style="padding-left: 20px;">Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.</p>

        </div>                        
    </div>
    </div>
    </form>
<script type="text/javascript">
window.print();
</script> 
</body>
</html>
