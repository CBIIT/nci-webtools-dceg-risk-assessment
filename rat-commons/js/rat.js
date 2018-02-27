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

	//alert("The height is " + height + " and the value of is isMobile is " + isMobile() )
	//alert("The Height is " + height)

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
		console.log("xhr = " + xhr.respsoneText())
		console.log("ajaxOptions = " + ajaxOptions.toString())
		console.log("thrownError = " + thrownError)
		console.log("error");
		$("#systemError").modal("show");
	})
	.always(function() {
		$('html,body').scrollTop(0);
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
	$("#startOver").on("click", goto_calculatePage);
	if ( isMobile() )
		$("#startOver").addClass("spacerBetweenQuestionsAndStartButtonMobile")
	else
		$("#startOver").removeClass("spacerBetweenQuestionsAndStartButtonMobile")

	// This code is a hack and this should be done in CSS.  I put the code in 
	// here since we are trying to get it done and it might have unforseen 
	// consequences if put in the CSS Style
	if ( isTablet() ) {
		$("#results_home").css("padding-top", "6px")
	}

}

/*********************************************************************************/
/* Create a pie chart                                                            */
/*                                                                               */
/* Parameters:                                                                   */
/*   percent		       	The change that the victim will get cancer       	 */
/*   divContainerForChart  	The HTML Container that will cotnain the chart   	 */
/*   color1 			The color for the chance of getting cancer       		 */
/*   color2  			The color for the chance of not getting cancer   		 */
/*********************************************************************************/
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
          //.attr('width', width)
          //.attr('height', height)
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
		$.each($("#riskForm section"), function(ind, el) {

			// Retrieve the top most pixel of the header belonging to section
			// If mobile
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
		var currentScrollPosition = Math.ceil($(window).scrollTop() + $(window).height());
		if ( currentScrollPosition >= $(document).height() ) {
			$("#form-steps li").removeClass('active');
			$('#form-steps li').last().addClass('active');
		   	adjust_line_width($('#form-steps li').length - 1);
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
		// The purose of this code is to handle the situation where there are multiple section being displayed.  
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
	var onResultsPage = ( String($("#form-steps").attr("class")).includes("hide"))

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
			if ( existFormSteps() ) adjust_line_height_mobile();
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
	//alert("Handling Scroll Event");
	var top_div = ( $(window).width() > 630 ) ? "main-nav" : "toolTitle";

	fixedToTop(top_div);
	formScrollSpy();

	// Works wrong on IE9 - it blurs the whole browser window if active 
	// element is document body. Better to check for this case:
	// if (document.activeElement != document.body) document.activeElement.blur();

}

/******************************************************************************/
/* Handles the resizing of window.  For the navigation component a line is    */
/* create manual to connect the navigation buttons. Since the line is         */
/* caclculated manually                                                       */
/******************************************************************************/
$(window).resize(function() {
	if(window.location.pathname=="/melanomarisktool/calculator.html"){
		adjustNavigationBarLine();
	 }
});

/******************************************************************************/
/* Adjusts the line connections the navigation bar circles                   **/
/******************************************************************************/
function adjustNavigationBarLine() {
	adjust_line_width()
	if( isMobile() )
		adjust_line_height_mobile();
	else
		adjust_line_height_dekstop()
}

/******************************************************************************/
/* For the navigation component set the length of the line that connects the  */
/* navigation circles so that all are connected                               */
/******************************************************************************/
function adjust_line_width(ind){
	var firstBubble = $("#form-steps > ol > li > a:nth-child(2)").first();
	var lastBubble  = $("#form-steps > ol > li > a:last-child").last();

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
function toggle_menu(){

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


    if($("#side_nav").width()>0){ $("#side_nav").animate({ width: "0%" });

			setTimeout(function() { $('#side_nav .glyphicon-menu-hamburger').css('display', 'none'); }, 250);
    	setTimeout(function(){ $("#form-steps").css("z-index","1"); }, 500);
    } else {
			$("header").css("z-index","200")
			$("#side_nav").animate({
				width: "70%"
			});

			// $("#side_nav").css("width","70%")
			setTimeout(function() { $('#side_nav .glyphicon-menu-hamburger').css('display', 'inline-block'); }, 250);
    }
}

// Whenever the window is opened and the side navigator is open then close it.
$(function() {
	$(window).on('resize', function(event) {
		if ($('#side_nav').width() > 0) $("#side_nav").animate({ width: "0%" });
	})
})

/*****************************************************************************/
/* Enables the Calculate Button                                              */
/* Todo: Change the name to enableCalculateButton                            */
/*****************************************************************************/
function enablebutton(){
	$("#calculate").attr('disabled', false);
	$("#calculate").removeClass("#calculate:disabled")
}

/******************************************************************************/
/* Disables the Calculate Button                                              */
/* TODO : Change the name to disableCalculateButton                           */
/******************************************************************************/
function disablebutton(){
	$("#calculate").attr('disabled', true);
	$("#caclulate").addClass("#calculate:disabled")
}

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
/* ( A double check to see if the    																					*/
/* the device is mobile)																										  */
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
    var mouseDown = $this.data('mouseEvent');

    $this.removeData('mouseEvent');

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

///////////////////////////////////////////////////////////////////////////////
// Enable the Caluclate Button if all non disabled inputs have a value
//////////////////////////////////////////////////////////////////////////////
function enableCalculateButton() {
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

	 if(valid==true) enablebutton();

	 $("select").on("select", redrawHTMLObject);
	 $("select").on("change", redrawHTMLObject);


}


//////////////////////////////////////////////////////////////////////////////
// Determine if the calculation button should be enabled.  If all the input  //
// fields that are enabled have a value then enable the calculate button     //
///////////////////////////////////////////////////////////////////////////////
function enableButtonIfAllFieldHaveInput()
{
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

	if(valid==true) enablebutton();

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
/* Does the Form Steps HTML Object Exist                                      */
/******************************************************************************/
function existFormSteps() {
	return ( $("#form-steps").length > 0 );
}

// Two functions to disable and enable  the section headers ( Currently a
// seciton header is text embedded in a h2 tag
function disableSectionHeaders() {
	$(".sectionTitle").attr("disabled","disabled")
	$(".sectionTitle").addClass("disableSectionTitle")
}

function enableSectionHeaders() {
	$(".sectionTitle").removeAttr("disabled")
	$(".sectionTitle").removeClass("disableSectionTitle")
}

///////////////////////////////////////////////////////////////////////////////
// Disable a form by doing the following                                     //
//   1. Disable all input except the reset button                                                //
//   2. Lighten the Seciton Header, Questions and Answers                    //
///////////////////////////////////////////////////////////////////////////////
function disableForm() {
	$("form :input").not("#reset").prop('disabled', true);
	$("form label.radio").css("color","#C0C0C0")
	$("[class*='questions']").css("color","#c0c0c0");
	disableSectionHeaders();
}

////////////////////////////////////////////////////////////////////////////////
// Enable a from by doing the follwoing                                       //
//    1. Enable all input to the form except the reset button                 //
//    2. Darken the Seciton Header, Questions and Answers                     //
////////////////////////////////////////////////////////////////////////////////
function enableForm() {
	$("form :input").not("#reset").attr('disabled', false);
	$("form label.radio").css("color","#2E2E2E")
	$("[class*='questions']").css("color","#2E2E2E")
	enableSectionHeaders();
	$("#riskForm").trigger("change")
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

	// Number of total subquestion before the current question
	var numberOfSubQuestions = 0

 	$(formName + " label.questions").filter(filterInputParameters).each(function(index, element) {

		// Extracts the current answer from the input screen to the current question
		// Assumption : The User has completed filling out the form
		// Input  first response to current question
		// Output The answer from the input page that the user selected.
		// Output NA if there is no answer ( for some questions to be answered other
		// questions must be answered with a specific value
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
				inputText = $(nameSelector + valueSelector).next().text()
			} else if ( inputElement.is("select")) {
				if ( $(inputElement).is(":enabled") ) {
					inputText = $(inputElement).find(":selected").text();
				}
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
		 	//		Returns to values
		 	//			An index string for questions a number, but for subquestion a lowercase letters
		 	//     		True if the element is a subqeustion
		 	function handleIndex(index, element) {

		 		var letters = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "l", "m", "n" ]
			 	var indexString = ""
			 	var isSubQuestion = false

		 	 	if ($(element).attr("data-subQuestion")) {
					numberOfSubQuestions = numberOfSubQuestions + 1
					numberOfSubQuestionsInARow = numberOfSubQuestionsInARow + 1
					indexString = letters[numberOfSubQuestionsInARow]
					isSubQuestion = true
			 	} else {
					numberOfSubQuestionsInARow = -1
					indexString = index - numberOfSubQuestions
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

		 	var questionDiv = container.append(lineNumber).append(questionText)
		 	if ( indexData.isSubQuestion ) {
			   questionDiv.css("margin-left", "1.8em")
		 	}

		 	return question.append(questionDiv)
		}

		// Create the row that contains the line number, question and answer
   		var inputElement = $($(element).nextUntil("label","div")[0]).children('input, select')
   		var inputAnswerText = extractAnswerDispalyedOnGui(inputElement)

   		var question = createQuestionCell(index, $(element).text())
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
	$('form').trigger('reset')

	// Both lines are needed.  The first line scroll to the top, but
	// the second line will force the correct navigation links in the
	// form-steps to be highlighted since it creates a scroll event
	// Rat.js uses the scroll event to update the form-steps
	$(window).scrollTop(0);
	$("html, body").animate({scrollTop: 0 }, 0 )

	$("form :input").attr('disabled', false);
	$("[class*='questions']").css("color","#2e2e2e")
	$("#calculate").attr("disabled", "disabled")
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
	var functionExist = ( typeof pecificRatFooterInitialization == "function" )
	
	if ( functionExist ) {
		functionName()
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

	console.log("Element Bottom = " + elementBottom)
	console.log("Window Bottom  = " + windowBottom)

	return ( (elementBottom + elementHeight ) - windowBottom > 0 ) ? true : false;

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

	// Rule: When the Start Over Button gains the focus from the Tab Key.  It sould be highlighted
	// Rule: When blurred then have the outline removed
	$("#startOver").on('focusin', 		function(event)  { focusBorderToggle(event);	});
	$("#startOver").on('focusout',      function(event)  { removeOutline(event); 		});
	

	// Rule : When tabbing the user could make the "Skip to Content" appear. which could
	// cause the form-step vertical line to not be in the correct position.  This code 
	// should fix that 
	$("*").on("focusin", function(event) { if ( existFormSteps() ) adjustNavigationBarLine(); })

	// Rule : Whenever you leave any HTML Object the focus is removed
	$("*").on("focusout", 				function(event) { removeOutline(event)			})

	/* When a different navigation link is clicked the callback will make the */
	/* link acitve and fix the line that connects all the navigation links    */
	var navigationLinks = $("#form-steps > ol > li > a");
	$(navigationLinks).on("click", gotoSection);

  	// Whenever the window is resizeid we need to recalculate the line that contains
	// the navigation numbers so that it fits correctly.
	$(window).resize(function() {
		fixedToTop( ( $(window).width() ) ? "main-nav" : "toolTitle" );
		if ( $("#form-steps").length > 0 ) {
			var riskFormSectionIndex = $("#form-steps > ol > li").filter(".active").children("a:first").attr("data-riskFormSection");
			adjust_line_width(riskFormSectionIndex);
		}
	});

	$("#riskForm").validate({
		ignore: ".skipValidate",
		submitHandler: processSubmission,
	});


});

$(window).load(function(e) {

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

	$(".responseOptions > label.radio,.responseOptionsWithoutIndent > label.radio").on('click keypress', function(e) {
		// This code was the orignal code for clicking on an image and 
		// expecting it to act like a radio button
		// if ($(e.target).hasClass('radio')) {
		// 	$(e.target).prev().trigger('click');
		// }
		// else if ($(e.target).parents('.radio')) {
		// 	$(e.target).parents('.radio').prev().trigger('click');
		// }
		// else {
		// 	if(e.type == "keypress") {
		// 		if ((e.keyCode == 13) || (e.keyCode == 32)){
		// 			$(e.target).children(".radio").prev().trigger('click');
		// 		}
		// 	}
		// 	if(e.type == "click") {$("#form-steps > ol > li > a")
		// 		$(e.target).children('.radio').prev().trigger('click');
		// 	}
		// }

		// The code will force an image to act likie an input
		if ( e.type == "click") { 
			if ($(e.target).hasClass('radio')) 
				$(e.target).prev().trigger('click');
			else if ($(e.target).parents('.radio')) 
				$(e.target).parents('.radio').prev().trigger('click');
		} else {
			if(e.type == "keypress") 
				if ((e.keyCode == 13) || (e.keyCode == 32))
					$(e.target).children(".radio").prev().trigger('click');
		}

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
		if ( $("#form-steps").length > 0) adjustNavigationBarLine();
	}

	// Determine what spacing should be between the Content and the Buttons
	var cssClass = ( isMobile() )  ? "spacerBetweenQuestionsAndButtonsMobile" : "spacerBetweenQuestionsAndButtonsDesktop";
	if ( $("#calculate").length > 0 ) $("#calculate").addClass(cssClass);

	// For the page with the Assess Patient Link Button set the click to calculate.html
	if ( $("#AssessPatientRisk").length > 0 )	$("#AssessPatientRisk").on("click", goto_calculatePage);

	// Any time the app starts it should start at the top of the page
	$('html,body').scrollTop(0);

	// Prints the Reuslts page
	$("#print").on("click", printCurrentPage );

	// The Print Button on the Results Pages should not be shown when the device
	// is mobile
	if ( isMobile() ) { $("#print").hide() }

	// The problem is HTML cannot handle about.html#OtherToolsSection ( It will only just to the page and not the section )
	// When the link is clicked http will split this into a url and section ( stored in hash ).  The div with the id will
	// be scrolled into view
	if ( window.location.hash ) $(window.location.hash)[0].scrollIntoView()

	// Due to the way this was written, when we click on a link to jump to a      //
	// a section then the section goes past the viewable area and some of it is   //
	// cut off.  The Plan is to scroll each secit0on to where the Main Title      //
	// origanally was placed and scrool to there
	if ( $("#mainAboutTitle").length == 1 && isMobile() == true ) {
		$("#jumpTitle").attr('data-x-coord-to-jump-to', $("#mainAboutTitle").offset().top)
		$("#jumpTitle").on("click", "a", function(event) { jumpToSection(event); })
	}
});


