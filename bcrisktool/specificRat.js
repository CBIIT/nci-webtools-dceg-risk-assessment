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
  // specifcRat code would excecute before the generic ratCode.  The incoorect
  // assumption was the generic code would execute and then the specific code
  // would execute
  $("#riskForm").on("change", enableCalculateButton);

  $("#BreastCancerHealth").on("focusin", function() { moveElementIfCloseToBottom("#BreastCancerHealth") }) 

	// Disables the form if the woman previously had cancer or trigger the form
  	// toc check if the calculate button can be enabled.``
	$("input[name='cancerAndRadiationHistory']").on("click", function(event) {
		if(this.value == 0){
			      $("#womanWithCancerDialog").modal("show");
      			disableForm();
            //$("input[name='cancerAndRadiationHistory']")[this.value].checked = false
	  	} else {
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
      		$("#riskForm").trigger("change")
     }
  });

  // Enables the form when the user clicks ok for the dialog box be dispalyed
  // for any question in the patient eligibility phasse or the race
  $("#okButtonCancerHistory").on("click",       enableBRATForm)
  $("#okButtonMutationBRCA").on("click",        enableBRATForm)
  $("#okButtonHispanicIssue").on("click",       enableBRATForm);
  $("#okButtonUnknownIssue").on("click",        enableBRATForm);
  $("#okButtonNativeAmericanIssue").on("click", enableBRATForm)
  $("#okButtonAdminIssue").on("click", enableBRATForm)

  // There are two select boxes Race and Sub Race.   For both Asian and Hispanic
  // there will be values found in the Sub Race Drop down.  For any other
  // it should be the default question
  $("#race").on("change", attachSubraceItems)
  $("#race").on("change", displayProblemWithRace)
  $("#race").on("change", adjustSubRaceMenuIfNecessary)
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
	$("#biopsyAnswerYes").on("click", enableQuestionAndAnswers)
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

// Brings up the dialog box explaining why the data is inaccurate for hispnaics,
// Native Americans/Alaskians and how the unknownn is handled
function displayProblemWithRace() {
    if( this.value == "Hispanic"){
        $("#hispanicIssue").modal("show");
        disableForm();
    } else if ( this.value == "Other") {
        $("#unknownIssue").modal()
        disableForm();
    } else if ( this.value == "Native American") {
        $("#NativeAmericanIssue").modal();
        disableForm();
    }
}

// Attach the corrct items to the drop down for the subrace.  The correct items
// is based on the race.
function attachSubraceItems() {

  // Problem : On the iphone the String "Select sub race/ethnicity or place of birth"
  // goes way pass the border, so for the mobile phone the phrase will be
  // "Select place of birth?"
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

// Problem : On the iphone the String "Select sub race/ethnicity or place of birth"
// goes way pass the border, so the width is adjusted for the device.
//function adjustSubraceWidth() {
//   if ( isMobile() && !isTablet() ) {
//     $("#sub_race").addClass("mobile")
//   } else {
//     $("#sub_race").removeClass("mobile")
//   }
//}

// When White, African American, Alaskan navtive or American Indian, unknown then
// the subrace menu is not needed.
function adjustSubRaceMenuIfNecessary() {
  if( this.value == "White" ||
      this.value == "Black" ||
      this.value == "Other" ) {
      disableSubRaceMenu()
  } else if ( this.value == 'Asian') {
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
  if ( (totalButtonsSelected != 2) || (totalButtonsWithYes > 0) )
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

// Disable a question and it answers that are associated with a woman having a
// breast biopsy
function disableQuestionAndAnswers(event) {
  $("input[name='biopsy_result']").attr("disabled", true)
  $("input[id^='breastBiopsiesCount']").css("color", "#C0C0C0")
  $("label[for^='breastBiopsiesCount']").css("color", "#C0C0C0")
  $("label[for^='breastBiopsiesCount']").attr("tabindex", "-1")

  $("input[name='biopsy_ah']").attr("disabled", true)
  $("label[id^='hadAh']").css("color", "#C0C0C0");
  $("label[for^='hadAh']").css("color", "#C0C0C0");
  $("label[for^='hadAh']").attr("tabindex","-1")

}

// Enable Questions and Answersi that are associated with a women having a
//breast biopsy
function enableQuestionAndAnswers(event) {
  $("input[name='biopsy_result']").attr("disabled", false);
  $("input[id^='breastBiopsiesCount']").css("color", "#606060")
  $("label[for^='breastBiopsiesCount']").css("color", "#2E2E2E")
  $("label[for^='breastBiopsiesCount']").attr("tabindex", "0")

  $("input[name='biopsy_ah']").attr("disabled", false);
  $("input[id^='hadAh']").css("color", "#606060");
  $("label[for^='hadAh']").css("color", "#2E2E2E");
  $("label[for^='hadAh']").attr("tabindex","0")


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

function resetForm() {
  genericResetForm()
  enableQuestionAndAnswers();
  disableSubRaceMenu();
  resetsDropDowns();
  enableSectionHeaders();
}