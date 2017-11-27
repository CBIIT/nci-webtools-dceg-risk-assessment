<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="QuestionAsker.ascx.cs" Inherits="CCRAT.Mobile.UserControls.QuestionAsker" %>
<%@ Register Assembly="CCRAT.Mobile" Namespace="CCRAT.Mobile" TagPrefix="CCRAT"%>
<div>
<div id="pc" runat="server" visible="true" class="q-pc" enableviewstate="false">0% Complete</div>
<div id="qs" runat="server">  
    <CCRAT:QuestionGroupManager ID="qgm" runat="server">            
        <CCRAT:QuestionGroup 
            ID="qgHispanic" 
            runat="server">
                <CCRAT:QuestionControl
                    ID="qcHispanic"                     
                    QuestionText="Do you consider yourself to be Hispanic or Latino?"
                    AdditionalQuestionText="<strong>Note:</strong> If yes, this tool cannot calculate an accurate risk for colorectal cancer."
                    AssociatedDropDownID=""
                    IsQuestionTextLabelForAssociatedControl="true"
                    OnAnswerValidation="qcHispanicValidate"
                    ErrorText=""
                    StopOnUnansweredQuestion="true"
                    QuestionExplanationID="qeHispanic" 
                    ExplanationText='At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov.</a>'
                    runat="server">     
                    <div>
                        <asp:RadioButton ID="rdoNonHispanic" GroupName="Race" runat="server" OnCheckedChanged="UpdateQuestions" />
                        <asp:Label ID="lblR" runat="server" AssociatedControlID="rdoNonHispanic"><strong>No/Don't Know - </strong>Continue Risk Calculation</asp:Label>
                        <br />
                    </div>
                    <div>
                        <asp:RadioButton ID="rdoHispanic" GroupName="Race" runat="server" OnCheckedChanged="UpdateQuestions"/>
                        <asp:Label ID="lblR2" runat="server" AssociatedControlID="rdoHispanic"><strong>Yes - </strong>End Risk Calculation</asp:Label>
                    </div>
                </CCRAT:QuestionControl>                                   
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgRace"
            runat="server">            
                <CCRAT:QuestionControl 
                    ID="qcRace" 
                    QuestionText="Which of the following do you consider yourself to be?"
                    AdditionalQuestionText=""
                    AssociatedDropDownID="ddlRace"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ErrorText=""
                    StopOnUnansweredQuestion="true"
                    OnAnswerValidation="qcRaceValidate"
                    QuestionExplanationID="qeRace"
                    ExplanationText='At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov.</a>'
                    runat="server">
                        <asp:DropDownList ID="ddlRace" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="White" Value="White" />
                            <asp:ListItem Text="Black or African-American" Value="Black" />
                            <asp:ListItem Text="Asian" Value="Asian" />
                            <asp:ListItem Text="American Indian or Alaska Native" Value="Indian"  />
                            <asp:ListItem Text="Native Hawaiian or other Pacific Islander" Value="Hawaiian" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>                                                
                </CCRAT:QuestionControl>               
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgCurrentAge" 
            runat="server" 
            OnQuestionGroupAnswered="qgCurrentAgeAnswered">            
                <CCRAT:QuestionControl
                    ID="qcCurrentAge"
                    QuestionText="What is your age?"
                    AdditionalQuestionText="Please note that this tool calculates risk for men and women 50 to 85 years of age."
                    ErrorText="You must specify your age."
                    StopOnUnansweredQuestion="true"
                    AssociatedDropDownID="ddlCurrentAge"
                    IsQuestionTextLabelForAssociatedControl="true"
			        QuestionExplanationID="qeCurrentAge"
			        ExplanationText='Colorectal cancer is more likely to occur as people get older. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.'
                    runat="server">
                        <asp:DropDownList ID="ddlCurrentAge" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NaN" />
                            <asp:ListItem Text="50" Value="50" />
                            <asp:ListItem Text="51" Value="51" />
                            <asp:ListItem Text="52" Value="52" />
                            <asp:ListItem Text="53" Value="53" />
                            <asp:ListItem Text="54" Value="54" />
                            <asp:ListItem Text="55" Value="55" />
                            <asp:ListItem Text="56" Value="56" />
                            <asp:ListItem Text="57" Value="57" />
                            <asp:ListItem Text="58" Value="58" />
                            <asp:ListItem Text="59" Value="59" />
                            <asp:ListItem Text="60" Value="60" />
                            <asp:ListItem Text="61" Value="61" />
                            <asp:ListItem Text="62" Value="62" />
                            <asp:ListItem Text="63" Value="63" />
                            <asp:ListItem Text="64" Value="64" />
                            <asp:ListItem Text="65" Value="65" />
                            <asp:ListItem Text="66" Value="66" />
                            <asp:ListItem Text="67" Value="67" />
                            <asp:ListItem Text="68" Value="68" />
                            <asp:ListItem Text="69" Value="69" />
                            <asp:ListItem Text="70" Value="70" />
                            <asp:ListItem Text="71" Value="71" />
                            <asp:ListItem Text="72" Value="72" />
                            <asp:ListItem Text="73" Value="73" />
                            <asp:ListItem Text="74" Value="74" />
                            <asp:ListItem Text="75" Value="75" />
                            <asp:ListItem Text="76" Value="76" />
                            <asp:ListItem Text="77" Value="77" />
                            <asp:ListItem Text="78" Value="78" />
                            <asp:ListItem Text="79" Value="79" />
                            <asp:ListItem Text="80" Value="80" />
                            <asp:ListItem Text="81" Value="81" />
                            <asp:ListItem Text="82" Value="82" />
                            <asp:ListItem Text="83" Value="83" />
                            <asp:ListItem Text="84" Value="84" />
                            <asp:ListItem Text="85" Value="85" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>

        <CCRAT:QuestionGroup 
            ID="qgGender" 
            OnQuestionGroupAnswered="qgGenderAnswered"
            runat="server">
                <CCRAT:QuestionControl
                    ID="qcGender"
                    QuestionText="Are you male or female?"
                    AssociatedDropDownID="ddlGender"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ErrorText="You must specify your gender."
				    StopOnUnansweredQuestion="true"
			        QuestionExplanationID="qeGender"	
			        ExplanationText='The risk and protective factors that may influence the development colorectal cancer are different for men and women.'		         
                    runat="server">
                        <asp:DropDownList ID="ddlGender" runat="server" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Male" Value="Male" />
                            <asp:ListItem Text="Female" Value="Female" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup
            ID="qgHeight"
            runat="server"
            OnQuestionGroupAnswered="qgHeightAnswered">
                <CCRAT:QuestionControl
                    ID="qcHeight"
                    QuestionText="How tall are you without shoes?"
                    QuestionExplanationID="qeHeight"
                    ExplanationText='Height and weight are used to calculate your body mass index (BMI) and can be used to measure total body fat and whether a person is a healthy weight. Obesity (a condition marked by an abnormally high, unhealthy amount of body fat) has been linked to an increased risk of colorectal cancer.'
                    OnAnswerValidation="qcHeightValidate"
                    AnswerUnit="inches"
                    StopOnUnansweredQuestion="true"
                    runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblHF" runat="server" AssociatedControlID="ddlHF">feet:</asp:Label>                                        
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlHF" runat="server" OnSelectedIndexChanged="UpdateQuestions">
                                        <asp:ListItem Text="Select" Value="NaN"></asp:ListItem>
                                        <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblHI" runat="server" AssociatedControlID="ddlHI">inches:</asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlHI" runat="server" OnSelectedIndexChanged="UpdateQuestions">
                                        <asp:ListItem Text="Select" Value="NaN"></asp:ListItem>
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
                                </td>
                            </tr>
                        </table>
                </CCRAT:QuestionControl>  
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup
            ID="qgWeight"
            runat="server"
            OnQuestionGroupAnswered="qgWeightAnswered">
                <CCRAT:QuestionControl
                    ID="qcWeight"
                    QuestionText="How much do you weigh without shoes?"
                    QuestionExplanationID="qeWeight"
                    ExplanationText='Height and weight are used to calculate your body mass index (BMI) and can be used to measure total body fat and whether a person is a healthy weight. Obesity (a condition marked by an abnormally high, unhealthy amount of body fat) has been linked to an increased risk of colorectal cancer.'
                    OnAnswerValidation="qcWeightValidate"
                    AnswerUnit="lbs"
                    StopOnUnansweredQuestion="true"
                    runat="server">
                        <asp:Label ID="lblWeight" runat="server" AssociatedControlID="txtWeight">Pounds:</asp:Label>
                        <asp:TextBox ID="txtWeight" Columns="4" MaxLength="5" runat="server" OnTextChanged="UpdateQuestions" />
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <%--7.0--%>
        
        <%--<CCRAT:QuestionGroup ID="qgNumServingsVegSH" runat="server">
            <CCRAT:QuestionSectionHeader ID="sh7" runat="server" Visible="true" SectionText="Think about what you ate in the past 30 days. Include meals, snacks, and anything else you ate either at home or away from home (at restaurants, at friends’, take-out, delivery, and so on)." />
            <asp:Button ID="bC1" runat="server" Text="Continue" OnClick="DrawNextQuestion" CssClass="btnC"/>
        </CCRAT:QuestionGroup>--%>
        
        <CCRAT:QuestionGroup 
            ID="qgNumServingsVeg" 
            runat="server"        
            OnQuestionGroupAnswered="qgNumServingsVegAnswered">        
                <CCRAT:QuestionControl
                    ID="qcNumServingsVeg"
                    QuestionText="In the past 30 days, about how many <em>servings</em> per week of vegetables or leafy green salads did you eat?"
                    AdditionalQuestionText="INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads.<br/>DO NOT INCLUDE fried vegetables like French fries or fried potatoes."
                    AssociatedDropDownID="ddlNumServingsVeg"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeNumServingsVeg"
                    ExplanationText='Some, but not all, studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.'
                    runat="server" >
                        <asp:DropDownList ID="ddlNumServingsVeg" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
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
        </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgAmountVeg" 
            runat="server"              
            OnQuestionRedraw="qgAmountVegRedraw">
            <CCRAT:QuestionControl
                ID="qcAmountVeg"
                QuestionText="In the past 30 days, <em>how much</em> did you usually eat in each serving of vegetables or leafy green salads?"
                AssociatedDropDownID="ddlAmountVeg"
                IsQuestionTextLabelForAssociatedControl="true"
                QuestionExplanationID="qeAmountVeg"
                ExplanationText='Some, but not all, studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer.'
                runat="server">
                    <asp:DropDownList ID="ddlAmountVeg" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                        <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                        <asp:ListItem Text="1/2 cup or less" Value=".25" />
                        <asp:ListItem Text="More than 1/2 cup but less than 1 1/2 cups" Value="1" />
                        <asp:ListItem Text="Between 1 1/2 cups and 3 cups" Value="2.25" />
                        <asp:ListItem Text="More than 3 cups but less than 5 cups" Value="4" />
                        <asp:ListItem Text="5 cups or more" Value="6" />
                    </asp:DropDownList>
            </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <%--9.0.0--%>
        <CCRAT:QuestionGroup 
            ID="qgColonoscopy" 
            runat="server" 
            OnQuestionGroupAnswered="qgColonoscopyAnswered">
                <CCRAT:QuestionControl
                    ID="qcColonoscopy"
                    QuestionText='During the past 10 years, did you have a colonoscopy or a sigmoidoscopy?'
                    AdditionalQuestionText="These are medical procedures in which a health care professional inserts a tube into the rectum to look for signs of cancer or other problems."
                    AssociatedDropDownID="ddlColonoscopy"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeColonoscopy"
                    ExplanationText='In a sigmoidoscopy, your healthcare provider checks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your healthcare provider can remove it using the sigmoidoscope. The healthcare provider can send that piece of tissue (biopsy) to the lab for testing. In a colonoscopy, your healthcare provider examines inside the rectum and entire colon using a long, lighted tube called a colonoscope. Using a colonoscope, your healthcare provider can remove polyps that may be found. The procedure to remove polyps is called a polypectomy. Having this procedure will decrease your risk of developing colorectal cancer because polyps, which can be precancerous lesions, are removed.'
                    runat="server">
                        <asp:DropDownList ID="ddlColonoscopy" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgHadPolyp" 
            runat="server" 
            OnQuestionRedraw="qgHadPolypRedraw">        
                <CCRAT:QuestionControl
                    ID="qcHadPolyp"
                    QuestionText="During the past 10 years did a healthcare provider tell you that you had a colon polyp or a rectal polyp?"
                    AssociatedDropDownID="ddlHadPolyp"
                    IsQuestionTextLabelForAssociatedControl="true"
                    AdditionalQuestionText="A polyp is a small growth, like a skin tag, that develops on the inside of the colon or rectum."
                    QuestionExplanationID="qeHadPolyp"
                    ExplanationText='Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are benign (not cancer), but some polyps can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlHadPolyp" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <%--11.0 Medication section--%>
        <%--<CCRAT:QuestionGroup ID="qgAsprinSH" runat="server">
            <CCRAT:QuestionSectionHeader ID="sh11" runat="server" Visible="true" SectionText="People may take medication to treat pain, headache, or arthritis; to relax muscles; or to prevent heart attacks and other diseases." />
            <asp:Button ID="bC11" runat="server" Text="Continue" OnClick="DrawNextQuestion" CssClass="btnC" />
        </CCRAT:QuestionGroup>--%>
        <CCRAT:QuestionGroup 
            ID="qgAsprin" 
            runat="server">
                <CCRAT:QuestionControl
                    ID="qcAsprin"                    
                    QuestionText="This question asks about medications that contain aspirin. During the past 30 days, have you taken aspirin, BUFFERIN, BAYER, or EXCEDRIN <em>at least 3</em> times a week?"
                    AdditionalQuestionText="(Do NOT include TYLENOL.)"
                    AssociatedDropDownID="ddlAsprin"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeAsprin"
                    ExplanationText='Studies have shown that aspirin and nonsteroidal anti-inflammatory drugs (NSAIDs) can lower the risk of colorectal adenomas (noncancerous tumors), and may lower risk of cancerous tumors in the colon and rectum.'
                    runat="server">
                        <asp:DropDownList ID="ddlAsprin" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
	    </CCRAT:QuestionGroup>
    	
        <CCRAT:QuestionGroup 
            ID="qgIbuprofen" 
            runat="server">                
                <CCRAT:QuestionControl
                    ID="qcIbuprofen"
                    QuestionText="This question asks about some medications that do not contain aspirin. During the past 30 days, have you taken ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN <em>at least</em> 3 times a week?"
                    AdditionalQuestionText="(Do NOT include TYLENOL.)"
                    AssociatedDropDownID="ddlIbuprofen"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeIbuprofen"
                    ExplanationText='Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlIbuprofen" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>    
        </CCRAT:QuestionGroup>
        
    	<%--13.0 physical activity section--%>
        <%--<CCRAT:QuestionGroup ID="qgshModerateActivities" runat="server">
            <CCRAT:QuestionSectionHeader ID="sh13" runat="server" Visible="true" SectionText="The next questions are about moderate and vigorous physical activities that you did around the house and those you did for recreation or exercise in the last 12 months." />
            <asp:Button ID="bC13" runat="server" Text="Continue" OnClick="DrawNextQuestion" CssClass="btnC" />
        </CCRAT:QuestionGroup>--%>
        <CCRAT:QuestionGroup 
            ID="qgModerateActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgModerateActivitiesAnswered">
                <CCRAT:QuestionControl
                    ID="qcModerateActivities"
                    QuestionText="Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity? If you did NOT do any, select 0."
                    AdditionalQuestionText="First, think about moderate activities. Moderate activities DO NOT cause you to sweat or breathe hard. <em>Some examples</em> include vacuuming, gardening, easy walking for exercise, and so on."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlModerateActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeModerateActivities"
                    ExplanationText='Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlModerateActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NaN" />
                            <asp:ListItem Text="0" Value="0" />
                            <asp:ListItem Text="1" Value="1" />
                            <asp:ListItem Text="2" Value="2" />
                            <asp:ListItem Text="3" Value="3" />
                            <asp:ListItem Text="4" Value="4" />
                            <asp:ListItem Text="5" Value="5" />
                            <asp:ListItem Text="6" Value="6" />
                            <asp:ListItem Text="7" Value="7" />
                            <asp:ListItem Text="8" Value="8" />
                            <asp:ListItem Text="9" Value="9" />
                            <asp:ListItem Text="10" Value="10" />
                            <asp:ListItem Text="11" Value="11" />
                            <asp:ListItem Text="12" Value="12" />
                            <asp:ListItem Text="13" Value="13" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgModerateHours" 
            runat="server" 
            OnQuestionRedraw="qcModerateHoursRedraw">                
                <CCRAT:QuestionControl
                    ID="qcModerateHours"
                    QuestionText="During those months, on average, about how many hours per week did you do moderate physical activities?"
                    AssociatedDropDownID="ddlModerateHours"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeModerateHours"
                    ExplanationText='Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlModerateHours" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Up to one hour per week" Value="2" />
                            <asp:ListItem Text="Between 1 and 2 hours per week" Value="3" />
                            <asp:ListItem Text="More than 2 but less than 3 hours per week" Value="4" />
                            <asp:ListItem Text="Between 3 and 4 hours per week" Value="5" />
                            <asp:ListItem Text="More than 4 hours per week" Value="6" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>       
        </CCRAT:QuestionGroup>
        
        <%--15.0.0--%>
        <CCRAT:QuestionGroup 
            ID="qgVigorousActivities" 
            runat="server" 
            OnQuestionGroupAnswered="qgVigorousActivitiesAnswered">
                <CCRAT:QuestionControl
                    ID="qcVigorousActivities"
                    QuestionText="Over the past 12 months, in how many months, if any, did you do any kind of vigorous physical activity? If you did NOT do any, select 0."
                    AdditionalQuestionText="Now, think about the vigorous activity you may have done over the last 12 months.<br /><br />Vigorous activities include all activities that DO cause you to sweat or breathe hard. <em>Some examples</em> include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt."
                    ShowAdditionalTextAboveQuestion="true"
                    AssociatedDropDownID="ddlVigorousActivities"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeVigorousActivities"
                    ExplanationText='Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlVigorousActivities" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NaN" />
                            <asp:ListItem Text="0" Value="0" />
                            <asp:ListItem Text="1" Value="1" />
                            <asp:ListItem Text="2" Value="2" />
                            <asp:ListItem Text="3" Value="3" />
                            <asp:ListItem Text="4" Value="4" />
                            <asp:ListItem Text="5" Value="5" />
                            <asp:ListItem Text="6" Value="6" />
                            <asp:ListItem Text="7" Value="7" />
                            <asp:ListItem Text="8" Value="8" />
                            <asp:ListItem Text="9" Value="9" />
                            <asp:ListItem Text="10" Value="10" />
                            <asp:ListItem Text="11" Value="11" />
                            <asp:ListItem Text="12" Value="12" />
                            <asp:ListItem Text="13" Value="13" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>    
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgVigorousHours" 
            runat="server" 
            OnQuestionRedraw="qcVigorousHoursRedraw"
            OnQuestionGroupAnswered="qgVigorousHoursAnswered">
                <CCRAT:QuestionControl
                    ID="qcVigorousHours"
                    QuestionText="During those months, on average, about how many hours per week did you do vigorous physical activities?"
                    AssociatedDropDownID="ddlVigorousHours"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeVigorousHours"
                    ExplanationText='Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.'
                    runat="server">
                        <asp:DropDownList ID="ddlVigorousHours" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Up to one hour per week" Value=".5" />
                            <asp:ListItem Text="Between 1 and 2 hours per week" Value="1.5" />
                            <asp:ListItem Text="More than 2 but less than 3 hours per week" Value="2.5" />
                            <asp:ListItem Text="Between 3 and 4 hours per week" Value="3.5" />
                            <asp:ListItem Text="More than 4 hours per week" Value="5" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <%--17.0.0--%>
        <%-- Male Questions --%>
        <CCRAT:QuestionGroup 
            ID="qg100MoreCigs" 
            runat="server" 
            OnQuestionRedraw="qc100MoreCigsRedraw"
            OnQuestionGroupAnswered="qg100MoreCigsAnswered">
                <CCRAT:QuestionControl
                    ID="qc100MoreCigs"
                    QuestionText="In your entire lifetime, altogether, have you smoked 100 or more <em>cigarettes</em>?"
                    AssociatedDropDownID="ddl100MoreCigs"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qe100MoreCigs"
                    ExplanationText='Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.<br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.'
                    runat="server">
                        <asp:DropDownList ID="ddl100MoreCigs" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgStartSmoke" 
            runat="server" 
            OnQuestionRedraw="qgStartSmokeRedraw"
            OnQuestionGroupAnswered="qgStartSmokeAnswered">
                <CCRAT:QuestionControl
                    ID="qcStartSmoke"
                    QuestionText="How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?"
                    AssociatedDropDownID="ddlStartSmoke"
                    QuestionExplanationID="qeStartSmoke"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ExplanationText='Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.<br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.'
                    runat="server">
                        <asp:DropDownList ID="ddlStartSmoke" runat="server" AutoPostBack="false" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN"></asp:ListItem>
                            <asp:ListItem Text="Never" Value="NeverSmoke"/>
                            <asp:ListItem Text="6" Value="6"/>
                            <asp:ListItem Text="7" Value="7" />
                            <asp:ListItem Text="8" Value="8" />
                            <asp:ListItem Text="9" Value="9" />
                            <asp:ListItem Text="10" Value="10" />
                            <asp:ListItem Text="11" Value="11" />
                            <asp:ListItem Text="12" Value="12" />
                            <asp:ListItem Text="13" Value="13" />
                            <asp:ListItem Text="14" Value="14" />
                            <asp:ListItem Text="15" Value="15" />
                            <asp:ListItem Text="16" Value="16" />
                            <asp:ListItem Text="17" Value="17" />
                            <asp:ListItem Text="18" Value="18" />
                            <asp:ListItem Text="19" Value="19" />
                            <asp:ListItem Text="20" Value="20" />
                            <asp:ListItem Text="21" Value="21" />
                            <asp:ListItem Text="22" Value="22" />
                            <asp:ListItem Text="23" Value="23" />
                            <asp:ListItem Text="24" Value="24" />
                            <asp:ListItem Text="25" Value="25" />
                            <asp:ListItem Text="26" Value="26" />
                            <asp:ListItem Text="27" Value="27" />
                            <asp:ListItem Text="28" Value="28" />
                            <asp:ListItem Text="29" Value="29" />
                            <asp:ListItem Text="30" Value="30" />
                            <asp:ListItem Text="31" Value="31" />
                            <asp:ListItem Text="32" Value="32" />
                            <asp:ListItem Text="33" Value="33" />
                            <asp:ListItem Text="34" Value="34" />
                            <asp:ListItem Text="35" Value="35" />
                            <asp:ListItem Text="36" Value="36" />
                            <asp:ListItem Text="37" Value="37" />
                            <asp:ListItem Text="38" Value="38" />
                            <asp:ListItem Text="39" Value="39" />
                            <asp:ListItem Text="40" Value="40" />
                            <asp:ListItem Text="41" Value="41" />
                            <asp:ListItem Text="42" Value="42" />
                            <asp:ListItem Text="43" Value="43" />
                            <asp:ListItem Text="44" Value="44" />
                            <asp:ListItem Text="45" Value="45" />
                            <asp:ListItem Text="46" Value="46" />
                            <asp:ListItem Text="47" Value="47" />
                            <asp:ListItem Text="48" Value="48" />
                            <asp:ListItem Text="49" Value="49" />
                            <asp:ListItem Text="50" Value="50" />
                            <asp:ListItem Text="51" Value="51" />
                            <asp:ListItem Text="52" Value="52" />
                            <asp:ListItem Text="53" Value="53" />
                            <asp:ListItem Text="54" Value="54" />
                            <asp:ListItem Text="55" Value="55" />
                            <asp:ListItem Text="56" Value="56" />
                            <asp:ListItem Text="57" Value="57" />
                            <asp:ListItem Text="58" Value="58" />
                            <asp:ListItem Text="59" Value="59" />
                            <asp:ListItem Text="60" Value="60" />
                            <asp:ListItem Text="61" Value="61" />
                            <asp:ListItem Text="62" Value="62" />
                            <asp:ListItem Text="63" Value="63" />
                            <asp:ListItem Text="64" Value="64" />
                            <asp:ListItem Text="65" Value="65" />
                            <asp:ListItem Text="66" Value="66" />
                            <asp:ListItem Text="67" Value="67" />
                            <asp:ListItem Text="68" Value="68" />
                            <asp:ListItem Text="69" Value="69" />
                            <asp:ListItem Text="70" Value="70" />
                            <asp:ListItem Text="71" Value="71" />
                            <asp:ListItem Text="72" Value="72" />
                            <asp:ListItem Text="73" Value="73" />
                            <asp:ListItem Text="74" Value="74" />
                            <asp:ListItem Text="75" Value="75" />
                            <asp:ListItem Text="76" Value="76" />
                            <asp:ListItem Text="77" Value="77" />
                            <asp:ListItem Text="78" Value="78" />
                            <asp:ListItem Text="79" Value="79" />
                            <asp:ListItem Text="80" Value="80" />
                            <asp:ListItem Text="81" Value="81" />
                            <asp:ListItem Text="82" Value="82" />
                            <asp:ListItem Text="83" Value="83" />
                            <asp:ListItem Text="84" Value="84" />
                            <asp:ListItem Text="85" Value="85" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgStillSmoke" 
            runat="server" 
            OnQuestionRedraw="qgStillSmokeRedraw"
            OnQuestionGroupAnswered="qgStillSmokeAnswered">                
                <CCRAT:QuestionControl
                    ID="qcStillSmoke"
                    QuestionText="Do you currently smoke cigarettes?"
                    AssociatedDropDownID="ddlStillSmoke"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeStillSmoke"
                    ExplanationText='Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.<br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.'
                    runat="server">
                        <asp:DropDownList ID="ddlStillSmoke" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgSmokeQuit"
		    OnQuestionRedraw="qgSmokeQuitRedraw"		    		    
            runat="server">
                <CCRAT:QuestionControl
                    ID="qcSmokeQuit"
                    QuestionText="How old were you when you quit smoking cigarettes completely?"
                    AdditionalQuestionText="(If you quit smoking cigarettes completely more than one time, please tell us how old you were the last time you quit smoking completely.)"
                    AssociatedDropDownID="ddlSmokeQuit"
                    QuestionExplanationID="qeSmokeQuit"
                    IsQuestionTextLabelForAssociatedControl="true"
                    ExplanationText='Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.<br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.'
                    runat="server">
                        <asp:DropDownList ID="ddlSmokeQuit" runat="server" AutoPostBack="false" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN"></asp:ListItem>
                            <asp:ListItem Text="6" Value="6"/>
                            <asp:ListItem Text="7" Value="7" />
                            <asp:ListItem Text="8" Value="8" />
                            <asp:ListItem Text="9" Value="9" />
                            <asp:ListItem Text="10" Value="10" />
                            <asp:ListItem Text="11" Value="11" />
                            <asp:ListItem Text="12" Value="12" />
                            <asp:ListItem Text="13" Value="13" />
                            <asp:ListItem Text="14" Value="14" />
                            <asp:ListItem Text="15" Value="15" />
                            <asp:ListItem Text="16" Value="16" />
                            <asp:ListItem Text="17" Value="17" />
                            <asp:ListItem Text="18" Value="18" />
                            <asp:ListItem Text="19" Value="19" />
                            <asp:ListItem Text="20" Value="20" />
                            <asp:ListItem Text="21" Value="21" />
                            <asp:ListItem Text="22" Value="22" />
                            <asp:ListItem Text="23" Value="23" />
                            <asp:ListItem Text="24" Value="24" />
                            <asp:ListItem Text="25" Value="25" />
                            <asp:ListItem Text="26" Value="26" />
                            <asp:ListItem Text="27" Value="27" />
                            <asp:ListItem Text="28" Value="28" />
                            <asp:ListItem Text="29" Value="29" />
                            <asp:ListItem Text="30" Value="30" />
                            <asp:ListItem Text="31" Value="31" />
                            <asp:ListItem Text="32" Value="32" />
                            <asp:ListItem Text="33" Value="33" />
                            <asp:ListItem Text="34" Value="34" />
                            <asp:ListItem Text="35" Value="35" />
                            <asp:ListItem Text="36" Value="36" />
                            <asp:ListItem Text="37" Value="37" />
                            <asp:ListItem Text="38" Value="38" />
                            <asp:ListItem Text="39" Value="39" />
                            <asp:ListItem Text="40" Value="40" />
                            <asp:ListItem Text="41" Value="41" />
                            <asp:ListItem Text="42" Value="42" />
                            <asp:ListItem Text="43" Value="43" />
                            <asp:ListItem Text="44" Value="44" />
                            <asp:ListItem Text="45" Value="45" />
                            <asp:ListItem Text="46" Value="46" />
                            <asp:ListItem Text="47" Value="47" />
                            <asp:ListItem Text="48" Value="48" />
                            <asp:ListItem Text="49" Value="49" />
                            <asp:ListItem Text="50" Value="50" />
                            <asp:ListItem Text="51" Value="51" />
                            <asp:ListItem Text="52" Value="52" />
                            <asp:ListItem Text="53" Value="53" />
                            <asp:ListItem Text="54" Value="54" />
                            <asp:ListItem Text="55" Value="55" />
                            <asp:ListItem Text="56" Value="56" />
                            <asp:ListItem Text="57" Value="57" />
                            <asp:ListItem Text="58" Value="58" />
                            <asp:ListItem Text="59" Value="59" />
                            <asp:ListItem Text="60" Value="60" />
                            <asp:ListItem Text="61" Value="61" />
                            <asp:ListItem Text="62" Value="62" />
                            <asp:ListItem Text="63" Value="63" />
                            <asp:ListItem Text="64" Value="64" />
                            <asp:ListItem Text="65" Value="65" />
                            <asp:ListItem Text="66" Value="66" />
                            <asp:ListItem Text="67" Value="67" />
                            <asp:ListItem Text="68" Value="68" />
                            <asp:ListItem Text="69" Value="69" />
                            <asp:ListItem Text="70" Value="70" />
                            <asp:ListItem Text="71" Value="71" />
                            <asp:ListItem Text="72" Value="72" />
                            <asp:ListItem Text="73" Value="73" />
                            <asp:ListItem Text="74" Value="74" />
                            <asp:ListItem Text="75" Value="75" />
                            <asp:ListItem Text="76" Value="76" />
                            <asp:ListItem Text="77" Value="77" />
                            <asp:ListItem Text="78" Value="78" />
                            <asp:ListItem Text="79" Value="79" />
                            <asp:ListItem Text="80" Value="80" />
                            <asp:ListItem Text="81" Value="81" />
                            <asp:ListItem Text="82" Value="82" />
                            <asp:ListItem Text="83" Value="83" />
                            <asp:ListItem Text="84" Value="84" />
                            <asp:ListItem Text="85" Value="85" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
                
        <CCRAT:QuestionGroup 
            ID="qgCigNumPerDay" 
            runat="server"
		    OnQuestionRedraw="qgCigNumPerDayRedraw"
            OnQuestionGroupAnswered="qgCigNumPerDayAnswered">        
                <CCRAT:QuestionControl
                    ID="qcCigNumPerDay"
                    QuestionText="Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked a day?"
                    AssociatedDropDownID="ddlCigNumPerDay"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeCigNumPerDay"
                    ExplanationText='Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer.<br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.'
                    runat="server">
                        <asp:DropDownList ID="ddlCigNumPerDay" runat="server" AutoPostBack="false" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="1 to 10 cigarettes a day" Value="1To10" />
                            <asp:ListItem Text="11 to 20 cigarettes a day" Value="11To20" />
                            <asp:ListItem Text="More than 20 cigarettes a day" Value="GT20" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        <%-- End Male Questions --%>

        <%-- Female Questions --%>
        <%--22.0.0--%>
        <CCRAT:QuestionGroup 
            ID="qgStillHavePeriods" 
            runat="server" 
            OnQuestionRedraw="qgStillHavePeriodsRedraw"
            OnQuestionGroupAnswered="qgStillHavePeriodsAnswered">
                <%--<CCRAT:QuestionSeparator IsSectionSeparator="true" ID="qs12" runat="server" />        --%>
                <CCRAT:QuestionControl
                    ID="qcStillHavePeriods"
                    QuestionText="Do you still have periods or menstrual cycles?"
                    AssociatedDropDownID="ddlStillHavePeriods"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeStillHavePeriods"
                    ExplanationText='Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used hormone replacement therapy (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.'
                    runat="server">
                        <asp:DropDownList ID="ddlStillHavePeriods" runat="server" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgLastCycle" 
            runat="server" 
            OnQuestionRedraw="qgLastCycleRedraw"
            OnQuestionGroupAnswered="qgLastCycleAnswered">
                <CCRAT:QuestionControl
                    ID="qcLastCycle"
                    QuestionText="When did you have your last period or menstrual cycle?"
                    AssociatedDropDownID="ddlLastCycle"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeLastCycle"
                    ExplanationText='Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used hormone replacement therapy (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.'
                    runat="server">
                        <asp:DropDownList ID="ddlLastCycle" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false" runat="server">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="1 year ago or less" Value="LT1" />
                            <asp:ListItem Text="More than 1 year ago but less than 2 years ago" Value="GT1LT2" />
                            <asp:ListItem Text="2 years ago or more" Value="GT2" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgUsedEstrogen" 
            runat="server"
            OnQuestionRedraw="qgUsedEstrogenRedraw">
                <CCRAT:QuestionControl
                    ID="qcUsedEstrogen"
                    QuestionText="During the past 2 years, have you used estrogen, progestin, or other female hormones?"
                    AdditionalQuestionText="These hormones may be given as hormone pills, oral contraceptives, shots, skin patches, vaginal creams, or as vaginal suppositories."
                    AssociatedDropDownID="ddlUsedEstrogen"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeUsedEstrogen"
                    ExplanationText='Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used hormone replacement therapy (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.'
                    runat="server">
                        <asp:DropDownList ID="ddlUsedEstrogen" OnSelectedIndexChanged="UpdateQuestions" AutoPostBack="false" runat="server">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
          
        </CCRAT:QuestionGroup>
        <%-- End female Questions --%>

        <%--25.0.0 Family History Section--%>
        <%--<CCRAT:QuestionGroup ID="qgHasRelativeHadCCSH" runat="server">
            <CCRAT:QuestionSectionHeader ID="shHasRelativeHadCC" runat="server" Visible="true" SectionText="The next questions ask about your family’s history with cancer of the color or rectum (sometimes called cancer of the lower intestine)." />
            <asp:Button ID="bC25" runat="server" Text="Continue" OnClick="DrawNextQuestion" CssClass="btnC" />
        </CCRAT:QuestionGroup>--%>
        <CCRAT:QuestionGroup 
            ID="qgHasRelativeHadCC"
            OnQuestionGroupAnswered="qgHasRelativeHadCCAnswered" 
            runat="server">
                <CCRAT:QuestionControl
                    ID="qcHasRelativeHadCC"
                    QuestionText="Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters. At any time in their lives, did any of these relatives ever have cancer of the colon or rectum (cancer of the lower intestine)?"
                    AssociatedDropDownID="ddlHasRelativeHadCC"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeHasRelativeHadCC"
                    ExplanationText='Close relatives (parents, brothers, sisters, or children) of a person with a history of colorectal cancer are somewhat more likely to develop this disease themselves, especially if the relative had the cancer at a young age. If many close relatives have a history of colorectal cancer, the risk can be even greater.'
                    runat="server">
                        <asp:DropDownList ID="ddlHasRelativeHadCC" runat="server" AutoPostBack="false" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="Yes" Value="Yes" />
                            <asp:ListItem Text="No" Value="No" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>        
        </CCRAT:QuestionGroup>
        
        <CCRAT:QuestionGroup 
            ID="qgNumRelativesHavingCC"             
            runat="server"
            OnQuestionGroupAnswered="qgNumRelativesHavingCCAnswered"
            OnQuestionRedraw="qgNumRelativesHavingCCRedraw">
                <CCRAT:QuestionControl
                    ID="qcNumRelativesHavingCC"
                    QuestionText="How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?"
                    AssociatedDropDownID="ddlNumRelativesHavingCC"
                    IsQuestionTextLabelForAssociatedControl="true"
                    QuestionExplanationID="qeNumRelativesHavingCC"
                    ExplanationText='Close relatives (parents, brothers, sisters, or children) of a person with a history of colorectal cancer are somewhat more likely to develop this disease themselves, especially if the relative had the cancer at a young age. If many close relatives have a history of colorectal cancer, the risk can be even greater.'
                    runat="server">
                        <asp:DropDownList ID="ddlNumRelativesHavingCC" runat="server" AutoPostBack="false" OnSelectedIndexChanged="UpdateQuestions">
                            <asp:ListItem Text="Select" Value="NAN" Selected="True" />
                            <asp:ListItem Text="One" Value="One" />
                            <asp:ListItem Text="Two or more" Value="TwoPlus" />
                            <asp:ListItem Text="I don't know" Value="DontKnow" />
                        </asp:DropDownList>
                </CCRAT:QuestionControl>
        </CCRAT:QuestionGroup>
        
        
        <div id="divQex" runat="server" visible="true" enableviewstate="false">
            <asp:PlaceHolder ID="phCalc" runat="server">                
                <asp:Button ID="btnN" CssClass="btn" Text="Next" runat="server" OnClick="btnNext_Click"/>
                <br />
            </asp:PlaceHolder>            
            <div><asp:Button ID="btnEx" runat="server" border="0" Text="Explanation" OnClick="ExplanationLink_Click" CssClass="btnL"/></div>
            <asp:PlaceHolder ID="phExplanation" runat="server" Visible="false">                                
                <div class="h"><asp:Button ID="btnBack" runat="server" Text="&lt; Back" OnClick="RedrawCurrentQuestion" CssClass="btnL"/></div>
                <div class="h" runat="server" id="pExplnation">Explanation is empty</div>
                <div><asp:Button ID="btnBack2" runat="server" Text="&lt; Back" OnClick="RedrawCurrentQuestion" CssClass="btnL"/></div>
            </asp:PlaceHolder>           
            <asp:HyperLink ID="lnkNewCalculation" NavigateUrl="~/Default.aspx" Text="New Risk Calculation" runat="server"></asp:HyperLink>
        </div>                  
    </CCRAT:QuestionGroupManager>       
    <%--<p id="pQRqrd" runat="server" style="color: #a90101;" visible="false"></p>--%>
