// A collection of term/definitions
// var terms = {
//   "invasive breast cancer" : {
//     definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
//   }
// };

$(function() {

    disableFields()

    // For the forms-step make sure that the last text link is right justified
    // since we do not know the gender yet.
    if ( existFormSteps() ) toggleGender();

    // A bug in the number field report see the CSS for comments for the numberField Border
    $(".numberField").addClass("numberFieldBorder")

    // For the foot/inches/weight fields validate the values values and if outside
    // the correct range alert the user
    $("[name='height_ft']").on("blur", function() {
        validateNumericAndDisplayErrorMessage($(this), "feetModal")
    })

    $("[name='height_in']").on("blur", function() {
        validateNumericAndDisplayErrorMessage($(this), "inchesModal")
    })

    $("[name='weight']").on("blur", function() {
        validateNumericAndDisplayErrorMessage($(this), "weightModal")
    })

    // Disables the form if the race is Hispanic or Latino then display some
    // information and disble the form.
    $("input[name='hispanic']").on("click", function(event) {
        if(this.value == 0){
            configureRaceDialog( "hispanic", enableCRATFormWithRaceDisabled )
   	    } else {
            $("#riskForm").trigger("change")
            enableRaceQuestion()
        }
    })

    $("#age").change(removeErrorMessage)
 

    $("[name='race']").not("[value='White']").on("click", function(event) {

        // Bring up the dialog
        configureRaceDialog($(this).val(), enableCRATForm)

        // Check the actual radio box
        $(event.target).prop("checked", true)

    });

    // Enables the form when the user clicks ok for the dialog box be dispalyed
    $("#smokingAgeErrorOkButton").on("click",       enableCRATForm)
    $("#foot-notice").on("click",                   enableCRATForm)
    $("#inch-notice").on("click",                   enableCRATForm)
    $("#weight-notice").on("click",                 enableCRATForm)

    $("[name='gender']").on("change",          toggleGender);

    // For Diet and Activity Section if the user select no servings disable the amont per serving
    $("#veg_servings").on("change",                 adjustAmountPerServingBasedOnServings)
    $("#moderate_months").on("change",              adjustHoursPerWeekModerateActivity)
    $("#vigorous_months").on("change",              adjustHoursPerWeekVigorousActivity)

    // For Medical History : During the past 10 years, did the patient have a colonoscopy, sigmoidoscopy, or both?
    $("#colonSigmoidoscopyYes").on("change",        function() { enableRadioButtonGroupQuestion($("#polyp")) })
    $("#colonSigmoidoscopyNo").on("change",         function() { disableRadioButtonGroupQuestion($("#polyp"))  })
    $("#colonSigmoidoscopyUnknown").on("change",    function() { disableRadioButtonGroupQuestion($("#polyp"))  })

    // For Medical History : Does the patient still have periods
    $("#periodYes").on("click",  function() { disableSelectBox($("[for='last_period']")) })
    $("#periodYes").on("click",  disableHormoneTreatment)
    $("#periodNo").on("click",   function() { enableSelectBox($("[for='last_period']")) })
    $("#periodNo").on("click",   adjustLastTimeSheHadPeriod)

    // For Medical History : when did the patient have her last period
    $("#last_period").on("change", adjustLastTimeSheHadPeriod)

    // Family History : Does the patient have any immediate relatives
    $("#familyCancerYes").on("change",      function() { enableRadioButtonGroupQuestion($("#family_count"))  })
    $("#familyCancerNo").on("change",       function() { disableRadioButtonGroupQuestion($("#family_count")) })
    $("#familyCancerUnknown").on("change",  function() { disableRadioButtonGroupQuestion($("#family_count")) })

    // Smoking : Has the patient every smoke more than 100 Cigarettes
    $("#smokeYes").on("click",      function() { enableSelectBox($("[for='firstYearSmoke']")) })
    $("#smokeYes").on("click",      enableCurrentlySmokeCigarettes)
    $("#smokeYes").on("click",      adjustSmokingOnRegularBasis)

    $("#smokeNo").on("click",       function() { disableSelectBox($("[for='firstYearSmoke']")) })
    $("#smokeNo").on("click",       disableCurrentlySmokeCigarettes)
    $("#smokeNo").on("click",       disableAgeQuitSmoking)
    $("#smokeNo").on("click",       disableCigarettesSmokedPerDay)

    $("#smokeUnknown").on("click",  function() { disableSelectBox($("[for='firstYearSmoke']")) })
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

    if ( $("#maleGender").length > 0 ) {
        toggleGender($("#maleGender"))
    }

    // The Quit Smoking Age will be dynamic since the value will be dependent
    // on the age that the person start smoking.  The values will be equal
    // to or greater than the values in the when did the pateient start Select
    // box
    updateQuitSmokingAge()

    // Make sure that the Quit Smoking only has ages greater than or equal to
    // the age the patient started smoking.
    $("#firstYearSmoke").on("change", function() {
      var startAgeForQuitSmoking = $("#firstYearSmoke option:selected").val()
      console.log("The value is " + startAgeForQuitSmoking)

      if ( $.isNumeric("") )
        updateQuitSmokingAge()
      else {
        var startSmokingAsInt = parseInt(startAgeForQuitSmoking)
        if ( startSmokingAsInt == 0 )
          updateQuitSmokingAge()
        else
          updateQuitSmokingAge(startSmokingAsInt)
      }
    })

  });

