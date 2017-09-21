// A collection of term/definitions
var terms = {
  "invasive breast cancer" : {
    definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
  }
};

$(function() {

  // Disables the form if the woman previously had cancer
  $("input[name='cancerAndRadiationHistory']").on("change", function() {
		if(this.value == 0){
			$("#womanWithCancerDialog").modal("show");
			$("form :input").not("[name='cancerAndRadiationHistory']").attr('disabled', true);
			$("[class*='questions']").css("color","#c0c0c0");
      			disableSubraceMenu();
			disablebutton();
		}
		else {
			$("form :input").not("[name='cancerAndRadiationHistory']").removeAttr('disabled');
			$("[class*='questions']").css("color","#2e2e2e");
      			disableSubraceMenu();
		}
	});

  // Disables the form if has a mutation in the BRCA1 or BRCA2
  $("input[name='geneticMakeup']").on("change", function() {
		if(this.value == 0 || this.value == 2 ){
			$("#hasBRCAMutation").modal("show");
			$("form :input").not("[name='geneticMakeup']").attr('disabled', true);
			$("[class*='questions']").css("color","#c0c0c0")
		  disableSubraceMenu();
      disablebutton();
		}
		else {
			$("form :input").not("[name='geneticMakeup']").removeAttr('disabled');
			$("[class*='questions']").css("color","#2e2e2e")
    	disableSubraceMenu();
		}
  });

  // Create a call to check if the calculate button should be enabled.
  $("#riskForm").change(function() {
    if ( $("input[name='cancerAndRadiationHistory']:checked").val() == 0 ) {
    	disablebutton();
      return;
    }

    var geneticMakeupValue = $("input[name='geneticMakeup']:checked").val();
    if ( geneticMakeupValue == 0 || geneticMakeupValue == 99 ) {
    	disablebutton();
      return;
    }
   });

  // Brings up the dialog box explaining why the data is inaccurate for hispnaics
  $("#race").on("change", function() {
    if( this.value == "US Hispanic"){
      $("#hispanicIssue").modal("show");
    }
  });

  // If the Asian Selection from the list has been selected then enable the sub_race
  $("#sub_race").prop("disabled", true)
  $("#race").on("change", disableSubraceMenu);

  // If the Number of Biopsies is None or 0 the questions about "How many breast biopies" and "atypical hyperlasia" should be disabled
  $("#biopsyAnswerYes").on("click", enableQuestionAndAnswers)
  $("#biopsyAnswerNo").on("click", disableQuestionAndAnswers);
  $("#biopsyAnswerUnknown").on("click", disableQuestionAndAnswers);

  // If the question about a women every having a biopsy is answered disable the questions associated with it.
  var biopsyValue = $("input:radio[name='biopsy']:checked").val();
  if ( biopsyValue == 0 || biopsyValue == 99 ) {
      disableQuestionAndAnswers();
      enableButtonIfAllFieldHaveInput();
  }

  // Display the help windw
  $(".definition").on("click", displayHelpWindow);

  // Initialize the button that will reset the form
  $("#reset_form").on("click", resetForm)

  $('#riskForm').trigger('change');

});

// Disable a question and it answers that are associated with a woman having a breast biopsy
function disableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", true);
  $("label[for='howManyBreastBiopsies']").css("opacity", ".2");

  $("input[name='hadAH']").attr("disabled", true);
  $("label[for='hadAH']").css("opacity", ".2");
}

// Enable Questions and Answersi that are associated with a women having a breast biopsy
function enableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", false);
  $("label[for='howManyBreastBiopsies']").css("opacity", "1.0");

  $("input[name='hadAH']").attr("disabled", false);
  $("label[for='hadAH']").css("opacity", "1.0");

  adjust_line_width();
}


// If the value of the race menu is not "Asian" the subrace dropddown select box
function disableSubraceMenu() {
  if ( $("#race").val() == "Asian")
    $("#sub_race").prop("disabled", false)
  else
    $("#sub_race").prop("disabled", true)
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
	make_pie_chart(result.risk, "#pieChart1",fiveYearPatientRiskColor, "#EFEFEF");
	make_pie_chart(result.averageFiveRisk, "#pieChart2", "#40A5C1", "#EFEFEF");
	make_pie_chart(result.lifetime_patient_risk, "#pieChart3", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.lifetime_average_risk, "#pieChart4", "#40A5C1", "#EFEFEF");
}

function resetForm() {
  genericResetForm()
  enableQuestionAndAnswers();
  disableSubraceMenu();
}
