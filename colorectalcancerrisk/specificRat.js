1// A collection of term/definitions
// var terms = {
//   "invasive breast cancer" : {
//     definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
//   }
// };

$(function() {

    // Any time the form changes check all necessary (enabled) input have an answer
    //
    // Moved the add event here because originally when debugging the code the
    // specifcRat code would excecute before the generic ratCode.  The incoorect
    // assumption was the generic code would execute and then the specific code
    // would execute
    $("#riskForm").on("change", enableCalculateButton);

    // Disables the form if the race is Hispanic or Latino then display some 
    // information and disble the form.
    $("input[name='hispanic']").on("click", function(event) {
        if(this.value == 0){
            $("#raceModal").modal("show");
            disableCRATForm();
   	    } else {
            enableRaceQuestion()
            $("#riskForm").trigger("change")
        }
    })

    // Adding extra funcitonality to the enableCalculateButton 
    // If both the age of starting and ending smoking have been enter warn the user if the quitting age is before the starting age
    $("#riskForm").on( "change", function(event) {
        alertUserIfStartSmokingIsAfterQuittingSmoking(event)
    })

    // Enables the form when the user clicks ok for the dialog box be dispalyed
    // for any question in the patient eligibility phasse or the race
    $("#hisp-notice").on("click",               enableCRATFormWithRaceDisabled)
    $("#smokingAgeErrorOkButton").on("click",   enableCRATForm)

    // Each time the gender is toggle the form should determine if the calculate button should be enabled */
    $("input[name='gender']").on("change", toggleGender);
    $("input[name='gender']").on("change", enableCalculateButton);

    // For Diet and Activity Section if the user select no servings disable the amont per serving
    $("#veg_servings").on("change",     adjustAmountPerServingBasedOnServings)
    $("#moderate_months").on("change",  adjustHoursPerWeekModerateActivity)
    $("#vigorous_months").on("change",  adjustHoursPerWeekVigorousActivity)

    // For Medical History : During the past 10 years, did the patient have a colonoscopy, sigmoidoscopy, or both?
    $("#colonSigmoidoscopyYes").on("change",        enableColonSigmoidoscopyQuestion)
    $("#colonSigmoidoscopyNo").on("change",         disableColonSigmoidoscopyQuestion)
    $("#colonSigmoidoscopyUnknown").on("change",    disableColonSigmoidoscopyQuestion)

    // For Medical History : Does the patient still have periods
    $("#periodYes").on("click", disasbleLastPeriodWhen)
    $("#periodYes").on("click", disableHormoneTreatment)
    $("#periodNo").on("click",  enableLastPeriodWhen)
    $("#periodNo").on("click",  enableHormoneTreatment)

    // For Medical History : when did the patient have her last period
    $("#last_period").on("change", adjustLastTimeSheHadPeriod)

    // Family History : Does the patient have any immediate relatives 
    $("#familyCancerYes").on("change",      enableAmountOfFamilyRelatives)
    $("#familyCancerNo").on("change",       disableAmountOfFamilyRelatives)
    $("#familyCancerUnknown").on("change",  disableAmountOfFamilyRelatives)

    // Smoking : Has the patient every smoke more than 100 Cigarettes
    $("#smokeYes").on("click",      enableAgeWhenStartedSmoking)
    $("#smokeYes").on("click",      enableCurrentlySmokeCigarettes)
    $("#smokeYes").on("click",      enableAgeQuitSmoking)
    $("#smokeYes").on("click",      enableCigarettesSmokedPerDay)

    $("#smokeNo").on("click",       disableAgeWhenStartedSmoking)
    $("#smokeNo").on("click",       disableCurrentlySmokeCigarettes)
    $("#smokeNo").on("click",       disableAgeQuitSmoking)
    $("#smokeNo").on("click",       disableCigarettesSmokedPerDay)

    $("#smokeUnknown").on("click",  disableAgeWhenStartedSmoking)
    $("#smokeUnknown").on("click",  disableCurrentlySmokeCigarettes)
    $("#smokeUnknown").on("click",  disableAgeQuitSmoking)
    $("#smokeUnknown").on("click",  disableCigarettesSmokedPerDay)

    // Smoking : Has the person ever smoked Cigrarettes regulary
    $("#firstYearSmoke").on("change", adjustSmokingOnRegularBasis)

    // Smoking : Do you currently smoke cigarettes
    $("#currentlySmokeYes").on("click", disableAgeQuitSmoking)
    $("#currentlySmokeNo").on("click",  enableAgeQuitSmoking)

    // Initialize the button that will reset the form
	$("#reset").on("click", resetForm)

  });