/* Sets the "Is the patient Hispanic or Latino?" Question to no */
function setHispanicQuestionToNo() {
    $("#hispanicNo").prop("checked", true)
    $("#hispanicNo").trigger("click")
}

/* A function that will set the correct race for the #raceValue and correct callback for the OK Button */
function configureRaceDialog( race, callbackForClickOkButton ) {
    var msg = "";
    if ( race === "hispanic" ) {
        msg = "When we first developed this tool, we tested it among non-Hispanic whites and found it to be accurate in estimating their risk of colorectal cancer. "
        msg = msg + "<span>&nbsp;&nbsp;</span>If the patient is Hispanic/Latino, this tool can still estimate their risk, but, "
        msg = msg + "because there are not as much data available for this group, the results may be less accurate."
    } else if ( race == "Black") {
        msg = "When we first developed this tool, we tested it with non-Hispanic whites and found it to be accurate in estimating their risk of colorectal cancer. "
        msg = msg + "<span>&nbsp;&nbsp;</span>If your patient is black/African American, this tool can still estimate his/her risk, but, "
        msg = msg + "because there are not as much data available for this group, the results may be less accurate."
    } else if ( race === 'Asian') {
        msg = "When we first developed this tool, we tested it among non-Hispanic whites and found it to be accurate in estimating their risk of colorectal cancer. "
        msg = msg + "<span>&nbsp;&nbsp;</span>If your patient is Asian or Pacific Islander, this tool can still estimate his/her risk, but, "
        msg = msg + "because there are not as much data available for this group, the results may be less accurate. "
    }

    $
    $("#raceModalParagraph1").html(msg);
    $("#raceOkButton").on("click",  callbackForClickOkButton)
    $("#raceModal").modal("show");
    setTimeout( function() { $("#raceModal").modal("show"); } , 500 )
    disableCRATForm();
}

/* Function validate Numeric are valid and if not shows a message  */
function validateNumericAndDisplayErrorMessage( element, modal ) {
        var validationPassed = validateNumber(element)
        if ( validationPassed == false ) {
            $("#" + modal).modal("show")
            disableCRATForm();
        }
}

/* Validates that a number is valid according to the rules of the application */
/* Assumption input type = number can only be a number or no input            */
function validateNumber(element) {

    var result

    let actualValue = $(element).val()
    let min=$(element).prop("min")
    let max=$(element).prop("max")

    /* If the valeu returned from parseInt is not a number then it will be the empty string */
    /* Any time we have no data gotoSectionider the validation to pass since there is nogthung to  */
    /* check                                                                                */
    var actualValueAsNumber = parseInt(actualValue)
    if ( isNaN(actualValueAsNumber))
        return true
    else
        result = ( actualValueAsNumber >= parseInt(min) && actualValueAsNumber <= parseInt(max) ) ? true : false
    return result;
}

