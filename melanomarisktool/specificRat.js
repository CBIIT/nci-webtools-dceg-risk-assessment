
// A two data structure
// When going from a number to a string you are associating an option from a select tag with a id for an img tag.
// When going from a string to a number you are associating an id for an img tag with an option from a select tag
var frecklingValue = {}
frecklingValue["3"]									= "mildFreckling"
frecklingValue["4"]									= "moderateFreckling"
frecklingValue["5"]									= "severeFreckling"
frecklingValue[""]									= "1"
frecklingValue["Absent"]							= "2"
frecklingValue["mildFreckling"]						= "3"
frecklingValue["moderateFreckling"]					= "4"
frecklingValue["severeFreckling"]					= "5"

$(function() {

   $("#raceModal").on("hidden.bs.modal", function(e) {
	  if(!isMobile())
	     var nameAttribute = $(e.target).attr("data-caller-name")
	     var selector = "input[name='" + nameAttribute + "']:checked"
         $(selector).next('[role=radio][aria-checked=true]').focus();
   })

	$("[class*='pictureText']").addClass("pictureTextEnabledColor")

	// When tabbing, the element is being hidden by part of the browser, so I want to move it so the user can see it.
	$("#melanomaRisk").on("focusin", function() { moveElementIfCloseToBottom("#melanomaRisk") })
	$("#preventMelanoma").on("focusin", function() { moveElementIfCloseToBottom("#preventMelanoma") })


	$("input[name='gender']").on("change", toggleGender);
	$("input[name='gender']").on("change", calcSizesOfSections);

	// If the person is not Non-Hispanic White then dispaly a dilog and sets
	// the value to Non-Hispanic White
	//$("input[id='notNonHispanicWhiteRadioButton']").on("change", function() {
	//    if ( $(this).value == 0 )
	//        $("#raceModal").attr("data-caller-name", $(this).prop("name"))
	//		disableMRATForm()
	//		$("#raceModal").modal("show");
	//});

	$("input[name='race']").on("click", function(event) {
	    if ( this.value == 1 ) {
	        genericResetValidator();
	        $("#raceModal").attr("data-caller-name", $(this).prop("name"))
	        disableMRATForm()

            // When the dialog box appeared the Other Checkbox from the
            // "What is the patient's race" the checkbox state changed
            // from checked to not checked.  This line fixed the problem,
            // but I am unsure why this is happening.
	        $("#notNonHispanicWhiteRadioButton").prop("checked", true)
	        setTimeout( function() { $("#raceModal").modal("show"); } , 500 )
	    } else {
            $("#riskForm").trigger("change")
            enableMRATForm()
	    }
	})

	$("input[id='nonHispanicWhiteRace']").on("click", enableMRATForm )

	// Initialize the button that will reset the form
	$("#reset").on("click", resetForm)

	$('#riskForm').trigger('change');

	$("#okButtonRace").on("click", function() {
	    enableMRATForm();
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

	// When the image is clicked then delegate the event to the correct "Click to
	// Select Button"
	$("[id$='Freckling']").on("click", function(event) {
			$(event.target).prev().children(":first()").click();
	});

	// for the image for the "How extensive is the freckling on the patients's
	// back and shoulders?".  When clicked the correct image should be selected
	$("#freckling").on("change", function() {
		var index = $(this).prop('selectedIndex') + 1
	  borderAroundPicture($("#freckling").parent().next().find("img"), index)
	});

	// Handles the "Click to Enlarge Link");
  $("a:contains('Enlarge')").on("click", function(event) {

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
  $("#pictureModal .close").on("click", function() {
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
	$("[href='javascript:go_toTermsAndConditions()']").focus()
}

////////////////////////////////////////////////////////////////////////////////
// Display the results for the Melenoma Cancer Risk Analysis Tool             //
////////////////////////////////////////////////////////////////////////////////
function resultsDisplay(response, textStatus, xhr) {
	var results=JSON.parse(response.message)

	var gender = ( $("input[name='gender']").val() == "male" ) ? "men" : "women"
	var message= "Based on the information provided, the patient's estimated risk for developing melanoma over the next 5 years is "+results.risk+"%.  A risk of " + results.risk + "% means that out of 1,000 white " + gender+ " with these characteristics living in the " + results.regionKey + " region, " + results.ratio + " will be expected to develop melanoma in the next 5 years."
	go_toresult();

	$("#results_text").html(message);
	$("#Risk1").text(results.risk+"%");
	make_pie_chart(results.risk, "#Pie_chart", "#BB0E3D", "#EFEFEF");

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
			$('.small_mole_answer')[0].innerHTML="Fewer than seven"
			$('.small_mole_answer')[1].innerHTML="Seven to sixteen"
			$('.small_mole_answer')[2].innerHTML="Seventeen or more"
			$('#small_moles').parent().addClass("spaceBetweenQuestions")

			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});

			$(".female").removeClass('show');
			$(".male").addClass('show');

			$("#mildFreckling").attr("src","rat-commons/images/mild-freckling-enlarge.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/moderate-freckling-enlarge.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/severe-freckling-enlarge.jpg")
			break;
		case "Female":
			$('.small_mole_answer')[0].innerHTML="Fewer than five"
			$('.small_mole_answer')[1].innerHTML="Five to eleven"
			$('.small_mole_answer')[2].innerHTML="Twelve or more"
            $('#small_moles').parent().removeClass("spaceBetweenQuestions")

			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});

			$("#mildFreckling").attr("src","rat-commons/images/few-freckling-female.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/moderate-freckling-female.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/many-freckling-female.jpg")

			$(".male").removeClass('show');
			$(".female").addClass('show');
			break;
		default:
			$.each($(".male, .female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
			});

			$("#mildFreckling").attr("src","")
			$("#moderateFreckling").attr("src","")
			$("#severeFreckling").attr("src","")

			break;
	}
}

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

     // Which pictures should be excluded from being disabled.
     // Returns (t) -- The element should be excluded
     function exclusions(element) {

        var resultPicInDialog = ($(element).parents("[role='dialog']").length == 0);
        var resultPicInHeader = ($(element).parents("header").length == 0 );

        return resultPicInDialog && resultPicInHeader;
     }

	 disableForm()
	 disableMap()

     // If the image is not in a dialog box then assume it is in a form and disable the image
	 $("img").filter( function(index,element) { var result = (exclusions(element) == true ) ? true : false;  return result; } ).addClass("image_disabled");
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

 /*
  * Retreives the Answer for the sunburn damage
	*/
	function ratSpecificAnswer(element) {
		return $("[name='damage']:checked").next().text()
	}