function alertUserIfStartSmokingIsAfterQuittingSmoking (event) {
    /*
    * function -- If the Age Started Smoking and the Age Quit Smoking have are both an Age 
    * verifyt that the start smoking is before or equal to the quit smoking
    */
    function startSmokingBeforeQuitSmoking() {
        
        let startSmoking = parseInt($("#firstYearSmoke").val())
        let endSmoking   = parseInt($("#smoke_quit").val())
        
        if ( isNaN(startSmoking) || isNaN(startSmoking)) {
            return false;
        } else if ( startSmoking > endSmoking ) {
            return true;
        } else {
            return false;
        }
    }

    if ( startSmokingBeforeQuitSmoking() == true ) {
        $("#smokingAgeError").modal("show");
        disableCRATForm();
    }
}

/* The fucntion disables for the form */
function disableCRATForm() {
    disableForm()
    $("[class='numberField']").next("span").css("color","#C0C0C0")
}

/** Group of fucntions that disable/enable the next question should be put together in one function */


/* A specialized version of the enableForm function where we determine if  */
/* certain fields should be enabled.                                       */
function enableCRATFormWithRaceDisabled() {
    enableCRATGenericForm()
    $("#hispanicYes").prop("checked", true)
    $("#hispanicNo").prop("checked", false)
    disableRaceQuestion()
}

function enableCRATForm() {
    enableCRATGenericForm()
    if ( $("[name='hispanic']".prop("checked") == true )) 
        disableRaceQuestion()
    else 
        enableRaceQuestion()
}

/* A generic functon for enabling the CRAT Form.  Hanldes all the common functionality */
function enableCRATGenericForm() {
    enableForm();
    $("[class='numberField'").next("span").css("color","#2E2E2E")
}

/* Disables the race question and its answers                                                */
/* This section should be refactored, but can be done as a TODO later on                     */
function disableRaceQuestion() {
    $("[for='race']").css("color", "#C0C0C0")
    $("[for='race']").next().css("color", "#C0C0C0")
    $("[for='race']").nextUntil("label.questions").children("label.radio").css("color","#C0C0C0")
    $("[for='race']").nextUntil("label.questions").children("input").attr("disabled","disabled")
}

/* Enables the race question and its answers */
function enableRaceQuestion() {
    $("[for='race']").css("color", "#2E2E2E")
    $("[for='race']").next().css("color", "#2E2E2E")
    $("[for='race']").nextUntil("label.questions").children("label.radio").css("color","#2E2E2E")
    $("[for='race']").nextUntil("label.questions").children("input").attr("disabled",false)
}

function enableServingOfLeafyGreenVegatables() {
    $("[for='veg_amount']").css("color", "#2E2E2E")
    $("[for='veg_amount']").nextUntil("label.questions").children("select").attr("disabled", false)        
}

function disableServingOfLeafyGreenVegatables() {
    $("[for='veg_amount']").css("color", "#C0C0C0")
    $("[for='veg_amount']").nextUntil("label.questions").children("select").attr("disabled", true)        
}

function enableHoursPerWeekModerateActivity() {
    $("[for='moderate_hours']").css("color", "#2E2E2E")
    $("[for='moderate_hours']").nextUntil("label.questions").children("select").attr("disabled", false)        
}

function disablehoursPerWeekModerateActivity() {
    $("[for='moderate_hours']").css("color", "#C0C0C0")
    $("[for='moderate_hours']").nextUntil("label.questions").children("select").attr("disabled", true)        
}

function enableHoursPerWeekVigorousActivity() {
    $("[for='vigorous_hours']").css("color", "#2E2E2E")
    $("[for='vigorous_hours']").nextUntil("label.questions").children("select").attr("disabled", false)        
}