</div>

<div id="res" runat="server" visible="false" EnableViewState="false">
    <asp:PlaceHolder ID="phResults" runat="server">
        <div class="h3">Results</div>        
        <div class="r">
            <span class="h4">Race/Ethnicity:&nbsp;&nbsp;</span>Non-Hispanic white
            <br />
            <span class="h4">Gender:&nbsp;&nbsp;</span><span id="gender" runat="server" />
            <br />
            <span class="h4">Age:&nbsp;&nbsp;</span><span id="age" runat="server" />
        </div>     
                   
        <div id="ph5" runat="server" class="r">
            <span class="h4">5 Year Risk:&nbsp;&nbsp;</span><span id="s5" runat="server" />
            <br />
            <asp:Button ID="btnExp5" runat="server" Text="Explanation" OnCommand="exRes_Click" CommandName="ex5" CssClass="btnL" />
        </div>        
       
        <div id="ph10" runat="server" class="r">
            <span class="h4">10 Year Risk:&nbsp;&nbsp;</span><span id="s10" runat="server" />
            <br />
            <asp:Button ID="btnExp10" runat="server" Text="Explanation" OnCommand="exRes_Click" CommandName="ex10" CssClass="btnL" />
        </div>
        
        <div id="phLT" runat="server" class="r">
            <span class="h4">Lifetime Risk:&nbsp;&nbsp;</span><span id="sLT" runat="server" />
            <br />
            <asp:Button ID="btnExpLT" runat="server" Text="Explanation" OnCommand="exRes_Click" CommandName="exL" CssClass="btnL" />
        </div>
        
        <div>
            <p>
                <strong>Reminder:</strong> The Colorectal Cancer Risk Assessment Tool was designed
                for use by health professionals and their patients. If you are not a health professional,
                you are encouraged to discuss these results and your personal risk of colorectal
                cancer with your healthcare provider. The results are calculated based on data from
                non-Hispanic white men and women ages 50 to 85+.
            </p>
            <p>
                <a href="a-e.aspx">About the Tool: Explaining the Results</a>
            </p>
            <p>
                <input type="hidden" id="restart" name="restart" value="true" runat="server"/>
                <a href="q.aspx?restart=true">New Risk Calculation</a>
            </p>
        </div>
        
        <%--place holder for displaying error messages if any--%>
        <asp:PlaceHolder ID="phErrorMsg" runat="server" Visible="false" EnableViewState="false">
            <div>
                <h4 style="display: inline; color: red;">Error Message:&nbsp;&nbsp;<span id="errorMsg" runat="server" /></h4>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phTestVars" runat="server" EnableViewState="false">
            <div id="divCalVars" style="border: 1px solid black; padding: 5px 5px 5px 5px; margin: 0 0 10px 16px;"
                runat="server" visible="false">
                <h4>
                    Calculation Vars</h4>
                <asp:Literal ID="litTestVars" runat="server" />
            </div>
        </asp:PlaceHolder>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phResultEx" runat="server" Visible="false" EnableViewState="false">
        <div class="h">
            <asp:Button ID="btnBack3" runat="server" Text="&lt; Back" OnClick="RedrawResults" CssClass="btnL" />
        </div>
        <div class="h" runat="server" id="pExp">Explanation is empty</div>
        <div>
            <asp:Button ID="btnBack4" runat="server" Text="&lt; Back" OnClick="RedrawResults" CssClass="btnL" />
        </div>
    </asp:PlaceHolder>
</div>
</div>