// Show/hide sub race/ethnicity question based on race selection
document.addEventListener('DOMContentLoaded', function() {
  var raceSelect = document.getElementById('race');
  var subRaceContainer = document.getElementById('subRaceContainer');
  if (raceSelect && subRaceContainer) {
    function updateSubRaceVisibility() {
      var value = raceSelect.value;
      if (value === 'Hispanic' || value === 'Asian') {
        subRaceContainer.classList.remove('hidden');
      } else {
        subRaceContainer.classList.add('hidden');
      }
    }
    raceSelect.addEventListener('change', updateSubRaceVisibility);
    updateSubRaceVisibility();
  }
});
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

   $("#womanWithCancerDialog").on("hidden.bs.modal", function(e) {
	  if(!isMobile()) 
         $("input[name='cancerAndRadiationHistory']:checked").next('[role=radio][aria-checked=true]').focus();
   });

   $("#hasBRCAMutation").on("hidden.bs.modal", function() {
	  if(!isMobile())  
        $("input[name='geneticMakeup']:checked").next('[role=radio][aria-checked=true]').focus();
   });

   // Disables the form if the woman previously had cancer or enable the form
   // if the woman does not have cancer.
   $("input[name='cancerAndRadiationHistory']").on("click", function(event) {
        if(this.value == 0){
            genericResetValidator();
            disableForm();
            setTimeout(function() {$("#womanWithCancerDialog").modal("show");},500);
        } else {
	  	    enableBRATForm()
      }
  });

  // Disables the form if has a mutation in the BRCA1 or BRCA2 or trigger the
  // from to check if the calcualte button can be enabled
  $("input[name='geneticMakeup']").on("click", function(event) {
	   if(this.value == 0 ) {
          genericResetValidator();
	      disableForm();
	      setTimeout(function() {$("#hasBRCAMutation").modal("show");},500);
	   } else {
	        enableBRATForm();
      		$("#riskForm").trigger("change")
       }
  });

  // For the patient Eligibility Seciton : enables the first question when user clicks ok.
  // Note that the 1st Questions will have the Answer Yes selected.
  $("#okButtonCancerHistory").on("click", function() { enableQuestionAndAnswers($("#questionAndAnswers1").attr("id")); })
  $("#okButtonCancerHistory").on("click", function() {$("#cancerAndRadiationHistoryYes").prop("checked",true); })

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
    // Update the label text for Hispanic selection
    $("[for='sub_race']").text("Where was the patient born?");
    attachOptionsToAnHTMLObject(
      {
        ""                 : properPhraseForQuestion,
        "Foreign Hispanic" : "Outside the US",
        "US Hispanic"      : "In the US"
      })
  } else if ( this.value == 'Asian') {
    // Update the label text for Asian American selection
    $("[for='sub_race']").text("Select ancestry/ethnic background");
    attachOptionsToAnHTMLObject(
      {
        ""            : properPhraseForQuestion,
        "Chinese"     : "Chinese",
        "Filipino"    : "Filipino",
        "Hawaiian"    : "Hawaiian",
        "Islander"    : "Pacific Islander",
        "Japanese"    : "Japanese",
        "Asian"       : "Other Asian"
      })
  } else {
    // Reset to default label text for other races
    $("[for='sub_race']").text("What is the sub race/ethnicity or place of birth?");
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
      this.value == "Other" ||
      this.value == "") {
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

/* A specialized version of the enableForm function where we determine if  */
/* certain fields should be enabled.                                       */
function enableBRATForm() {
  enableForm();
  womanHadBiopsy();
  changeSubraceMenu();

  if ( $("[name='biopsy']:checked").val() == 1 ) enableQuestionAndAnswers();
  }

// Function : Determine if the woman every had a biopsy and disable certain
// questions if the answer was no
function womanHadBiopsy() {
  var biopsyValue = $("input:radio[name='biopsy']:checked").val();
  if ( biopsyValue == 0 || biopsyValue == 99 || !biopsyValue) {
    		disableQuestionAndAnswers();
  }
}

// Disable Questions and Answers that are associated with a women having a
// breast biopsy
function disableQuestionAndAnswers(event) {
  $("input[name='biopsy_result']").attr("disabled", true)
  $("input[id^='breastBiopsiesCount']").next().css("color", "#C0C0C0")
  $("input[id^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("color", "#C0C0C0").attr("aria-disabled",true);
  
  $("input[name='biopsy_ah']").attr("disabled", true)
  $("input[id^='hadAh']").next().css("color", "#C0C0C0");
  $("input[id^='hadAh']").parent().prev("[class*='questions']").css("color", "#C0C0C0").attr("aria-disabled",true);
  removeErrorMessage({target: $("#breastBiopsiesCount1")});
  removeErrorMessage({target: $("#hadAhYes")});
  
  $("[aria-labelledby=biopsy_resultLabel]").find("[role=radio]").attr("tabindex","-1").attr("aria-disabled",true);
  $("[aria-labelledby=biopsy_ahLabel]").find("[role=radio]").attr("tabindex","-1").attr("aria-disabled",true);
}

// Enable Questions and Answers that are associated with a women having a
// breast biopsy
function enableBiopsyQuestionAndAnswers(event) {

  $("input[name='biopsy_result']").attr("disabled", false)
  $("input[id^='breastBiopsiesCount']").next().css("color", "#606060")
  $("input[id^='breastBiopsiesCount']").parent().prev("[class*='questions']").css("color", "#2E2E2E").attr("aria-disabled",false);
  
  $("input[name='biopsy_ah']").attr("disabled", false)
  $("input[id^='hadAh']").next().css("color", "#606060");
  $("input[id^='hadAh']").parent().prev("[class*='questions']").css("color", "#2E2E2E").attr("aria-disabled",false);

  $("[aria-labelledby=biopsy_resultLabel]").find("[role=radio]").attr("aria-disabled",false);
  $("[aria-labelledby=biopsy_ahLabel]").find("[role=radio]").attr("aria-disabled",false);
  
  if ($("[aria-labelledby=biopsy_resultLabel]").find("[role=radio][aria-checked=true]").length > 0) {
    $("[aria-labelledby=biopsy_resultLabel]").find("[role=radio][aria-checked=true]").attr("tabindex","0");
  } else {
    $("[aria-labelledby=biopsy_resultLabel]").find("[role=radio]:first").attr("tabindex","0");
  }

  if ($("[aria-labelledby=biopsy_ahLabel]").find("[role=radio][aria-checked=true]").length > 0) {
    $("[aria-labelledby=biopsy_ahLabel]").find("[role=radio][aria-checked=true]").attr("tabindex","0");
  } else {
    $("[aria-labelledby=biopsy_ahLabel]").find("[role=radio]:first").attr("tabindex","0");
  }


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
  removeErrorMessage({ target: $("#sub_race")});

}

/* Produces the results box for the RAT                                      */
function resultsDisplay(response, textStatus, xhr) {
  var result = JSON.parse(response.message)
	go_toresult();
  addInformationToResultPageIntroductionText()


	var fiveYearPatientRiskColor = ( result.risk > result.averageFiveRisk) ? "#BB0E3D" : "#2DC799";
	var lifetimePateientRiskColor = ( result.lifetime_patient_risk > result.lifetime_average_risk) ? "#BB0E3D" : "#2DC799";

    fiveYearPatientRiskColor = ( result.risk == result.averageFiveRisk ) ? "#40A5C1": fiveYearPatientRiskColor;
    lifetimePateientRiskColor = ( result.lifetime_patient_risk == result.lifetime_average_risk ) ? "#40A5C1": lifetimePateientRiskColor;

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
  disableQuestionAndAnswers();
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
  var startTag = '<p class="secondary_information">'
  var endTag = '</p>'

  if ( $(element).attr("id") == $("#race").attr("id") ) {

    var currentRaceSelected = $("#race option:selected").text();

    var returnString = ""
    if ( currentRaceSelected.startsWith("His")) {
      returnHTML =
        startTag + "Assessments for Hispanas/Latinas are subject to greater uncertainty than those for white and African American/black women." + endTag +
        startTag + "Researchers are conducting additional studies, including studies with minority populations, to gather more data and to increase the accuracy of the tool for women in these populations. " + endTag
    }
    else if ( currentRaceSelected == 'American Indian or Alaskan Native') {
      returnHTML =
        startTag + "Risk estimates for American Indian/Alaska Native women are based on data for white women; further studies are needed to refine and validate this tool." + endTag
    }
    else if ( currentRaceSelected == 'Unknown') {
      returnHTML = startTag + "Risk estimates for Unknown race/ethnicity are based on data for white women." + endTag
    } else {
      returnHTML = ""
    }
  }

  return returnHTML;
}

function addInformationToResultPageIntroductionText() {
  var returnHTML = null;
  var startTag = '<li data-dynamicallyAdded="true">'
  var endTag = '</li>'

  var currentRaceSelected = $("#race option:selected").text();

  var returnString = ""
  if ( currentRaceSelected.startsWith("His")) {
    returnHTML =
          startTag + "Assessments for Hispanas/Latinas are subject to greater uncertainty than those for white and African "     +
                     "American/black women. Researchers are conducting additional studies, including studies with minority "           +
                     "populations, to gather more data and to increase the accuracy of the tool for women in these populations." + endTag
  }
  else if ( currentRaceSelected == 'American Indian or Alaskan Native') {
      returnHTML =
          startTag +  "Risk estimates for American Indian/Alaska Native women are based on data for white women; " +
                      "further studies " + " are needed to refine and validate this tool." + endTag
  }

  $("#results_home ul.content.resultsPageContent").append(returnHTML)
}
