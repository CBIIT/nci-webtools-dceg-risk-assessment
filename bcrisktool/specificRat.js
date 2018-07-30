// A collection of term/definitions
var terms = {
  "invasive breast cancer" : {
    definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
  }
};

$(function() {


  // Any time the form changes check all necessary (enabled) input have an answer
  //
  // Moved the add event here because originally when debugging the code the
  // specifcRat code would excecute before the generic ratCode.  The incorrect
  // assumption was the generic code would execute before the specific code
  // would execute

  $("#BreastCancerHealth").on("focusin", function() { moveElementIfCloseToBottom("#BreastCancerHealth") })

   // Disables the form if the woman previously had cancer or enable the form
   // if the woman does not have cancer.
   $("input[name='cancerAndRadiationHistory']").on("click", function(event) {
        if(this.value == 0){
            $("#womanWithCancerDialog").modal("show");
            disableForm();
	  	} else {
	  	    enableBRATForm()
	  	    $("#riskForm").trigger("change")
      }
  });

  // Disables the form if has a mutation in the BRCA1 or BRCA2 or trigger the
  // from to check if the calcualte button can be enabled
  $("input[name='geneticMakeup']").on("click", function(event) {
	   if(this.value == 0 ) {
	        $("#hasBRCAMutation").modal("show");
            disableForm();
	   } else {
	        enableBRATForm();
      		$("#riskForm").trigger("change")
       }
  });

  // For the patient Eligibility Seciton : enables the first question when user clicks ok.
  // Note that the 1st Questions will have the Answer Yes selected.
  $("#okButtonCancerHistory").on("click", function() { enableQuestionAndAnswers($("#questionAndAnswers1").attr("id")); })
  $("#okButtonCancerHistory").on("click", function() {$("#cancerAndRadiationHistoryYes").prop("checked","true"); })

  $("#okButtonMutationBRCA").on("click", function() { enableQuestionAndAnswers($("#questionAndAnswers2").attr("id")) });
  $("#okButtonMutationBRCA").on("click", function() { $("#geneticMakeupYes").prop("checked", true )} )

  // Enables the form when the user clicks ok for the dialog box be dispalyed
  // for any question in the patient eligibility phasse or the race
  $("#okButtonHispanicIssue").on("click",       enableBRATForm);
  $("#okButtonUnknownIssue").on("click",        enableBRATForm);
  $("#okButtonNativeAmericanIssue").on("click", enableBRATForm)
  $("#okButtonAdminIssue").on("click", enableBRATForm)

  // There are two select boxes Race and Sub Race.   For both Asian and Hispanic
  // there will be values found in the Sub Race Drop down.  For all other disabled
  $("#race").on("change", attachSubraceItems)
  $("#race").on("change", adjustSubRaceMenuIfNecessary)

  // TODO : We are late in the development cycle, can we get ride of this lineNumber
  // since it is called above ?
  $("#race").ready(attachSubraceItems)

	// On this IOS Phone 6 the navigation bar line in the center was not getting positioned
	// correctly, so I am adding a callback to the #RACE drop down so that the navigation
	// bar get drawn correctly everytime.
	$("#race").on("change", handleScrollEvent);

  	// If the Asian Selection from the list has been selected then enable the sub_race
	$("#sub_race").prop("disabled", true)
 	$("[for='sub_race']").css("color","#c0c0c0");
 	//$("#hispanicIssue").on("change", changeSubraceMenu);

  	// If the Number of Biopsies is None or 0 the questions about "How many breast biopies" and "atypical hyperlasia" should be disabled
	$("#biopsyAnswerYes").on("click", enableBiopsyQuestionAndAnswers)
 	$("#biopsyAnswerNo").on("click", disableQuestionAndAnswers);
  $("#biopsyAnswerUnknown").on("click", disableQuestionAndAnswers);

 	// If the question about a women every having a biopsy is answered disable the questions associated with it.
  womanHadBiopsy();

  	// Display the help window
  	$(".definition").on("click", displayHelpWindow);

  	// Initialize the button that will reset the form
  	$("#reset").on("click", resetForm)

  	// Add specifc test for the Breast Cancer Rat ( All Patient Eligibility)
  	// that make the caculate button disabled if all the question are not answered
  	// with No
  	$("#riskForm").on("change", disableIfPatientIsNotEligible);
  	$('#riskForm').trigger('change');
});

