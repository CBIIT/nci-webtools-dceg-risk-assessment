<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="WUCDemo.ascx.cs" Inherits="CCRAT.Web.UserControls.WUCDemo" %>

<!-- QDIV -->
<div id="qdivHispanic" class="question">

	<div class="qtext">
		<span class="sectiontitle">
		Do you consider yourself to be <span class="bold">Hispanic</span> or <span class="bold">Latino</span>?
		[<a href="javascript:toggle('more_hispanic');" id="more_hispanic_d" class="def_link_more" title="More about ">More</a>]
        <asp:RequiredFieldValidator ID="rfvHispanic" runat="server" 
            ControlToValidate="rblhispanic" Display="Dynamic" ErrorMessage="Please select Yes/No for Hispanic or Latino" 
            ValidationGroup="vgDemo">Required</asp:RequiredFieldValidator>
        </span>
        <div class="qbreak"></div>        
        <asp:RadioButtonList ID="rblhispanic" runat="server" RepeatLayout="Flow">
	        <asp:ListItem  Value="Yes">Yes</asp:ListItem>
	        <asp:ListItem  Value="No">No</asp:ListItem>
        </asp:RadioButtonList>
        <script type="text/javascript">
        
            $('[name=ctl00$cphMain$WUCDemo$rblhispanic]').change(HispanicRblOnChangeHandler);
        </script>
        <div class="blankspace"></div>
    </div>
</div>
<!-- QDIV -->
<div id="qdivRace" class="question">
    <div class="qtext">
        <span class="sectiontitle">Which of the following do you consider yourself to be? [<a
            href="javascript:toggle('more_hispanic');" id="more_race_d" class="def_link_more"
            title="More about ">More</a>] 
        <asp:CustomValidator  ID="rfvRace" runat="server" 
           Display="Dynamic"
           ErrorMessage="Please Select Race"  
            OnServerValidate="ValidateRace" 
            ValidationGroup="vgDemo">Required</asp:CustomValidator >
        </span>
        <div class="qbreak"></div>
        <asp:RadioButtonList ID="rblRace" runat="server" RepeatLayout="Flow">
            <asp:ListItem Text="White" Value="White" />
            <asp:ListItem Text="Black or African-American" Value="Black" />
            <asp:ListItem Text="Asian or Pacific Islander" Value="Asian" />
        </asp:RadioButtonList>
        <div class="blankspace"></div>
    </div>
</div>
        <script type="text/javascript">
            $('[name=ctl00$cphMain$WUCDemo$rblRace]').change(RaceRblOnChangeHandler);
        </script>
<!-- QDIV -->
<div id="qdiv3" class="question">
    <div class="qtext">
        <span class="sectiontitle">What is your <span class="bold">age</span>? [<a href="javascript:toggle('more_age');"
            id="more_age_d" class="def_link_more" title="More about ">More</a>] 
        <asp:RangeValidator ID="rvAge" runat="server" ControlToValidate="ddlCurrentAge" 
            Display="Dynamic" ErrorMessage="Please select age" MaximumValue="85" MinimumValue="50" 
            ValidationGroup="vgDemo"></asp:RangeValidator>
        </span>
        <br />
        <span class="italic">NOTE: This tool calculates risk for men and women 50 to 85 years
            of age.</span>
        <div class="qbreak"></div>
        <asp:DropDownList ID="ddlCurrentAge" runat="server" >
        </asp:DropDownList>
        <div class="blankspace"></div>
    </div>
</div>
<!-- QDIV -->
<div id="qdiv4" class="question">
    <div class="qtext">
        <span class="sectiontitle">What is your <span class="bold">sex</span>? [<a href="javascript:toggle('more_sex');"
            id="more_sex_d" class="def_link_more" title="More about ">More</a>] 
        <asp:RequiredFieldValidator ID="rfvSex" runat="server" 
            ControlToValidate="rblSex" Display="Dynamic" ErrorMessage="Please select sex" 
            ValidationGroup="vgDemo">Required</asp:RequiredFieldValidator>
        </span>
        <div class="qbreak"></div>
        <asp:RadioButtonList ID="rblSex" runat="server" RepeatLayout="Flow" 
            AutoPostBack="True" onselectedindexchanged="rblSex_SelectedIndexChanged" >
            <asp:ListItem Text="Male" Value="Male" />
            <asp:ListItem Text="Female" Value="Female" />
        </asp:RadioButtonList>
        <div class="blankspace"></div>
                <div>
            <asp:Label ID="lblMessageMisc" runat="server" Text="" ForeColor="Red" Visible="false" ></asp:Label></div>

    </div>
</div>
<!-- QDIV -->
<div id="qdiv5" class="question">
    <div class="qtext">
        <span class="sectiontitle">What is your <span class="bold">height</span> without shoes?
            [<a href="javascript:toggle('more_height');" id="more_height_d" class="def_link_more"
                title="More about ">More</a>] 
        <asp:RequiredFieldValidator ID="rfvHeight" runat="server" 
            ControlToValidate="txtFeet" Display="Dynamic" ErrorMessage="Please enter your height" 
            ValidationGroup="vgDemo">Required</asp:RequiredFieldValidator>
        </span>
        <div class="qbreak">
        </div>
        <asp:TextBox ID="txtFeet" runat="server" class="heighweight" onkeyup="onlyDigit(this)"
            onkeypress="onlyDigit(this)"></asp:TextBox>
        feet
        <asp:TextBox ID="txtInch" runat="server" class="heighweight" onkeyup="onlyDigit(this)"
            onkeypress="onlyDigit(this)" MaxLength="2"></asp:TextBox>
        inches
        <asp:RangeValidator ID="HeightInchesRangeValidator"
                runat="server" ValidationGroup="vgDemo" ErrorMessage="Please enter number between 0 to 11 for inches." ControlToValidate="txtInch" MaximumValue="11" MinimumValue="0" SetFocusOnError="True" Type="Integer"></asp:RangeValidator>
        <div class="blankspace">
        
            <asp:RangeValidator ID="txtFeetRangeValidator" ValidationGroup="vgDemo" runat="server" ControlToValidate="txtFeet" MaximumValue="11" MinimumValue="1" SetFocusOnError="True" Type="Integer" ErrorMessage="Please enter number between 1 to 11 for feet"></asp:RangeValidator>
        </div>
    </div>
