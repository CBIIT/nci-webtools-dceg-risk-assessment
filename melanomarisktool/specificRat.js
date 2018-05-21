
// A two data structure
// When going from a number to a string you are associating an option from a select tag with a id for an img tag.
// When going from a string to a number you are associating an id for an img tag with an option from a select tag
var frecklingValue = {}
frecklingValue["3"]									= "mildFreckling"
frecklingValue["4"]									= "moderateFreckling"
frecklingValue["5"]									= "severeFreckling"
frecklingValue[""]									= "1"
frecklingValue["Absent"]						= "2"
frecklingValue["mildFreckling"]			= "3"
frecklingValue["moderateFreckling"]	= "4"
frecklingValue["severeFreckling"]		= "5"

$(function() {

	$("[class*='pictureText']").addClass("pictureTextEnabledColor")

	// When tabbing, the element is being hidden by part of the browser, so I want to move it so the user can see it.
	$("#melanomaRisk").on("focusin", function() { moveElementIfCloseToBottom("#melanomaRisk") })
	$("#preventMelanoma").on("focusin", function() { moveElementIfCloseToBottom("#preventMelanoma") })


	$("input[name='gender']").on("change", toggleGender);
	$("input[name='gender']").on("change", calcSizesOfSections);

	// If the person is not Non-Hispanic White then dispaly a dilog and sets
	// the value to Non-Hispanic White
	$("input[id='notNonHispanicWhiteRadioButton']").on("change", function() {
			disableMRATForm()
			$("#raceModal").modal("show");
	});

	$("input[id='nonHispanicWhiteRace']").on("click", enableMRATForm )

	// Initialize the button that will reset the form
	$("#reset").on("click", resetForm)

	// When the male or female has been selected then the calculate button can be
	// enabled, but only if all the fields that should be selected have been
	$("#maleGender").on("change", allowCalculate);
	$("#femaleGender").on("change", allowCalculate);

	$('#riskForm').trigger('change');

	// Enables the First Question only and disable the Command Button.
	//
	// Since the enableCalculateButton() does not check for the case where the
	// number of enabled inputs is 0.  If the number of enabled input are 0 then
	// all the questions have been answered, so the Calculate Button would be
	// green. I decided to fix it here since I do not want to change rat.js
	// this late in the task unless I need to.
	//
	$("#okButtonRace").on("click", function() {
    enableFirstQuestionAndAnswers($("#questionAndAnswers1").attr("id"))
  })

	$("#okButtonRace").on("click", function() {
		disablebutton()
  })

	$("termAndConditionsPge").removeClass("show")

	// for the image for the "How extensive is the freckling on the patient's
	// back and shoulders?" when clicked the border should be visible to show
	// that it was selected and the select box should be set to the correct
	// option.
	$("[id^=freckleClick]").on("click",
		function(event) {
			var index = frecklingValue[ $(event.target).parent().siblings("img").first().attr("id") ]
			borderAroundPicture($("#freckling").parent().next().find("img"), index )
			selectionBasedOnImageSelect("freckling",  index )
	})

	// for the image for the "How extensive is the freckling on the patients's
	// back and shoulders?".  When clicked the correct image should be selected
	$("#freckling").on("change", function() {
		var index = $(this).prop('selectedIndex') + 1
		console.log("index = " + index)
	  borderAroundPicture($("#freckling").parent().next().find("img"), index)
	});

	// Handles the "Click to Enlarge Link");
  $("#freckling").parent().next().find("a:contains('Click to Enlarge')").on("click", function(event) {

		// Going to the URL will be prevented
		event.preventDefault();

		// Display the dialog
		var image = $(this).parent().siblings("img").attr("src")
		$("#pictureModal #image").attr("src", image)

		var text = $(this).parent().prev().attr("data-name")
		$("#pictureModal #text").text(text)

		disableMRATForm()
		$("#pictureModal img").removeClass("image_disabled")
		$("#pictureModal #text").removeClass("pictureTextDisabledColor")
		$("#pictureModal").modal("show");
	});

	// When the dialog box showing the image is selected this function will
	// enable the form.
  $("#okButtonPic").on("click", function() {
		enableMRATForm()
	});

});

