// A collection of term/definitions
// var terms = {
//   "invasive breast cancer" : {
//     definition : "https://www.cancer.gov/common/popUps/popDefinition.aspx?id=CDR0000537695&version=Patient&language=English"
//   }
// };

$(function() {

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
            configureRaceDialog( "Hispanic/Latino", enableCRATFormWithRaceDisabled )
   	    } else {
            $("#riskForm").trigger("change")
            enableRaceQuestion()
        }
    })

    $("[name='race']").not("[value='White']").on("click", function(event) {
        
        // Bring up the dialog 
        var currentRace = $(event.target).next().text()
        configureRaceDialog(currentRace, enableCRATForm)

        // Check the actual radio box
        $(event.target).prop("checked", true)

    });

    // Enables the form when the user clicks ok for the dialog box be dispalyed
    $("#smokingAgeErrorOkButton").on("click",       enableCRATForm)
    $("#foot-notice").on("click",                   enableCRATForm)
    $("#inch-notice").on("click",                   enableCRATForm)
    $("#weight-notice").on("click",                 enableCRATForm)

    // Each time the gender is toggle the form should determine if the calculate button should be enabled */
    $("[name='gender']").on("change",          toggleGender);
    $("[name='gender']").on("change",          enableCalculateButton);

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
    $("#familyCancerYes").on("change",      enableAmountOfFamilyRelatives)
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
    
    // While the user is typing the data inside the textbox enables/disable the
    // calculate buton if all the inputs are valid/invalid
    $("input[type=number]").bind('keyup input', function() { 
        if ( disableIfHeightOrWeightAreInvalid() == true ) {
            disablebutton()
        }
        else {
            enableCalculateButton()
        }
    });

    if ( $("#maleGender").length > 0 ) {
        toggleGender($("#maleGender"))
    }    

  });

/* Sets the "Is the patient Hispanic or Latino?" Question to no */
function setHispanicQuestionToNo() {
    $("#hispanicNo").trigger("click")
    $("#hispanicNo").prop("checked", true)
} 

/* A function that will set the correct race for the #raceValue and correct callback for the OK Button */
function configureRaceDialog( race, callbackForClickOkButton ) {
    $("#raceValue").text(race)
    $("#raceOkButton").on("click",  callbackForClickOkButton)
    $("#raceModal").modal("show");
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
    else 
        enableRaceQuestion()
    
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

    // If the race is not hispnaic then make sure that the No for the queistion : 
    // "Is the patient Hispanic or Latino is marked as No".  Since when user causes 
    // the dialog to appear for race the answer to the answer to the 
    // "Is the patient Hispanic" or Latino question will disappear
    var hispanicNoRadioButton = $("[name='hispanic']:checked")
    if ( $("[name='race']:checked") != "" ) setHispanicQuestionToNo()

    // Enable Buttons if all inputs are valid
    enableCalculateButton()
    if ( disableIfHeightOrWeightAreInvalid() ) disablebutton()

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
    $("#race").nextUntil("label.questions").children("label.radio").css("color","#C0C0C0")
    $("#race").nextUntil("label.questions").children("input").attr("disabled","disabled")

    $("#race").nextUntil("label.questions").children("label.radio").attr("tabindex", "-1")
    $("#race").nextUntil("label.questions").children("input").attr("tabindex", "-1")

    $("#hispanicYes").prop("checked", true)
}

/* Enables the race question and its answers */
function enableRaceQuestion() {
    $("#race").css("color", "#2E2E2E")
    $("#race").next().css("color", "#2E2E2E")
    $("#race").nextUntil("label.questions").children("label.radio").css("color","#2E2E2E")
    $("#race").nextUntil("label.questions").children("input").attr("disabled",false)

    $("#race").nextUntil("label.questions").children("label.radio").attr("tabindex", "0")
    $("#race").nextUntil("label.questions").children("input").attr("tabindex", "0")
 
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
    $(element).nextUntil("label.questions").children("label.radio").css("color","#C0C0C0")
    $(element).nextUntil("label.questions").children("input").attr("disabled", true)  
    
    $(element).nextUntil("label.questions").children("label.radio").attr("tabindex", "-1")
    $(element).nextUntil("label.questions").children("input").attr("tabindex", "-1")
}

function enableRadioButtonGroupQuestion(element) {
    $(element).css("color", "#2E2E2E")
    $(element).nextUntil("label.questions").children("label.radio").css("color","#2E2E2E")
    $(element).nextUntil("label.questions").children("input").attr("disabled", false)    

    $(element).nextUntil("label.questions").children("label.radio").attr("tabindex", "0")
    $(element).nextUntil("label.questions").children("input").attr("tabindex", "0")
}

function disableAmountOfFamilyRelatives() {
    $("#family_count").css("color", "#C0C0C0")
    $("#family_count").next().children("input").attr("disabled", true)  
    $("#family_count").next().children("label.radio").css("color", "#C0C0C0")  
    $("#family_count").nextUntil("label.questions").children("label.radio").attr("tabindex", "-1")
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
    $("#currentlySmoke").css("color", "#C0C0C0")
    $("#currentlySmoke").nextUntil("label.questions").children("input").attr("disabled", true) 
    $("#currentlySmoke").nextUntil("label.questions").children("label.radio").css("color", "#C0C0C0")   
    
    $("#currentlySmoke").nextUntil("label.questions").children("label.radio").attr("tabindex", "-1")
    $("#currentlySmoke").nextUntil("label.questions").children("input").attr("tabindex", "-1")

}