function disableHoursPerWeekVigorousActivity() {
    $("[for='vigorous_hours']").css("color", "#C0C0C0")
    $("[for='vigorous_hours']").nextUntil("label.questions").children("select").attr("disabled", true)        
}

function disableColonSigmoidoscopyQuestion() {
    $("[for='polyp']").css("color", "#C0C0C0")
    $("[for='polyp']").nextUntil("label.questions").children("label.radio").css("color","#C0C0C0")
    $("[for='polyp']").nextUntil("label.questions").children("input").attr("disabled", true)    
}

function enableColonSigmoidoscopyQuestion() {
    $("[for='polyp']").css("color", "#2E2E2E")
    $("[for='polyp']").nextUntil("label.questions").children("label.radio").css("color","#2E2E2E")
    $("[for='polyp']").nextUntil("label.questions").children("input").attr("disabled", false)    
}

function disasbleLastPeriodWhen() {
    $("[for='last_period']").css("color", "#C0C0C0")
    $("[for='last_period']").nextUntil("label.questions").children("select").attr("disabled", true)        
}

function enableLastPeriodWhen() {
    $("[for='last_period']").css("color", "#2E2E2E")
    $("[for='last_period']").nextUntil("label.questions").children("select").attr("disabled", false)        
}

function disableHormoneTreatment() {
    $("[for='hormone_treatment']").css("color", "#C0C0C0")
    $("[for='hormone_treatment']").next().css("color", "#C0C0C0")
    $("[for='hormone_treatment']").next().next().children("label.radio").css("color","#C0C0C0")
    $("[for='hormone_treatment']").next().next().children("input").attr("disabled", true)    
}

function enableHormoneTreatment() {
    $("[for='hormone_treatment']").css("color", "#2E2E2E")
    $("[for='hormone_treatment']").next().css("color", "#2E2E2E")
    $("[for='hormone_treatment']").next().next().children("label.radio").css("color","#2E2E2E")
    $("[for='hormone_treatment']").next().next().children("input").attr("disabled", true)    
}

function enableAmountOfFamilyRelatives() {
    $("[for='family_count']").css("color", "#2E2E2E")
    $("[for='family_count']").next().children("input").attr("disabled", false)  
    $("[for='family_count']").next().children("label.radio").css("color", "#2E2E2E")               
}

function disableAmountOfFamilyRelatives() {
    $("[for='family_count']").css("color", "#C0C0C0")
    $("[for='family_count']").next().children("input").attr("disabled", true)  
    $("[for='family_count']").next().children("label.radio").css("color", "#C0C0C0")                  
}

function enableAgeWhenStartedSmoking() {
    $("[for='firstYearSmoke']").css("color", "#2E2E2E")
    $("[for='firstYearSmoke']").nextUntil("label.questions").children("select").attr("disabled", false)        
}

function disableAgeWhenStartedSmoking() {
    $("[for='firstYearSmoke']").css("color", "#C0C0C0")
    $("[for='firstYearSmoke']").nextUntil("label.questions").children("select").attr("disabled", true)        
}

function enableCurrentlySmokeCigarettes() {
    $("[for='currentlySmoke']").css("color", "#2E2E2E")
    $("[for='currentlySmoke']").nextUntil("label.questions").children("input").attr("disabled", false)
    $("[for='currentlySmoke']").nextUntil("label.questions").children("label.radio").css("color", "#2E2E2E")                            
}

function disableCurrentlySmokeCigarettes() {
    $("[for='currentlySmoke']").css("color", "#C0C0C0")
    $("[for='currentlySmoke']").nextUntil("label.questions").children("input").attr("disabled", true) 
    $("[for='currentlySmoke']").nextUntil("label.questions").children("label.radio").css("color", "#C0C0C0")                      
}

function enableAgeQuitSmoking() {
    $("[for='smoke_quit']").css("color", "#2E2E2E")
    $("[for='smoke_quit']").next().css("color", "#2E2E2E")
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("disabled", false)
    /* $("[for='smoke_quit']").nextUntil("label.questions").children("label.radio").css("color", "#2E2E2E")  */                          
}

