
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

	//disableFormStepLinksSection508()


   $("#raceModal").on("hidden.bs.modal", function(e) {
	  if(!isMobile())
	     var nameAttribute = $(e.target).attr("data-caller-name")
	     var selector = "input[name='" + nameAttribute + "']:checked"
         $(selector).next('[role=radio][aria-checked=true]').focus();
   })

    $('#pictureModal').on('hidden.bs.modal', function (e) {
        enableMRATForm()

        var nameAttribute = $(e.target).attr("data-caller-name")

        if ( isMobile() || nameAttribute === undefined) {
            return;
        } else {
            var selector = "#" + nameAttribute
            $(selector).next("div").focus();
            $(selector).next("div").addClass("addOutline")
        }
    })

    $("#mapModal").on("hidden.bs.modal", function(e) {
        if(!isMobile()) {
            $("#state-listing").focus()
            $("#state-listing").addClass("addOutline")
            enableMRATForm()
        }
     })




	$("[class*='pictureText']").addClass("pictureTextEnabledColor")

	// When tabbing, the element is being hidden by part of the browser, so I want to move it so the user can see it.
	$("#melanomaRisk").on("focusin", function() { moveElementIfCloseToBottom("#melanomaRisk") })
	$("#preventMelanoma").on("focusin", function() { moveElementIfCloseToBottom("#preventMelanoma") })

    $("input[name='gender']").on("change", formStepsSection508)
    $("input[name='gender']").on("change", enableSkinSection);
    $("input[name='gender']").on("change", enablePhysicalSection);
	$("input[name='gender']").on("change", toggleGender);
	$("input[name='gender']").on("change", calcSizesOfSections);

	$("input[name='race']").on("click", function(event) {
	    if ( this.value == 1 ) {
	        genericResetValidator();
	        $("#raceModal").attr("data-caller-name", $(this).prop("name"))
	        disableMRATForm()

	        event.stopPropagation();

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

  	//$("#mapModal button.close").on("click", function() {
  	//    enableMRATForm()
  	//})

	$("termAndConditionsPge").removeClass("show")

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
        setTimeout( function() { $("#pictureModal").modal("show"); } , 500 )

	});

    // Shows the image when the enter is pressed on a selected answer
	$("#newSolarDamage .radio, #newFrecklePictures .radio").not(":first").on("keypress", function(event) {
	    var keycode = (event.keyCode ? event.keyCode : event.which);
	    if ( keycode == 13 ) {

	    	// Going to the URL will be prevented
        	event.preventDefault();

        	//Display the dialog
        	var picture = $(this).parent().prev().children("img")
        	$("#pictureModal #image").prop("src", $(picture).prop("src"))
        	$("#pictureModal #text").text($(picture).attr("data-name"))

            disableMRATForm()
            $("#pictureModal img").removeClass("image_disabled")
            $("#pictureModal #text").removeClass("pictureTextDisabledColor")
            $("#pictureModal").attr("data-caller-name", $(this).prev().prop("id"))
            setTimeout( function() { $("#pictureModal").modal("show"); } , 500 )
	    }
	})

	$("#state-listing").on("keypress", function(event) {
	     var keycode = (event.keyCode ? event.keyCode : event.which);
	     if ( keycode == 13 ) {
	        event.preventDefault()

	        disableMRATForm()
	        setTimeout( function() { $("#mapModal").modal("show"); } , 500 )
	     }
	})

	// Move the answer abou freckles into view, so the user can see the answer
	//$("#newFrecklePictures .radio").on("focus", function(event) {
	//    handleFocusRadioGroupForFreckle(event)
	//})


	// The starting state for all the controls in the Skin and Physical Section
	// should be disabled since they are not seen when the application first
	// appears
	$("#skin-section").each(function(index,el) {
	    disableRadioGroupSection508(el)
	})

	$("#physical-section").each(function(index,el) {
	    disableRadioGroupSection508(el)
	})

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

	var gender = ( $("input[name='gender']:checked").val() == "Male" ) ? "men" : "women"
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
			$('.small_mole_answer')[0].innerHTML="Few&shy;er than sev&shy;en"
			$('.small_mole_answer')[1].innerHTML="Se&shy;ven to six&shy;teen"
			$('.small_mole_answer')[2].innerHTML="Seven&shy;teen or more"
			$('#small_moles').parent().addClass("spaceBetweenQuestions")

            configureSection508ForGender()

			$(".female").removeClass('show');
			$(".male").addClass('show');

			$("#mildFreckling").attr("src","rat-commons/images/mild-freckling-enlarge.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/moderate-freckling-enlarge.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/severe-freckling-enlarge.jpg")

			registerFreckleCustomRadioAccess()

			break;
		case "Female":
			$('.small_mole_answer')[0].innerHTML="Few&shy;er than five"
			$('.small_mole_answer')[1].innerHTML="Five to el&shy;even"
			$('.small_mole_answer')[2].innerHTML="Twelve or more"
            $('#small_moles').parent().removeClass("spaceBetweenQuestions")

            configureSection508ForGender();

			$("#mildFreckling").attr("src","rat-commons/images/few-freckling-female.jpg")
			$("#moderateFreckling").attr("src","rat-commons/images/moderate-freckling-female.jpg")
			$("#severeFreckling").attr("src","rat-commons/images/many-freckling-female.jpg")

			$(".male").removeClass('show');
			$(".female").addClass('show');

			registerFreckleCustomRadioAccess()
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
	disableFormStepLinksSection508()

	// Make the section skin, exam section invisible.
	$("#skin-section").addClass("no_display")
	$("#skin").addClass("no_display")
	$("#physical-section").addClass("no_display")
	$("#physical").addClass("no_display")

	// Set the form steps so section is the active one.
    makeFormStepsSectionActive(1)

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

	 configureSection508ForGender()
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
    if ( $(element).parent().attr("class") ) {
	    var cssStyles = $(element).parent().attr("class").toLowerCase()
	    var containsFemaleGender    = ( cssStyles.indexOf(femaleGender) > -1 ) ? true : false
	    var containsMaleGender      = ( containsFemaleGender ) ? false :  ( cssStyles.indexOf(maleGender)  > -1 ) ? true : false
	    var isSelectedGenderFemale 	= ( selectedGender == femaleGender )
	}

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

	/*
	 * A set of functions for setting the enable and disable of the HTML Elements
	 */
	function disableRadioGroupSection508(startingDiv) {
	    $(startingDiv).find("input").prop("disabled", true)
        $(startingDiv).find("input").removeProp("required")

	    $(startingDiv).find("[role=radio]").attr("tabindex","-1")

        $(startingDiv).find(".questions").attr("aria-disabled", true)
        $(startingDiv).find("input").attr("aria-disabled", true)
        $(startingDiv).find(".questions_secondary").attr("aria-disabled", true)
        $(startingDiv).find("[role='radio']").attr("aria-disabled",true);
	}

	function enableRadioGroupSection508(startingDiv) {
        $(startingDiv).find("input").prop("disabled", false)
        $(startingDiv).find("input").prop("required", true)

        if ( $(startingDiv).find("[role=radio][aria-checked=true]").length > 0) {
            $(startingDiv).find("[role=radio][aria-checked=true]").attr("tabindex","0");
        } else {
            $(startingDiv).find("[role='radio']:first").attr("tabindex","0");
        }

        $(startingDiv).find(".questions").attr("aria-disabled", false)
        $(startingDiv).find("input").attr("aria-disabled", false)
        $(startingDiv).find(".questions_secondary").attr("aria-disabled", false)
        $(startingDiv).find("[role='radio']").attr("aria-disabled", false);
   	}

    function enableSelectBoxSection508(element) {
        $(startingDiv).find("select").prop("disabled", false)
        $(startingDiv).find("select").prop("required", true)

        $(startingDiv).find(".questions").attr("aria-disabled", false)
        $(startingDiv).find(".questions_secondary").attr("aria-disabled",false);
        $(startingDiv).find("select").attr("aria-disabled", false);
    }

    function disableSelectBoxSection508(element) {
        $(startingDiv).find("select").prop("disabled", true)
        $(startingDiv).find("select").prop("required", false)

        $(startingDiv).find(".questions").attr("aria-disabled", true)
        $(startingDiv).find(".questions_secondary").attr("aria-disabled",true);
        $(startingDiv).find("select").attr("aria-disabled", true);

    }

    function disableFormStepLinksSection508() {
         //var formStepLinks = $("#form-steps ol li").not(":first").children("a")

         $("#step2_name").attr("disabled")
         $("#step2_name").attr("aria-disabled", true)
         $("#step2_number").attr("disabled")
         $("#step2_number").attr("aria-disabled", true)

         $("#step3_name").attr("disabled")
         $("#step3_name").attr("aria-disabled", true)
         $("#step3_number").attr("disabled", true)
         $("#step3_number").attr("aria-disabled", true)
    }

    function enableFormStepLinksSection508() {
        //var formStepLinks = $("#form-steps ol li ").not(":first").children("a")
        $("#step2_name").removeAttr("disabled")
        $("#step2_name").attr("aria-disabled", false)
        $("#step2_number").removeAttr("disabled")
        $("#step2_number").attr("aria-disabled", false)

        $("#step3_name").removeAttr("disabled")
        $("#step3_name").attr("aria-disabled", false)
        $("#step3_number").removeAttr("disabled")
        $("#step3_number").attr("aria-disabled", false)
    }

    // Problem from we got the following issue : The skip-link target should exist and be focusable
    // This was caused by using #references
    // Solution : include the # references only when male or female has been selected.
    function formStepsSection508() {
        $("#form-steps ol li:nth(1) a").prop("href", "#skin-section")
        $("#form-steps ol li:nth(2) a").prop("href", "#physical-section")

        enableFormStepLinksSection508()
    }

   /*******/

  function enableSkinSection() {
    enableSection("#skin-section")
  }

  function enablePhysicalSection() {
    enableSection("#physical-section")
  }

   // Enables all the Radio Groups for the Skin and Physical Section
   function enableSection(sectionName) {
        $(sectionName).children().not(".male, .female").each(function(index,el) {
            enableRadioGroupSection508(el)
        })
   }

////////////////////////////////////////////////////////////////////////////////////////////////
// handleKeyDown originally came from rat.js however, the algorithm is not working for the    //
// freckling section ("Question : How extensive is the freckling on the patient's back and    //
// shoulders?")                                                                               //
////////////////////////////////////////////////////////////////////////////////////////////////

var KEYCODE = {
    DOWN: 40,
    LEFT: 37,
    RIGHT: 39,
    SPACE: 32,
    UP: 38,
	TAB: 9
}



function registerFreckleCustomRadioAccess() {
	$("#newFrecklePictures [role=radio]").each(function(){

		$(this).unbind('keydown',      handleKeyDownRadioGroup)
		$(this).unbind('mousedown',    handleKeyDownRadioGroup)
		$(this).unbind('focus',        handleFocusRadioGroup)

	    $(this).on('keydown',   handleKeyDownRadioGroupForFreckle);
        $(this).on('mousedown', handleKeyDownRadioGroupForFreckle);
        //$(this).on('focus',     handleFocusRadioGroupForFreckle);
	});

    // A fix for internet exploer.  When tabbging to absent (freckle question)
    // from the question below the absent answer would be under the form steps
    // component.
    $("#absentFrecklingAnswer").next().on("focus", function(event) {

        if ( $(this).isInViewport() == false ) {
            scrollIntoView(event)
        }
    })
}

function scrollIntoView(event) {
  	var element = $(event.currentTarget);
  	var radioGroup = $(element).parent().prev()
  	var radioGroupSize = $(radioGroup).height()/2;
  	var heightPos = Math.max(
  	  (radioGroup.offset().top - $('#form-steps').outerHeight())-radioGroupSize,0);
  	$('html, body').scrollTop(heightPos);
  }

function handleFocusRadioGroupForFreckle(event) {
    var mouseEvent = $(this).data("radioMouseEvent");
    $(this).removeData("radioMouseEvent");
	if(isMobile() || mouseEvent || $(event.currentTarget).parent().parent().isInViewport() ) return;

	var element = $(event.currentTarget);
	var radioGroup = $(element).parent().parent();
	var radioGroupSize = $(radioGroup).height()/2;
	var heightPos = Math.max(
	  (radioGroup.offset().top - $('#form-steps').outerHeight())-radioGroupSize,0);
	$('html, body').scrollTop(heightPos);

}



function handleKeyDownRadioGroupForFreckle(event){
  var type = event.type;
  var next = false;

  var isDisabled = $(event.currentTarget).prev('input:radio').prop('disabled');

  if(isDisabled) {
    return true;
  }

  var setRadioButton = function(node,state,focus) {

	  if (state) {
		$(node).attr('aria-checked', 'true');
		$(node).attr('tabIndex','0');
		$(node).prev('input:radio').trigger('click');
		if(focus) $(node).focus();
	  }
	  else {
		$(node).attr('aria-checked', 'false');
		$(node).attr('tabIndex','-1');
	  }
  }

  var nextRadioButton = function(node) {
      console.log("Currently in next Radio Button")
	  return $(node).parent().next('div').next('div').find('[role=radio]');
  }

  var previousRadioButton = function(node) {
      console.log("Currently in next Prev Button")
	  return $(node).parent().prev('div').prev('div').find('[role=radio]');
  }

  var firstRadioButton = function(node) {
      console.log("Currently in next Prev Button")
	  return $(node).parent().parent().children('div.responseOptions:first').find('[role=radio]');
  }

  var lastRadioButton = function(node) {
      console.log("Currently in the last Radio Button")
	  return $(node).parent().parent().children('div:last').find('[role=radio]');
  }

  if(type === "keydown") {
    var node = event.currentTarget;
    var key = event.which || event.keyCode || 0;
    switch (key) {
      case KEYCODE.DOWN:
      case KEYCODE.RIGHT:
        console.log("The Value of the key for down and right was " + key)
        var next = nextRadioButton(node);
        console.log("1--The length of next was " + $(next).length)
		if ($(next).length === 0) {
		    next = firstRadioButton(node);
		    event.currentTarget = next;
		}
		break;

      case KEYCODE.UP:
      case KEYCODE.LEFT:
        console.log("The Value of the key for up and left was " + key)
        next = previousRadioButton(node);
        console.log("2--The length of next was " + $(next).length)
        if ($(next).length === 0) {
            next = lastRadioButton(node);
            event.currentTarget = next;
        }
        break;

      case KEYCODE.SPACE:
        next = node;
        break;
    }

    if ($(next).length > 0) {
      console.log("The input was " + $(next).prev().prop("id"))
	  $(node).parent().parent().children('div').find('[role=radio]').each(function(){
		  setRadioButton($(this),false);
	  });
      event.preventDefault();
	  event.stopPropagation();

	  setRadioButton(next,true,true);

	   // When the space bar is pushed the current element is already visible to the user so no scrolling needs to
	   // be done.  If the scrollIntoView() was called there would be jittering of the screen.
	   if ( key != KEYCODE.SPACE ) {
        scrollIntoView(event)
       }
	}
  } else if (type === "mousedown") {
	  var node = event.currentTarget;
	  $(node).parent().parent().children('div').find('[role=radio]').each(function(){
		  setRadioButton($(this),false);
	  });
	  $(this).data("radioMouseEvent",true);
      setRadioButton(node,true,true);

  }
}

///// End Section


/*
 * Configures the form for the currently selected gender
 */
function configureSection508ForGender() {

    var selectedGender = ".female"
    var notSelectedGender = ".male"

	if ( $("input[name='gender']:checked").val() == "Male" ) {
	    selectedGender=".male"
	    notSelectedGender=".female"
	}

    $.each($(notSelectedGender), function(index, el) {
	    disableRadioGroupSection508(el)
	});


    $.each($(selectedGender), function(index, el) {
        enableRadioGroupSection508(el)
	});

}

function specificRatFooterInitialization() {
   $("#contactLink").prop("href", "https://www.cancer.gov/melanomarisktool/")
}