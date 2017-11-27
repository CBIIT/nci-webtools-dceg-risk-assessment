<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuestionAsker2.ascx.cs" Inherits="CCRAT.Web.UserControls.QuestionAsker2" %>
<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<script type="text/javascript">
    function Validate(heightFeetID, heightInchesID, weightID) {
        //Get all dropdowns
        
        var ddls = document.getElementsByTagName('select');
        var length = ddls.length;        
        for (i=0; i < length; i++) 
        {
            if (ddls[i].options[ddls[i].selectedIndex].value == 'NAN') {
                alert("All questions must be answered before the patient's risk can be calculated.");
                return false;
            }
        }
        
        //Check height, Check weight.
        var heightFeet = document.getElementById(heightFeetID);
        var heightInches = document.getElementById(heightInchesID);
        var weight = document.getElementById(weightID);
        
        if (heightFeet) {
            if (heightFeet.value == '') {
                alert("All questions must be answered before the patient's risk can be calculated.");
                return false;                
            }        
        }
            
        if (heightInches) {
            if (heightInches.value == '') {
                alert("All questions must be answered before the patient's risk can be calculated.");
                return false;                
            }        
        }
        
        if (weight) {
            if (weight.value == '') {
                alert("All questions must be answered before the patient's risk can be calculated.");
                return false;                
            }        
        }

        
        return true;
    }
     
    /*   
    function onlyDigit(e) 
    {   
        var evt = e || window.event;
        var unicode=evt.keyCode;             
        if (unicode!=8 && unicode!=9 && unicode!=46 && unicode!=39 && unicode!=37) 
        {  
            if((unicode<48||unicode>57)) 

            {
                //alert('Please only enter numeric values.');
                return false; 
            }
        } 
    } 
    */
    //allows only digits [0-9]
    function onlyDigit(obj) 
    {   
        reg = /[^0-9]/g;
	    obj.value =  obj.value.replace(reg,"");
    } 
    
    //allows only digits[0-9] and period .
    function onlyDigit2(obj) 
    {   
        reg = /[^0-9.]/g;
	    obj.value =  obj.value.replace(reg,"");
    } 
    
    function ToggleHelpLink(helpText) {
        var helpText = document.getElementById(helpText);

        if (helpText.style.display == 'none')
            helpText.style.display = '';
        else
            helpText.style.display = 'none';
    }
/*    
    function getElementsByClassName(className, tag, elm){
	    var testClass = new RegExp("(^|\\s)" + className + "(\\s|$)");
	    var tag = tag || "*";
	    var elm = elm || document;
	    var elements = (tag == "*" && elm.all)? elm.all : elm.getElementsByTagName(tag);
	    var returnElements = [];
	    var current;
	    var length = elements.length;
	    for(var i=0; i<length; i++){
		    current = elements[i];
		    if(testClass.test(current.className)){
			    returnElements.push(current);
		    }
	    }
	    return returnElements;
    }
    
    function hookupPopups() {
        var popUps = getElementsByClassName('def-popup', "a", document);
        
        var length = popUps.length;
        for (var i=0; i<length; i++) {
            popUps[i].onclick = "popUp('" + popUps[i].href + "'); return false;"
        }
    }
  */  
