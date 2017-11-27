<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuestionAsker2.ascx.cs" Inherits="CCRAT.Web.UserControls.QuestionAsker2" %>
<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>

<script type="text/javascript">
    function Validate(heightID, heightFeetID, heightInchesID, weightID) {
        //Get all dropdowns
        
        var ddls = document.getElementsByTagName('select');
        var length = ddls.length;
        var errMessage = "";
        var firstUnAnsweredElementID;
        var heightFeetUA = false;
        var lblHeight = 'lblHeight';
        var lblWeight = 'lblWeight';
        
        setClass(lblHeight, '', true);
        setClass(lblWeight, '', true);
        
        for (i=0; i < length; i++) {
            if (ddls[i].options[ddls[i].selectedIndex].value == 'NAN') {
                if (ddls[i].id == heightFeetID || ddls[i].id == heightInchesID) {
                    if (!firstUnAnsweredElementID)
                        firstUnAnsweredElementID = ddls[i].id;
                    setClass(lblHeight, 'unanswered', true);
                    if (ddls[i].id == heightFeetID) {
                        errMessage += "\n" + document.getElementById(heightID).title;
                        heightFeetUA = true;
                    }
                    else if (ddls[i].id == heightInchesID && heightFeetUA == false) {
                        errMessage += "\n" + document.getElementById(heightID).title;
                    }                                                       
                }
                else {
                    if (!firstUnAnsweredElementID)
                        firstUnAnsweredElementID = ddls[i];
                    setClass(ddls[i].id, 'unanswered');
                    errMessage += "\n" + ddls[i].title;
                }
                
            }
            else {
                setClass(ddls[i].id, '');
            }            
        }
       
        var weight = document.getElementById(weightID);
        if (weight) {
            if (weight.value == '') {
                errMessage += "\n" + weight.title;
                setClass(lblWeight, 'unanswered', true);
                if (!firstUnAnsweredElementID)
                    firstUnAnsweredElementID = weightID;
            }
            else
                setClass(lblWeight, '', true);
        }

        if (errMessage.length > 0) {
            alert("Before the risk can be calculated, you must answer these questions:" + errMessage);
            elmnt = document.getElementById(firstUnAnsweredElementID);
            if (elmnt)
                elmnt.focus();
            return false;
        }  
        
        // Web Analytics (Omniture) - call web analytics-related function defined in 
        // in analytics_include.html and rendered in the web analytics page-load tag.  
        // If web analytics are turned off,  analytics_include.html is empty and this function is not found.
        // In the future it may be more efficient to attach this JavaScript code 
        // to the appropriate page event (click or submit) so no reference to web analytics
        // will be needed in this file.  
        if(window.Analytics_CalculateRiskConversionEvent)
            window.Analytics_CalculateRiskConversionEvent();
            
        return true;
    }
    //sets or removes class attribute of an element(unanswered question)
    function setClass(id, className, label) {
        var lbl;
        if(label == true)
            lbl = document.getElementById(id);
        else
            lbl = document.getElementById(id.replace(id.substr(id.lastIndexOf("_"), 4), "lbl"));
            
        if (lbl) {
            if (className) {
                lbl.className = className;
            }
            else {
                lbl.removeAttribute("class");
            }
        }
    }

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
    
    //disclaimer for hispanics
    function showAlertHispanic(ddlId) {
        var ddl = document.getElementById(ddlId);
        
        if (ddl && ddl.options[ddl.selectedIndex].value.toLowerCase() == 'yes') {
            var s = "When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for this group, your results may be less accurate.\n\nIn the future, we hope to make this tool more accurate for Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for this group.\n\nAlthough the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.";
            //alert(s);
            popUp2('disclaimer-hispanic.aspx');
        }
        return true;
    }
    //disclaimer for african americans and asians
    function showAlertBlackOrAsian(ddlId) {
        var ddl = document.getElementById(ddlId);
        if (ddl) {
            if(ddl.options[ddl.selectedIndex].value.toLowerCase() == 'black')
                //alert("When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are African American, this tool can still estimate your risk. But, because there is not as much data available for this group, your results may be less accurate.\n\nIn the future, we hope to make this tool more accurate for African Americans, as researchers complete studies that will provide information to update the tool for this group.\n\nAlthough the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.");
                popUp2('disclaimer-african-american.aspx');
            else if (ddl.options[ddl.selectedIndex].value.toLowerCase() == 'asian')
                //alert("When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are Asian American or Pacific Islander, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.\n\nIn the future, we hope to make this tool more accurate for Asian Americans and Pacific Islanders, as researchers complete studies that will provide information to update the tool for these groups.\n\nAlthough the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.");
                popUp2('disclaimer-asian-american.aspx');
        }
        return true; 
    }