////////////////////////////////////////////////////////////////////////////////
// For a collection of images draw a border around the current selected image //
////////////////////////////////////////////////////////////////////////////////
function borderAroundPicture(allImages, currentIndex) {
	$(allImages).removeClass("selectableImageBorder")
	$("#" + frecklingValue[currentIndex]).addClass("selectableImageBorder")
}

////////////////////////////////////////////////////////////////////////////////
// For the drop down select by index of value.  I used this because the       //
// options go from nothing to servere and I believe the flow from top to      //
// bottom will always increase in severity                                    //
////////////////////////////////////////////////////////////////////////////////
function selectionBasedOnImageSelect(id, index) {
	$("#" + id + " option").prop("selected", false)
	$("#" + id + " option:nth-child(" + index  + ")" ).prop("selected", true)
}

////////////////////////////////////////////////////////////////////////////////
// Displays the Term and Conditions Page                                      //
////////////////////////////////////////////////////////////////////////////////
function go_toTermsAndConditions() {
	$("#mainAboutPage").removeClass("show")
	$("#termAndConditionsPage").addClass("show")
}

////////////////////////////////////////////////////////////////////////////////
// Dispaly the Main About Page
////////////////////////////////////////////////////////////////////////////////
function go_toAboutPage() {
	$("#mainAboutPage").addClass("show")
	$("#termAndConditionsPage").removeClass("show")
}

////////////////////////////////////////////////////////////////////////////////
// Rules : When the user has not selected a male or female then the calculate
// button should always be disabled, but when the user has selected male or
// female then the calculate should follow the normal rat rules ( all inputs
// question must have an answer unless they are disabled).
////////////////////////////////////////////////////////////////////////////////
function allowCalculate() {
	  if ( $("input[name='gender']:checked").val() !== undefined ) {
			$("#riskForm").on("change", enableCalculateButton);
		}
}

////////////////////////////////////////////////////////////////////////////////
// Display the results for the Melenoma Cancer Risk Analysis Tool             //
////////////////////////////////////////////////////////////////////////////////
function resultsDisplay(response, textStatus, xhr) {
	var results=JSON.parse(response.message)
	var message="Based on the information provided, the patient's estimated risk for developing melanoma over the next 5 years is "+results.risk+"%. For every 1,000 "+ results.gender+"s living in the " +results.regionKey+" region with these characteristics, on average about "+ results.ratio+" will develop melanoma in the next 5 years.";

	go_toresult();

	$("#results_text").html(message);
	$("#Risk1").text(results.risk+"%");
	make_pie_chart(results.risk, "#Pie_chart", "#2DC799", "#EFEFEF");

}

/*
 * Display the correct form object for the gender
 */
function toggleGender(e) {
	var value = $(e.target).val();
	$("#skin-section").removeClass("no_display")
	$("#skin").removeClass("no_display")
	$("#physical-section").removeClass("no_display")
	$("#physical").removeClass("no_display")
	switch (value) {
		case "Male":
			$('.small_mole_answer')[0].innerHTML="Less than seven"
			$('.small_mole_answer')[1].innerHTML="Seven to sixteen"
			$('.small_mole_answer')[2].innerHTML="Seventeen or more"
			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});
			$(".female").removeClass('show');
			$(".male").addClass('show');

			$("#mildFreckling").attr("src","rat-commons/images/mratMildLrg.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/mratModLrg.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/mratSevereLrg.jpg")
			break;
		case "Female":
			$('.small_mole_answer')[0].innerHTML="Less than five"
			$('.small_mole_answer')[1].innerHTML="Five to eleven"
			$('.small_mole_answer')[2].innerHTML="Twelve or more"
			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});

			$("#mildFreckling").attr("src","rat-commons/images/mratMildLrg.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/mratModLrg.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/mratSevereLrg.jpg")

			$(".male").removeClass('show');
			$(".female").addClass('show');
			break;
		default:
			$.each($(".male, .female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
			});
			break;
	}
}

