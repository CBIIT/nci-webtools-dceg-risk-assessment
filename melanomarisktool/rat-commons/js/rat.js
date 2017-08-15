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

/*
 * A function calculates and stores the position of each header and so that
 * when a navigation button or link is clicked or the user scrolls to a position
 * on the screen , the correct navigation buttion and link will be selected and
 * when a navigtation or link is selected, the program will scroll to the
 * correct section
 *
 * TODO: All the data attributes that I have set are not needed anymore. They shoudl be cleaned up
 * TODO: Can we cache the mal and femal so that we only have to generate the sizes at beginning.
 */
function calc()
{
	var navigationLinks = $("#form-steps > ol > li > a");

	// Initializes the information that both the seciton and navigation links of
	// form-steps need
	var oneSectionForManyLinks = 2;
	var currentLocationOnScrolledScreen = 0

	var heightOfHeaderAndSectionsAccumulator = 0;
	var heightOfFormSteps = $("#form-steps").outerHeight(true);
	console.log("Form Steps = " + heightOfFormSteps);
	$.each($("#riskForm section"), function(index, element) {

		// Get the starting pixel for the current header
		// We will make one simplfying assumption :
		// 		When the first button/link is clicked in the form-step you will see both the Header and the form-steps
		//			The data-position-height will always be 0 since that is position that will be scrolled to
		//    When any other button/link is clicked in the form-step you will see the from-step only and not the header

		// Accumulates the Height of the header and section, so the form will scrolled to the correct position for the next element
		// This calcuation will using this in currentHeight calculation for the next iteration
		var currentTitleAndSecitonHeight = $(element).prev().outerHeight(true) + $(element).outerHeight(true);
		console.log("Height of previous = " + $(element).prev().outerHeight(true));
		console.log("Hiehgt of current  = " + $(element).outerHeight(true));

		// Each anchor in the navigation Links will now the index, section id,
		// section header name and y-position.
		// TODO : Remove data elements that are not needed anymore
		var startIndex = index * 2;
		var endIndex = (index * oneSectionForManyLinks ) + ( oneSectionForManyLinks);

		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSection', index);
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionName', $(element).attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionHeaderName', $(element).prev().attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-position-height', heightOfFormSteps + heightOfHeaderAndSectionsAccumulator);


		// Each section will know id, the id its header and the y-postion of its sectionHeaderBoxHeight
		// TODO :
		$(this).attr('data-riskFormSectionName', $(element).attr('id'));
		$(this).attr('data-riskFormSectionHeaderName', $(element).prev().attr("id"));
		$(this).attr('data-position-height', heightOfFormSteps + heightOfHeaderAndSectionsAccumulator)

		heightOfHeaderAndSectionsAccumulator = heightOfHeaderAndSectionsAccumulator + currentTitleAndSecitonHeight;

	});

}


function toTop(){
	if (document.getElementById("main-nav").scrollIntoView) {
		document.getElementById("main-nav").scrollIntoView();
	}
	else
		$('html,body').scrollTop(0);
}

function invalidForm(e, validator) {
	$("#errors").addClass('alert alert-danger');
	toTop();
}

/**
 * Make an AJAX call to the back end.  The purpose is to handle a Get or POST
 * so the developer does not need whether the call is a GET or POST
 */
function processSubmission(form){

	// Determine how the parameters will be sent to the web tier
  var userData = (form.method == 'get') ? $(form).serialize() : new FormData(form);

	// Send the data to the web tier.
	$.ajax({
		url: form.action,
		type: form.method,
		dataType: 'json',
		error: function(jqXHR, textStatus, errorThrown) {
							 alert('An error occurred... Look at the console (F12 or Ctrl+Shift+I, Console tab) for more information!');

							 $('#result').html('<p>status code: '+jqXHR.status+'</p><p>errorThrown: ' + errorThrown + '</p><p>jqXHR.responseText:</p><div>'+jqXHR.responseText + '</div>');
							 console.log('jqXHR:');
							 console.log(jqXHR);
							 console.log('textStatus:');
							 console.log(textStatus);
							 console.log('errorThrown:');
		},
		data: userData,
    contentType: false,
    processData: false,
	}).done(resultsDisplay)
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		toTop();
	});
}

/*****************************************************************************/
/* Display the page so the user can enter the data fro the calculation       */
/*****************************************************************************/
function goback_tocalc(){
	$('#main').removeClass('hide')
	$('#form-steps').removeClass('hide')
	$("#results").removeClass('show')
	$("#results_text").html("");
	$("#Pie_chart").html("");
	$(window).scrollTop(0);
}

