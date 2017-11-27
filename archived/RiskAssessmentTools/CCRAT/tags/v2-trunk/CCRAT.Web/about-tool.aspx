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
 		    <li><a href="#explaining">Explaining the Results</a>   |  </li> 
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
                <CCRAT:AEQuestion runat="server">Do you consider yourself to be Hispanic/Latino?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Which of the following do you consider yourself to be?  (African-American; Asian American/Pacific Islander; White)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                <p>When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer.  If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.</p>
                <p>In the future, we hope to make this tool more accurate for African Americans, Asian Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for these groups.</p>
                <p>This tool does not yet apply to American Indians and Alaska Natives, but we are working to improve the tool for use by these groups of people.</p>
                <p>This Web site can help you learn more about cancer risk, including colorectal cancer risk: <a href="http://understandingrisk.cancer.gov">Understanding the Puzzle</a> from NCI</p>
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation2" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">What is your age? (Keep in mind that this tool only estimates risk for people from 50 to 85 years old.)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                As you get older, your risk of colorectal cancer gets higher. More than 90 percent of people with this disease are diagnosed after age 50. The average age at diagnosis is 72.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="ae1" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">Are you male or female?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                The factors that can protect you from colorectal cancer or cause you to be at higher risk  are different for men and women.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation4" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">How tall are you without shoes?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How much do you weigh without shoes?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Height and weight are used to determine your body mass index (BMI). It can also be used to measure total body fat and whether a person is a healthy weight. Obesity (a problem in which people have too much body fat) has been linked to a higher risk of colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation7" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server"><strong>In the past 30 days, about how many <u>servings per week</u> of vegetables or leafy green salads did you eat?</strong> INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads. DO NOT INCLUDE fried vegetables like French fries or fried potatoes.</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">In the past 30 days, how much did you usually eat in each serving of vegetables or leafy green salads?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Some studies suggest that people who eat a diet very low in vegetables may have a higher risk of colorectal cancer. 
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation8" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">During the past 10 years, did you have a <a href="def-colonoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscopy</a> or a <a href="def-sigmoidoscopy.aspx" onclick="popUp(event);return false;" class="grey-text">sigmoidoscopy</a>?(These are medical procedures in which your doctor inserts a tube into the rectum to look for signs of cancer or other problems.)</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                In a sigmoidoscopy, your doctor looks inside your rectum and the lower part of the colon with a lighted tube called a sigmoidoscope. If anything unusual is in the rectum or colon, like a small polyp or inflamed tissue, your doctor can remove it using the sigmoidoscope. Then, he or she will send that piece of tissue to the lab for testing.  In a colonoscopy, your doctor looks inside the rectum and entire colon using a long, lighted tube called a <a href="def-colonoscope.aspx" onclick="popUp(event);return false;" class="grey-text">colonoscope</a>. Using a colonoscope, your doctor can remove any polyps he or she sees. The procedure to remove polyps is called a polypectomy.  Having this procedure will reduce your risk of colorectal cancer because polyps that can grow into cancer are removed.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation9" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">During the past 10 years did a doctor tell you that you had a polyp in your colon or rectum?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Polyps are growths on the inner wall of the colon or rectum. They are common in people over age 50. Most polyps are not cancer, but some can become cancer. Finding and removing polyps may reduce the risk of colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation10" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">This question asks about medications that contain aspirin. During the past 30 days, have you taken aspirin, BUFFERIN, BAYER, or EXCEDRIN <u>at least</u> 3 times a week?  (Do NOT include TYLENOL)</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">This question asks about some medications that do not contain aspirin. During the past 30 days, have you taken ADVIL, ALEVE, CELEBREX, IBUPROFEN, MOTRIN, NAPROXEN, or NUPRIN <u>at least</u> 3 times a week?  Do NOT include TYLENOL.</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies have shown that aspirin and drugs called NSAIDs can lower the risk of colorectal adenomas (tumors that are not cancer), and may lower the risk of colorectal cancer. (NSAID stands for nonsteroidal <a href="def-anti-inflammatory.aspx" onclick="popUp(event);return false;" class="grey-text">anti-inflammatory</a> drug.)
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation11" runat="server">
            <Questions>
                <CCRAT:AEQuestion runat="server">Over the past 12 months, in how many months, if any, did you do any kind of moderate exerices?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During those months, on average, about how many hours per week did you do moderate exercise?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Over the past 12 months, in how many months, if any, did you do any kind of vigorous exercise?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During those months, on average, about how many hours per week did you do vigorous exercise?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies suggest that not being active may increase your risk of colorectal cancer. On the other hand, if you exercise often, you may reduce your risk of colorectal cancer.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation12" runat="server" OverrideQuestionHeading="Questions for males:">
            <Questions>
                <CCRAT:AEQuestion runat="server">In your entire lifetime, altogether, have you smoked 100 or more <u>cigarettes</u>?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How old were you when you started smoking cigarettes on a regular basis, that is, at least one cigarette a day for six months or longer?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Do you currently smoke cigarettes?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How old were you when you quit smoking cigarettes completely?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">Thinking back over the years you have smoked regularly, about how many cigarettes have you usually smoked a day?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies suggest that men who are current or former smokers of cigarettes may be at increased risk for polyps and colorectal cancer. 
                <br />
                At this time, studies show that smoking does not increase risk of colorectal cancer among women. As time goes on and other studies are completed, that may change.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation13" runat="server" OverrideQuestionHeading="Questions for females:">
            <Questions>
                <CCRAT:AEQuestion runat="server">Do you still have periods?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">When did you have your last period?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">During the past 2 years, have you used estrogen, progestin, or other female hormones?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                Studies show that women who still have periods, stopped having their periods in the past 2 years, or have used <a href="def-HRT.aspx" onclick="popUp(event);return false;" class="grey-text">hormone replacement therapy</a> (HRT) in the past 2 years may be at lower risk for colorectal cancer than other women.
            </Explanation>
        </CCRAT:AboutExplanation>

        <CCRAT:AboutExplanation ID="AboutExplanation14" runat="server" HideSeparator="true">
            <Questions>
                <CCRAT:AEQuestion runat="server">Think only about your biological mother and father, full brothers and sisters, and your biological sons or daughters.  At any time in their lives, did any of these relatives ever have colorectal cancer (which is another way to say colon or rectal cancer)?</CCRAT:AEQuestion>
                <CCRAT:AEQuestion runat="server">How many of these relatives had colorectal cancer (which is another way to say colon or rectal cancer)?</CCRAT:AEQuestion>
            </Questions>
            <Explanation>
                If you have close relatives (parents, brothers, sisters, or children) who have had colorectal cancer, your risk of colorectcal cancer is slightly higher. This is more true if the relative had the cancer at a young age.   If you have many close relatives who have had colorectal cancer, the risk can be even higher.
            </Explanation>
        </CCRAT:AboutExplanation>                   
    </div>
    
    <p style="margin-top: 16px;"><a href="#top">Back to Top</a></p>
    
    <a name="explaining"></a>
    <h2>Explaining the Results</h2>
    <p>
        The Colorectal Cancer Risk Assessment Tool estimates your risk of colorectal cancer during the next 5 and 10 years (up to age 90) if you are:
        <ul class="red-arrow">
            <li>50 to 85 years old</li>
            <li>African American</li>
            <li>Asian American/Pacific Islander</li>
            <li>Hispanic/Latino</li>
            <li>White</li>
        </ul>
    </p>
    <p>This tool uses the answers you provided to the questions to estimate your risk of colorectal cancer.</p>
    <p>This tool provides estimates on absolute colorectal cancer risk. Absolute colorectal cancer risk refers to the chance that you will develop colorectal cancer during a certain number of years.</p>
    <p>When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer.  If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.</p>
    <p>In the future, we hope to make this tool more accurate for African Americans, Asian Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for these groups.</p>
    <p>This tool does not yet apply to American Indians and Alaska Natives, but we are working to improve the tool for use in these groups of people.</p>
    <p>This Web site can help you learn more about cancer risk, including colorectal cancer risk: <a href="http://understandingrisk.cancer.gov">Cancer Risk: Understanding the Puzzle from NCI</a></p>
    <p><a href="#top">Back to Top</a></p>

    <a name="model"></a>
    <h2>About the Model</h2>
    <p>The Colorectal Cancer Risk Assessment Tool is based on the first absolute risk model for colorectal cancer. The model was developed using data from two large U.S. population-based case-control studies of colon and rectal cancer, cancer incidence data from 13 <a href="http://seer.cancer.gov/">NCI Surveillance, Epidemiology, and End Results (SEER)</a> registries, and from national mortality rates.  The Colorectal Cancer Risk Assessment Tool uses the respondent’s answers about risk and preventive factors to calculate that person’s absolute risk of colorectal cancer for a specific time period.</p>
    <p>The model was tested in a large population and has been shown to be accurate in predicting absolute risk. Because the majority of participants in the case-control studies were non-Hispanic white males and females, relative risks for other racial or ethnic groups could not be estimated.  Researchers have since updated the tool using SEER rates for African American, Asian American/Pacific Islander, and Hispanic/Latino populations to enable the tool to be applicable for men and women in these populations.  As more data becomes available on the African American, Asian American/Pacific Islander, and Hispanic/Latino populations, researchers will be able to test and validate the tool for these populations.</p>
    <p>The risk calculator will be updated periodically as new data or research become available. In addition, the tool may prove useful to researchers who are designing research intervention studies.</p>
    <p><a href="#top">Back to Top</a></p>

    <a name="references"></a>
    <h2>References</h2>
    <ol>
        <li>Freedman AN, Slattery ML, Ballard-Barbash R, Willis G, Cann B, Pee D, Gail MH, Pfeiffer RM. A colorectal cancer risk prediction tool for white men and women without known susceptibility.  J Clin Oncol 2009 Feb 10;27(5):686-93. Epub 2008 Dec 29. [<a href="http://www.ncbi.nlm.nih.gov/pubmed/19114701">PubMed Abstract</a>]</li>
        <li>Park Y, Freedman AN, Gail MH, Pee D, Hollenbeck A, Schatzkin A, Pfeiffer RM. Validation of a colorectal cancer risk prediction model among whites 50 years old and over. J Clin Oncol 2009 Feb 10;27(5):694-8. Epub 2008 Dec 29. [<a href="http://www.ncbi.nlm.nih.gov/pubmed/19114700">PubMed Abstract</a>]</li>
    </ol>
    <p><a href="#top">Back to Top</a></p>       
</div>
</asp:Content>