function disableAgeQuitSmoking() {
    $("[for='smoke_quit']").css("color", "#C0C0C0")
    $("[for='smoke_quit']").next().css("color", "#C0C0C0")    
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("disabled", true) 
    /* $("[for='smoke_quit']").nextUntil("label.questions").children("label.radio").css("color", "#C0C0C0") */                    
}

function enableCigarettesSmokedPerDay() {
    $("[for='cigarettes_num']").css("color", "#2E2E2E")
    $("[for='cigarettes_num']").next().children("select").attr("disabled", false)
}

function disableCigarettesSmokedPerDay() {
    $("[for='cigarettes_num']").css("color", "#C0C0C0")
    $("[for='cigarettes_num']").next().children("select").attr("disabled", true) 
}


/* This section will disable and eanble the select boxes dynamically  and should be refactored later on */
function adjustAmountPerServingBasedOnServings() {
    if ( this.value == '0' ) {
        disableServingOfLeafyGreenVegatables()
    } else {
        enableServingOfLeafyGreenVegatables()
    }
}

function adjustHoursPerWeekModerateActivity() {
    if ( this.value == '0' ) {
        disablehoursPerWeekModerateActivity()
    } else {
        enableHoursPerWeekModerateActivity()
    }

}

function adjustHoursPerWeekVigorousActivity() {
    if ( this.value == '0' ) {
        disableHoursPerWeekVigorousActivity()
    } else {
        enableHoursPerWeekVigorousActivity()
    }
}

function adjustLastTimeSheHadPeriod() {
    if ( this.value == '0' || this.value == '1') {
        disableHormoneTreatment()
    } else {
        enableHormoneTreatment()
    }
}

function adjustSmokingOnRegularBasis() {
    if ( this.value == '0' ) {
        disableCurrentlySmokeCigarettes()
        disableAgeQuitSmoking()
        disableCigarettesSmokedPerDay()
    } else {
        enableCurrentlySmokeCigarettes()
        enableAgeQuitSmoking()
        enableCigarettesSmokedPerDay()
    }
    
}

/* Toggle the gender form Male to Female or Female to Male */
function toggleGender(e) {
    var value = $(e.target).val();
    switch (value) {
        case "Male":
            $.each($(".female").find("input, select"), function(index, el) {
                $(el).prop("required",false);
            });

            $.each($(".male").find("input, select"), function(index, el) {
                $(el).prop("required", true)
            });

            $(".female").removeClass('show');
            $(".male").addClass('show');
            break;
        case "Female":
            $.each($(".male").find("input, select"), function(index, el) {
                $(el).prop("required", "false")
                if($("[name='" + el.name + "']").val().length > 0)
                    $("[name='" + el.name + "']").val("");
                });

            $.each($(".female").find("input, select"), function(index, el) {
                $(el).prop("required",true);
            });

            $(".male").removeClass('show');
            $(".female").addClass('show');
            break;
        default:
            $(".male, .female").removeClass('show').find("input, select").removeAttr("required");
            $.each($(".male, .female").find("input, select"), function(index, el) {
                $(el).prop("required",true);
            });
            break;
    }
}




  // Disables the form if has a mutation in the BRCA1 or BRCA2 or trigger the
  // from to check if the calcualte button can be enabled
  // $("input[name='geneticMakeup']").on("click", function(event) {
	//    if(this.value == 0 ) {
  //     $("#hasBRCAMutation").modal("show");
  //     disableForm();
	//    } else {
  //     		$("#riskForm").trigger("change")
  //    }
  // });

  // Enables the form when the user clicks ok for the dialog box be dispalyed
  // for any question in the patient eligibility phasse or the race
  // $("#okButtonCancerHistory").on("click",       enableBRATForm)
  // $("#okButtonMutationBRCA").on("click",        enableBRATForm)
  // $("#okButtonHispanicIssue").on("click",       enableBRATForm);
  // $("#okButtonUnknownIssue").on("click",        enableBRATForm);
  // $("#okButtonNativeAmericanIssue").on("click", enableBRATForm)
  // $("#okButtonAdminIssue").on("click", enableBRATForm)

  // There are two select boxes Race and Sub Race.   For both Asian and Hispanic
  // there will be values found in the Sub Race Drop down.  For any other
  // it should be the default question
  // $("#race").on("change", attachSubraceItems)
  // $("#race").on("change", displayProblemWithRace)
  // $("#race").on("change", adjustSubRaceMenuIfNecessary)
  // $("#race").ready(attachSubraceItems)

	// On this IOS Phone 6 the navigation bar line in the center was not getting positioned
	// correctly, so I am adding a callback to the #RACE drop down so that the navigation
	// bar get drawn correctly everytime.
	// $("#race").on("change", handleScrollEvent);

  	// If the Asian Selection from the list has been selected then enable the sub_race
	// $("#sub_race").prop("disabled", true)
 	// $("[for='sub_race']").css("color","#c0c0c0");
 	// //$("#hispanicIssue").on("change", changeSubraceMenu);

  	// If the Number of Biopsies is None or 0 the questions about "How many breast biopies" and "atypical hyperlasia" should be disabled
	// $("#biopsyAnswerYes").on("click", enableQuestionAndAnswers)
 	// $("#biopsyAnswerNo").on("click", disableQuestionAndAnswers);
  // $("#biopsyAnswerUnknown").on("click", disableQuestionAndAnswers);

 	// If the question about a women every having a biopsy is answered disable the questions associated with it.
  //womanHadBiopsy();

  	// Display the help window