</script>
<div class="maincontentboxtext-paddedText">
<div id="Questions" style="display:none;">
    <p id="pQuestionsRequired" runat="server" style="color: #a90101;"><strong>All questions are required.</strong></p>
    <CCRAT:QuestionGroupManager ID="qgmManager" runat="server">
        <CCRAT:QuestionGroup 
            ID="qgHispanic" 
            runat="server">
                <CCRAT:QuestionControl 
                    ID="qcHispanic"                     
                    QuestionText="Do you consider yourself to be Hispanic or Latino?"
                    AssociatedDropDownID="ddlHispanic"
                    IsQuestionTextLabelForAssociatedControl="true"
                    OnAnswerValidation="qcHispanicValidate"
                    ErrorText='We are sorry, but right now, this tool can only estimate the risk of colorectal cancer for white people between the ages of 50 to 85 years old.  We are working to make the tool useful for African Americans, Hispanics, and Asian Americans.  We expect this work to be complete during the spring of 2009.  Until the tool is updated, you can access another <a href="http://www.diseaseriskindex.harvard.edu/update/hccpquiz.pl?lang=english&func==home&quiz=colon">online risk assessment tool</a> developed at the Harvard School of Public Health. For information to help you understand cancer risk, visit <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.'
                    StopOnUnansweredQuestion="true"
                    QuestionExpanationID="qeHispanic"
                    runat="server">                    
                        <asp:DropDownList ID="ddlHispanic" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No"  />
                            <asp:ListItem Text="I don't know" Value="DontKnow"  />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>                
                <CCRAT:QuestionExplanation ID="qeHispanic" runat="server">
                    At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgRace" 
            runat="server">            
                <CCRAT:QuestionSeparator ID="qsRace" runat="server" />
                <CCRAT:QuestionControl 
                    ID="qcRace" 
                    QuestionText="Which of the following do you consider yourself to be?"
                    AssociatedDropDownID="ddlRace"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ErrorText='We are sorry, but right now, this tool can only estimate the risk of colorectal cancer for white people between the ages of 50 to 85 years old.  We are working to make the tool useful for African Americans, Hispanics, and Asian Americans.  We expect this work to be complete during the spring of 2009.  Until the tool is updated, you can access another <a href="http://www.diseaseriskindex.harvard.edu/update/hccpquiz.pl?lang=english&func==home&quiz=colon">online risk assessment tool</a> developed at the Harvard School of Public Health. For information to help you understand cancer risk, visit <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.'
                    StopOnUnansweredQuestion="true"
                    OnAnswerValidation="qcRaceValidate"
                    QuestionExpanationID="qeRace"
                    runat="server">
                        <asp:DropDownList ID="ddlRace" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="White" Value="White" />
                            <asp:ListItem Text="Black or African-American" Value="Black" />
                            <asp:ListItem Text="Asian" Value="Asian" />
                            <asp:ListItem Text="American Indian or Alaska Native" Value="Indian"  />
                            <asp:ListItem Text="Native Hawaiian or other Pacific Islander" Value="Hawaiian" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeRace" runat="server">
                    At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.
                </CCRAT:QuestionExplanation>

        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgCurrentAge" 
            runat="server" 
            OnQuestionGroupAnswered="qgCurrentAgeAnswered">            
                <CCRAT:QuestionSeparator ID="qsCurrentAge" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcCurrentAge"
                    QuestionText="What is your age?"
                    AdditionalQuestionText="Please note that this tool calculates risk for men and women 50 to 85 years of age."
                    ErrorText="You must specify your age."
                    StopOnUnansweredQuestion="true"
                    AssociatedDropDownID="ddlCurrentAge"
                    IsQuestionTextLabelForAssociatedControl="true"
			        QuestionExpanationID="qeCurrentAge"
                    runat="server">
                        <asp:DropDownList ID="ddlCurrentAge" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeCurrentAge" runat="server">
                    Colorectal cancer is more likely to occur as people get older. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>

        <CCRAT:QuestionGroup 
            ID="qgGender" 
            OnQuestionGroupAnswered="qgGenderAnswered"
            runat="server">
                <CCRAT:QuestionSeparator ID="qsGender" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcGender"
                    QuestionText="Are you male or female?"
                    AssociatedDropDownID="ddlGender"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ErrorText="You must specify your gender."
				    StopOnUnansweredQuestion="true"
			        QuestionExpanationID="qeGender"
                    runat="server">
                        <asp:DropDownList ID="ddlGender" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Male" Value="Male" />
                            <asp:ListItem Text="Female" Value="Female" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeGender" runat="server">
                The risk and protective factors that may influence the development of colorectal cancer are different for men and women.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgNumServingsVeg" 
            runat="server"        
            OnQuestionGroupAnswered="qgNumServingsVegAnswered">        
                <CCRAT:QuestionSeparator ID="QuestionSeparator18" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcHeight"
                    QuestionText="How tall are you without shoes?"
                    QuestionExpanationID="qeHeight"
                    OnAnswerValidation="qcHeightValidate"
                    AnswerUnit="inches"
                    SkipForDeterminingIfCompleted="true"
                    runat="server">
                        <div style="white-space: nowrap">
                            <asp:TextBox ID="txtHeightFeet" onkeyup="onlyDigit(this)" onkeypress="onlyDigit(this)" MaxLength="1" Width="10" runat="server" /> 
                            <asp:Label ID="lblHeightFeet" runat="server" AssociatedControlID="txtHeightFeet">feet</asp:Label>
                            &nbsp;&nbsp;
                            <asp:TextBox ID="txtHeightInches" onkeyup="onlyDigit(this)" onkeypress="onlyDigit(this)" MaxLength="2" Width="18" runat="server" />
                            <asp:Label ID="lblHeightInches" runat="server" AssociatedControlID="txtHeightInches">inches</asp:Label>
                        </div>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeHeight" runat="server">
                    Height and weight are used to calculate your body mass index (BMI) and can be used to measure total body fat and whether a person is a healthy weight. Obesity (a condition marked by an abnormally high, unhealthy amount of body fat) has been linked to an increased risk of colorectal cancer.
                </CCRAT:QuestionExplanation>

                <CCRAT:QuestionSeparator ID="qsWeight" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcWeight"
                    QuestionText="How much do you weigh without shoes?"
                    QuestionExpanationID="qeWeight"
                    AnswerUnit="lbs"
                    OnAnswerValidation="qcWeightValidate"
                    SkipForDeterminingIfCompleted="true"
                    runat="server">
                        <asp:TextBox ID="txtWeight" onkeyup="onlyDigit2(this)" onkeypress="onlyDigit2(this)" Columns="4" Width="40" MaxLength="5" runat="server" /> <asp:Label ID="lblWeight" runat="server" AssociatedControlID="txtWeight">lbs</asp:Label>.
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeWeight" runat="server">
                    Height and weight are used to calculate your body mass index (BMI) and can be used to measure total body fat and whether a person is a healthy weight. Obesity (a condition marked by an abnormally high, unhealthy amount of body fat) has been linked to an increased risk of colorectal cancer.
                </CCRAT:QuestionExplanation>
                
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="qsHeight" runat="server" />
                <CCRAT:QuestionSectionHeader 
                    ID="qshNumServingsVeg" 
                    SectionText="Think about what you ate in the past 30 days.  Include meals, snacks, and anything else you ate either at home or away from home (at restaurants, at friends’, take-out, delivery, and so on)." 
                    runat="server" />                
                <CCRAT:QuestionControl
                    ID="qcNumServingsVeg"
                    QuestionText="In the past 30 days, about how many <em>servings per week</em> of vegetables or leafy green salads did you eat?"
                    AdditionalQuestionText="INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads.<br/>DO NOT INCLUDE fried vegetables like French fries or fried potatoes."
                    AssociatedDropDownID="ddlNumServingsVeg"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeNumServingsVeg"
                    runat="server" >
                        <asp:DropDownList ID="ddlNumServingsVeg" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="None" Value="0" />
                            <asp:ListItem Text="Less than 1 serving per week" Value=".5" />
                            <asp:ListItem Text="1-2 servings per week" Value="1.5" />
                            <asp:ListItem Text="3-4 servings per week" Value="3.5" />
                            <asp:ListItem Text="5-6 servings per week" Value="5.5" />
                            <asp:ListItem Text="7-10 servings per week" Value="8.5" /> 
                            <asp:ListItem Text="More than 10 servings per week" Value="11" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeNumServingsVeg" runat="server">
                    Some, but not all, studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgAmountVeg" 
            runat="server"              
            OnQuestionRedraw="qgAmountVegRedraw">
            <CCRAT:QuestionSeparator ID="qsAmountVeg" runat="server" />
            <CCRAT:QuestionControl
                ID="qcAmountVeg"
                QuestionText="In the past 30 days, <em>how much</em> did you usually eat in each serving of vegetables or leafy green salads?"
                AssociatedDropDownID="ddlAmountVeg"
                IsQuestionTextLabelForAssociatedControl="true"
                QuestionExpanationID="qeAmountVeg"
                runat="server">
                    <asp:DropDownList ID="ddlAmountVeg" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                        <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                        <asp:ListItem Text="1/2 cup or less" Value=".25" />
                        <asp:ListItem Text="More than 1/2 cup but less than 1 1/2 cups" Value="1" />
                        <asp:ListItem Text="Between 1 1/2 cups and 3 cups" Value="2.25" />
                        <asp:ListItem Text="More than 3 cups but less than 5 cups" Value="4" />
                        <asp:ListItem Text="5 cups or more" Value="6" />
                    </asp:DropDownList>
            </CCRAT:QuestionControl>
            <CCRAT:QuestionExplanation ID="qeAmountVeg" runat="server">
                Some, but not all, studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
            </CCRAT:QuestionExplanation>

        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgColonoscopy" 
            runat="server" 
            OnQuestionGroupAnswered="qgColonoscopyAnswered">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="qsColonoscopy" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcColonoscopy"
                    QuestionText='During the past 10 years, did you have a <a href="def-colonoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscopy</a> or a <a href="def-sigmoidoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">sigmoidoscopy</a>?'
                    AdditionalQuestionText="These are medical procedures in which a healthcare professional inserts a tube into the rectum to look for signs of cancer or other problems."
                    AssociatedDropDownID="ddlColonoscopy"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeColonoscopy"
                    runat="server">
                        <asp:DropDownList ID="ddlColonoscopy" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeColonoscopy" runat="server">
                    In a sigmoidoscopy, your healthcare provider checks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your healthcare provider can remove it using the sigmoidoscope. The healthcare provider can send that piece of tissue (<a href="def-biopsy.aspx" onclick="popUp(event);return false;" class="grey-text">biopsy</a>) to the lab for testing.  In a colonoscopy, your healthcare provider examines inside the rectum and entire colon using a long, lighted tube called a <a href="def-colonoscope.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscope</a>. Using a colonoscope, your healthcare provider can remove polyps that may be found. The procedure to remove polyps is called a polypectomy.  Having this procedure will decrease your risk of developing colorectal cancer because polyps, which can be precancerous lesions, are removed.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgHadPolyp" 
            runat="server" 
            OnQuestionRedraw="qgHadPolypRedraw">        
                <CCRAT:QuestionSeparator ID="qsHadPolyp" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcHadPolyp"
                    QuestionText="During the past 10 years did a healthcare provider tell you that you had a colon polyp or a rectal polyp?"
                    AssociatedDropDownID="ddlHadPolyp"
                    IsQuestionTextLabelForAssociatedControl="true"
                    AdditionalQuestionText="A polyp is a small growth, like a skin tag, that develops on the inside of the colon or rectum."
                    QuestionExpanationID="qeHadPolyp"
                    runat="server">
                        <asp:DropDownList ID="ddlHadPolyp" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeHadPolyp" runat="server">
                    Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are benign (not cancer), but some polyps can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgAsprin" 
            runat="server">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator19" runat="server" />
                <CCRAT:QuestionSectionHeader 
                    ID="QuestionSeparator1" 
                    SectionText="People may take medication to treat pain, headache, or arthritis; to relax muscles; or to prevent heart attacks and other diseases."
                    runat="server" />
                <CCRAT:QuestionControl
                    ID="qcAsprin"                    
                    QuestionText="This question asks about medications that contain aspirin.  During the past 30 days, have you taken aspirin, BUFFERIN, BAYER, or EXCEDRIN <em>at least</em> 3 times a week?"
                    AdditionalQuestionText="Do <strong>NOT</strong> include TYLENOL."
                    AssociatedDropDownID="ddlAsprin"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeAsprin"
                    runat="server">
                        <asp:DropDownList ID="ddlAsprin" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeAsprin" runat="server">
                    Studies have shown that aspirin and nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drugs (NSAIDs) can lower the risk of colorectal adenomas (noncancerous tumors), and may lower risk of cancerous tumors in the colon and rectum.
                </CCRAT:QuestionExplanation>

	    </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgIbuprofen" 
            runat="server">                
                <CCRAT:QuestionSeparator ID="QuestionSeparator2" runat="server" />                
                <CCRAT:QuestionControl
                    ID="qcIbuprofen"
                    QuestionText="This question asks about some medications that do not contain aspirin.  During the past 30 days, have you taken ADVIL, ALEVE, CELEBREX, ibuprofen, MOTRIN, naproxen, or NUPRIN <em>at least</em> 3 times a week?"
                    AdditionalQuestionText="Do <strong>NOT</strong> include TYLENOL."
                    AssociatedDropDownID="ddlIbuprofen"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeIbuprofen"
                    runat="server">
                        <asp:DropDownList ID="ddlIbuprofen" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeIbuprofen" runat="server">
                    Studies have shown that aspirin and nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drugs (NSAIDs) can lower the risk of colorectal adenomas (noncancerous tumors), and may lower risk of cancerous tumors in the colon and rectum.
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgModerateActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgModerateActivitiesAnswered">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator20" runat="server" />
                <CCRAT:QuestionSectionHeader 
                    ID="QuestionSeparator3" 
                    SectionText="The next questions are about moderate and vigorous physical activities that you did around the house and those you did for recreation or exercise in the last 12 months."
                    runat="server" />
                <CCRAT:QuestionControl
                    ID="qcModerateActivities"
                    QuestionText="Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity?"
                    AdditionalQuestionText="First, think about moderate activities.  Moderate activities DO NOT cause you to sweat or breathe hard.  <strong>Some examples</strong> include vacuuming, gardening, easy walking for exercise, and so on."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlModerateActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeModerateActivities"
                    runat="server">
                        <asp:DropDownList ID="ddlModerateActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeModerateActivities" runat="server">
                    Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgModerateHours" 
            runat="server" 
            OnQuestionRedraw="qcModerateHoursRedraw">                
                <CCRAT:QuestionSeparator ID="QuestionSeparator4" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcModerateHours"
                    QuestionText="During those months, on average, about how many hours per week did you do moderate physical activities?"
                    AssociatedDropDownID="ddlModerateHours"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeModerateHours"
                    runat="server">
                        <asp:DropDownList ID="ddlModerateHours" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Up to one hour per week" Value="2" />
                            <asp:ListItem Text="Between 1 and 2 hours per week" Value="3" />
                            <asp:ListItem Text="More than 2 but less than 3 hours per week" Value="4" />
                            <asp:ListItem Text="Between 3 and 4 hours per week" Value="5" />
                            <asp:ListItem Text="More than 4 hours per week" Value="6" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeModerateHours" runat="server">
                    Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgVigorousActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgVigorousActivitiesAnswered">
                <CCRAT:QuestionSeparator ID="QuestionSeparator5" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcVigorousActivities"
                    QuestionText="Over the past 12 months, in how many months, if any, did you do any kind of vigorous physical activity?"
                    AdditionalQuestionText="Now, think about the vigorous activity you may have done over the last 12 months.  Vigorous activities include all activities that DO cause you to sweat or breathe hard.   <strong>Some examples</strong> include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlVigorousActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeVigorousActivities"
                    runat="server">
                        <asp:DropDownList ID="ddlVigorousActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeVigorousActivities" runat="server">
                    Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgVigorousHours" 
            runat="server" 
            OnQuestionRedraw="qcVigorousHoursRedraw"
            OnQuestionGroupAnswered="qgVigorousHoursAnswered">
                <CCRAT:QuestionSeparator ID="QuestionSeparator6" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcVigorousHours"
                    QuestionText="During those months, on average, about how many hours per week did you do vigorous physical activities?"
                    AssociatedDropDownID="ddlVigorousHours"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeVigorousHours"
                    runat="server">
                        <asp:DropDownList ID="ddlVigorousHours" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Up to one hour per week" Value=".5" />
                            <asp:ListItem Text="Between 1 and 2 hours per week" Value="1.5" />
                            <asp:ListItem Text="More than 2 but less than 3 hours per week" Value="2.5" />
                            <asp:ListItem Text="Between 3 and 4 hours per week" Value="3.5" />
                            <asp:ListItem Text="More than 4 hours per week" Value="5" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeVigorousHours" runat="server">
                    Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <%-- Male Questions --%>
        <CCRAT:QuestionGroup 
            ID="qg100MoreCigs" 
            runat="server" 
            OnQuestionRedraw="qc100MoreCigsRedraw"
            OnQuestionGroupAnswered="qg100MoreCigsAnswered">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator7" runat="server" />        
                <CCRAT:QuestionControl
                    ID="qc100MoreCigs"
                    QuestionText="In your entire lifetime, altogether, have you smoked 100 or more cigarettes?"
                    AssociatedDropDownID="ddl100MoreCigs"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qe100MoreCigs"
                    runat="server">
                        <asp:DropDownList ID="ddl100MoreCigs" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qe100MoreCigs" runat="server">
                    Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.
                    <br/>In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgStartSmoke" 
            runat="server" 
            OnQuestionRedraw="qgStartSmokeRedraw"
            OnQuestionGroupAnswered="qgStartSmokeAnswered">
                <CCRAT:QuestionSeparator ID="QuestionSeparator8" runat="server" />                
                <CCRAT:QuestionControl
                    ID="qcStartSmoke"
                    QuestionText="How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?"
                    AssociatedDropDownID="ddlStartSmoke"
                    QuestionExpanationID="qeStartSmoke"
                    IsQuestionTextLabelForAssociatedControl="true"
                    runat="server">
                        <asp:DropDownList ID="ddlStartSmoke" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeStartSmoke" runat="server">
                    Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.
                    <br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
                </CCRAT:QuestionExplanation>

        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgStillSmoke" 
            runat="server" 
            OnQuestionRedraw="qgStillSmokeRedraw"
            OnQuestionGroupAnswered="qgStillSmokeAnswered">                
                <CCRAT:QuestionSeparator ID="QuestionSeparator9" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcStillSmoke"
                    QuestionText="Do you currently smoke cigarettes?"
                    AssociatedDropDownID="ddlStillSmoke"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeStillSmoke"
                    runat="server">
                        <asp:DropDownList ID="ddlStillSmoke" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeStillSmoke" runat="server">
                    Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.
                    <br/>In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgSmokeQuit"
		    OnQuestionRedraw="qgSmokeQuitRedraw"
            runat="server">
                <CCRAT:QuestionSeparator ID="QuestionSeparator10" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcSmokeQuit"
                    QuestionText="How old were you when you quit smoking cigarettes completely?"
                    AdditionalQuestionText="If you quit smoking cigarettes completely more than one time, please tell us how old you were the last time you quit smoking completely."
                    AssociatedDropDownID="ddlSmokeQuit"
                    QuestionExpanationID="qeSmokeQuit"
                    IsQuestionTextLabelForAssociatedControl="true"
                    runat="server">
                        <asp:DropDownList ID="ddlSmokeQuit" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeSmokeQuit" runat="server">
                    Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.
                    <br/>In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
                
        <CCRAT:QuestionGroup 
            ID="qgCigNumPerDay" 
            runat="server"
		    OnQuestionRedraw="qgCigNumPerDayRedraw"
            OnQuestionGroupAnswered="qgCigNumPerDayAnswered">        
                <CCRAT:QuestionSeparator ID="QuestionSeparator11" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcCigNumPerDay"
                    QuestionText="Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked each day?"
                    AssociatedDropDownID="ddlCigNumPerDay"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeCigNumPerDay"
                    runat="server">
                        <asp:DropDownList ID="ddlCigNumPerDay" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="1 to 10 cigarettes a day" Value="1To10" />
                            <asp:ListItem Text="11 to 20 cigarettes a day" Value="11To20" />
                            <asp:ListItem Text="More than 20 cigarettes a day" Value="GT20" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeCigNumPerDay" runat="server">
                    Recent studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.
                    <br/>In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <%-- End Male Questions --%>
        
        <%-- Female Questions --%>
        <CCRAT:QuestionGroup 
            ID="qgStillHavePeriods" 
            runat="server" 
            OnQuestionRedraw="qgStillHavePeriodsRedraw"
            OnQuestionGroupAnswered="qgStillHavePeriodsAnswered">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator12" runat="server" />        
                <CCRAT:QuestionControl
                    ID="qcStillHavePeriods"
                    QuestionText="Do you still have periods or menstrual cycles?"
                    AssociatedDropDownID="ddlStillHavePeriods"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeStillHavePeriods"
                    runat="server">
                        <asp:DropDownList ID="ddlStillHavePeriods" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeStillHavePeriods" runat="server">
                    Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgLastCycle" 
            runat="server" 
            OnQuestionRedraw="qgLastCycleRedraw"
            OnQuestionGroupAnswered="qgLastCycleAnswered">
                <CCRAT:QuestionSeparator ID="QuestionSeparator13" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcLastCycle"
                    QuestionText="When did you have your last period or menstrual cycle?"
                    AssociatedDropDownID="ddlLastCycle"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeLastCycle"
                    runat="server">
                        <asp:DropDownList ID="ddlLastCycle" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" runat="server">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="1 year ago or less" Value="LT1" />
                            <asp:ListItem Text="More than 1 year ago but less than 2 years ago" Value="GT1LT2" />
                            <asp:ListItem Text="2 years ago or more" Value="GT2" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeLastCycle" runat="server">
                    Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgUsedEstrogen" 
            runat="server"
            OnQuestionRedraw="qgUsedEstrogenRedraw">
                <CCRAT:QuestionSeparator ID="QuestionSeparator14" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcUsedEstrogen"
                    QuestionText="During the past 2 years, have you used estrogen, progestin, or other female hormones?"
                    AdditionalQuestionText="These hormones may be given as hormone pills, oral contraceptives, shots, skin patches, vaginal creams, or as vaginal suppositories."
                    AssociatedDropDownID="ddlUsedEstrogen"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeUsedEstrogen"
                    runat="server">
                        <asp:DropDownList ID="ddlUsedEstrogen" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" runat="server">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeUsedEstrogen" runat="server">
                    Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
        <%-- End female Questions --%>

        <CCRAT:QuestionGroup 
            ID="qgHasRelativeHadCC"
            OnQuestionGroupAnswered="qgHasRelativeHadCCAnswered" 
            runat="server">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator21" runat="server" />
                <CCRAT:QuestionSectionHeader 
                    ID="QuestionSeparator15" 
                    SectionText="The next questions ask about your family’s history with cancer of the colon or rectum (sometimes called cancer of the lower intestine)."
                    runat="server" />
                <CCRAT:QuestionControl
                    ID="qcHasRelativeHadCC"
                    QuestionText="Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have cancer of the colon or rectum (cancer of the lower intestine)?"
                    AssociatedDropDownID="ddlHasRelativeHadCC"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeHasRelativeHadCC"
                    runat="server">
                        <asp:DropDownList ID="ddlHasRelativeHadCC" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeHasRelativeHadCC" runat="server">
                    Close relatives (parents, brothers, sisters, or children) of a person with a history of colorectal cancer are somewhat more likely to develop this disease themselves, especially if the relative had the cancer at a young age.   If many close relatives have a history of colorectal cancer, the risk can be even greater.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgNumRelativesHavingCC"             
            runat="server"
            OnQuestionRedraw="qgNumRelativesHavingCCRedraw">
                <CCRAT:QuestionSeparator ID="QuestionSeparator16" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcNumRelativesHavingCC"
                    QuestionText="How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?"
                    AssociatedDropDownID="ddlNumRelativesHavingCC"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeNumRelativesHavingCC"
                    runat="server">
                        <asp:DropDownList ID="ddlNumRelativesHavingCC" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="One" Value="One" />
                            <asp:ListItem Text="Two or more" Value="TwoPlus" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeNumRelativesHavingCC" runat="server">
                    Close relatives (parents, brothers, sisters, or children) of a person with a history of colorectal cancer are somewhat more likely to develop this disease themselves, especially if the relative had the cancer at a young age.   If many close relatives have a history of colorectal cancer, the risk can be even greater.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionSeparator ID="QuestionSeparator17" runat="server" />
        <div class="calculateButtons">
            <asp:PlaceHolder ID="phCalculateButtons" runat="server">
                <asp:Image ID="btnCalculateDisabled"
                    runat="server"
                    ImageUrl="~/images/calculate-risk-disabled.gif"
                    Width="102" Height="17"
                    AlternateText="Finish form to calculate risk" 
                    ToolTip="Finish form to calculate risk"
                    />
                <asp:ImageButton ID="btnCalculate" 
                    AlternateText="Calculate Risk" 
                    ToolTip="Calculate Risk" 
                    runat="server" 
                    ImageUrl="~/images/calculate-risk.gif" 
                    Width="102" Height="17" 
                    onclick="btnCalculate_Click"
                    />
            </asp:PlaceHolder>
            <asp:HyperLink ID="lnkNewCalculation"
                NavigateUrl="~/Default.aspx"
                runat="server">
                    <asp:Image
                        ID="imgNewCalculation"
                        ImageUrl="~/images/calculate-risk-new.gif"
                        AlternateText="New Risk Calculation"
                        runat="server" />
                </asp:HyperLink>
        </div>
    </CCRAT:QuestionGroupManager>
</div>
<script type="text/javascript">
    document.getElementById('Questions').style.display = 'block';
</script>
<noscript>
<h1 style="color: #a90101;">Javascript is currently not enabled in your browser.  If you wish to use this tool, please enable Javascript.</h1>
</noscript>

</div>