

/* A function calculates and stores the position of each header and so that
 * when a navigation button or link is clicked or the user scrolls to a position
 * on the screen , the correct navigation buttion and link will be selected and
 * when a navigtation or link is selected, the program will scroll to the
 * correct section
 *
 * TODO: All the data attributes that I have set are not needed anymore. They shoudl be cleaned up
 * TODO: Can we cache the mal and femal so that we only have to generate the sizes at beginning.
 */
function calcSizesOfSections()
{

	var navigationLinks = $("#form-steps > ol > li > a");

	// Initializes the information that both the seciton and navigation links of
	// form-steps need
	var oneSectionForManyLinks = 2;
	var currentLocationOnScrolledScreen = 0

	var heightOfHeaderAndSectionsAccumulator = 0;

	// For the iphone the header is under the form-steps and it is bigger then the
	// form-steps on mobile this might cause a problem.
	//
	// On the iphone is did : $("#form-steps").css("display", "none") and the
	// header was seen because it was below (z-index) of the form-steps
	var heightOfFormSteps = $("#form-steps").outerHeight(true);
	var heightOfHeader    = $("header").outerHeight(true);
	var height = heightOfFormSteps

	
	$.each($("#riskForm section"), function(index, element) {

		// Accumulates the Height of the header and section, so the form will scrolled to
		// the correct position for the next element.  This calcuation will using this in
		// currentHeight calculation for the next iteration
		var currentTitleAndSecitonHeight = $(element).prev().outerHeight(true) + $(element).outerHeight(true);
		//alert("The current Height = " + currentTitleAndSecitonHeight)

		// Each anchor in the navigation Links will now the index, section id,
		// section header name and y-position.
		// TODO : Remove data elements that are not needed anymore
		var startIndex = index * 2;
		var endIndex = (index * oneSectionForManyLinks ) + ( oneSectionForManyLinks);

		var currentHeight = height + heightOfHeaderAndSectionsAccumulator

		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSection', index);
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionName', $(element).attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionHeaderName', $(element).prev().attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-position-height', currentHeight);

		// Each section will know id, the id its header and the y-postion of its sectionHeaderBoxHeight
		$(this).attr('data-riskFormSectionName', $(element).attr('id'));
		$(this).attr('data-riskFormSectionHeaderName', $(element).prev().attr("id"));
		$(this).attr('data-position-height', currentHeight)

		heightOfHeaderAndSectionsAccumulator = heightOfHeaderAndSectionsAccumulator + currentTitleAndSecitonHeight;

	});
}

/**
 * Make an AJAX call to the back end.  The purpose is to handle a Get or POST
 * so the developer does not need whether the call is a GET or POST
 */
function processSubmission(form){

	// Determine how the parameters will be sent to the web tier
  var userData = (form.method == 'get') ? $(form).serialize() : new FormData(form);

	convertQuestionAndAnswersToTableRows("riskForm", "InputParameters")

	// Send the data to the web tier.
	$.ajax({
		url: form.action,
		type: form.method,
		dataType: 'json',
		data: userData,
    contentType: false,
    processData: false,
	}).done(resultsDisplay)
	.fail(function(xhr, ajaxOptions, thrownError) {
		console.log("xhr = " + xhr.ressponseText)
		console.log("ajaxOptions = " + ajaxOptions.toString())
		console.log("thrownError = " + thrownError)
		console.log("error");
		$("#systemError").modal("show");
	})
	.always(function() {
		$('html,body').scrollTop(0);
		$('body').attr('tabindex','-1');
		$('body').focus();
	});
}

/*****************************************************************************/
/* function : Goto the Calculate Page                                        */
/*****************************************************************************/
function goto_calculatePage() {
	window.location = "calculator.html"
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

	adjustNavigationBarLine();

	handleScrollEvent();
	$('html,body').scrollTop(0);

	// Problem : When hispanic is selected textual information is added to the
	// Question/Answer.  However, the user can click on the Edit Response and
	// if Hipsanic is still the answer the information will be attached twice.
	// This code will remove the information when the user goes back to the
	// calculate page.
	$("[data-dynamicallyAdded='true']").each( function(index,element) {
		element.parentNode.removeChild(element)
	});
}

/*****************************************************************************/
/* Display the page so the user can view the results                         */
/****************************************************************************/
function go_toresult() {
	$('#main').addClass('hide')
	$('#form-steps').addClass('hide')
	$("#results").addClass('show')
	$(window).scrollTop(0);

	// Certian Buttons are anchor tags and need to have the text centered for their form
	$("#startOverButton").on("click", goto_calculatePage);
	if ( isMobile() )
		$("#startOverButton").addClass("spacerBetweenQuestionsAndStartButtonMobile")
	else
		$("#startOverButton").removeClass("spacerBetweenQuestionsAndStartButtonMobile")

	// If we are currently on a mobile phone then remove the margin from the
	// "Start a New Assessment Button so the buttons are closer toegher"
	if ( isMobile() ) {
		$("#startOverButton").removeClass("spacerBetweenQuestionsAndStartButtonMobile")
	}

	// This code is a hack and this should be done in CSS.  I put the code in
	// here since we are trying to get it done and it might have unforseen
	// consequences if put in the CSS Style
	if ( isTablet() ) {
		$("#results_home").css("padding-top", "6px")
	}

	// This is needed for the calculate button on the input entry form, so
	// set this to false when you go the resutls page
    var validator = $("#riskForm").data("validator");
    $(validator).data("mouseEventSubmitForm", false);
    $(window).data('mouseEvent', false)

}

/******************************************************************************/
/* Create a pie chart                                                         */
/*                                                                            */
/* Parameters:                                                                */
/*   percent		       	The change that the victim will get cancer        */
/*   divContainerForChart  	The HTML Container that will cotnain the chart    */
/*   color1 			The color for the chance of getting cancer            */
/*   color2  			The color for the chance of not getting cancer        */
/******************************************************************************/
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
					.append("svg")
          .attr('width', width)
          .attr('height', height)
	  			.attr('viewBox', '0 0 ' + width + " " + height)
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
// To update the navigation bar when the user scrolls the page.  By uising    //
// ignoreIfOneSectionIsVisible(), this algorithm will handle the situation    //
// when only one screen is being displayed                                    //
////////////////////////////////////////////////////////////////////////////////
function formScrollSpy() {

	if ( existFormSteps() == false ) return;

	// Rule: If there is only once section visible then just return
	if ( ignoreIfOneSectionIsVisible() ) return;

	// Calculate the bottom of the Form Steps where the questions will start.
	var window_top = $(window).scrollTop();
	window_top = window_top + calculateBottomOfFormSteps();

	if ( ignoreIfOneSectionIsVisible() == false ) {

		$.each($("#riskForm section:visible"), function(ind, el) {

			// Retrieve the top most pixel of the header belonging to section
			// If mobile
			var sectionHeight =$(this).attr('data-position-height');

			// If the current section is just below the navigation bar ( form-stpes)
			// then that section should be the active.
			if ( window_top >= sectionHeight) {

				// Remove the active style from any navigation link and apply it to the
				// current link being processed.
				//
				// Rule : In order to be active the button must be visible.  For example
				// in CCRAT the male question/answers have five sections and the female
				// has four sections.
				$("#form-steps li").removeClass('active');
				$("#form-steps li:eq(" + ind + "):visible").addClass('active');
				adjust_line_width(ind);
			}
		});
	}

	// Rule : Scrollbar at very top the first navigation elements ( link/button)
	// should be active
	if ( $(window).scrollTop() == 0 ) {
		$("#form-steps li").removeClass("active")
		$('#form-steps li').first().addClass('active');
		adjust_line_width(0);
	}

	// Rule  : If there is only one section of data of the first set of navigation links should be active
	// Rule  : If more than one section of data and the Scrollbar is at the bottom then the last navigation elements (link/button)should be active
    if ( ignoreIfOneSectionIsVisible() == true )
		return;
	else {
		if ( $("#form-steps li.active:visible").length == 0 ) {
			$("#form-steps li").removeClass('active');
			$("#form-steps li:visible:last").addClass("active")
		}
	}
}

