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
			$("form :input").not("#reset").attr('disabled', true);
			$("[class*='questions']").css("color","#c0c0c0");
      			disableSubRaceMenu();
			      disablebutton();
      			disableSectionHeaders();
      			resetsDropDowns();
		}
	});

  	// Disables the form if has a mutation in the BRCA1 or BRCA2
  	$("input[name='geneticMakeup']").on("change", function() {
		if(this.value == 0 || this.value == 2 ){
			$("#hasBRCAMutation").modal("show");
			$("form :input").not("#reset").attr('disabled', true);
			$("[class*='questions']").css("color","#c0c0c0")
		      	disableSubRaceMenu();
		 	      disablebutton();
      			disableSectionHeaders();
   			    resetsDropDowns();
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
  	var biopsyValue = $("input:radio[name='biopsy']:checked").val();
  	if ( biopsyValue == 0 || biopsyValue == 99 ) {
      		disableQuestionAndAnswers();
      		enableButtonIfAllFieldHaveInput();
  	}

  	// Display the help window
  	$(".definition").on("click", displayHelpWindow);

  	// Initialize the button that will reset the form
  	$("#reset").on("click", resetForm)

  	$('#riskForm').trigger('change');
});

// Disable a question and it answers that are associated with a woman having a breast biopsy
function disableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", true);
  $("label[for='howManyBreastBiopsies']").css("color", "#C0C0C0");
  $("input[name='howManyBreastBiopsies']").attr("checked", false);

  $("input[name='hadAH']").attr("disabled", true);
  $("label[for='hadAH']").css("color", "#c0c0c0");
  $("input[name='hadAH']").attr("checked", false);

}

// Enable Quesctions and Answersi that are associated with a women having a breast biopsy
function enableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", false);
  $("label[for='howManyBreastBiopsies']").css("color", "#2e2e2e");

  $("input[name='hadAH']").attr("disabled", false);
  $("label[for='hadAH']").css("color", "#2e2e2e");

  adjust_line_width();
}

/* Reset the drop down to its default value */
function resetsDropDowns() {
  function resetsAgeDropDown()      { $("#age option:eq(0)").attr("selected", "selected")             }
  function resetsRaceDropDown()     { $("#race option:eq(0)").attr("selected", "selected")            }
  function resetsChildBirthAge()    { $("#childbirth_age option:eq(0)").attr("selected", "selected")  }
  function resetsSubRaceDropDown()  { $("#sub_race option:eq(0)").attr("selected", "selected")          }

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
	make_pie_chart(result.risk, "#pieChart1",fiveYearPatientRiskColor, "#EFEFEF");
	make_pie_chart(result.averageFiveRisk, "#pieChart2", "#40A5C1", "#EFEFEF");
	make_pie_chart(result.lifetime_patient_risk, "#pieChart3", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.lifetime_average_risk, "#pieChart4", "#40A5C1", "#EFEFEF");
}

function resetForm() {
  genericResetForm()
  enableQuestionAndAnswers();
  disableSubRaceMenu();
  resetsDropDowns();
  enableSectionHeaders();
}