//  	$(".definition").on("click", displayHelpWindow);

  	// Initialize the button that will reset the form
//  	$("#reset").on("click", resetForm)

  	// Add specifc test for the Breast Cancer Rat ( All Patient Eligibility)
  	// that make the caculate button disabled if all the question are not answered
  	// with No
//  	$("#riskForm").on("change", disableIfPatientIsNotEligible);
//  	$('#riskForm').trigger('change');
//});
// 
// Brings up the dialog box explaining why the data is inaccurate for hispnaics,
// Native Americans/Alaskians and how the unknownn is handled
// function displayProblemWithRace() {
//     if( this.value == "Hispanic"){
//         $("#hispanicIssue").modal("show");
//         disableForm();
//     } else if ( this.value == "Other") {
//         $("#unknownIssue").modal()
//         disableForm();
//     } else if ( this.value == "Native American") {
//         $("#NativeAmericanIssue").modal();
//         disableForm();
//     }
//})

// Attach the corrct items to the drop down for the subrace.  The correct items
// is based on the race.
// function attachSubraceItems() {

//   // Problem : On the iphone the String "Select sub race/ethnicity or place of birth"
//   // goes way pass the border, so for the mobile phone the phrase will be
//   // "Select place of birth?"
//   var properPhraseForQuestion = "Select"

//   if ( this.value == "Hispanic") {
//     attachOptionsToAnHTMLObject(
//       {
//         ""                 : properPhraseForQuestion,
//         "Foreign Hispanic" : "Born outside the US",
//         "US Hispanic"      : "US born"
//       })
//   } else if ( this.value == 'Asian') {
//     attachOptionsToAnHTMLObject(
//       {
//         ""            : properPhraseForQuestion,
//         "Chinese"     : "Chinese",
//         "Filipino"    : "Filipino",
//         "Hawaiian"    : "Hawaiian",
//         "Islander"    : "Islander",
//         "Japanese"    : "Japanese",
//         "Asian"       : "Other Asian"
//       })
//   } else {
//     attachOptionsToAnHTMLObject(
//       {
//         ""            : properPhraseForQuestion
//       })
//   }
// }

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
// function adjustSubRaceMenuIfNecessary() {
//   if( this.value == "White" ||
//       this.value == "Black" ||
//       this.value == "Other" ) {
//       disableSubRaceMenu()
//   } else if ( this.value == 'Asian') {
//       changeSubraceMenu()
//   }
// }

// Create and Attach a set of options to an HTML Object
// function attachOptionsToAnHTMLObject(optionsValuesAndText) {
//   $("#sub_race").empty();
//   $.each(optionsValuesAndText, function (val, text) {
//     $("#sub_race").
//       append( $("<option></option>").val(val).html(text).addClass("content") );
//   });
// }