var validationMessages = {
	region: {
		required: "The region in which the patient resides must be selected."
	},
	gender: {
		required: "The patient's gender must be selected."
	},
	race: {
		required: "The patient's race must be selected."
	},
	age: {
		required: "The patient's age must be selected."
	},
	sunburn: {
		required: "Whether the patient has ever received a sunburn must be recorded."
	},
	complexion: {
		required: "The patient's complexion must be selected."
	},
	"big-moles": {
		required: "The number of moles greater than 5mm in diameter on the patient's back must be selected."
	},
	"small-moles": {
		required: "The number of moles less than or equal to 5mm in diameter on the patient's back must be selected."
	},
	"tan": {
		required: "The level to which the patient presents a tan must be selected."
	},
	freckling: {
		required: "The extent of the freckling on the patient's back must be selected."
	},
	damage: {
		required: "Whether the patient has severe solar damage on their next and shoulders must be selected."
	}
};

var validationRules = {
	region: {
		required: true
	},
	gender: {
		required: true
	},
	race: {
		required: true
	},
	age: {
		required: true
	},
	sunburn: {
		required: {
			depends: function(el) {
				return  $('[name="gender"]').val() == "Male";
			}
		}
	},
	complexion: {
		required: true
	},
	"big-moles": {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Male";
			}
		}
	},
	"small-moles": {
		required: true
	},
	"tan": {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Female";
			}
		}
	},
	freckling: {
		required: true
	},
	"damage": {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Male";
			}
		}
	}
};

// Removes the capability for the user to interact with the map
function disableMap() {
	$("#state-listing").addClass("disabled");
	$("#map").addClass("image_disabled");
}

// Adds the capability for the user to interact with the map
function enableMap() {
	$("#state-listing").removeClass("disabled");
	$("#map").removeClass("image_disabled");
}

/* Resets the form back to default look and values that it contains           */
function resetForm() {
  genericResetForm()
	enableMap();
  enableSectionHeaders();

	// Remove the capability for the application to make the calculate button
	// enabled.  The calculate button can never be enabled until male or female
	// has been selected`
	$("#riskForm").unbind("change", enableCalculateButton);

	// Make the section skin, exam section invisible.
	$("#skin-section").addClass("no_display")
	$("#skin").addClass("no_display")
	$("#physical-section").addClass("no_display")
	$("#physical").addClass("no_display")

}

/*
 * Disable the MRAT Form
 */
 function disableMRATForm() {
	 disableForm()
	 disableMap()

	 $("img").addClass("image_disabled")
	 $("p").addClass("picture")

	 $("[class*='pictureText']").removeClass("pictureTextEnabledColor")
	 $("[class*='pictureText']").addClass("pictureTextDisabledColor")



 }

 /*
  * Enable the MRAT form
	*/
 function enableMRATForm() {
	 enableForm();
	 enableMap();
	 enableCalculateButton();

	 $("[class*='pictureText']").addClass("pictureTextEnabledColor")
	 $("[class*='pictureText']").removeClass("pictureTextDisabledColor")

	 $("img").removeClass("image_disabled")
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
	// Cannot use the includes function since Internet Explorer does not support it.

	var cssStyles = $(element).parent().attr("class").toLowerCase()
	var containsFemaleGender    = ( cssStyles.indexOf(femaleGender) > -1 ) ? true : false
	var containsMaleGender      = ( containsFemaleGender ) ? false :  ( cssStyles.indexOf(maleGender)  > -1 ) ? true : false

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
