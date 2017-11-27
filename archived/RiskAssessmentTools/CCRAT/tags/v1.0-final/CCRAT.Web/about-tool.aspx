<%@ Page Language="C#" MasterPageFile="CCRAT.master"  AutoEventWireup="true" CodeBehind="about-tool.aspx.cs" Inherits="CCRAT.Web.about_tool" %>
<%@ Register Assembly="CCRAT.Web" Namespace="CCRAT" TagPrefix="CCRAT" %>
<%@ Register Src="~/UserControls/PageOptions.ascx" TagName="PageOptions" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="cphPageOptions" ID="cntPageOptions" runat="server">
    <uc2:PageOptions ID="PageOptions1" EmailTitle="Colorectal Cancer Risk Assessment Tool"
        runat="server" />
</asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleLeft" ID="cBoxTitleLeft" runat="server"><img src="images/title-about-the-tool.gif" width="135" height="18" alt="About the Tool" /></asp:Content>
<asp:Content ContentPlaceHolderID="cphBoxTitleRight" ID="cBoxTitleRight" runat="server"><asp:HyperLink ID="lnlNewCal" NavigateUrl="~/default.aspx" runat="server">New Risk Calculation</asp:HyperLink></asp:Content>
<asp:Content ContentPlaceHolderID="cphContentAnchors" ID="cContentAnchors" runat="server">
    <div class="content-anchors">
	    <ul>
		    <li><a href="#eq">Explaining the Questions</a>   |  </li>
 		    <li><a href="#explaining">About the Results</a>   |  </li> 
 		    <li><a href="#model">About the Model</a>   |  </li>
 		    <li><a href="#references">References</a></li></ul>
     </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphMain" runat="server">