/*****************************************************************************/
/* Display the page so the user can view the results                         */
/****************************************************************************/
function go_toresult() {
	$('#main').addClass('hide')
	$('#form-steps').addClass('hide')
	$("#results").addClass('show')
}

/*****************************************************************************/
/* Create a pie chart                                                        */
/*                                                                           */
/* Parameters:                                                               */
/*   percent								The change that the victim will get cancer       */
/* 	 divContainerForChart		The HTML Container that will cotnain the chart   */
/*   color1 								The color for the chance of getting cancer       */
/*   color2  								The color for the chance of not getting cancer   */
/*****************************************************************************/
function make_pie_chart(percent, divContainerForChart, color1, color2){

	// Remoeves the pie charts created so tehy are not displayed next time.  This
	// allow the user to see the current prie chart and not the previous one
	$(divContainerForChart).empty();

	// Create the Pie Chart
	(function(d3) {

        'use strict';

        var dataset = [
          { label: 'Risk', count: percent },
          { label: 'Total', count: 100-percent },
        ];

        var width = 206;
        var height = 206;
        var radius = Math.min(width, height) / 2;

        var color = d3.scaleOrdinal().range([color1,color2]);

        var svg = d3.select(divContainerForChart)
          .append('svg')
          .attr('width', width)
          .attr('height', height)
          .append('g')
          .attr('transform', 'translate(' + (width / 2) +
            ',' + (height / 2) + ')');

        var arc = d3.arc()
          .innerRadius(0)
          .outerRadius(radius);

        var pie = d3.pie()
          .value(function(d) { return d.count; })
          .sort(null);

        var path = svg.selectAll('path')
          .data(pie(dataset))
          .enter()
          .append('path')
          .attr('d', arc)
          .attr('fill', function(d) {
            return color(d.data.label);
          });

      })(window.d3);
}

////////////////////////////////////////////////////////////////////////////////
// To update the navigation bar when the user scrolls the page                //
////////////////////////////////////////////////////////////////////////////////
function formScrollSpy() {

	// Calculate the bottom of the Form Steps where the questions will start.
	var window_top = $(window).scrollTop();
	window_top = window_top + calculateBottomOfFormSteps();

	$.each($("#riskForm section"), function(ind, el) {

		// Retrieve the top most pix of the header belonging to section
		var sectionHeight =$(this).attr('data-position-height');

		// If the current section is just below the navigation bar ( form-stpes)
		// then that section should be the active.
		if ( window_top >= sectionHeight) {

				// Remove the active style from any navigation link and apply it to the
				// current link being processed.
  			$("#form-steps li").removeClass('active');
				$("#form-steps li:eq(" + ind + ")").addClass('active');
				adjust_line_width(ind);
		}
	});

	// Rule : Scrollbar at very top the first navigation elements ( link/button)
	// should be active
	if ( $(window).scrollTop() == 0 ) {
		 		$('#form-steps li').first().addClass('active');
		 		adjust_line_width(0);

	}

	// Rule  : 	If male or female is not checked then the Navigation should only make
	//         	the first page active.
	// Rules : 	Scrollbar is at the bottom then the last navigation elements (link/button)
	// 					should be active
	if ( isMaleOrFemaleChekced() == 0 )
		return;
	else {
		var currentScrollPosition = Math.ceil($(window).scrollTop() + $(window).height());
		if ( currentScrollPosition >= $(document).height() ) {
					$("#form-steps li").removeClass('active');
			 		$('#form-steps li').last().addClass('active');
		   		adjust_line_width($('#form-steps li').length - 1);
		}
	}

}

// var currentScrollPosition = Math.ceil($(window).scrollTop() + $(window).height());
// var startingPositionOfLastSection = $("#form-steps ol li a").last().attr('data-position-height');
// if ( currentScrollPosition > startingPositionOfLastSection ) {
// 			$("#form-steps li").removeClass('active');
// 			$('#form-steps li').last().addClass('active');
// 			adjust_line_width($('#form-steps li').length - 1);
//
/******************************************************************************/
/* When a navigation number or name is clicked then the form should be scroll */
/* ed to the top of the section header                                        */
/******************************************************************************/
function gotoSection(event) {

	console.log("------------------------------------------------ in goto Section");

	// Rule: When there is a male/female selection, one of the items must checked
	// if the
	if ( isMaleOrFemaleChekced() == 0 ) return;

	var indexOfSection = $(this).attr('data-riskFormSection')

  // Remove the active style from the previous link and apply it to the
	// current link.
	var elementContainingListItems = $(this).parent().parent();
	$(elementContainingListItems).children("li").removeClass('active');
	$(this).parent().addClass('active');
	adjust_line_width(indexOfSection);

  // Scroll to the actual spot.
	var scrollTo = ( indexOfSection == 0 ) ? 0 : $(this).attr('data-position-height');
	$('html, body').animate({
			scrollTop: scrollTo
		}, 1000);
}