/******************************************************************************/
/* When a navigation number or name is clicked then the form should be scroll */
/* ed to just below the seciton header                                        */
/******************************************************************************/
function gotoSection(event) {

	// Rule: If there is only once section visible then just return

	var indexOfSection = undefined
	var sectionName = undefined
	var scrollFor = undefined

    //if ( $(event.target).parent().hasClass("active") )
    //    return;

	if ( ignoreIfOneSectionIsVisible() ) {

		// The purpose of this code is to handle the situation where there is only a signle section being dispalyed.  An exmaple
		// is MRAT.  Before the user select male/female there is only one section.  The code will only scroll to top if the first
		// set of navigation links are selected.  If other navigation links are selected then  nothing will happen.
		indexOfSection = 0;
		scrollFor = 0

		// Only scroll if the header is not displayed otherwise ignore it.
		var sectionButtonOrLinkedPushed = $(this).attr('data-riskFormSection')
		if ( sectionButtonOrLinkedPushed == 0 && $(window).scrollTop() != 0)
			$("html, body").animate({scrollTop: 0}, 2000)

		// Stops the event propogration or you could get weird events from happening.
		$(this).blur()
		event.preventDefault()

	} else {
		// The purpose of this code is to handle the situation where there are multiple section being displayed.
		indexOfSection = $(this).attr('data-riskFormSection')

		// Remove the active style from the previous link and apply it to the
		// current link.
		var elementContainingListItems = $(this).parent().parent();
		$(elementContainingListItems).children("li").removeClass('active');
		$(this).parent().addClass('active');
		adjust_line_width(indexOfSection);

		sectionName = $(this).attr("data-riskFormSectionHeaderName")
		scrollFor = 2000
	}

	var heightOfFormSteps = $("#form-steps").outerHeight(true)

	// Find the top point of the section, but if its the first section then go to 0 point
	// so the header will be displayed.  The heaer is only displayed when scrolled to
	// the top most pixel
	var scrollTo = ( indexOfSection == 0 ) ? 0 : $("#" + sectionName).position().top;

	// This code was written due to an analysis of the code running.  When the first
	// naivagion button was highlighted and the user clicked any other navigation
	// button then the user was being scrolled to a pointer higher then was should
	// have been scrolled to.  This code fixeds the problem.
	if ( indexOfSection != 0 && $(window).scrollTop() == 0) heightOfFormSteps = heightOfFormSteps * 2

	// Scrolls to the actual point
	var possibleNewValue = scrollTo - heightOfFormSteps
	scrollTo = ( possibleNewValue <= 0 ) ? 0 : possibleNewValue
	$("html, body").animate({scrollTop: scrollTo  }, scrollFor )
}

/* Makes a Section of the Forms Active ( Bubble and Text )                    */
/*                                                                            */
/* Input : An index starting at 1 ( index of list item to make active         */
/*                                                                            */
function makeFormStepsSectionActive(index) {

   $("#form-steps ol li").removeClass("active")

   var stringSelector = $("#form-steps ol li:nth-child(" + index + ")")
   $(stringSelector).addClass("active")
}

/* Determine if either male or female has been selected                       */
/*                                                                            */
/* The algorithmm will first check see if any Html object with the name       */
/* gender is on the page.  If it is on the page then male/female play a part  */
/* in the calculations.  If it is not on the page then it will be ignored     */
/*                                                                            */
/* If there is an HTML Object with the name gender make sure that either male */
/* or female has been selected                                                */
/*                                                                            */
/* Return (T) An HTML Object is name gender and either male/female is         */
/* checked or there is no HTML Object called gendar                           */
/*                                                                            */
/* Return (F) There is an HTML Object with the name gendar, but male/female   */
/* has not been selected.                                                     */
function isMaleOrFemaleChekced() {
        var result =  ( $("input[name='gender']").length == 0 ) ? true : $("input[name='gender']:checked").length;
	result;
}