<div class="maincontentboxtext-paddedText">
    <a name="eq"></a>
    <div class="questionExplanations">
        <h2>Explaining the Questions</h2>

        <CCRAT:AboutExplanation ID="AboutExplanation1" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">Do you consider yourself to be Hispanic or Latino?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Which of the following do you consider yourself to be?  (White; Black or African-American; Asian; American Indian or Alaska Native, Native Hawaiian or other Pacific Islander; Other)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.    
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation2" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">What is your age? (Please note that this tool only calculates risk for men and women ages 50 to 85.)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Colorectal cancer is more likely to occur as people get older. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.                    
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="ae1" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">Are you male or female?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                The risk and protective factors that may influence the development of colorectal cancer are different for men and women.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation4" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">How tall are you without shoes?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How much do you weigh without shoes?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Height and weight are used to calculate your body mass index (BMI) and can be used to measure total body fat and whether a person is a healthy weight. Obesity (a condition marked by an abnormally high, unhealthy amount of body fat) has been linked to an increased risk of colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation7" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">In the past 30 days, about how many <strong>servings per week</strong> of vegetables or leafy green salads did you eat?  INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads. DO NOT INCLUDE fried vegetables like French fries or fried potatoes.</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">In the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Some, but not all, studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer. 
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation8" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">During the past 10 years, did you have a <a href="def-colonoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscopy</a> or a <a href="def-sigmoidoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">sigmoidoscopy</a>?(These are medical procedures in which a healthcare professional inserts a tube into the rectum to look for signs of cancer or other problems.)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                In a sigmoidoscopy, your healthcare provider checks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your healthcare provider can remove it using the sigmoidoscope. The healthcare provider can send that piece of tissue (<a href="def-biopsy.aspx" onclick="popUp(event);return false;" class="grey-text">biopsy</a>) to the lab for testing.  In a colonoscopy, your healthcare provider examines inside the rectum and entire colon using a long, lighted tube called a <a href="def-colonoscope.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscope</a>. Using a colonoscope, your healthcare provider can remove polyps that may be found. The procedure to remove polyps is called a polypectomy.  Having this procedure will decrease your risk of developing colorectal cancer because polyps, which can be precancerous lesions, are removed.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation9" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">During the past 10 years did a healthcare provider tell you that you had a colon polyp or a rectal polyp?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are benign (not cancer), but some polyps can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation10" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">This question asks about medications that contain aspirin.  During the past 30 days, have you taken aspirin, BUFFERIN, BAYER, or EXCEDRIN at least 3 times a week?  (Do NOT include TYLENOL)</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">This question asks about some medications that do not contain aspirin.  During the past 30 days, have you taken ADVIL, ALEVE, CELEBREX, ibuprofen, MOTRIN, naproxen, or NUPRIN at least 3 times a week?  (Do NOT include TYLENOL)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies have shown that aspirin and nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drugs (NSAIDs) can lower the risk of colorectal adenomas (noncancerous tumors), and may lower risk of cancerous tumors in the colon and rectum.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation11" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">Over the past 12 months, in how many months, if any, did you do any kind of moderate physical activity?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During those months, on average, about how many hours per week did you do moderate physical activities?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Over the past 12 months, in how many months, if any, did you do any kind of vigorous physical activity?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During those months, on average, about how many hours per week did you do vigorous physical activities?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Evidence suggests that an inactive lifestyle may be associated with an increased risk of colorectal cancer. In contrast, people who exercise regularly may have a decreased risk of developing colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation12" runat="server" OverrideQuestionHeading="Questions for males:">
            <Questions>
                <CCRAT:AEQuestion runat="server">In your entire lifetime, altogether, have you smoked 100 or more cigarettes?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Do you currently smoke cigarettes?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How old were you when you quit smoking cigarettes completely?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked a day?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies suggest that a person who is a current or former smoker of cigarettes may be at increased risk of developing polyps and colorectal cancer. 
                <br />In the case-control data that were used to build the absolute risk prediction model, smoking did not influence risk of colorectal cancer among women and was thus not included in the questionnaire for women. As more data become available that may change.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation13" runat="server" OverrideQuestionHeading="Questions for females:">
            <Questions>
                <CCRAT:AEQuestion runat="server">Do you still have periods or menstrual cycles?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">When did you have your last period or menstrual cycle?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During the past 2 years, have you used estrogen, progestin, or other female hormones?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies indicate that women who still have their menstrual periods, stopped having their menstrual periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for developing colorectal cancer than other women.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation14" runat="server" HideSeparator="true">
            <Questions>
                <CCRAT:AEQuestion runat="server">Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have cancer of the colon or rectum (cancer of the lower intestine)?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How many of these relatives had cancer of the colon or rectum (cancer of the lower intestine)?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Close relatives (parents, brothers, sisters, or children) of a person with a history of colorectal cancer are somewhat more likely to develop this disease themselves, especially if the relative had the cancer at a young age.   If many close relatives have a history of colorectal cancer, the risk can be even greater.
            </Explanation>
        </CCRAT:AboutExplanation>                   
    </div>
    
    <p style="margin-top: 16px;"><a href="#top">Back to Top</a></p>
    
    <a name="explaining"></a>
    <h2>About the Results</h2>
    <p>The Colorectal Cancer Risk Assessment Tool estimates the risk of developing colorectal cancer for non-Hispanic white men and women ages 50 to 85 during the next 5-year and 10-year period up to age 90 (lifetime risk) based on the risk and protective factor information provided. Risk estimates increase with age because the risk of developing colorectal cancer increases with age.
    </p>
    <p>Risk estimates calculated by the tool are estimates of absolute colorectal cancer risk. Absolute colorectal cancer risk is the probability of developing colorectal cancer in a defined age interval. One way to evaluate the accuracy of the risk estimate is to determine whether it correctly predicts average risk in non-Hispanic white men and women with the same risk factors and age. The Colorectal Cancer Risk Assessment Tool predicts such average risk well.
    </p>
    <p>At this time the risk calculations and results provided by this tool are only accurate for non-Hispanic white men and women ages 50 to 85. Researchers are in the process of updating the tool to produce accurate results for men and women of other races and ethnicities. Information to help you understand cancer risk, including colorectal cancer risk, is available at <a href="http://understandingrisk.cancer.gov">http://understandingrisk.cancer.gov</a>.
    </p>
    <p>While risk may be accurately estimated for non-Hispanic white men and women ages 50 to 85, these predictions do not allow one to say precisely <i>which</i> people will develop colorectal cancer. The tool is designed to help patients and their healthcare providers make informed choices about when and how screening should take place.
    </p>
    <p><a href="#top">Back to Top</a></p>

    <a name="model"></a>
    <h2>About the Model</h2>
    <p>
    The Colorectal Cancer Risk Assessment Tool is based on the first absolute risk model for colorectal cancer.  The model was developed using data from two large U.S. population-based case-control studies of colon and rectal cancer, cancer incidence data from 13 NCI <a href="http://seer.cancer.gov/">Surveillance, Epidemiology, and End Results (SEER)</a> registries, and from national mortality rates.  The Colorectal Cancer Risk Assessment Tool uses the respondent’s answers about risk and preventive factors to calculate that person’s absolute risk for developing colorectal cancer for a specific time period. 
    </p>
    <p>The model was tested in a large population and has been shown to be accurate in predicting absolute risk. Because the majority of participants in the case-control studies were non-Hispanic white males and females, relative risks for other racial or ethnic groups could not be estimated.  Researchers are in the process of updating the tool by using SEER rates for minority populations to allow the tool to produce more accurate results for men and women in these populations.
    </p>
    <p>The risk calculator will be updated periodically as new data or research become available. In addition, the tool may prove useful to researchers who are designing research intervention studies.
    </p>
    <p><a href="#top">Back to Top</a></p>

    <a name="references"></a>
    <h2>References</h2>
    <ol>
        <li>Freedman AN, Slattery ML, Ballard-Barbash R, Willis G, Cann B, Pee D, Gail MH, Pfeiffer RM. A colorectal cancer risk prediction tool for white men and women without known susceptibility.  J Clin Oncol [In press].</li>
        <li>Park Y, Freedman AN, Gail MH, Pee D, Hollenbeck A, Schatzkin A, Pfeiffer RM. Validation of a colorectal cancer risk prediction model among whites 50 years old and over. J Clin Oncol [In press].</li>
    </ol>
    <p><a href="#top">Back to Top</a></p>
</div>
</asp:Content>