// A function that will be called as a CallBack when the footer is loaded.  This function will be the same name
// for all specificRats.  I believe that this function will scroll to the top of the #contactLink so it can be
// seen
function specificRatFooterInitialization() {
  $("#contactLink").on("focusin", function() { $("html, body").animate( { scrollTop: $("#contactLink").position().top }) })
}

// Attach the corrct items to the drop down for the subrace based on race
function attachSubraceItems() {

  var properPhraseForQuestion = "Select"

  if ( this.value == "Hispanic") {
    attachOptionsToAnHTMLObject(
      {
        ""                 : properPhraseForQuestion,
        "Foreign Hispanic" : "Born outside the US",
        "US Hispanic"      : "US born"
      })
  } else if ( this.value == 'Asian') {
    attachOptionsToAnHTMLObject(
      {
        ""            : properPhraseForQuestion,
        "Chinese"     : "Chinese",
        "Filipino"    : "Filipino",
        "Hawaiian"    : "Hawaiian",
        "Islander"    : "Islander",
        "Japanese"    : "Japanese",
        "Asian"       : "Other Asian"
      })
  } else {
    attachOptionsToAnHTMLObject(
      {
        ""            : properPhraseForQuestion
      })
  }
}

// When White, African American, Alaskan navtive or American Indian, unknown then
// the subrace menu is not needed.
function adjustSubRaceMenuIfNecessary() {
  if( this.value == "White" ||
      this.value == "Black" ||
      this.value == "Other" ) {
      disableSubRaceMenu()
  } else if ( this.value == 'Asian' ||
              this.value == 'Hispanic') {
      changeSubraceMenu()
  }
}

// Create and Attach a set of options to an HTML Object
function attachOptionsToAnHTMLObject(optionsValuesAndText) {
  $("#sub_race").empty();
  $.each(optionsValuesAndText, function (val, text) {
    $("#sub_race").
      append( $("<option></option>").val(val).html(text).addClass("content") );
  });
}

// If Any question is "Yes" in the Patient Eligibility is selected then
// disable the calculate button
function disableIfPatientIsNotEligible() {
  var totalButtonsSelected = $("#patient-eligibility-section input:checked").length
  var totalButtonsWithYes = $("#patient-eligibility-section input[id$='Yes']:checked").length
  if ( totalButtonsWithYes > 0 )
    disablebutton()
}

/* A specialized version of the enableForm function where we determine if  */
/* certain fields should be enabled.                                       */
function enableBRATForm() {
  enableForm();
  womanHadBiopsy();
  changeSubraceMenu();

  if ( $("[name='biopsy']:checked").val() == 1 ) enableQuestionAndAnswers();

  enableButtonIfAllFieldHaveInput();
  //disablebutton();
  disableIfPatientIsNotEligible()
}

// Function : Determine if the woman every had a biopsy and disable certain
// questions if the answer was no
function womanHadBiopsy() {
  var biopsyValue = $("input:radio[name='biopsy']:checked").val();
  if ( biopsyValue == 0 || biopsyValue == 99 ) {
    		disableQuestionAndAnswers();
  }
}