/* A function that returns true if the height/weight is disabled */
function disableIfHeightOrWeightAreInvalid() {

    if ( ( validateNumber($("[name='height_ft']")) == false )  ||
         ( validateNumber($("[name='height_in']")) == false )  ||
         ( validateNumber($("[name='weight']"))    == false ))
        return true
    else
        return false
}


/* The fucntion disables for the form */
function disableCRATForm() {
    disableForm()
    $("[class*='numberField']").css("color","#C0C0C0")
    $("[class*='numberField']").prop("disabled", true)
    $("[class*='numberField']").next("span").css("color", "#C0C0C0")
}

/** Group of fucntions that disable/enable the next question should be put together in one function */

function enableCRATFormWithRaceDisabled() {
    enableCRATGenericForm();
    disableRaceQuestion()

}

function enableCRATForm() {
    enableCRATGenericForm()
    if ( $("[name='hispanic']").prop("value") != "0" )
        disableRaceQuestion()
    else {
        enableRaceQuestion()
        //clearAnswerToHispanicYes()
    }
}

/* A generic functon for enabling the CRAT Form.  Hanldes all the common functionality */
function enableCRATGenericForm() {
    enableForm();

    // Style the Height and Weight to show they are neabled
    $("[class*='numberField']").css("color","#2E2E2E")
    $("[class*='numberField']").prop("disabled", false)
    $("[class*='numberField']").next("span").css("color", "#2E2E2E")

    // Enable and Disable the HTML Objects based on the current values of the form.
    adjustAmountPerServingBasedOnServings()
    adjustHoursPerWeekModerateActivity()
    adjustHoursPerWeekVigorousActivity()

    examResult = $("[name='exam']:checked").val()
    if ( examResult == 1 || examResult == 2 )
        disableRadioButtonGroupQuestion($("#polyp"))
    else
        enableRadioButtonGroupQuestion($("#polyp"))

    //
    // We are very close to a release, but if we get some time then I believe
    // we can change disablleAmountOfFamilyRelatives, enableAmountOfFamilyRelatives
    // to disableRadioButtonGroupQuestion/enableRadioButtonGroupQuestion
    //
    if ( $("[name='family_cancer']:checked").val() == "0")
        disableAmountOfFamilyRelatives()
    else
        enableAmountOfFamilyRelatives()

    // Enable and Disable the HTML Objects based on the current values of the form for female
    if ( $("[name='gender']:checked").val() == "Female") {

        if ( $("[name='period']:checked").val() == "0" ) {
            disableSelectBox($("[for='last_period']"))      //disasbleLastPeriodWhen()
            disableHormoneTreatment()
        } else {
            enableSelectBox($("[for='last_period']"))

            if ( $("[name='last_period'] option:selected").val() == "2" ) {
                enableHormoneTreatment()
            } else {
                disableHormoneTreatment()
            }
        }
    }

    // Enable and Disable the HTML Objects based on the current value fo the form for male
    if ($("[name='gender']:checked").val() == "Male") {
        var cigarettesCount = $("[name='cigarettes']:checked").val()
        if (  cigarettesCount == "0" || cigarettesCount === undefined )
        {
            enableSelectBox($("[for='firstYearSmoke']"))
            adjustSmokingOnRegularBasis()
        } else {
            disableSelectBox($("[for='firstYearSmoke']"))
            disableCurrentlySmokeCigarettes()
            disableAgeQuitSmoking()
            disableCigarettesSmokedPerDay()
        }

    }

    // If the race is not hispnaic then make sure that the No for the question :
    // "Is the patient Hispanic or Latino is marked as No".  Since when user causes
    // the dialog to appear for race the answer to the answer to the
    // "Is the patient Hispanic" or Latino question will disappear
    if ( $("[name='race']:checked") != "" ) setHispanicQuestionToNo()

    disableFields()

}

