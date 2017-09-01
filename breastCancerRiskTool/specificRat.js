$(window).load(function(event) {

  // Disables the form if the woman previously had cancer
  $("input[name='cancerAndRadiationHistory']").on("change", function() {
		if(this.value == 0){
			$("#womanWithCancerDialog").modal("show");
			$("form :input").not("[name='cancerAndRadiationHistory']").attr('disabled', true);
			$("[class*='questions']").css("color","#6c6c6c");
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
			$("[class*='questions']").css("color","#6c6c6c")
      disableSubraceMenu();
      disablebutton();
		}
		else {
			$("form :input").not("[name='geneticMakeup']").removeAttr('disabled');
			$("[class*='questions']").css("color","#2e2e2e")
      disableSubraceMenu();
		}

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

      currentPage()

      // If the biopsy anser is no certain question will be disabled
      var biopsyValue = $("input:radio[name='biopsy']:checked").val();
      if ( biopsyValue == 0 || biopsyValue == 99 ) disableQuestionAndAnswers();


      enableButtonIfAllFieldHaveInput();


    });
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

  // For every definition display the meaning
  $(".definition").on("mouseenter", displayHelpWindows);

});

// Disable a question and it answers
function disableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", true);
  $("label[for='howManyBreastBiopsies']").css("opacity", ".2");

  $("input[name='hadAH']").attr("disabled", true);
  $("label[for='hadAH']").css("opacity", ".2");
}

// Enable Questions and Answers
function enableQuestionAndAnswers(event) {
  $("input[name='howManyBreastBiopsies']").attr("disabled", false);
  $("label[for='howManyBreastBiopsies']").css("opacity", "1.0");

  $("input[name='hadAH']").attr("disabled", false);
  $("label[for='hadAH']").css("opacity", "1.0");

}


// If the value of the race menu is not "Asian" then disable
function disableSubraceMenu() {
  if ( $("#race").val() == "Asian")
    $("#sub_race").prop("disabled", false)
  else
    $("#sub_race").prop("disabled", true)
}

function adjust_line_width(ind){

  console.log("In specific JS");
 	var first_dot=$("#form-steps").find("a")[1]
 	var first_dot_left=$(first_dot).position().left
 	var first_dot_width=$(first_dot).outerWidth(true)
 	var last_dot=$("#form-steps").find("a")[$("#form-steps").find("a").length-1]
 	var last_dot_left=$(last_dot).position().left
 	var last_dot_width=$(last_dot).outerWidth(true)
 	$("#line").find("hr").css("left",first_dot_left+first_dot_width/2+10)
  $("#line").find("hr").css("width", last_dot_left - first_dot_left)

  if ( ind == 1)
    $("#line").find("hr").css("width", last_dot_left - first_dot_left + 15)
  if ( ind == 2)
    $("#line").find("hr").css("width",last_dot_left-first_dot_left+last_dot_width/4-20)
}

var terms = {
  "invasive breast cancer" : {
    type : "url",
    definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
  }
};

function displayHelpWindows() {
  var definitionName = $(this).text();

  var type = "";
  var definition = "";
  if ( terms.hasOwnProperty(definitionName)) {
    type = terms[definitionName].type
    definition = terms[definitionName].definition
  }
  else {
    console.log("No definition found for " + definitionName);
    return;
  }

  if ( type === "url") {
    $(this).webuiPopover( { type:'iframe', url:definition, closeable:true})
  }
}