/* Determine if either male or female has been selected                       */
/*                                                                            */
/* The algorhtm will first check see if any Html object with the name         */
/* gender is on the page.  If it is on the page then male/female play a part  */
/* in the calculations.  If it is not on the page then it will be ignored     */
/*                                                                            */
/* If there is an HTML Object with the name gender make sure that either male */
/* or female has been selected                                                */
/*                                                                            */
/* Return (T) An HTML Object is name genddar and either male/female is        */
/* checked or there is no HTML Object called gendar                              */
/*                                                                            */
/* Return (F) There is an HTML Object with the name gendar, but male/female   */
/* has not been selected.                                                     */
function isMaleOrFemaleChekced() {
	var result =  ( $("input[name='gender']").length == 0 ) ? 0 : $("input[name='gender']:checked").length;
	return result;
}


function fixedToTop(div_top,use_mobile) {
	var header_height=$('header').outerHeight();
	var window_top = $(window).scrollTop();
	var div_top = $("#"+div_top).offset().top;
	//var div_top = $("#header").height();
	//var div_top = $("#toolTitle").offset().top;
	//	var div_top = $("#main-nav").offset().top;

	var form_steps_height=$('#form-steps').outerHeight();
	//console.log("window_top "+window_top)
	//console.log("div_top "+ div_top)
	if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){
			$("#main").css("margin-top",0+"px");
			$("header").css("top", "0px");
 			$("#form-steps").css("top",header_height+"px");
		}
	if ( window_top > div_top ){
		$("#form-steps").addClass('fixed');
		if($(window).width()>=992)
			$("#line").find("hr").css("top",form_steps_height-30)
		else
			$("#line").find("hr").css("top",form_steps_height-37)

	}
	else{
		$("#form-steps").removeClass('fixed');
		adjust_line_height_dekstop()

	}
}



function toggleFormDisplay(e) {
	e.preventDefault();

	if (e.type == "keypress") {
		$(e.target).trigger('click');
	}
 	else {
		$("#riskForm, #summary, #form-steps").toggleClass(function() {
			if($(this).hasClass('show')) {
				$(this).removeClass('show');
			}
			else {
				$(this).addClass('show');
			}
			return this;
		});
	}
}


// Handles the scroll event
function handleScrollEvent(event) {
	if($(window).width()>=630)
		var top_div="main-nav"
	else
		var top_div="toolTitle"

	fixedToTop(top_div);
	formScrollSpy();
}