// If Any question is "Yes" in the Patient Eligibility is selected then
// disable the calculate button
// function disableIfPatientIsNotEligible() {
//   var totalButtonsSelected = $("#patient-eligibility-section input:checked").length
//   var totalButtonsWithYes = $("#patient-eligibility-section input[id$='Yes']:checked").length
//   if ( (totalButtonsSelected != 2) || (totalButtonsWithYes > 0) )
//     disablebutton()
// }

// /* A specialized version of the enableForm function where we determine if  */
// /* certain fields should be enabled.                                       */
// function enableBRATForm() {
//   enableForm();
//   womanHadBiopsy();
//   changeSubraceMenu();

//   if ( $("[name='biopsy']:checked").val() == 1 ) enableQuestionAndAnswers();

//   enableButtonIfAllFieldHaveInput();
//   //disablebutton();
//   disableIfPatientIsNotEligible()
// }

// Function : Determine if the woman every had a biopsy and disable certain
// questions if the answer was no
// function womanHadBiopsy() {
//   var biopsyValue = $("input:radio[name='biopsy']:checked").val();
//   if ( biopsyValue == 0 || biopsyValue == 99 ) {
//     		disableQuestionAndAnswers();
//   }
// }

// Disable a question and it answers that are associated with a woman having a
// breast biopsy
// function disableQuestionAndAnswers(event) {
//   $("input[name='biopsy_result']").attr("disabled", true);
//   $("input[id^='breastBiopsiesCount']").css("color", "#C0C0C0")
//   $("label[for^='breastBiopsiesCount']").css("color", "#C0C0C0")

//   $("input[name='biopsy_ah']").attr("disabled", true);
//   $("label[id^='hadAh']").css("color", "#C0C0C0");
//   $("label[for^='hadAh']").css("color", "#C0C0C0");

// }

// Enable Questions and Answersi that are associated with a women having a
//breast biopsy
// function enableQuestionAndAnswers(event) {
//   $("input[name='biopsy_result']").attr("disabled", false);
//   $("input[id^='breastBiopsiesCount']").css("color", "#606060")
//   $("label[for^='breastBiopsiesCount']").css("color", "#2E2E2E")

//   $("input[name='biopsy_ah']").attr("disabled", false);
//   $("input[id^='hadAh']").css("color", "#606060");
//   $("label[for^='hadAh']").css("color", "#2E2E2E");

//   adjust_line_width();
// }

/* Reset the drop down to its default value */
// function resetsDropDowns() {
//   function resetsAgeDropDown()      { $("#age option:eq(0)").attr("selected", "selected")             }
//   function resetsRaceDropDown()     { $("#race option:eq(0)").attr("selected", "selected")            }
//   function resetsChildBirthAge()    { $("#childbirth_age option:eq(0)").attr("selected", "selected")  }
//   function resetsSubRaceDropDown()  { $("#sub_race option:eq(0)").attr("selected", "selected")        }

//   resetsAgeDropDown();
//   resetsRaceDropDown();
//   resetsSubRaceDropDown();
//   resetsChildBirthAge();
// }

// If the value of the race menu is not "Asian" the subrace dropddown select box
// function changeSubraceMenu() {
//   if ( $("#race").val() == "Asian" || $("#race").val() == "Hispanic")
//     enableSubRaceMenu()
//   else
//     disableSubRaceMenu();
// }

// Enables the Sub Race Menu
// function enableSubRaceMenu() {
//   $("[for='sub_race']").css("color","#2e2e2e");
//   $("#sub_race").prop("disabled", false)
// }

// Disables the Sub Race Menu
// function disableSubRaceMenu() {
//   $("[for='sub_race']").css("color","#c0c0c0");
//   $("#sub_race").prop("disabled", true)
//   $("#sub_race option:eq(0)").prop("selected","selected");

// }

/* Produces the results box for the RAT                                      */

