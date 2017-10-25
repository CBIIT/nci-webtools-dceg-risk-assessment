// A collection of term/definitions
var terms = {
  "invasive breast cancer" : {
    definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
  }
};

$(function() {

	// Disables the form if the woman previously had cancer or trigger the form
  	// toc check if the calculate button can be enabled.``
	$("input[name='cancerAndRadiationHistory']").on("change", function() {
		if(this.value == 0){
			$("#womanWithCancerDialog").modal("show");
      			disableForm();
	  	} else {
      			$("#riskForm").trigger("change")
    		}
  });

  // Disables the form if has a mutation in the BRCA1 or BRCA2 or trigger the
  // from to check if the calcualte button can be enabled
  $("input[name='geneticMakeup']").on("change", function() {
	if(this.value == 0 || this.value == 2 ){
      		$("#hasBRCAMutation").modal("show");
      		disableForm();
	  } else {
      		$("#riskForm").trigger("change")
    	}
  });

  // Enables the form when the user clicks ok for the dialog box be dispalyed
  // for any question in the patient eligibility phasse.
  $("#okButtonCancerHistory").on("click", enableBRATForm)
  $("#okButtonMutationBRCA").on("click", enableBRATForm)

	// Brings up the dialog box explaining why the data is inaccurate for hispnaics,
 	// Native Americans/Alaskians and how the unknow is handled
  	$("#race").on("change", function() {
    		if( this.value == "US Hispanic"){
      			$("#hispanicIssue").modal("show");
    		} else if ( this.value == "Other") {
			$("#unknownIssue").modal("show")
		} else if ( this.value == "Native American") {
 			$("#NativeAmericanIssue").modal("show");
    		}
  	});

	// On this IOS Phone 6 the navigation bar line in the center was not getting positioned
	// correctly, so I am adding a callback to the #RACE drop down so that the navigation
	// bar get drawn correctly everytime.
	$("#race").on("change", handleScrollEvent);

  	// If the Asian Selection from the list has been selected then enable the sub_race
	$("#sub_race").prop("disabled", true)
 	$("[for='sub_race']").css("color","#c0c0c0");
 	$("#race").on("change", changeSubraceMenu);

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

// If Any "Yes" or Unknow Answer in the Patient Eligibility is selected then
// disable the calculate button
function disableIfPatientIsNotEligible() {
  var result = $("#patient-eligibility-section input[id$='No']:checked").length;
  if ( result != 2 ) disablebutton();
}

/* A specialized version of the enableForm function where we determine if  */
/* certain fields should be enabled.                                       */
function enableBRATForm() {
  enableForm();
  womanHadBiopsy();
  changeSubraceMenu();
  disablebutton();
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
  $("input[name='howManyBreastBiopsies']").attr("disabled", true);
  $("label[for='breastBiopsiesCount1']").css("color", "#C0C0C0");

  $("input[name='hadAH']").attr("disabled", true);
  $("label[for='hadAhYes']").css("color", "#c0c0c0");

}

// Enable Questions and Answersi that are associated with a women having a
//breast biopsy
function enableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", false);
  $("label[for='breastBiopsiesCount1']").css("color", "#2e2e2e");

  $("input[name='hadAH']").attr("disabled", false);
  $("label[for='hadAhYes']").css("color", "#2e2e2e");

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
  if ( $("#race").val() == "Asian")
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