$(window).load(function(e) {
	if( !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
		$(window).on("scroll", handleScrollEvent);
	}
	else if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){
		var top_div = ( $(window).width() > 753 ) ? "main-nav" : "toolTitle";
		fixedToTop(top_div,true);
		$(window).on('touchmove', function(event) {
			if($(window).width()>=753)
				var top_div="main-nav"
			else
				var top_div="toolTitle"

			fixedToTop(top_div,true);
			formScrollSpy();

		});
	}

	if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
	$(".toggleTool").on("click keypress", toggleFormDisplay);

	$(".responseOptions > label.radio,.responseOptionsWithoutIndent > label.radio").on('click keypress', function(e) {
		if ($(e.target).hasClass('radio')) {
			$(e.target).prev().trigger('click');
		}
		else if ($(e.target).parents('.radio')) {
			$(e.target).parents('.radio').prev().trigger('click');
		}
		else {
			if(e.type == "keypress") {
				if ((e.keyCode == 13) || (e.keyCode == 32)){
					$(e.target).children(".radio").prev().trigger('click');
				}
			}
			if(e.type == "click") {$("#form-steps > ol > li > a")
				$(e.target).children('.radio').prev().trigger('click');
			}
		}
	});

	// Sets the form back to defaults whent reset form button is clicked
	$("#reset_form").on("click",function(){
		$('form').trigger('reset')
	 	$(window).scrollTop(0);
	 	$("#skin-section").addClass("no_display")
		$("#skin").addClass("no_display")
		$("#physical-section").addClass("no_display")
		$("#physical").addClass("no_display")
		$("form :input").attr('disabled', false);

	});
	$("button.select").on('click keypress', function(e) {
		if(e.type == "keypress") {
			if ((e.keyCode == 13) || (e.keyCode == 32)) {
				$(e.target).prev().trigger('click');
			}
		}
		if(e.type == "click") {
			$(e.target).prev().trigger('click');
		}
	});

	$("input[name='gender']").on("change", toggleGender);
	$("input[name='gender']").on("change", calc);
	$("input[name='race']").on("change", function() {
		if(this.value == 1){
			$("#raceModal").modal("show");
			$("form :input").not("[name='race']").attr('disabled', true);
			$("[class*='questions']").css("color","#6c6c6c")
			$("#state-listing").addClass("disabled");
			$("#map").addClass("image_disabled");
		}
		else {
			$("form :input").not("[name='race']").removeAttr('disabled');
			$("[class*='questions']").css("color","#2e2e2e")
			$("#state-listing").removeClass("disabled");
			$("#map").removeClass("image_disabled");

		}
	});

	$('a[data-toggle="tab"]').on('hidden.bs.tab', function(e) {
		if($("nav.navbar-collapse").hasClass('in'))
			$('button[data-toggle="collapse"]').trigger("click");
	});

	var header_height=$('header').outerHeight();
 	var form_steps_height=$('#form-steps').outerHeight();
 	var logo_height=$('#logo').outerHeight();
	$("#side_nav").css("margin-top",logo_height+"px");
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
 		console.log("mobile");
 		 $("header").addClass('fixed');
 		 $("#form-steps").addClass('fixed');
 		 if($("#side_nav").width()>0)
 		 	$("#form-steps").css("z-index","999")
 		 else{
 		 	$("#form-steps").css("z-index","1")
 		 }

 		 // $("#main").css("margin-top",header_height+"px");
		 $("#main").css("margin-top", "0px");
 		 $("#form-steps").css("top", + header_height + "px");
 		 $("header").css("background","white");
 		 $("#main").removeClass("container-fluid");

 		$("#line").find("hr").css("top",form_steps_height/2)
	}

 	else{
	 	adjust_line_height_dekstop()
 	}

	adjust_line_width()

});

$(window).resize(function() {
	if(window.location.pathname=="/melanomarisktool/calculator.html"){
	 	adjust_line_width()
	 	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) )
	 		$("#line").find("hr").css("top",form_steps_height/2)
	 	else{
		 	adjust_line_height_dekstop();

	 	}
	 }

});

function adjust_line_width(ind){
 	var first_dot=$("#form-steps").find("a")[1]
 	var first_dot_left=$(first_dot).position().left
 	var first_dot_width=$(first_dot).outerWidth(true)
 	var last_dot=$("#form-steps").find("a")[$("#form-steps").find("a").length-1]
 	var last_dot_left=$(last_dot).position().left
 	var last_dot_width=$(last_dot).outerWidth(true)
 	$("#line").find("hr").css("left",first_dot_left+first_dot_width/2+10)

  if($(window).width()<992 ||navigator.userAgent.search("Firefox")>-1)
    	$("#line").find("hr").css("width",last_dot_left-first_dot_left-last_dot_width/2+10)
    else
    	$("#line").find("hr").css("width",last_dot_left-first_dot_left-last_dot_width/2+20)
	if(ind==1)
		$("#line").find("hr").css("width",last_dot_left-first_dot_left)

    else if(ind==2)
    	$("#line").find("hr").css("width",last_dot_left-first_dot_left+last_dot_width/4-20)



}