/* Disabled the Age Quit Smoking Select Box when the user is currently smokng */
/* Refactor : Merge all the enable and disable of the smoking into cleaner    */
/* Problems : The HTML Ojbects ( <select> use callbacks where each callback)  */
/* The reset function uses a block of code to the same functionality          */
/* At some point these should be merged                                       */
function correctlyEnableSmokeQuit() {
   if ( $("[name='smoke_now']:checked").val() == "1")
      disableAgeQuitSmoking()
   else
      enableAgeQuitSmoking()
}

/* Disables the race question and its answers                                                */
/* This section should be refactored, but can be done as a TODO later on                     */
function disableRaceQuestion() {
    $("#race").css("color", "#C0C0C0")
    $("#race").next().css("color", "#C0C0C0")
    $("#race").nextUntil("label.questions").children("div.responseOptions > div").css("color","#C0C0C0")
    $("#race").nextUntil("label.questions").children("input").attr("disabled","disabled")

    $("#race").nextUntil("label.questions").children("div.responseOptions > div").attr("tabindex", "-1")

    $("#hispanicYes").prop("checked", true)
}

/* Enables the race question and its answers */
function enableRaceQuestion() {
    $("#race").css("color", "#2E2E2E")
    $("#race").next().css("color", "#2E2E2E")
    $("#race").nextUntil("label.questions").children("div.responseOptions > div").css("color","#2E2E2E")
    $("#race").nextUntil("label.questions").children("input").attr("disabled",false)

    $("#race").nextUntil("label.questions").children("label.radio").attr("tabindex", "0")
    $("#race").nextUntil("label.questions").children("div.responseOptions > div").attr("tabindex", "0")

    $("#hispanicYes").prop("checked", false)
}

// Clears the Yes answer to the question "Is the patient Hispanic or Latino?"
function clearAnswerToHispanicYes() {
  $("#hispanicYes").prop("checked", false)
}

// Standard Routine to disable a select box in the GUI
function disableSelectBox(element) {
    $(element).css("color", "#C0C0C0")
    $(element).nextUntil("label.questions").children("select").attr("disabled", true)
    $(element).nextUntil("label.questions").children("select").attr("tabindex", "-1")
}

// Standard Routine to enable a select box in the GUI
function enableSelectBox(element) {
    $(element).css("color", "#2E2E2E")
    $(element).nextUntil("label.questions").children("select").attr("disabled", false)
    $(element).nextUntil("label.questions").children("select").attr("tabindex", "0")
}

// Standard routine to disable a question and answer with radio buttons
function disableRadioButtonGroupQuestion(element) {
    $(element).css("color", "#C0C0C0")
    $(element).nextUntil("label.questions").children("div.radio").css("color","#C0C0C0")
    $(element).nextUntil("label.questions").children("input").attr("disabled", true)

    $(element).nextUntil("label.questions").children("div.radio").attr("tabindex", "-1")
    $(element).nextUntil("label.questions").children("input").attr("tabindex", "-1")
}

function enableRadioButtonGroupQuestion(element) {
    $(element).css("color", "#2E2E2E")
    $(element).nextUntil("label.questions").children("div.radio").css("color","#2E2E2E")
    $(element).nextUntil("label.questions").children("input").attr("disabled", false)

    $(element).nextUntil("label.questions").children("div.radio").attr("tabindex", "0")
    $(element).nextUntil("label.questions").children("input").attr("tabindex", "0")
}

function disableAmountOfFamilyRelatives() {
    $("#family_count").css("color", "#C0C0C0")
    $("#family_count").next().children("input").attr("disabled", true)
    $("#family_count").next().children("div.radio").css("color", "#C0C0C0")
    $("#family_count").nextUntil("label.questions").children("div.radio").attr("tabindex", "-1")
    $("#family_count").nextUntil("label.questions").children("input").attr("tabindex", "-1")

}

function enableAmountOfFamilyRelatives() {
    $("#family_count").css("color", "#2E2E2E")
    $("#family_count").next().children("input").attr("disabled", false)
    $("#family_count").next().children("label.radio").css("color", "#2E2E2E")
    $("#family_count").nextUntil("label.questions").children("label.radio").attr("tabindex", "0")
    $("#family_count").nextUntil("label.questions").children("input").attr("tabindex", "0")

}