/////////////////////////////////////////////////////////////////////////////////
// Allows the Header, Navigation and Toolbar to stay at the top of the screen  //
/////////////////////////////////////////////////////////////////////////////////
function fixedToTop(div,use_mobile) {
	var header_height=$('header').outerHeight(true);
	var window_top = $(window).scrollTop();
	var div_top = $("#"+div).offset().top;
	var tool_title_height=$('#toolTitle').outerHeight(true);
	var form_steps_height = ( existFormSteps() ) ? $('#form-steps').outerHeight(true) : 0;

	function hideCalculatePageHeader(div, pixelCount) {
		$("header").css("visibility", "hidden");
		$("#toolTitle").removeClass("fixed")
		$("#" + div).css("margin-top", pixelCount + "px" )
	}

	function showCalculatePageHeader(div, pixelCount) {
		$("header").css("visibility", "visible");
		$("#toolTitle").addClass("fixed")
		$("#" + div).css("margin-top",pixelCount + "px")
	}

	function showMainOrAboutPageHeader(div, pixelCount) {
		$("header").css("visibility", "visible")
		$("#" + div).css("padding-top", pixelCount + "px")
	}

	function hideMainOrAboutPageHeader(div, pixelCount) {
		$("header").css("visibility", "hidden")
		$("#" + div).css("padding-top", pixelCount + "px")
	}

	// Determines if the user is viewing the results page
	var onResultsPage = ( ( String($("#form-steps").attr("class"))).indexOf("hidden") > -1 ) ? true : false


	// if isMobile and onResultsPage then the user will be viewing the result page
	// if isMobile and existFormSteps then the user will be viewing the input page
	// else the user will be viewing the main or the about page
	//
	// window_top > 0 							: The window has been scrolled
	// window_top <= 0 (Usually else keyword ) 	: Effectivelty at the top of the window
  	if ( isMobile()) {
		if ( onResultsPage == true) {

			if ( window_top > 0 ) {
				$("header").addClass("fixed")
				hideCalculatePageHeader("results_home", $("#results_home").css("margin-top"))
			} else {
				$("header").removeClass("fixed")
				showCalculatePageHeader("results_home", $("#results_home").css("margin-top"))
			}

		} else if ( existFormSteps() ) {
			if ( window_top > 0 )	{
				header_height = 0
				$("header").removeClass("fixed")
				hideCalculatePageHeader("riskForm", 0)
			} else {
				height = header_height + form_steps_height + 14
				$("header").addClass('fixed');
				showCalculatePageHeader("riskForm", height)
			}

			// Form Steps is always fixed.  The only variable is its height.
 			$("#form-steps").css("top",header_height+"px");
			$("#form-steps").addClass("fixed");
		} else {
			if ( window_top > 0 )
				hideMainOrAboutPageHeader("main_home", 0)
			else {
				$("header").css("visibility", "visible")
				showMainOrAboutPageHeader("main_home", $("header").outerHeight(true))
			}
		}
		return
  	}

	// Handle the Desktop Case since mobile is only for phones and tables
	if ( isMobile() == false && window_top > 0) {
		$("#form-steps").addClass('fixed');
		if($(window).width()>=992)
		 	$("#line").find("hr").css("top",form_steps_height-30)
		else
		 	$("#line").find("hr").css("top",form_steps_height-37)
	} else {
		if ( existFormSteps() ) {
			$("#form-steps").removeClass('fixed');
			adjust_line_height_dekstop()
		}
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

///////////////////////////////////////////////////////////////////////////////
// Handles an event such as a scroll, touchmove etc.  The routine will make  //
// sure that the top elements such as the navigation bar and header always   //
// stay at the top. Also to make sure that the correct navigation elements   //
// are highlight ( depends on which section is below the headers)            //
///////////////////////////////////////////////////////////////////////////////
function handleScrollEvent(event) {
	handleHeaderNavigationRedraw();

	//alert("Handling Scroll Event");
	// Works wrong on IE9 - it blurs the whole browser window if active
	// element is document body. Better to check for this case:
	// if (document.activeElement != document.body) document.activeElement.blur();

}

/* Resubable code to adjust the header/navigation bar                         */
function handleHeaderNavigationRedraw() {
	var top_div = ( $(window).width() > 630 ) ? "main-nav" : "toolTitle";

	fixedToTop(top_div);
	formScrollSpy();
	if ( existFormSteps() == true ){
		var midPointX = adjustNavigationBarLine()
		//adjustLinks(midPointX)
	}
}

/******************************************************************************/
/* Adjusts the line connections the navigation bar circles                   **/
/******************************************************************************/
function adjustNavigationBarLine() {
	adjust_line_width()

	var midPointX = undefined
	if( isMobile() )
		midPointX = adjust_line_height_mobile();
	else
		midPointX = adjust_line_height_dekstop()

	return midPointX
}

function adjustLinks(midPointX) {
	$("#form-steps ol > li:visible > a:nth-child(2)").each(function() {
		var heightOfCircle = $(this).css("height")
		var topPointOfCircle = parseInt(midPointX) - (parseInt(heightOfCircle)/2)
		if ( topPointOfCircle < 100 ) {
			var startingPointOfCircle = midPointX - topPointOfCircle
			$(this).css("top", startingPointOfCircle + "px")
		}
	})
}

/******************************************************************************/
/* For the navigation component set the length of the line that connects the  */
/* navigation circles so that all are connected                               */
/******************************************************************************/
function adjust_line_width(ind){
	var firstBubble = $("#form-steps > ol > li > a.step-node").first();
	var lastBubble  = $("#form-steps > ol > li:visible:last > a.step-node").first();

	var startingPoint = $(firstBubble).offset().left + $(firstBubble).width();
	var endingPoint = $(lastBubble).offset().left - startingPoint;

	$("#line").find("hr").css("left",  startingPoint);
	$("#line").find("hr").css("width", endingPoint );
}

/******************************************************************************/
/* For the navigation component set the height of the line that connects the  */
/* navigation circles so that are connected along the line                    */
/*                                                                            */
/* Note Stopping Here since I need to get back to bcriskTool                  */
/* The comment first bubble is one of navigation bubbles with the class       */
/* active                                                                     */
/******************************************************************************/
function adjust_line_height_dekstop(){

  var firstBubble = $("#form-steps ol li").not(".active").children().filter("a:nth-child(2)").first()
  var startPoint = $(firstBubble).position().top + $(firstBubble).height()/2;
  $("#line").find("hr").css("top", startPoint);

	return startPoint
}

/******************************************************************************/
/* For the navigation component set the height of the line that connects the  */
/* navigation circles sot that they are connected along the line for mobile   */
/*                                                                            */
/* Note: I first tried using adjust_line_height_dekstop for positioning the   */
/* the line veritically, but it did not work, so I had to tweak the code that */
/* I used above                                                               */
/*                                                                            */
/* TODO : Is there a way to merge the adjust_line_height_dekstop with the     */
/* adjust_line_height_mobile() ?                                              */
/******************************************************************************/
function adjust_line_height_mobile() {
	var firstBubbleTopPosition = $("#form-steps > ol > li > a:nth-child(2)").first().position().top;
	var height = $("#form-steps > ol > li > a:nth-child(2)").first().height();
	var startPoint = firstBubbleTopPosition + ( height /2 );
	$("#line").find("hr").css("top", startPoint);

	return startPoint
}

/******************************************************************************/
/* Based on the Currrent Page hihglight the link for current pages os the user*/
/* know that is the page they are on                                          */
/******************************************************************************/
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

// Get the bottom pixel location of the #form-steps.
//
// Algorithm
//	If the form-steps ( navigation bar) does not exist then return 0
//  If the form-stpes ( navigation bar) does exist then return the right of the form-steps
//
function calculateBottomOfFormSteps() {
	var height = ( existFormSteps ) ? $("#form-steps").position().top + $("#form-steps").outerHeight(true) : 0;
	return height;
}

/* Verify that we can rid of this function */
function calculatePositionToScrollTo(target) {
 	var positionOfHeader = $(target).position().top;
	return positionOfHeader - calculateBottomOfFormSteps();
}

/******************************************************************************/
/* Handles the toggle menu opening/closing for mobile applications            */
/*                                                                            */
/* Problem : As of October 5, 2017 : When the user click the Hanmburger Icon  */
/* and the menu either opened or closed the 2nd Hamburger Icon found in the   */
/* HTML Object name side_nav would have its first line displayed below it.    */
/* The situation was fixed by hiding the hamburger icon from the side_nav and */
/* making it appear a few milliseocnds so the animation has time to complete  */
/*                                                                            */
/* It has been very hard to get the submenu to position itself horizatally    */
/* so I tried a new stratergy instead of creating a one algorithm for         */
/* all browsers/mobile devices, I create one algorithm for the desktop and    */
/* one algorithm for the mobile.                                              */
/******************************************************************************/
function toggle_menu(e){
	  var top
		if ( isMobile() == false )
		{
			top = $('#toolTitle').offset().top + 'px'
			$("#side_nav").css("right", 0);
			$("#side_nav").css("margin", 0);
		} else {
			top = $('#toolTitle').position().top + 'px'
			$("#side_nav").css("margin-top",0)
		}

		$("#side_nav").css("position", "absolute");
		$("#side_nav").css("top", top)


    if($("#side_nav").width()>0){
        $("#side_nav").show().animate({ width: "0%" },{ duration: 300, complete: function() {
            $('#side_nav .glyphicon-menu-hamburger').css('display', 'none');
            $("#form-steps").css("z-index","1");
            }
        });

    } else {
		$("header").css("z-index","200")
		$("#side_nav").stop(true,true).show().animate({width: "70%"},{ complete: function() {
		  $('#side_nav .glyphicon-menu-hamburger').css('display', 'inline-block');
		    }
		    }
		);
    }
}

// Whenever the window is opened and the side navigator is open then close it.
$(function() {
	$(window).on('resize', function(event) {
		if ($('#side_nav').width() > 0) $("#side_nav").animate({ width: "0%" });
	})
})

// Problem with Internet Explorder.  When the screen is minized and then
// resized $('#side_nav .glyphicon-menu-hamburger') which causes it to have
// Form steps many pixels below the header.  This is a hack.  I cam keeping
// this code in here becausse I might be changing it to
$(function() {
	$(window).on('resize', function(event) {
		if ( $(window).width() >= 992 )  $('#side_nav').css('display', 'none');
	})
})

/******************************************************************************/
/* Is the device a mobile tablet.  See isMobile for comments                  */
/******************************************************************************/
function isTablet() {
	var checkUserAgent = /iPad/i.test(navigator.userAgent);

	var checkPlatform = false
	if ( checkUserAgent == false ) {
		 checkPlatform = /iPad/i.test(navigator.platform);
	}

	return checkUserAgent || checkPlatform
}


/******************************************************************************/
/* Is the device a mobile phone or tablet ?  This routine is broken           */
/* In order to keep the code as close to the original as possible ( since     */
/* the code is being changed very late and I don't totally understand the     */
/* situation, I only check the platform if the UserAgent returned false       */
/* ( A double check to see if the device is mobile)							  */
/******************************************************************************/
function isMobile() {
	var checkUserAgent = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

	var checkPlatform = false
	if ( checkUserAgent == false ) {
		 checkPlatform = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.platform);
	}

	return checkUserAgent || checkPlatform
}

/******************************************************************************/
/* Remove all the top and bottom margins for the section                      */
/******************************************************************************/
function removeSectionMargins()
{
	$("#riskForm section").each(function(index, element) {
		$(element).css("margin-top", "0px");
		$(element).css("margin-bottom", "0px");
	});
}

/******************************************************************************/
/* Remove all the top and bottom margins for the section headers              */
/******************************************************************************/
function removeSectionHeaderMargins()
{
 	$(".sectionTitle").each(function(index, element) {
		$(element).css("margin-top", "0px");
		$(element).css("margin-bottom", "0px");
	});
}

//////////////////////////////////////////////////////////////////////////
// These next two functions take care of the border around the input    //
// when the user tabs or clicks the input field, a border apears        //
// around that.  However for Section 509, it seems only the border      //
// needs to appear if the user is tabbing into the input field          //
//                                                                      //
// When there is a mouseDown event the mouse down event is executed and //
// then the focus event is execute.                                     //
//////////////////////////////////////////////////////////////////////////

// Stores information that the mouse was pressed so that the focus event
// can know that it was mouse down event.
function mouseDownBorderToggle(event) {
	var $this = $(this)

	// Only set the data attribute if its not already focused, as the
	// focus event wouldn't fire afterwards, leaving the flag set
	if ( ! $this.is(':focus')) $this.data('mouseEvent', true);

	$("*").addClass("removeOutline")
	$("*").removeClass("addOutline")

	// This may not be needed anymore since I added a focusOut event.
	// In the future, this should be verified that it can be removed.
	//document.activeElement.blur()
}

// Executes the code to remove or add the border around the input element
// whether it was a mouse event or the user tabbed into it.
function focusBorderToggle(event) {
	var $this = $(this);
	var validator = $("#riskForm").data("validator");

    var mouseDown = $this.data('mouseEvent') || $(validator).data('mouseEventSubmitForm');

    $this.removeData('mouseEvent');
    $(validator).removeData('mouseEventSubmitForm');



	if ( mouseDown ) {
        removeOutline(event)
    } else {
        $("*").removeClass("addOutline")
		$(event.target).removeClass("removeOutline");
		$(event.target).addClass("addOutline")

	}
}

// A helper functon to remove the outline since it will be used in nother place
// Put the code here since it will be used in more than one place.
function removeOutline(event) {
	$(event.target).addClass("removeOutline");
	$(event.target).removeClass("addOutline");
}

/******************************************************************************/
/* If the element is disabled it enables it and if enabled it disables it.    */
/******************************************************************************/
function toggleInputs(input) {
    if ($(input).attr("disabled"))
        $(input).removeAttr('disabled');
    else
        $(input).attr('disabled' ,true);
}

function connectDefintionsToApp(applicationGlossary) {

	// Merge your term/defintions with the global glossary terms and definitions
	$.extend($_Glossary, applicationGlossary);

	// Bind to the the click event and the on-touch event
	$(document).on("click touchstart", ".definition", termDisplay);

	// We are using Bootstrap tooltips so they need to be initialized.
	$('[data-toggle="tooltip"]').tooltip();
}

function doesElementContainTerm(element) {
	return $(element).attr("data-term") !== undefined
}

function addDefintion(element) {
	$(element).attr("data-toggle","tooltip");
	$(element).attr("data-term", $(element).text());
}

/*****************************************************************************/
/* Displays information about the term embedded within the HTML Element as   */
/* text.                                                                     */
/*****************************************************************************/
function displayHelpWindow() {
  var definitionName = $(this).text();
  var definition = "";


  if ( terms.hasOwnProperty(definitionName)) {
    definition = terms[definitionName].definition;
  } else {
    console.log("Popup Window: No definition found for " + definitionName);
    return;
  }

  window.open(definition,"_blank","width=355,height=450");
}

/******************************************************************************/
/* Does the Form Steps HTML Object Exist and are they visible.  If they are   */
/* not visible then they technically do not exist since the user cannot see   */
/* them.                                                                      */
/******************************************************************************/
function existFormSteps() {
	return ( $("#form-steps:visible").length > 0 );
}

// Two functions to disable and enable  the section headers ( Currently a
// seciton header is text embedded in a h2 tag
function disableSectionHeaders() {
	$(".sectionTitle").attr("disabled","disabled").attr("aria-disabled",true);
	$(".sectionTitle").addClass("disableSectionTitle")
}

function enableSectionHeaders() {
	$(".sectionTitle").removeAttr("disabled").attr("aria-disabled",false);
	$(".sectionTitle").removeClass("disableSectionTitle")
}

///////////////////////////////////////////////////////////////////////////////
// Disable a form by doing the following                                     //
//   1. Disable all input except the reset button                                                //
//   2. Lighten the Seciton Header, Questions and Answers                    //
///////////////////////////////////////////////////////////////////////////////
function disableForm() {
	$("form :input").not("#reset").prop('disabled', true);
	$("form a").addClass("disabled")
	$("form [role=radio]").css("color","#C0C0C0");
	$("form [role=radio]").attr("tabindex","-1").attr("aria-disabled",true);
	$("[class*='questions']").css("color","#c0c0c0").attr("aria-disabled",true);
	disableSectionHeaders();
}

////////////////////////////////////////////////////////////////////////////////
// Enable a from by doing the follwoing                                       //
//    1. Enable all input to the form except the reset button                 //
//    2. Darken the Seciton Header, Questions and Answers                     //
////////////////////////////////////////////////////////////////////////////////
function enableForm() {
	$("form :input").not("#reset").attr('disabled', false);
	$("form a").removeClass("disabled")
	$("form [role=radio]").css("color","#606060").attr("aria-disabled",false);
	$("[class*='questions']").css("color","#2E2E2E").attr("aria-disabled",false);
	$("form [role=radiogroup]").each(function() {
		if( $(this).find("[role=radio][aria-checked=true]").length > 0 ) {
		  $(this).find("[role=radio][aria-checked=true]").attr("tabindex","0");
		} else {
		  $(this).find("[role=radio]:first").attr("tabindex","0");	
		}
	});
	enableSectionHeaders();
}

////////////////////////////////////////////////////////////////////////////////
// Calculates the Starting point of the Risk Form for the mobile appear
// This takes into account the space taken up by the header, form steps and
// 14 pixel which I cannnot remember why I put in there
////////////////////////////////////////////////////////////////////////////////
function calculateForMobileRiskFormStart() {
	var header_height=$('header').outerHeight(true);
	var form_steps_height = ( existFormSteps()) ? $('#form-steps').outerHeight(true) : 0;
	var height = header_height + form_steps_height + 14;
	return height;

}

///////////////////////////////////////////////////////////////////////////////
// This is a hack, the problem is for the MRAT some of the sections are hidden
// When the user scrolls to the bottom then the navigation links for the third
// section is highlighted.  This is wrong since there is only one section and
// the 1st navigtation links should be hightlighted, not the last.
// As a quick hack and the best idea that I have, is to ignroe the movement
// to a different section if there is only section visible.
////////////////////////////////////////////////////////////////////////////////
function ignoreIfOneSectionIsVisible() {
	return ( $("section:visible").length <= 1 )
}

///////////////////////////////////////////////////////////////////////////////
// Redraws a specific HTML Object
//
// In IE 11 whenever a value from a drop down was choosen the background color
// of the choosen element was still visible ( blocknig the background color)
// of the drop down.  If the element is redrawn then the selected background
// color should go always
///////////////////////////////////////////////////////////////////////////////
function redrawHTMLObject() {
	$(this).hide().show(0)
}

///////////////////////////////////////////////////////////////////////////////
// This function will scroll pass the Logo.  One of it uses is to be used    //
// to go directly to the conentent since that is section 508 requirement     //
///////////////////////////////////////////////////////////////////////////////
function scrollPassLogo() {

	$("[class*='sr-only-focusable']").blur()

	var pixels = $("#toolTitle").position().top;
	$('html, body').animate({ scrollTop: pixels }, 1000);
}

/*****************************************************************************/
/* A function that will retrieve the Questions ( must have style questions)  */
/* and the current answers at the time the user pressed the calculate button */
/*                                                                           */
/* input -- name of a form where the questions/answers will be retrieved     */
/* input -- name of table where they will be appended to.                    */
/* output -- A collection of <trow> containing the questions and answers     */
/*****************************************************************************/
function convertQuestionAndAnswersToTableRows(formName, tableName) {

	var formName = "#" + formName
	var form = $(formName)

  	var tableName = "#" + tableName
	var table = $(tableName)

	var allTablesRows = undefined;

	// Remove all <TR> nodes from the tree except the header
	$(tableName + " tbody").find("tr:gt(0)").remove()

	// Verify that the parameters are valid
	if ( form.length != 1 ) {
		console.log("Error : Invalid Parameter form name for convertQuestionAndAnswersToTableRows ")
	}

	if ( table.length != 1 ) {
		console.log("Error : Invalid Parameter table name for convertQuestionAndAnswersToTableRows ")
	}

	// TODO : Find a better way to handle the situation where there is a global
	// to functions.  May closures or in this case CSS Counters

	// Number of SubQuestion One after another
	var numberOfSubQuestionsInARow = -1

	// Number of SubSubQuestions One after another ( this is two levels of indentation)
	var numberOfSubSubQuestionsInARow = -1

	// Number of SubSubSubQuestions.  One after another ( this is for three level of indentation)
	var numberOfSubSubSubQuestionsInARow = -1

	// Number of SubSubSubSubQuestions.  One after another ( this is for four levels of indentation)

	// Number of total subquestion before the current question
	var numberOfSubQuestions = 0

	// Number of total subSubQuestion before the current question ( this is two levels of indentation )
	var numberOfSubSubQuestions = 0

	// Number of total subSubSubQuestion before the current question ( this is for three levels of indentation )
	var numberOfSubSubSubQuestions = 0

 	$(formName + " label.questions").filter(filterInputParameters).each(function(index, element) {

		// Extracts the current answer from the input screen to the current question
		//
		// Assumption : The User has completed filling out the form
		//
		// Input
		//	first response to current question
		//
		// Output
		//	The answer from the input page that the user selected.
		// Output
		//	NA if there is no answer ( for some questions to be answered other questions must be answered with a specific value )
		//
		// Bug
		//	Between the div with the class question and the div with the class responseOptions do not put any div. Usually what
		//  would go between there would be a secondary question.  Use a paragraph tag instead of a div tag
		//
		function extractAnswerDispalyedOnGui(inputElement) {

			var inputText = ""
			if ( inputElement.is(":radio"))	{
				// Get the name attribute which the radio button use for the variable name of the Data
				// Using the nane get the input value from the Form Data.

				var name = $(inputElement).attr("name")
				var value = $("input[name='" + name + "']:checked").val()

				// Select the answer text from the input page.
				var nameSelector = "[name='" + name + "']"
				var valueSelector = "[value='" + value + "']"
				inputText = $(nameSelector + valueSelector + ":checked").next().text()
			} else if ( inputElement.is("select")) {
				if ( $(inputElement).is(":enabled") ) {
					inputText = $(inputElement).find(":selected").text();
				}
			} else {
				if ( typeof ratSpecificAnswer == 'function') {
					inputText = ratSpecificAnswer(element)

				}
			}

			// If the elment is disabled there should be no answer to the question.
			if ( $(inputElement).filter(":disabled").length > 0 ) {
				inputText = ""
			}

			if ( !inputText ) { inputText = "n/a"}

			return inputText
		}

		// Creates a TD Tag with the number of the question a period and the question itself
		function createQuestionCell(index, questionText) {

		 	// There are two types of questions:
		 	//    Questions will have a numeric number that need to have one added to it
		 	//    since the index is 0-based and subtracted using the number of previous
		 	//    subquestions asksed.
		 	//
		 	//    Subquestions will use the alphabet for number.  The first one will get
		 	//    an "A" and the second will get a "B".  Once a new question without
		 	//    the data-subquestion attribute is found then the next subqestion will
			//    get "A"
			//
			// 	  Later on two enhanncments were added to have two more levels.  This code
			//    could be improved by making it recursive.
		 	//
		 	//		Returns to values
		 	//			An index string for questions a number, but for subquestion a lowercase letters
		 	//     		True if the element is a subqeustion
		 	function handleIndex(index, element, inputElement) {

				var letters = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "l", "m", "n" ]
				var numbers = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" ]
			 	var indexString = ""
			 	var isSubQuestion = false

		 	 	if ($(element).attr("data-subQuestion")) {
					numberOfSubQuestions = numberOfSubQuestions + 1
					numberOfSubQuestionsInARow = numberOfSubQuestionsInARow + 1
					indexString = letters[numberOfSubQuestionsInARow]

					numberOfSubSubQuestionsInARow = -1
					numberOfSubSubSubQuestionsInARow = -1

					isSubQuestion = "Level 1"

				} else if ( $(element).attr("data-subSubQuestion")) {
					numberOfSubSubQuestions = numberOfSubSubQuestions + 1
					numberOfSubSubQuestionsInARow = numberOfSubSubQuestionsInARow + 1
					indexString = numbers[numberOfSubSubQuestionsInARow]

					numberOfSubSubSubQuestionsInARow = -1

					isSubQuestion = "Level 2"

				} else if ( $(element).attr("data-subSubSubQuestion")) {
					numberOfSubSubSubQuestions = numberOfSubSubSubQuestions + 1
					numberOfSubSubSubQuestionsInARow = numberOfSubSubSubQuestionsInARow + 1
					indexString = letters[numberOfSubSubSubQuestionsInARow]

					isSubQuestion = "Level 3"

				} else {
					numberOfSubQuestionsInARow = -1
					indexString = index - numberOfSubQuestions - numberOfSubSubQuestions - numberOfSubSubSubQuestions
			 	}

			 	return { indexString: indexString, isSubQuestion: isSubQuestion }
	   		}

 	 	 	var indexData = handleIndex(index + 1, element)

		 	// The spacing between the number and the question is different if you
			// two number ( ex. 10) vs one number
		 	var paddingRight = ( Number(indexData.indexString) > 9 ) ? ".5em" : "1em"

		 	var question = $("<td></td>").addClass("questions")
		 	var container = $("<div></div>").css("display","flex").css("flex-direction","row")
		 	var lineNumberSpan = $("<span></span>").text(indexData.indexString).addClass("questionNumber")
 		 	var linePeriodSpan = $("<span></span>").text(".").css("padding-right", paddingRight)
 		 	var lineNumber = $("<div></div>").append(lineNumberSpan).append(linePeriodSpan)
			var extraInformation = undefined;
			if ( typeof addInformationToTheQuestions !== "undefined" ) extraInformation = addInformationToTheQuestions(inputElement)

			// The Div is 50% width of the flx box and the paragraph tags take up the full width of the div that is a child of the flex box so each paragraph is on a certain line.
			// use $('<p></p>') since .append("<p>" + questionText + "</p>") could have javascript injected into it
			var questionTextBlock = ( extraInformation === null ) ? $("<p></p>").append(questionText) : $("<div></div>").append($('<p class="questionHasExtraInformation"></p>').append(questionText)).append(extraInformation)
			var questionDiv = container.append(lineNumber).append(questionTextBlock);

		 	if ( indexData.isSubQuestion == "Level 1" ) {
			   questionDiv.addClass("levelIdentation1")
		 	} else if ( indexData.isSubQuestion == "Level 2") {
			   questionDiv.addClass("levelIndentation2")
			} else if ( indexData.isSubQuestion == "Level 3") {
			   questionDiv.addClass("levelIndentation3")
			}

		 	return question.append(questionDiv)
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// Create the row that contains the line number, question and answer                //
		//////////////////////////////////////////////////////////////////////////////////////

		// Gets the first answer markup.  The first answer will usually be a checkbox or a select box.
		// So, the user will be able to get the answer from the infromation.  However, if the answer
		// is different ( ex. 3 text boxes for the height/width/lbs ) then the algorithm will call
		// a routine from the specfic rat to handle the situation
		var inputElement = $($(element).nextUntil("label","div")[0]).find('input, select')
		if ( $(inputElement.length) == 0 ) inputElement = element

   	var inputAnswerText = extractAnswerDispalyedOnGui(inputElement)
   	var question = createQuestionCell(index, $(element).html(), inputElement)
   	var answer = $("<td></td>").text(inputAnswerText).addClass("answers")
   	var tableRow = $("<tr></tr>").append(question).append(answer)

		$(tableName + " tbody").append(tableRow)

		return true;

	});

}

////////////////////////////////////////////////////////////////////////////////
// Filter the list of input parameters based on some sort of critera          //
//                                                                            //
// This helper function exist since the filter function being called may or   //
// may not exist and I dont't a runtime error                                 //
//                                                                            //
// Input:                                                                     //
//   index, elemeent                                                          //
//                                                                            //
// Output:                                                                    //
//   (T) -- Keep the current object or the filter function is not defined     //
////////////////////////////////////////////////////////////////////////////////
function filterInputParameters(index, element) {

	// Determines if their is an filter to verify whether each element should be used
	var filterExist = ( typeof filterForInputParametersDisplay == "function" )

	result =  ( filterExist ) ? filterForInputParametersDisplay(element) : true

	return result

}

////////////////////////////////////////////////////////////////////////////////
// Handles the generic reset for all the risk analysis tools
////////////////////////////////////////////////////////////////////////////////
function genericResetForm() {
	$('form').trigger('reset');
	$("form [role=radio]").attr("tabindex","-1");
	$("form [role=radio]").attr("aria-checked","false");
	scrollTo(0,0);
	enableForm();
}

function genericResetValidator() {

  var validator = $('form').data('validator');
  validator && validator.resetForm();
  $(".borderError").removeClass("borderError");
}

///////////////////////////////////////////////////////////////////////////////
// Prints the current page of the website                                    //
///////////////////////////////////////////////////////////////////////////////
function printCurrentPage() {
	window.print()
}

////////////////////////////////////////////////////////////////////////////////
// Jumps to the start of a section taking into account the factors that could
// affect the positon showing up at the top of the screen.
//
// Note : I am hardcoding 40 in here for two reason
//   1. Not exaclty sure how to derive height from the css since
//      I am using a span and can find the height since it is inline
//   2. I know that 40px is the space between the header and the content
//      since that was asked in an IR.
////////////////////////////////////////////////////////////////////////////////
function jumpToSection(event) {
	var position 							= 0
	var url 								= $(event.target).attr("href")
	var spacerHeightBetweenSections 		= $(url).css("marginTop").replace("px","")

	if ( $(window).scrollTop() == 0 ) {
		var heightOfHeader 						= $("header").outerHeight(true)
		var spaceBetweenHeaderAndFirstHeader 	= 40;
		var hieghtOfToolTitle 					= $("#toolTitle").outerHeight(true)
		var spacerHeightBetweenSections 		= $(url).css("marginTop").replace("px","")
		position = $(url).offset().top - heightOfHeader -
										 spaceBetweenHeaderAndFirstHeader -
										 hieghtOfToolTitle -
										 spacerHeightBetweenSections
	} else {
		position = $(url).offset().top - spacerHeightBetweenSections
	}

	$('html, body').animate({ scrollTop: position }, 2000);
}

////////////////////////////////////////////////////////////////////////////////
// If a function exist thne call it                                           //
////////////////////////////////////////////////////////////////////////////////
function callIfFunctionExist() {

	// Determines if function exist
	var functionExist = ( typeof specificRatFooterInitialization == "function" )

	if ( functionExist ) {
		specificRatFooterInitialization()
	}
}

////////////////////////////////////////////////////////////////////////////////
// On the main page the link is not comming into view when it is tabbed to    //
// since part of the browser is blocking it.                                  //
//                                                                            //
// This code will scroll the link so it come into view.                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
function moveElementIfCloseToBottom(element) {

	var result = htmlObjectCloseToBottomOfScreen(element, 1)
	if ( result ) {
	  $("html, body").animate( { scrollTop: $(element).offset().top + $(element).height() })
	}
  }

////////////////////////////////////////////////////////////////////////////////
// This function will determine if the HTML Object's bottom is very close to  //
// the bottom.  If it is it will return true                                  //
//                                                                            //
// htmlObject -- The curent object being analysized                           //
// threshold  -- The nuber of pixels above bottom                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
function htmlObjectCloseToBottomOfScreen(htmlObject, threshold) {

	var elementHeight = $(htmlObject).height()

	var elementBottom 	=  $(htmlObject).offset().top 	+ $(htmlObject).height();
	var windowBottom 	=  $(window).scrollTop() 		+ $(window).height();

	return ( (elementBottom + elementHeight ) - windowBottom > 0 ) ? true : false;

}

///////////////////////////////////////////////////////////////////////////////
// Enables the first question and its associated Answers.  An example usage  //
// of this rouine is when the form is disabled, but you want one queston     //
// enabled.                                                                  //
//                                                                           //
// Inuut : A div with an id attribute specified.
//                                                                           //
// Example -- Do the person have cancer                                      //
//   User click Yes ( Since this is  preidictive tool, the form would be     //
//                    disabled and this question would be enabled)           //
//        click No then enable form                                          //
///////////////////////////////////////////////////////////////////////////////
function enableQuestionAndAnswers(divId) {
  $("#" + divId + " > label").css("color","#2E2E2E");
  $("#" + divId + " input").attr("disabled", false);
  $("#" + divId + " input").css("color", "#606060");
  $("#" + divId + " label").css("color", "#2E2E2E");
  $("#" + divId + " div").css("color", "#606060");
  $("#" + divId).find('[role=radio][aria-checked=true]:first').attr("tabindex","0");
}

////////////////////////////////////////////////////////////////////////////////
// Removes the error the message from Input that changed                      //
//		Input: Information about the event.                                   //
//                                                                            //
// Problem with prevUntil : If the element that matches the selector is the   //
// element directly above then nothing will returned and prev must be used    //
////////////////////////////////////////////////////////////////////////////////
function removeErrorMessage(event) {

	var getParent = $(event.target).parent()
	var question = $(getParent).prevUntil("label.questions").prev()
	if ( question.length == 0 ) question = $(getParent).prev()

    $(event.target).removeClass("error")
    $(event.target).removeAttr("aria-describedBy")

	var objectWithBorder = $(question).parent() 
	if ( objectWithBorder ) {
	    $(objectWithBorder).removeClass("borderError");
	    $(objectWithBorder).find("[role='alert']").remove()
	}

}

function registerCustomRadioAccess() {
	$("[role=radio]").each(function(){
		$(this).on('keydown',handleKeyDownRadioGroup);
		$(this).on('mousedown',handleKeyDownRadioGroup);
		$(this).on('focus',handleFocusRadioGroup);
	});
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// (T)rue if an apple product
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isAppleProduct() {
    var hardware = ( navigator.platform === 'MacIntel' || navigator.platform === 'iPad' || navigator.platform === 'iPhone') ? true: false
    var isSafari = !!navigator.userAgent.match(/Version\/[\d\.]+.*Safari/)
    return hardware && isSafari
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// (T) if internet explorer 11
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isIe11() {
    var isIE11 = ( !!navigator.userAgent.match(/Trident\/7\./)) ? true : false
    return isIE11
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// (T) if an iphone
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function isApplePhone() {
    var isPhone = ( navigator.platform === 'iPhone' ) ? true : false
    return isPhone
}

var KEYCODE = {
    DOWN: 40,
    LEFT: 37,
    RIGHT: 39,
    SPACE: 32,
    UP: 38,
	TAB: 9
}

function handleFocusRadioGroup(event) {
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

function handleKeyDownRadioGroup(event){
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
	  return $(node).parent().next('div').find('[role=radio]');
  }
  
  var previousRadioButton = function(node) {
	  return $(node).parent().prev('div').find('[role=radio]');
  }
  
  var firstRadioButton = function(node) {
	  return $(node).parent().parent().children('div.responseOptions:first').find('[role=radio]');
  }
  
  var lastRadioButton = function(node) {
	  return $(node).parent().parent().children('div:last').find('[role=radio]');
  }
  
  if(type === "keydown") {
    var node = event.currentTarget;
    var key = event.which || event.keyCode || 0;
    switch (key) {
      case KEYCODE.DOWN:
      case KEYCODE.RIGHT:
        var next = nextRadioButton(node);
		if ($(next).length === 0) next = firstRadioButton(node);
		break;

      case KEYCODE.UP:
      case KEYCODE.LEFT: 
        next = previousRadioButton(node);
        if ($(next).length === 0) next = lastRadioButton(node);
        break;

      case KEYCODE.SPACE:
        next = node;
        break;
    }

    if ($(next).length > 0) {
	  $(node).parent().parent().children('div').find('[role=radio]').each(function(){
		  setRadioButton($(this),false);
	  });
      event.preventDefault();
	  event.stopPropagation();
	  setRadioButton(next,true,true);
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
////////////////////////////////////////////////////////////////////////////////
// Startup Code
////////////////////////////////////////////////////////////////////////////////

$(document).ready(function() {

	////////////////////////////////////////////////////////////////////////////////
	// Problem : When the user clicks on the logo.  The user will goto to         //
	// cancer.gov, but the border will still be visible when coming back to the   //
	// original website.  This code will remove the border                        //                                                                 //
	////////////////////////////////////////////////////////////////////////////////
	$("#logo").on("mouseup", function(event) { mouseDownBorderToggle(event) })

	// Add the link that "Skip to Main Conetnet will use"
	$("#skipContentHome").attr("href", "javascript:scrollPassLogo()");
	$("#skipContentCalculate").attr("href", "javascript:scrollPassLogo()")
	$("#skipContentAbout").attr("href", "javascript:scrollPassLogo()")

	// Load the foot ander intialize the footer if the function exist in specificRat.js
	//$("#footer").load("./rat-commons/html/footer.html" , function() { typeof specificRatFooterIniialization == "function" && specificRatFooterIniialization()  })
	$("#footer").load("./rat-commons/html/footer.html" , function() { callIfFunctionExist() })

	// Add the footter to the end of the page.  Also, setup the links so that when
	// the user clicks on a footer link and is sent to a new page the outline for
	// the current item will disappear.
	$("#footer").on("mouseup","a", function(event) { mouseDownBorderToggle(event) })

	currentPage();

	// If using a Phone or Tablet then there are no margins above or below a
	// section and its section headers
	if ( isMobile() ) {
		removeSectionMargins();
		removeSectionHeaderMargins();
	}

	// Calculate the height of the section so that it will be to scroll to the beginning of
	// the correct section
	calcSizesOfSections();

	// Rule : When using the mouse the input element with focus should not have the outline
	// Rule : When using the tab the input element with focus should have the outline
	// Exemption : The last button has to be handle differently
	$("#riskForm").children().on('mousedown', 	function(event)  { mouseDownBorderToggle(event); });
	$("#riskForm").children().on('focusin',   	function(event)  { focusBorderToggle(event);  	 });
	$("#reset").on("focusout", 					function(event)  { removeOutline(event); 		 })

	// Rule : When the AssessPatientRisk gains the focus from the Tab Key it should be highlighted)
	// Rule : When blurred then have the outline removed
	$("#AssessPatientRisk").on('focusin', 		function(event)  { focusBorderToggle(event);	});
	$("#AssessPatientRisk").on('focusout',      function(event)  { removeOutline(event); 		});

	// Rule: When the Start Over Button/Edit Repsonses or the print icon gains the focus from the
	// Tab Key.  It sould be highlighted and blurred then have the outline removed
	$("#startOverButton, #returnToCalculateButton").on('focusin',  function(event)  { focusBorderToggle(event);	});
	$("#startOverButton, #returnToCalculateButton").on('focusout', function(event)  { removeOutline(event);     });

	$("#printBottom").on('focusin', function(event) { focusBorderToggle(event); });
	$("#printBottom").on('mousedown', function(event) { mouseDownBorderToggle(event); });

    $("#printTop").on('focusin', function(event) { focusBorderToggle(event); });
    $("#printTop").on('mousedown', function(event) { mouseDownBorderToggle(event); });

    // The Side Menu at the top of the screen should be highlighted when it is tabbed into
    $("#toolTitle > button > div").on('focusin', function(event) {
        focusBorderToggle(event);
    });

    $("#toolTitle > button > div").on('focusout', function(event) {
        removeOutline(event);
    });




	// Rule : When tabbing the user could make the "Skip to Content" appear. which could
	// cause the form-step vertical line to not be in the correct position.  This code
	// should fix that
	$("*").on("focusin", function(event) { if ( existFormSteps() ) adjustNavigationBarLine(); })

	// Rule : Whenever you leave any HTML Object the focus is removed
	// Rule : Whenever the focus bar is leaving and going to the navigation bar of the actual browser the Navigion bar of the app
	//        needs to be updated
	$("*").on("focusout", function(event) { removeOutline(event); if ( existFormSteps() ) adjustNavigationBarLine(); })

	/* When a different navigation link is clicked the callback will make the */
	/* link acitve and fix the line that connects all the navigation links    */
	var navigationLinks = $("#form-steps > ol > li > a");
	$(navigationLinks).on("click", gotoSection);

  	// Whenever the window is resizeid we need to recalculate the line that contains
	// the navigation numbers so that it fits correctly.
	$(window).resize(function() {
		handleHeaderNavigationRedraw()
	});

	$("#riskForm").validate({
		ignore: ".skipValidate",
		onkeyup: false,
		onfocusout: false,
		submitHandler: processSubmission,
		errorElement: 'div',
		errorPlacement: function(error,element) {
		  error.appendTo($(element).parent().prevAll('label.questions:first'));
		  $(error).attr("role","alert");
		},
		invalidHandler: function(form,validator) {
		  var errors = validator.numberOfInvalids();
		  if (errors) {
		    var element = validator.errorList[0].element;
		    var targetScroll = $(element).parent().prevAll('label.questions:first');
            
		    if ($(element).is(':radio')) {
		      $(element).next('[role=radio]').focus();
		    } else {
		      $(element).focus();
		    }
			
			$('html, body').scrollTop(targetScroll.parent().offset().top - $('#form-steps').outerHeight() - 15);
			
		  }
		 },
		 showErrors: function(errorMap,errorList) {
		   if (errorList.length) {
                var error = errorList.shift();
                var newErrorList = [];
                newErrorList.push(error);
                this.errorList = newErrorList;

                $(".borderError").removeClass("borderError")
				$(error.element).parent().prevAll('label.questions:first').parent().addClass("borderError");
		   }
		   this.defaultShowErrors(); 
		 },

	    onclick: function(element, event) {
			 if ( $(event.currentTarget).is("select")) {
				 return false;
			 } else {
			    setTimeout( function() {
				    $(element).parent().prevAll('label.questions:first').parent().removeClass("borderError");
				    $(element).parent().prevAll('label.questions:first').find('.error').remove();
				    },100);
			 }
		} 


	});

	$("select").change(removeErrorMessage)

    jQuery.extend(jQuery.validator.messages, {
        required: "&nbsp;* This is required"
     });

	// When the user is on the results page, this event will send the user back
	// to the goto_calculatePage
	$("#returnToCalculateButton").on("click", goback_tocalc);

    $(document).keydown(function(e) {
		if (e.which == 32 && $(e.target).is('[role=radio]') ) {
          e.preventDefault();
		}
    });


});


$(function(e) {

	// For the printing the Apple needs something a little different css
	if ( isAppleProduct() == true ) {
	    $("#displayInput").addClass("printAppleOnly")
	}

	if ( isApplePhone() ) {
		$("#InputParameters").addClass("printIphoneOnly")
	}

	if ( isIe11() ) {
		$("#displayInput").addClass("printIEOnly")
	}

   registerCustomRadioAccess();
  // Callsbacks to handle the Navigation Bar when user scrolls or uses an
  // touch event
	$(window).on("scroll", handleScrollEvent);
	if ( isMobile() ) {
		$(window).on("scroll", 		handleScrollEvent);
		$(window).on("touchmove", 	handleScrollEvent);
		$(window).on("swipe", 		handleScrollEvent);
		$(window).on("mousemove", 	handleScrollEvent);
	}

	if( isMobile() ) $(".toggleTool").on("click keypress", toggleFormDisplay);
    
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

	$('a[data-toggle="tab"]').on('hidden.bs.tab', function(e) {
		if($("nav.navbar-collapse").hasClass('in'))
			$('button[data-toggle="collapse"]').trigger("click");
	});

  // Sets up the GUI for mobile devices or desktop devices
	$("#side_nav").css("margin-top", $("#toolTitle").position().top + "px")
	if( isMobile() ) {

		var header_height=$('header').outerHeight(true);
		var form_steps_height=$('#form-steps').outerHeight();
		var logo_height=$('#logo').outerHeight();

 		$("header").addClass('fixed');
		$("header").css("top", "0px")

		if ( $("#form-steps").length > 0 ) {
			$("#form-steps").addClass('fixed');
			if($("#side_nav").width()>0)
				$("#form-steps").css("z-index","999")
			else{
	 		 	$("#form-steps").css("z-index","1")
			}

			$("#form-steps").css("top", + header_height + "px");
			var height = header_height + form_steps_height + 14;
	    	$("#riskForm").css("margin-top", height + "px");

			adjustNavigationBarLine();


			// Sets the Form Steps as the same height as the Header so when
			// the mobile application is scrolled the Form Steps will cover
			// the Header fully.  When Scrolled, and not at the top, only
			// the Form Steps should be seen.
			//$("#form-steps").outerHeight($("header").outerHeight(true))
		} else {
			$("#main_home").css("padding-top", header_height);
		}

 		$("header").css("background","white");

	} else {
		if ( $("#form-steps").length > 0) {
			$("#form-steps ol li:first()").addClass('active');
			adjustNavigationBarLine();
		}

	}

	// Determine what spacing should be between the Content and the Buttons
	var cssClass = ( isMobile() )  ? "spacerBetweenQuestionsAndButtonsMobile" : "spacerBetweenQuestionsAndButtonsDesktop";
	if ( $("#calculate").length > 0 ) $("#calculate").addClass(cssClass);

    $("#calculate").on("click",function(e) {
      var validator = $("#riskForm").data("validator");
      $(validator).data("mouseEventSubmitForm",true);
    });
	// For the page with the Assess Patient Link Button set the click to calculate.html
	if ( $("#AssessPatientRisk").length > 0 )	$("#AssessPatientRisk").on("click", goto_calculatePage);

	// Any time the app starts it should start at the top of the page
	$('html,body').scrollTop(0);

	// Prints the Reuslts page
	$("[id^='print']").on("click", printCurrentPage );

	$("[id^='print']").on("keyup", function(event) {
        event.preventDefault();
        if ( event.keyCode == 13 ) {
            printCurrentPage();
        }
    })

	// The problem is HTML cannot handle about.html#OtherToolsSection ( It will only just to the page and not the section )
	// When the link is clicked http will split this into a url and section ( stored in hash ).  The div with the id will
	// be scrolled into view
	if ( window.location.hash ) $(window.location.hash)[0].scrollIntoView()

	// Due to the way this was written, when we click on a link to jump to a      //
	// a section then the section goes past the viewable area and some of it is   //
	// cut off.  The Plan is to scroll each seciton to where the Main Title      //
	// origanally was placed and scrooll to there
	if ( $("#mainAboutTitle").length == 1 && isMobile() == true ) {
		$("#jumpTitle").attr('data-x-coord-to-jump-to', $("#mainAboutTitle").offset().top)
		$("#jumpTitle").on("click", "a", function(event) { jumpToSection(event); })
	}

	$.fn.isInViewport = function() {
	    var fixedOffset = $('#form-steps').outerHeight();
        var elementTop = $(this).offset().top;
        var elementBottom = elementTop + $(this).outerHeight();
        var viewportTop = $(window).scrollTop() + fixedOffset;
        var viewportBottom = viewportTop + $(window).height();
        return elementTop > viewportTop && elementBottom < viewportBottom;
    };

    //polyfill for now
	if (!String.prototype.startsWith) {
	  String.prototype.startsWith = function(searchString, position) {
		position = position || 0;
		return this.indexOf(searchString, position) === position;
	};
}
});