function adjust_line_height_dekstop(){
	var header_height=$('header').outerHeight();
 	var form_steps_height=$('#form-steps').outerHeight();
	if($(window).width()<992)
	 	$("#line").find("hr").css("top",header_height+form_steps_height/2)
	else
	 	$("#line").find("hr").css("top",header_height+form_steps_height-30)

}
function currentPage() {
	 var path = window.location.pathname;
	 var filename = path.substring(path.lastIndexOf('/')+1);
	 if(filename.indexOf('index') == -1){
	 	if($(window).width()>=992)
	 		$("nav li a[href='" + filename + "']").parent().addClass('active');
	 	else
	 		$("#side_nav li a[href='" + filename + "']").parent().addClass('active');
	 }

}
function smoothScroll(e) {
	if (e.type == "keypress") {
		if ((e.keyCode == 13) || (e.keyCode == 32))
			$(e.target).trigger('click');
	}
 	if(location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
		var target = $(this.hash);
		target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
		if (target.length) {
			event.preventDefault();

			var scrollTo = -1;
			if ( isFirstSection(target) == true ) {
				scrollTo = 0;
			} else {
				scrollTo = calculatePositionToScrollTo(target);
			}

			//var sectionHeaderBoxHeight = target.outerHeight() + target.innerHeight() + target.height();
			//console.log("SectionBoxHeight = " + sectionHeaderBoxHeight);
			$('html, body').animate({
					scrollTop: scrollTo
	    		//scrollTop: (target.offset().top +  sectionHeaderBoxHeight)
					//scrollTop: (target.offset().top) + sectionHeaderBoxHeight
	    	}, 1000);
	    	return false;
	    }
	}
}

/* Determines if the element passed in is the first section in the form      */
function isFirstSection(target) {
	var gotoId = "#" + $(target).attr('id');
	var selector = $("[href='" + gotoId + "']");
	var index = $(selector).first().attr('data-riskFormSection');

	return index == 0;
}

// Get the bottom pixel location of the #form-steps.
//
// Algorithm
//	If the form-steps ( navigation bar) does not exist then return 0
//  If the form-stpes ( navigation bar) does exist then return the right of the form-steps
//
function calculateBottomOfFormSteps() {

	var height = 0;
	if ( $("#form-steps").length !== 0 ) {
			height = $("#form-steps").position().top + $("#form-steps").outerHeight();
	}

	return height;
}

function calculatePositionToScrollTo(target) {

 	var positionOfHeader = $(target).position().top;
	return positionOfHeader - calculateBottomOfFormSteps();
}

$(function() {
	currentPage();
	// smooth scrolling to element on page
	//$('a[href*="#"]:not([href="#"])').on("click keypress", smoothScroll);


	/* When a different navigation link is clicked the callback will make the */
	/* link acitve and fix the line that connects all the navigation links    */
	var navigationLinks = $("#form-steps > ol > li > a");
	$(navigationLinks).on("click", gotoSection);

  // Whenever the window is resize we need to recalculate the line that contains
	// the navigation numbers so that it fits correctly.
	$(window).resize(function() {
		fixedToTop( ( $(window).width() ) ? "main-nav" : "toolTitle" );
		var riskFormSectionIndex = $("#form-steps > ol > li").filter(".active").children("a:first").attr("data-riskFormSection");
		adjust_line_width(riskFormSectionIndex);
	});




	$("#riskForm").validate({
		ignore: ".skipValidate",
		wrapper: 'p',
		submitHandler: processSubmission,
		highlight: function(el, errorClass) {
			$("[name='" + el.name + "']").addClass(errorClass);
		},
		unhighlight: function(el, errorClass) {
			$("[name='" + el.name + "']").removeClass(errorClass);
		}
	});
});

function toggle_menu(){

    if($("#side_nav").width()>0){
    	$("#side_nav").css("width","0%")
    	setTimeout(function(){ $("#form-steps").css("z-index","1"); }, 500);

    }

	else{
		$("#form-steps").css("z-index","99")
		$("#side_nav").css("width","70%")

	}

}
function enablebutton(){
	$("#calculate").prop('disabled', false);
	$("#calculate").attr("src","rat-commons/images/Calculate_Risk_Button.png");
}

function disablebutton(){
	$("#calculate").prop('disabled', true);
	$("#calculate").attr("src","rat-commons/images/Disabled_Calculate_Risk_Button.png");
}
$(document).ready(function(){
	currentPage()

	$("#riskForm").change(function() {
		var newVal = $(this).val();
		var inputs = $("form#riskForm input:enabled, form#riskForm select:enabled");
		valid=true
		inputs.each(function(index) {
    		var input = $(this);
    		if(input[0].required==true){
    			name=input[0].name
    			if(($('input[name=' + name +']').is('input') && $('input[name=' + name + ']:checked').length==0) || ($('select[name=' + name +']').is('select') && input[0].selectedIndex==0)){
      				disablebutton()
      				valid=false
      			}
    		}
		});
		if(valid==true)
			enablebutton();
	});
});

/* Is the device a mobile phone or tablet ?                                   */
function isMobile() {
	return 1;
}