function resultsDisplay(response, textStatus, xhr) {

    var result = JSON.parse(response.message)
    go_toresult()
    
    var messageBeginning = "Based on the information provided, the patient's estimated risk for developing colorectal cancer over "
    var message5years    = "the next 5 years is !Fillin! compared to a risk of FillIn "
    var message10years   = "the next 10 years is !FillIn! compareed to a risk of FillInc"
    var messageLifeTime  = "their lifetime ( to age 90) is !Fill in! compared to a risk of !Fill In!"
    var messageEnding    = "for a patient of the same age and race/ethnicity from the general US population.";
  
  
    $("#results_text_5_years").text(messageBeginning + message5years + messageEnding);
    $("#results_text_10_years").text(messageBeginning + message10years + messageEnding);
    $("#results_text_lifetime").text(messageBeginning + messageLifeTime + messageEnding);
  
    var fiveYearPatientRiskColor    = ( result.risk > result.averageFiveYearRisk            ) ? "#BB0E3D" : "#2DC799";
    var tenYearPatientRiskColor     = ( result.patient10YearRisk > result.average10YearRisk   ) ? "#BB0E3D" : "#2DC799";
    var lifetimePateientRiskColor   = ( result.patientLifetimeRisk > result.averageLifetimeRisk    ) ? "#BB0E3D" : "#2DC799";
    
	//$("#results_text_5_years").html(results_text_5_years);
    //$("#results_text_10_years").html(results_text_10_years);
    //$("#results_text_lifetime").html(results_text_lifetime)

	$("#Risk1").text(result.risk+"%");
    $("#Risk2").text(result.average5YearRisk+"%");
	$("#Risk3").text(result.patient10YearRisk+"%");
    $("#Risk4").text(result.average10YearRisk+"%");    
	$("#Risk5").text(result.patientLifetimeRisk+"%");
    $("#Risk6").text(result.averageLifetimeRisk+"%");
    
	make_pie_chart(result.risk,                  "#pieChart1", fiveYearPatientRiskColor,  "#EFEFEF");
    make_pie_chart(result.average5YearRisk,      "#pieChart2", "#40A5C1",                 "#EFEFEF");
	make_pie_chart(result.patient10YearRisk,     "#pieChart3", tenYearPatientRiskColor,  "#EFEFEF");
    make_pie_chart(result.average10YearRisk,     "#pieChart4", "#40A5C1",                 "#EFEFEF");    
	make_pie_chart(result.patientLifetimeRisk,   "#pieChart5", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.averageLifetimeRisk,   "#pieChart6", "#40A5C1",                 "#EFEFEF");
}

function resetForm() {
  genericResetForm()
  enableQuestionAndAnswers();
  disableSubRaceMenu();
  resetsDropDowns();
  enableSectionHeaders();
}

/*
  * Filter the Input Parameters based on the current gendar ( male, female ) 
  *
  *	Assumption : By now the user should have selected Male or Female
  *
  * The rat.js will be expecting the following prototype and the exact function name
  *		prototype: boolean filterForInputParametersDisplay(HTMLObject)
  *     functionName : filterForInputParametersDisplay
  *
  * When looking at this remember female contains male and will include("male") will return true for both.
  *
  * Input
  *    An HTML Object 
  * 
  * Output 
  *    Boolean ( true means the elemenet will not be filtered ) 
  */
  function filterForInputParametersDisplay(element)
  {
     var selectedGender 	= $("input[name='gender']:checked").val().toLowerCase()
     var maleGender 		= $("#maleGender").val().toLowerCase()
     var femaleGender 	= $("#femaleGender").val().toLowerCase()
 
     // Get the CSS Styles and determine whether it contians male or female ( remember female.include(male) == true )
     var cssStyles = $(element).parent().attr("class").toLowerCase()
     var containsFemaleGender 	= cssStyles.includes(femaleGender);
     var containsMaleGender      = ( containsFemaleGender ) ? false : cssStyles.includes(maleGender)
     var isSelectedGenderFemale 	= ( selectedGender == femaleGender )
     
     var resultSelectedGender = false
     if ( isSelectedGenderFemale == true && containsFemaleGender == true ) 
         resultSelectedGender = true
     else if ( isSelectedGenderFemale == false && containsMaleGender == true ) 
         resultSelectedGender = true
     
     // In order to be true neither gender must be used or the select gender must be found in the CSS Styles
     var result = ( (containsMaleGender == false && containsFemaleGender == false) || resultSelectedGender ) ? true : false
     
     return result;
  }
 