// Disable Questions and Answers that are associated with a women having a
// breast biopsy
function disableQuestionAndAnswers(event) {
  $("input[name='biopsy_result']").attr("disabled", true)
  $("input[id^='breastBiopsiesCount']").next().css("color", "#C0C0C0")
  $("label[for^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("color", "#C0C0C0")
  $("label[for^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("tabindex","-1")

  $("input[name='biopsy_ah']").attr("disabled", true)
  $("input[id^='hadAh']").next().css("color", "#C0C0C0");
  $("label[for^='hadAh']").parent().prev("[class*='questions']").css("color", "#C0C0C0")
  $("label[for^='hadAh']").parent().prev("[class*='questions']").css("tabindex","-1")

}

// Enable Questions and Answers that are associated with a women having a
// breast biopsy
function enableBiopsyQuestionAndAnswers(event) {

  $("input[name='biopsy_result']").attr("disabled", false)
  $("input[id^='breastBiopsiesCount']").next().css("color", "#606060")
  $("label[for^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("color", "#2E2E2E")
  $("label[for^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("tabindex","0")

  $("input[name='biopsy_ah']").attr("disabled", false)
  $("input[id^='hadAh']").next().css("color", "#606060");
  $("label[for^='hadAh']").parent().prev("[class*='questions']").css("color", "#2E2E2E")
  $("label[for^='hadAh']").parent().prev("[class*='questions']").css("tabindex","0")

  adjust_line_width();
}

/* Reset the drop down to its default value */
function resetsDropDowns() {
  function resetsAgeDropDown()      { $("#age option:eq(0)").attr("selected", "selected")             }
  function resetsRaceDropDown()     { $("#race option:eq(0)").attr("selected", "selected")            }
  function resetsChildBirthAge()    { $("#childbirth_age option:eq(0)").attr("selected", "selected")  }
  function resetsSubRaceDropDown()  { $("#sub_race option:eq(0)").attr("selected", "selected")        }

  resetsAgeDropDown();
  resetsRaceDropDown();
  resetsSubRaceDropDown();
  resetsChildBirthAge();
}

// If the value of the race menu is not "Asian" the subrace dropddown select box
function changeSubraceMenu() {
  if ( $("#race").val() == "Asian" || $("#race").val() == "Hispanic")
    enableSubRaceMenu()
  else
    disableSubRaceMenu();
}

// Enables the Sub Race Menu
function enableSubRaceMenu() {
  $("[for='sub_race']").css("color","#2e2e2e");
  $("#sub_race").prop("disabled", false)
}

// Disables the Sub Race Menu
function disableSubRaceMenu() {
  $("[for='sub_race']").css("color","#c0c0c0");
  $("#sub_race").prop("disabled", true)
  $("#sub_race option:eq(0)").prop("selected","selected");

}

/* Produces the results box for the RAT                                      */
function resultsDisplay(response, textStatus, xhr) {
  var result = JSON.parse(response.message)
	go_toresult();


	var fiveYearPatientRiskColor = ( result.risk > result.averageFiveRisk) ? "#BB0E3D" : "#2DC799";
	var lifetimePateientRiskColor = ( result.lifetime_patient_risk > result.lifetime_average_risk) ? "#BB0E3D" : "#2DC799";

	$("#results_text1").html(result.message);
	$("#results_text2").html(result.lifetime_message);
	$("#Risk1").text(result.risk+"%");
	$("#Risk2").text(result.averageFiveRisk+"%");
	$("#Risk3").text(result.lifetime_patient_risk+"%");
	$("#Risk4").text(result.lifetime_average_risk+"%");
	make_pie_chart(result.risk,                  "#pieChart1", fiveYearPatientRiskColor,  "#EFEFEF");
	make_pie_chart(result.averageFiveRisk,       "#pieChart2", "#40A5C1",                 "#EFEFEF");
	make_pie_chart(result.lifetime_patient_risk, "#pieChart3", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.lifetime_average_risk, "#pieChart4", "#40A5C1",                 "#EFEFEF");
}

/* The code that resets the form */
function resetForm() {
  genericResetForm();
  genericResetValidator();
  enableQuestionAndAnswers();
  disableSubRaceMenu();
  resetsDropDowns();
  enableSectionHeaders();
}

/******************************************************************************/
/* To Add a Disclaimer to the HTML                                            */
/* Input : The Element containing the answer used to get the extra information*/
/* Output : null --> No Extra Information                                     */
/* Output : not null --> A paragraph tag containing the disclaimer            */
/******************************************************************************/
function addInformationToTheQuestions(element) {

  var returnHTML = null;
  if ( $(element).attr("id") == $("#race").attr("id") ) {

    var currentRaceSelected = $("#race option:selected").text();

    var returnString = ""
    if ( currentRaceSelected == 'Hispana/Latina') {
      returnString = "Assessments for Hispanic women are subject to greater uncertainty than those for white and African American women."
    }
    else if ( currentRaceSelected == 'American Indian or Alaskan Native') {
      returnString = "Assessments for American Indian or Alaskan Native women are uncertain and based on data for white women."
    }
    else if ( currentRaceSelected == 'Unknown') {
      returnString = "The risk assessment was based on data for white females."
    } else {
      returnString = undefined
    }

    if ( returnString !== undefined ) {
      returnHTML = '<p class="secondary_information">' + returnString + '</p>'
    }
  }

  return returnHTML;
}