function disableCurrentlySmokeCigarettes() {
    $("#currentlySmokeLabel").css("color", "#C0C0C0")
    $("#currentlySmokeLabel").nextUntil("label.questions").children("input").attr("disabled", true)
    $("#currentlySmokeLabel").nextUntil("label.questions").children("div.radio").css("color", "#C0C0C0")

    $("#currentlySmokeLabel").nextUntil("label.questions").children("div.radio").attr("tabindex", "-1")
    $("#currentlySmokeLabel").nextUntil("label.questions").children("input").attr("tabindex", "-1")

}

function enableCurrentlySmokeCigarettes() {
    $("#currentlySmokeLabel").css("color", "#2E2E2E")
    $("#currentlySmokeLabel").nextUntil("label.questions").children("input").attr("disabled", false)
    $("#currentlySmokeLabel").nextUntil("label.questions").children("div.radio").css("color", "#2E2E2E")

    $("#currentlySmokeLabel").nextUntil("label.questions").children("div.radio").attr("tabindex", "0")
    $("#currentlySmokeLabel").nextUntil("label.questions").children("input").attr("tabindex", "0")

}

function disableAgeQuitSmoking() {
    $("#smokeQuitLabel").css("color", "#C0C0C0")
    $("#smokeQuitLabel").next().css("color", "#C0C0C0")
    $("#smokeQuitLabel").nextAll("div").children("select").attr("disabled", true)
    $("#smokeQuitLabel").nextUntil("label.questions").children("select").attr("tabindex", "-1")

}

function enableAgeQuitSmoking() {
    $("#smokeQuitLabel").css("color", "#2E2E2E")
    $("#smokeQuitLabel").next().css("color", "#2E2E2E")
    $("#smokeQuitLabel").nextAll("div").children("select").attr("disabled", false)
    $("#smokeQuitLabel").nextUntil("label.questions").children("select").attr("tabindex", "0")

}

function disableCigarettesSmokedPerDay() {
    $("[for='cigarettes_num']").css("color", "#C0C0C0")
    $("[for='cigarettes_num']").nextAll("div").children("select").attr("disabled", true)
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("tabindex", "-1")

}

function enableCigarettesSmokedPerDay() {
    $("[for='cigarettes_num']").css("color", "#2E2E2E")
    $("[for='cigarettes_num']").next().children("select").attr("disabled", false)
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("tabindex", "-1")

}

function disableHormoneTreatment() {
    $("#hormone_treatment").css("color", "#C0C0C0")
    $("#hormone_treatment").next().css("color", "#C0C0C0")
    $("#hormone_treatment").nextUntil("label.questions").children("div.radio").css("color","#C0C0C0")
    $("#hormone_treatment").nextUntil("label.questions").children("input").attr("disabled", true)
    $("#hormone_treatment").nextUntil("label.questions").children("div.radio").attr("tabindex", "-1")
    $("#hormone_treatment").nextUntil("label.questions").children("input").attr("tabindex", "-1")
}

function enableHormoneTreatment() {
    $("#hormone_treatment").css("color", "#2E2E2E")
    $("#hormone_treatment").next().css("color", "#2E2E2E")
    $("#hormone_treatment").nextUntil("label.questions").children("div.radio").css("color","#2E2E2E")
    $("#hormone_treatment").nextUntil("label.questions").children("input").attr("disabled", false)
    $("#hormone_treatment").nextUntil("label.questions").children("div.radio").attr("tabindex", "0")
    $("#hormone_treatment").nextUntil("label.questions").children("input").attr("tabindex", "0")
}

/* This section will disable and eanble the select boxes dynamically  and should be refactored later on */
function adjustAmountPerServingBasedOnServings() {
    if ( $("#veg_servings").val() == '0' || $("#veg_servings").val() == '' ) {
        disableSelectBox($("[for='veg_amount']"))
    } else {
        enableSelectBox($("[for='veg_amount']"))
    }
}