</div>
<!-- QDIV -->
<div id="qdiv6" class="question">
    <div class="qtext">
        <span class="sectiontitle">What is your <span class="bold">weight</span> without shoes?
            [<a href="javascript:toggle('more_weight');" id="more_weight_d" class="def_link_more"
                title="More about ">More</a>] 
        <asp:RequiredFieldValidator ID="rfvWeight" runat="server" 
            ControlToValidate="txtWeight" Display="Dynamic" ErrorMessage="Please enter your weight" 
            ValidationGroup="vgDemo">Required</asp:RequiredFieldValidator>
        </span>
        <div class="qbreak">
        </div>
        <asp:TextBox ID="txtWeight" runat="server" class="heighweight" onkeyup="return isNumberKey(event)" 
            onkeypress="return isNumberKey(event)" MaxLength="3"></asp:TextBox><%--onkeyup="onlyDigit2(this)"
            onkeypress="onlyDigit2(this)"--%>
        lbs
        <div class="blankspace">
        </div>
                    <asp:RangeValidator ID="txtWeightRangeValidator" ValidationGroup="vgDemo" runat="server" ControlToValidate="txtWeight" MaximumValue="999" MinimumValue="1" SetFocusOnError="True" Type="Integer" ErrorMessage="Please enter number between 1 to 999 for weight"></asp:RangeValidator>

    </div>
</div>
<!-- Definition DIVs -->
<div id="more_hispanic" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Note
        </div>
        <div class="stattable_more">
            When we first developed this tool, we tested it with white people and found it to
            be accurate in estimating their risk of colorectal cancer. If you are African American,
            Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate
            your risk. But, because there is not as much data available for these groups, your
            results may be less accurate.
            <br />
            <br />
            In the future, we hope to make this tool more accurate for African Americans, Asian
            Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies
            that will provide information to update the tool for these groups.
            <br />
            <br />
            This tool does not yet apply to American Indians and Alaska Natives, but we are
            working to improve the tool for use by these groups of people.
            <br />
            <br />
            This Web site can help you learn more about cancer risk, including colorectal cancer
            risk: Understanding the Puzzle from NCI.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('more_hispanic',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>
<div id="more_age" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Age
        </div>
        <div class="stattable_more">
            As you get older, your risk of colorectal cancer gets higher. More than 90 percent
            of people with this disease are diagnosed after age 50. The average age at diagnosis
            is 72.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('more_age',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>
<div id="more_sex" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Sex
        </div>
        <div class="stattable_more">
            The factors that can protect you from colorectal cancer or cause you to be at higher
            risk are different for men and women.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('more_sex',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>
<div id="more_height" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div  class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Height
        </div>
        <div class="stattable_more">
            Height and weight are used to determine your body mass index (BMI). It can also
            be used to measure total body fat and whether a person is a healthy weight. Obesity
            (a problem in which people have too much body fat) has been linked to a higher risk
            of colorectal cancer.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('more_height',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>
<div id="more_weight" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div  class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Weight
        </div>
        <div class="stattable_more">
            Height and weight are used to determine your body mass index (BMI). It can also
            be used to measure total body fat and whether a person is a healthy weight. Obesity
            (a problem in which people have too much body fat) has been linked to a higher risk
            of colorectal cancer.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('more_weight',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>



<div id="More_Hisp" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Hispanic
        </div>
        <div class="stattable_more">
            When we first developed this tool, we tested it with white people and found it to
            be accurate in estimating their risk of colorectal cancer. If you are Hispanic/Latino, this tool can still estimate
            your risk. But, because there is not as much data available for these groups, your
            results may be less accurate.
            <br />
            <br />
            In the future, we hope to make this tool more accurate for Hispanics/Latinos, as researchers complete studies
            that will provide information to update the tool for these groups.
            <br />
            <br />
            Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('More_Hisp',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>

<div id="More_Black" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Black or African-American
        </div>
        <div class="stattable_more">
            When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are African American, this tool can still estimate your risk. But, because there is not as much data available for this group, your results may be less accurate.
            <br />
            <br />
            In the future, we hope to make this tool more accurate for African Americans, as researchers complete studies that will provide information to update the tool for this group.            <br />
            <br />
            Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('More_Black',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>

<div id="More_Asain" style="display: none;" class="lb_container">
    <!-- lightbox -->
    <div class="popup_container_more">
        <!-- centered box -->
        <div class="stat_container_more">
            Asian or Pacific Islander
        </div>
        <div class="stattable_more">
            When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are Asian American or Pacific Islander, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.            <br />
            <br />
            <br />
            In the future, we hope to make this tool more accurate for Asian Americans and Pacific Islanders, as researchers complete studies that will provide information to update the tool for these groups.            <br /><br />
            Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer.
            <br />
            <br />
        </div>
        <div class="close_butt_more">
            <a href="#definition_link" onclick="toggle('More_Asain',event); 
			return false;" class="close_butt_more">X Close</a>
        </div>
    </div>
</div>
<!-- End of Def Divs -->
<asp:ValidationSummary ID="VgDemoSummaryRequiredFields" runat="server" EnableClientScript="true" ShowMessageBox="True" ValidationGroup="vgDemo" ShowSummary="False" />
