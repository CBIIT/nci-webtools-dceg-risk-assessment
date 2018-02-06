$(function() {

	$("input[name='gender']").on("change", toggleGender);
	$("input[name='gender']").on("change", calcSizesOfSections);

	// If the person is not Non-Hispanic White then dispaly a dilog and sets
	// the value to Non-Hispanic White
	$("input[id='notNonHispanicWhiteRadioButton']").on("change", function() {
			disableMRATForm()
			$("#raceModal").modal("show");
			$("#nonHispanicWhiteRace")[0].checked = true;
	});

	// Initialize the button that will reset the form
	$("#reset").on("click", resetForm)

	// When the male or female has been selected then the calculate button can be
	// enabled, but only if all the fields that should be selected have been
	$("#maleGender").on("change", allowCalculate);
	$("#femaleGender").on("change", allowCalculate);

	$('#riskForm').trigger('change');

	// Enables the form when the user clicks ok for the dialog box be dispalyed
	$("#okButtonRace").on("click", enableMRATForm)

	$("termAndConditionsPge").removeClass("show")
});

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
 }

 /*
  * Enable the MRAT form
	*/
 function enableMRATForm() {
	 enableForm();
	 enableMap();
	 enableCalculateButton();
 }