function adjustHoursPerWeekModerateActivity() {
    if ( $("#moderate_months").val() == '0' || $("#moderate_months").val() == '' ) {
        disableSelectBox($("[for='moderate_hours']"))
    } else {
        enableSelectBox($("[for='moderate_hours']"))
    }

}

function adjustHoursPerWeekVigorousActivity() {
    if ( $("#vigorous_months").val() == '0' || $("#vigorous_months").val() == '') {
        disableSelectBox($("[for='vigorous_hours']"))
    } else {
        enableSelectBox($("[for='vigorous_hours']"))
    }
}

//
// Todo : Fix the name of this function.  The problem is we are enabling/disabling
// the hormone treatment, but the does not indicate that.
function adjustLastTimeSheHadPeriod() {
    if ( $("[name='last_period']").val() == '0' || $("[name='last_period']").val() == '1') {
        disableHormoneTreatment()
    } else {
        enableHormoneTreatment()
    }
}

function adjustSmokingOnRegularBasis() {
    if ( $("[name='smoke_age']").val() == "0" ) {
        disableCurrentlySmokeCigarettes()
        disableAgeQuitSmoking()
        disableCigarettesSmokedPerDay()
    } else {
        enableCurrentlySmokeCigarettes()

        if ( $("[name='smoke_now']:checked").val() == "0" || $("[name='smoke_now']:checked").val() == undefined )
            enableAgeQuitSmoking()
        else
            disableAgeQuitSmoking()

        enableCigarettesSmokedPerDay()
    }

}

/* Toggle the gender form Male to Female or Female to Male */
function toggleGender(e) {

    var value = ( e === undefined ) ? "Unknown" : $(e.target).val()
    switch (value) {
        case "Male":
            // Used for form steps since some extra styling need to done
            $("#different").removeClass("maleOnlyStep")

            $("#form-steps ol li:last-child a:nth-child(2)").css("margin-right", "0");
            $("#form-steps ol li:nth-child(7) a:nth-child(2)").css("margin", "0 auto 0 auto")

            $(".female").removeClass('show');
            $(".male").addClass('show');

            $(".female").find("input, select").removeProp("required")
            $(".male").find("input, select").prop("required")
            break;
        case "Female":
            // Used for form steps since some extra styling need to done
            $("#different").addClass("maleOnlyStep")
            $("#form-steps ol li:nth-child(7) a:nth-child(2)").css("margin-right", "0 ")

            $(".male").removeClass('show');
            $(".female").addClass('show');

            $(".male").find("input, select").removeProp("required")
            $(".female").find("input, select").prop("required")
            break;
        default:

            // Used for form steps since some extra styling need to done
            $(".female, .male").removeClass('show')
            $(".female, .male").find("input, select").removeProp("required");
            $("#form-steps ol li:nth-child(7) a:nth-child(2)").css("margin-right", "0")
            $("#different").addClass("maleOnlyStep")
    }

    adjustNavigationBarLine()
    calcSizesOfSections()

}

/* Getting very close to the end and I don't have the time to fiture this out */
/* Howeever, when the male radio is clicked, the yes and no text of the       */
/* Do you currently smoke cigarettes?                                         */
function fixSmokingSection() {
  $("[for='currentlySmokeYes']").css("color", "#2E2E2E")
  $("[for='currentlySmokeNo']").css("color", "#2E2E2E")
}