function enableCurrentlySmokeCigarettes() {
    $("#currentlySmoke").css("color", "#2E2E2E")
    $("#currentlySmoke").nextUntil("label.questions").children("input").attr("disabled", false)
    $("#currentlySmoke").nextUntil("label.questions").children("label.radio").css("color", "#2E2E2E")    
    
    $("#currentlySmoke").nextUntil("label.questions").children("label.radio").attr("tabindex", "0")
    $("#currentlySmoke").nextUntil("label.questions").children("input").attr("tabindex", "0")

}

function disableAgeQuitSmoking() {
    $("[for='smoke_quit']").css("color", "#C0C0C0")
    $("[for='smoke_quit']").next().css("color", "#C0C0C0")    
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("disabled", true) 
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("tabindex", "-1")

}

function enableAgeQuitSmoking() {
    $("[for='smoke_quit']").css("color", "#2E2E2E")
    $("[for='smoke_quit']").next().css("color", "#2E2E2E")
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("disabled", false)
    $("[for='smoke_quit']").nextUntil("label.questions").children("select").attr("tabindex", "0")

}

function disableCigarettesSmokedPerDay() {
    $("[for='cigarettes_num']").css("color", "#C0C0C0")
    $("[for='cigarettes_num']").next().children("select").attr("disabled", true)
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
    $("#hormone_treatment").next().next().children("label.radio").css("color","#C0C0C0")
    $("#hormone_treatment").next().next().children("input").attr("disabled", true)    
}

function enableHormoneTreatment() {
    $("#hormone_treatment").css("color", "#2E2E2E")
    $("#hormone_treatment").next().css("color", "#2E2E2E")
    $("#hormone_treatment").next().next().children("label.radio").css("color","#2E2E2E")
    $("#hormone_treatment").next().next().children("input").attr("disabled", false)    
}

/* This section will disable and eanble the select boxes dynamically  and should be refactored later on */
function adjustAmountPerServingBasedOnServings() {
    if ( $("#veg_servings").val() == '0' ) {
        disableSelectBox($("[for='veg_amount']"))
    } else {
        enableSelectBox($("[for='veg_amount']"))
    }
}

function adjustHoursPerWeekModerateActivity() {
    if ( $("#moderate_months").val() == '0' ) {
        disableSelectBox($("[for='moderate_hours']"))
    } else {
        enableSelectBox($("[for='moderate_hours']"))
    }

}

function adjustHoursPerWeekVigorousActivity() {
    if ( $("#vigorous_months").val() == '0' ) {
        disableSelectBox($("[for='vigorous_hours']"))
    } else {
        enableSelectBox($("[for='vigorous_hours']"))
    }
}

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

            $(".female").removeClass('show');
            $(".male").addClass('show');

            $(".female").find("input, select").removeAttr("required","required")
            $(".male").find("input, select").attr("required", "required")
            break;
        case "Female":
            // Used for form steps since some extra styling need to done 
            $("#different").addClass("maleOnlyStep")

            $(".male").removeClass('show');
            $(".female").addClass('show');

            $(".male").find("input, select").removeAttr("required","required")
            $(".female").find("input, select").attr("required","required")
            break;
        default:

            // Used for form steps since some extra styling need to done 
            $(".female, .male").removeClass('show').find("input, select").removeAttr("required");
            $("#different").addClass("maleOnlyStep")
    }

    adjustNavigationBarLine()
    calcSizesOfSections()

}

/* Produces the results box for the RAT                                                        */

function resultsDisplay(response, textStatus, xhr) {

    var result = JSON.parse(response.message)
    go_toresult()
    
    var messageBeginning = "Based on the information provided, the patient's estimated risk for developing colorectal cancer over "
    var message5years    = "the next 5 years is !Fillin1!% compared to a risk of !Fillin2!% "
    var message10years   = "the next 10 years is !Fillin3!% compareed to a risk of !Fillin4!% "
    var messageLifeTime  = "their lifetime ( to age 90) is !Fillin5!% compared to a risk of !Fillin6!% "
    var messageEnding    = "for a patient of the same age and race/ethnicity from the general US population.";

    message5years   = message5years.replace(  "!Fillin1!",    result.risk)
    message5years   = message5years.replace(  "!Fillin2!",    result.average5YearRisk)
    message10years  = message10years.replace( "!Fillin3!",    result.patient10YearRisk)
    message10years  = message10years.replace( "!Fillin4!",    result.average10YearRisk)
    messageLifeTime = messageLifeTime.replace("!Fillin5!",    result.patientLifetimeRisk)
    messageLifeTime = messageLifeTime.replace("!Fillin6!",    result.averageLifetimeRisk)
  

    $("#results_text_5_years").text(messageBeginning + message5years + messageEnding);
    $("#results_text_10_years").text(messageBeginning + message10years + messageEnding);
    $("#results_text_lifetime").text(messageBeginning + messageLifeTime + messageEnding);


    var fiveYearPatientRiskColor    = ( result.risk > result.average5YearRisk            ) ? "#BB0E3D" : "#2DC799";
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
    make_pie_chart(result.average5YearRisk,   "#pieChart2", "#40A5C1",                 "#EFEFEF");
	make_pie_chart(result.patient10YearRisk,     "#pieChart3", tenYearPatientRiskColor,  "#EFEFEF");
    make_pie_chart(result.average10YearRisk,     "#pieChart4", "#40A5C1",                 "#EFEFEF");    
	make_pie_chart(result.patientLifetimeRisk,   "#pieChart5", lifetimePateientRiskColor, "#EFEFEF");
	make_pie_chart(result.averageLifetimeRisk,   "#pieChart6", "#40A5C1",                 "#EFEFEF");
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
  enableSectionHeaders();
 
  adjustNavigationBarLine()
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