</script>

<div class="maincontentboxtext-paddedText">
<div id="Questions" style="display:none;">
    <p id="pQuestionsRequired" runat="server" style="color: #a90101;"><strong>To estimate your risk, answer the following questions</strong></p>
    <CCRAT:QuestionGroupManager ID="qgmManager" runat="server">
        <CCRAT:QuestionGroup 
            ID="qgHispanic" 
            OnQuestionGroupAnswered="qgHispanicAnswered"
            runat="server">
                <CCRAT:QuestionControl 
                    ID="qcHispanic"                     
                    QuestionText="Do you consider yourself to be Hispanic/Latino?"
                    AssociatedDropDownID="ddlHispanic"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeHispanic"
                    ErrorText="You must specify your ethnicity."
				    StopOnUnansweredQuestion="true"
                    runat="server">                    
                        <asp:DropDownList ID="ddlHispanic" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No"  />
                            <asp:ListItem Text="I don't know" Value="DontKnow"  />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>                
                <CCRAT:QuestionExplanation ID="qeHispanic" runat="server">
                    <p class="helpText">When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.</p>
                    <p class="helpText">In the future, we hope to make this tool more accurate for African Americans, Asian Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for these groups.</p>
                    <p class="helpText">This tool does not yet apply to American Indians and Alaska Natives, but we are working to improve the tool for use by these groups of people.</p>                    
                    <p class="helpText">This Web site can help you learn more about cancer risk, including colorectal cancer risk: <a href="http://understandingrisk.cancer.gov">Understanding the Puzzle</a> from NCI.</p>
                </CCRAT:QuestionExplanation>
                <%--<CCRAT:QuestionModalAlert id="qmaHispanic" AssociatedQuestionControlID="qcHispanic" ShowIfValue="Yes" CssClass="disclaimer-popup" runat="server">
                    <p>When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for this group, your results may be less accurate.</p>
                    <p>In the future, we hope to make this tool more accurate for Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for this group.</p>
                    <p>Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.</p>
                </CCRAT:QuestionModalAlert>--%>

        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgRace" 
            OnQuestionRedraw="qgRaceRedraw"
            OnQuestionGroupAnswered="qgRaceAnswered"
            runat="server">            
                <CCRAT:QuestionSeparator ID="qsRace" runat="server" />
                <CCRAT:QuestionControl 
                    ID="qcRace" 
                    QuestionText="Which of the following do you consider yourself to be?"
                    AssociatedDropDownID="ddlRace"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeRace"                    
                    runat="server">
                        <asp:DropDownList ID="ddlRace" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Asian or Pacific Islander" Value="Asian" />
                            <asp:ListItem Text="Black or African-American" Value="Black" />
                            <asp:ListItem Text="White" Value="White" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeRace" runat="server">
                    <p class="helpText">When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer.  If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.</p>
                    <p class="helpText">In the future, we hope to make this tool more accurate for African Americans, Asian Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for these groups.</p>
                    <p class="helpText">This tool does not yet apply to American Indians and Alaska Natives, but we are working to improve the tool for use by these groups of people.</p>
                    <p class="helpText">This Web site can help you learn more about cancer risk, including colorectal cancer risk: <a href="http://understandingrisk.cancer.gov">Understanding the Puzzle</a> from NCI.</p>
                </CCRAT:QuestionExplanation>
                <%--<CCRAT:QuestionModalAlert id="qmaAfricanAmerican" AssociatedQuestionControlID="qcRace" ShowIfValue="Black" CssClass="disclaimer-popup" runat="server">
                    <p>When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer.  If you are African American, this tool can still estimate your risk. But, because there is not as much data available for this group, your results may be less accurate.</p>
                    <p>In the future, we hope to make this tool more accurate for African Americans, as researchers complete studies that will provide information to update the tool for this group.</p>
                    <p>Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.</p>
                </CCRAT:QuestionModalAlert>
                <CCRAT:QuestionModalAlert id="qmaAsian" AssociatedQuestionControlID="qcRace" ShowIfValue="Asian" CssClass="disclaimer-popup" runat="server">
                    <p>When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer.  If you are Asian American or Pacific Islander, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.</p>
                    <p>In the future, we hope to make this tool more accurate for Asian Americans and Pacific Islanders, as researchers complete studies that will provide information to update the tool for these groups.</p>
                    <p>Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.</p>
                </CCRAT:QuestionModalAlert>--%>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgCurrentAge" 
            runat="server" 
            OnQuestionGroupAnswered="qgCurrentAgeAnswered">            
                <CCRAT:QuestionSeparator ID="qsCurrentAge" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcCurrentAge"
                    QuestionText="What is your age?"
                    AdditionalQuestionText="Keep in mind that this tool only estimates risk for people from 50 to 85 years old."
                    ErrorText="You must specify your age."
                    StopOnUnansweredQuestion="true"
                    AssociatedDropDownID="ddlCurrentAge"
                    IsQuestionTextLabelForAssociatedControl="true"
			        QuestionExpanationID="qeCurrentAge"
                    runat="server">
                        <asp:DropDownList ID="ddlCurrentAge" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeCurrentAge" runat="server">
                    As you get older, your risk of colorectal cancer gets higher. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.
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
                    The factors that can protect you from colorectal cancer or cause you to be at higher risk  are different for men and women.
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
                    AnswerUnit="FeetAndInches"
                    SkipForDeterminingIfCompleted="true"
                    ToolTip="Height (in feet and inches)"
                    runat="server">
                        <div style="white-space: nowrap">
                            <%--<asp:TextBox ID="txtHeightFeet" onkeyup="onlyDigit(this)" onkeypress="onlyDigit(this)" MaxLength="1" Width="10" runat="server" /> --%>
                            <asp:DropDownList ID="ddlHeightFeet" runat="server" OnSelectedIndexChanged="UpdateQuestions">
                                <asp:ListItem Text="Select" Value="NAN"></asp:ListItem>
                                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                            </asp:DropDownList>                            
                            <asp:Label ID="lblHeightFeet" runat="server" AssociatedControlID="ddlHeightFeet">feet</asp:Label>
                            &nbsp;&nbsp;
                            <%--<asp:TextBox ID="txtHeightInches" onkeyup="onlyDigit(this)" onkeypress="onlyDigit(this)" MaxLength="2" Width="18" runat="server" />--%>
                            <asp:DropDownList ID="ddlHeightInches" runat="server" OnSelectedIndexChanged="UpdateQuestions">
                                <asp:ListItem Text="Select" Value="NAN"></asp:ListItem>
                                <asp:ListItem Text="0" Value="0"></asp:ListItem>
                                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                <asp:ListItem Text="11" Value="11"></asp:ListItem>
                            </asp:DropDownList>  
                            <asp:Label ID="lblHeightInches" runat="server" AssociatedControlID="ddlHeightInches">inches</asp:Label>
                        </div>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeHeight" runat="server">
                    Height and weight are used to determine your body mass index (BMI). It can also be used to measure total body fat and whether a person is a healthy weight. Obesity (a problem in which people have too much body fat) has been linked to a higher risk of colorectal cancer.
                </CCRAT:QuestionExplanation>

                <CCRAT:QuestionSeparator ID="qsWeight" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcWeight"
                    QuestionText="How much do you weigh without shoes?"
                    QuestionExpanationID="qeWeight"
                    AnswerUnit="pounds"
                    OnAnswerValidation="qcWeightValidate"                    
                    SkipForDeterminingIfCompleted="true"
                    runat="server">
                        <asp:TextBox ID="txtWeight" onkeyup="onlyDigit2(this)" onkeypress="onlyDigit2(this)" Columns="4" Width="40" MaxLength="5" runat="server" ToolTip="Weight (in pounds)" /> <asp:Label ID="lblWeight" runat="server" AssociatedControlID="txtWeight">pounds</asp:Label>
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeWeight" runat="server">
                    Height and weight are used to determine your body mass index (BMI). It can also be used to measure total body fat and whether a person is a healthy weight. Obesity (a problem in which people have too much body fat) has been linked to a higher risk of colorectal cancer.
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
                    Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
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
                Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.
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
                    In a sigmoidoscopy, your doctor looks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your doctor can remove it using the sigmoidoscope. Then, he or she will send that piece of tissue to the lab for testing.  In a colonoscopy, your doctor looks inside the rectum and entire colon using a long, lighted tube called a <a href="def-colonoscope.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscope</a>. Using a colonoscope, your doctor can remove any polyps he or she sees. The procedure to remove polyps is called a polypectomy.  Having this procedure will reduce your risk of colorectal cancer because polyps that can grow into cancer are removed.
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
                    Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are not cancer, but some can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.
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
                    Studies have shown that aspirin and drugs called NSAIDs can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. (NSAID stands for nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drug.)
                </CCRAT:QuestionExplanation>

	    </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgIbuprofen" 
            runat="server">                
                <CCRAT:QuestionSeparator ID="QuestionSeparator2" runat="server" />                
                <CCRAT:QuestionControl
                    ID="qcIbuprofen"
                    QuestionText="This question asks about some medications that do not contain aspirin.  During the past 30 days, have you taken ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN <em>at least</em> 3 times a week?"
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
                    Studies have shown that aspirin and drugs called NSAIDs can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. (NSAID stands for nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drug.)
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgModerateActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgModerateActivitiesAnswered">
                <CCRAT:QuestionSeparator IsSectionSeparator="true" ID="QuestionSeparator20" runat="server" />
                <CCRAT:QuestionSectionHeader 
                    ID="QuestionSeparator3" 
                    SectionText="The next questions are about moderate and vigorous exercise that you did around the house and for recreation in the last 12 months."
                    runat="server" />
                <CCRAT:QuestionControl
                    ID="qcModerateActivities"
                    QuestionText="Over the past 12 months, in how many months did you do any kind of moderate exercise? If you did NOT do any, write in 0."
                    AdditionalQuestionText="First, think about moderate exercise. Moderate exercise DOES NOT cause you to sweat or breathe hard. <strong>Some examples</strong> include vacuuming, gardening, easy walking for exercise, and so on."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlModerateActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeModerateActivities"
                    runat="server">
                        <asp:DropDownList ID="ddlModerateActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeModerateActivities" runat="server">
                    Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        <CCRAT:QuestionGroup 
            ID="qgModerateHours" 
            runat="server" 
            OnQuestionRedraw="qcModerateHoursRedraw">                
                <CCRAT:QuestionSeparator ID="QuestionSeparator4" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcModerateHours"
                    QuestionText="During those months, on average, about how many hours per week did you do moderate exercise?"
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
                    Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
                </CCRAT:QuestionExplanation>            
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgVigorousActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgVigorousActivitiesAnswered">
                <CCRAT:QuestionSeparator ID="QuestionSeparator5" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcVigorousActivities"
                    QuestionText="Over the past 12 months, in how many months, if any, did you do any kind of vigorous exercise? If you did NOT do any, write in 0."
                    AdditionalQuestionText="Now, think about the vigorous exercise you may have done over the last 12 months. Vigorous exercise includes all activities that DO cause you to sweat or breathe hard. <strong>Some examples</strong> include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlVigorousActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExpanationID="qeVigorousActivities"
                    runat="server">
                        <asp:DropDownList ID="ddlVigorousActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="true" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeVigorousActivities" runat="server">
                    Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
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
                    QuestionText="During those months, on average, about how many hours per week did you do vigorous exercise?"
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
                    Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
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
                    QuestionText="In your entire lifetime, altogether, have you smoked 100 or more <em>cigarettes</em>?"
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
                    Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
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
                    Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
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
                    Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
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
                    AdditionalQuestionText="(If you quit smoking cigarettes completely more than one time, please tell us how old you were the last time you quit smoking completely.)"
                    AssociatedDropDownID="ddlSmokeQuit"
                    QuestionExpanationID="qeSmokeQuit"
                    IsQuestionTextLabelForAssociatedControl="true"
                    runat="server">
                        <asp:DropDownList ID="ddlSmokeQuit" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UpdateQuestions" />
                </CCRAT:QuestionControl>
                <CCRAT:QuestionExplanation ID="qeSmokeQuit" runat="server">
                    Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
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
                    QuestionText="Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked a day?"
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
                    Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                    <br />
                    At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
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
            <%--<CCRAT:QuestionSectionHeader ID="QuestionSectionHeader2" SectionText="ESTROGEN QUESTIONS ARE FOR WOMEN ONLY" runat="server" />--%>
            <CCRAT:QuestionControl
                    ID="qcStillHavePeriods"
                    QuestionText="Do you still have periods?"
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
                    Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
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
                    QuestionText="When did you have your last period?"
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
                    Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
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
                    Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
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
                    SectionText="The next questions ask about your family’s history of colorectal cancer (which is another way to say colon and rectal cancer)."
                    runat="server" />
                <CCRAT:QuestionControl
                    ID="qcHasRelativeHadCC"
                    QuestionText="Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have colorectal cancer (which is another way to say colon and rectal cancer)?"
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
                    If you have close relatives (parents, brothers, sisters, or children) who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
                </CCRAT:QuestionExplanation>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgNumRelativesHavingCC"             
            runat="server"
            OnQuestionRedraw="qgNumRelativesHavingCCRedraw">
                <CCRAT:QuestionSeparator ID="QuestionSeparator16" runat="server" />
                <CCRAT:QuestionControl
                    ID="qcNumRelativesHavingCC"
                    QuestionText="How many of these relatives had colorectal cancer (which is another way to say colon and rectal cancer)?"
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
                    If you have close relatives (parents, brothers, sisters, or children) who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age. If you have many close relatives who have had colorectal cancer, the risk can be even higher.
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