/* Produces the results box for the RAT                                                        */
function resultsDisplay(response, textStatus, xhr) {

    function returnColorText(risk, averageRisk) {
        var colorText = undefined;
        if ( risk < averageRisk ) {
            colorText = "presented in green since it is lower than";
        } else if ( risk > averageRisk ) {
            colorText = "presented in red since it higher than";
        } else {
            colorText = "presented in green since it is the same as";
        }

        return colorText;
    }

    var result = JSON.parse(response.message)
    go_toresult()

    var messageBeginning = "Based on the information provided, the patient's estimated risk for developing colorectal cancer over "
    var message5years    = "the next 5 years is !Fillin1!% !Color1! the average risk of !Fillin2!% "
    var message10years   = "the next 10 years is !Fillin3!% !Color2! the average risk of !Fillin4!% "
    var messageLifeTime  = "their lifetime (to age 90) is !Fillin5!% !Color3! the average risk of !Fillin6!% "
    var messageEnding    = "for a patient of the same age, gender, and race/ethnicity from the general US population.";

    var colorText1 = returnColorText(result.risk, result.average5YearRisk);
    var colorText2 = returnColorText(result.patient10YearRisk, result.average10YearRisk);
    var colorText3 = returnColorText(result.patientLifetimeRisk, result.averageLifetimeRisk);

    console.log("The result is " + console.log(result))
    console.log("The message is ")

    message5years          = message5years.replace(  "!Fillin1!",    result.risk)
    message5years          = message5years.replace(  "!Color1!",     colorText1)
    message5years          = message5years.replace(  "!Fillin2!",    result.average5YearRisk)
    message10years         = message10years.replace( "!Fillin3!",    result.patient10YearRisk)
    message10years         = message10years.replace(  "!Color2!",     colorText2)
    message10years         = message10years.replace( "!Fillin4!",    result.average10YearRisk)
    messageLifeTime        = messageLifeTime.replace("!Fillin5!",    result.patientLifetimeRisk)
    messageLifeTime        = messageLifeTime.replace(  "!Color3!",     colorText3)
    messageLifeTime        = messageLifeTime.replace("!Fillin6!",    result.averageLifetimeRisk)

    $("#results_text_5_years").text(messageBeginning + message5years + messageEnding);
    $("#results_text_10_years").text(messageBeginning + message10years + messageEnding);
    $("#results_text_lifetime").text(messageBeginning + messageLifeTime + messageEnding);

    var fiveYearPatientRiskColor    = ( result.risk > result.average5YearRisk            ) ? "#BB0E3D" : "#2DC799";
    var tenYearPatientRiskColor     = ( result.patient10YearRisk > result.average10YearRisk   ) ? "#BB0E3D" : "#2DC799";
    var lifetimePateientRiskColor   = ( result.patientLifetimeRisk > result.averageLifetimeRisk    ) ? "#BB0E3D" : "#2DC799";

	$("#Risk1").text(result.risk+"%");
    $("#Risk2").text(result.average5YearRisk+"%");
	$("#Risk3").text(result.patient10YearRisk+"%");
    $("#Risk4").text(result.average10YearRisk+"%");
	$("#Risk5").text(result.patientLifetimeRisk+"%");
    $("#Risk6").text(result.averageLifetimeRisk+"%");

	make_pie_chart(result.risk,                 "#pieChart1", fiveYearPatientRiskColor,  "#EFEFEF");
    make_pie_chart(result.average5YearRisk,     "#pieChart2", "#40A5C1",                 "#EFEFEF");
	make_pie_chart(result.patient10YearRisk,    "#pieChart3", tenYearPatientRiskColor,   "#EFEFEF");
    make_pie_chart(result.average10YearRisk,    "#pieChart4", "#40A5C1",                 "#EFEFEF");
	make_pie_chart(result.patientLifetimeRisk,  "#pieChart5", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.averageLifetimeRisk,  "#pieChart6", "#40A5C1",                 "#EFEFEF");
}

function resetForm() {

  var heightWithActiveButton = $("#form-steps").outerHeight(true)

  // The Fifth Text ande Bubble Link in the form stops should not be visible
  $("#different").addClass("maleOnlyStep")

  // Click on the First Bubble Link so the application will go the top for section 1.
  if ( $("#different").hasClass("active") ) {
    $("#different").removeClass("active")
  }

  toggleGender(undefined)

  // Problem : Before this line this line was added the form step navigation
  // bar has the horizontal line at the top of the circles.  This is incorrect.
  // Due to research, I obeserved that the #form-steps div was not as large
  // as it usually was.  This wa due to having no li tag with the class active
  // when the form-steps was resized.  When I add the class active the form-steps
  // was being displayed correclty.
  $("#form-steps li:first-of-type").addClass("active")

  genericResetForm()
  enableRadioButtonGroupQuestion("#polyp")
  enableRadioButtonGroupQuestion("#family_count")
  enableHormoneTreatment()
  enableRaceQuestion()
  fixSmokingSection()
  enableSectionHeaders();

  adjustNavigationBarLine()

  disableFields()
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
     var selectedGender 	= $("[name='gender']:checked").val().toLowerCase()
     var maleGender 		= $("#maleGender").val().toLowerCase()
     var femaleGender 	    = $("#femaleGender").val().toLowerCase()

     // Get the CSS Styles and determine whether it contians male or female ( remember female.include(male) == true )
     var cssStyles = $(element).parent().attr("class").toLowerCase()
     var containsFemaleGender 	    = cssStyles.includes(femaleGender);
     var containsMaleGender         = ( containsFemaleGender ) ? false : cssStyles.includes(maleGender)
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

  // The purpose of this routine is to create an answer that is not based on radio buttons or the select box.  An
  // example would be the question about the feet/inches/pounds.
  function ratSpecificAnswer(element) {

      answer = $("[name='height_ft']").val() + "' " + $("[name='height_in']").val() + "'' and " + $("[name='weight']").val() + " lbs"
      return answer
  }

// Update the Select Box for the Age that the person quit smoking
// If the screen is getting updated and the user has already selected a values
// then
function updateQuitSmokingAge(startAge, endAge) {

    // For Internt Explorer you can define parameters in the function prototype
    // function updateQuitSmokingAge(startAge = 6, endAge = 55) {
    startAge = startAge || 6
    endAge = endAge || 55

    // A routine that will create a collection of option tags.   Each option tag
    // will contain an age/value.
    function createAgeOptionList() {

        var optionsData = []

        elementSelect = {}
        elementSelect.value = 0
        elementSelect.text = 'Select'
        optionsData.push(elementSelect)

        //elementNever = {}
        //elementNever.value = 1
        //elementNever.text = 'Never smoke Cigrarettes'
        //optionsData.push(elementNever)

        for ( var age = startAge; age <= endAge; age++ ) {
          var ageAsStr = parseInt(age)

          var element = {}
          element.value = age
          element.text = ageAsStr

          optionsData.push(element)
        }

        return optionsData
    }

    // Main Algoirthm

    $("#smoke_quit").children().remove()

    var optionsData = createAgeOptionList()
    $.each( optionsData, function(key, value) {
      $("#smoke_quit").append($("<option></option>").attr("value", value.value).text(value.text))
    })
}

// When the application is started are refreshed some of the questions/answers will be disabled.
function disableFields() {

    function noValueForSelectBox(htmlObject) {
        return ( $(htmlObject).val() == '0' || $(htmlObject).val() == '' ) ? true : false
    }

    function noValueForRadioGroup(htmlObjectName) {
        var selector = "[name='" + htmlObjectName + "']:checked"
        return ( $(selector).length == 0 ) ? true : false;
    }

    if ( noValueForSelectBox($("#veg_servings")) ) {
        disableSelectBox($("[for='veg_amount']"))
    }

    if ( noValueForSelectBox($("#moderate_months")) ) {
        disableSelectBox($("[for='moderate_hours']"))
    }

    if ( noValueForSelectBox($("#vigorous_months")) ) {
        disableSelectBox($("[for='vigorous_hours']"))
    }

    if ( noValueForRadioGroup("exam") ) {
        disableRadioButtonGroupQuestion("#polyp")
    }

    if ( noValueForRadioGroup("familyCount") ) {
        disableRadioButtonGroupQuestion("#family_count")
    }

    if ( noValueForRadioGroup("peroid") ) {
        disableSelectBox($("[for='last_period']"))
        disableHormoneTreatment()
    }

    if ( noValueForRadioGroup("cigarettes") ) {
        disableSelectBox($("[for='firstYearSmoke']"))
        disableCurrentlySmokeCigarettes()
        disableAgeQuitSmoking()
        disableCigarettesSmokedPerDay()
    }
}



