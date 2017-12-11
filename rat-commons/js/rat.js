/* A function calculates and stores the position of each header and so that
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

	var height = ( isMobile() ) ? 0 : $("#form-steps").outerHeight(true);
	$.each($("#riskForm section"), function(index, element) {

		// Accumulates the Height of the header and section, so the form will scrolled to the correct position for the next element
		// This calcuation will using this in currentHeight calculation for the next iteration
		var currentTitleAndSecitonHeight = $(element).prev().outerHeight(true) + $(element).outerHeight(true);

		// Each anchor in the navigation Links will now the index, section id,
		// section header name and y-position.
		// TODO : Remove data elements that are not needed anymore
		var startIndex = index * 2;
		var endIndex = (index * oneSectionForManyLinks ) + ( oneSectionForManyLinks);

		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSection', index);
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionName', $(element).attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-riskFormSectionHeaderName', $(element).prev().attr('id'));
		$(navigationLinks).slice(startIndex, endIndex).attr('data-position-height', height + heightOfHeaderAndSectionsAccumulator);


		// Each section will know id, the id its header and the y-postion of its sectionHeaderBoxHeight
		// TODO :
		$(this).attr('data-riskFormSectionName', $(element).attr('id'));
		$(this).attr('data-riskFormSectionHeaderName', $(element).prev().attr("id"));
		$(this).attr('data-position-height', height + heightOfHeaderAndSectionsAccumulator)

		heightOfHeaderAndSectionsAccumulator = heightOfHeaderAndSectionsAccumulator + currentTitleAndSecitonHeight;
		//console.log("Height of Header and Section Accumulator = " + heightOfHeaderAndSectionsAccumulator);

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
	.fail(function() {
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

	// This is hack.  The code is the startup section in an isMobile() if-clause
	// It should be placed in its own routine and called from here.  What the code
	// does it position the elements on the page.  The code here is just positioning
	//  the html object with an id of #results_home.
	if ( isMobile() ) $("#results_home").css("margin-top", "116px");

}

/*********************************************************************************/
/* Create a pie chart                                                            */
/*                                                                               */
/* Parameters:                                                                   */
/*   percent		       	The change that the victim will get cancer       */
/*   divContainerForChart  	The HTML Container that will cotnain the chart   */
/*   color1 			The color for the chance of getting cancer       */
/*   color2  			The color for the chance of not getting cancer   */
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
// To update the navigation bar when the user scrolls the page                //
////////////////////////////////////////////////////////////////////////////////
function formScrollSpy() {

	//console.log("Start Scroll Spy")

	if ( existFormSteps() == false ) return;

	// Rule: If there is only once section visible then just return
	if ( ignore() ) return;

	// Calculate the bottom of the Form Steps where the questions will start.
	var window_top = $(window).scrollTop();
	window_top = window_top + calculateBottomOfFormSteps();

	//console.log("Thw window top is at position " + window_top);

	$.each($("#riskForm section"), function(ind, el) {

		// Retrieve the top most pixel of the header belonging to section
		// If mobile
		var sectionHeight =$(this).attr('data-position-height');
		//if ( isMobile() ) {
		//	sectionHeight = parseInt(sectionHeight) + calculateForMobileRiskFormStart();
		//}
		//console.log("Seciton Height = " + sectionHeight)


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

	// Rule  : 	If male or female is not checked then any Navigation (Button/Link)
	//		should only make the first page active.
	// Rules : 	Scrollbar is at the bottom then the last navigation elements (link/button)
	// 		should be active
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

	//adjustNavigationBarLine();

	//console.log("end scroll spy ------------------------------")
}

/******************************************************************************/
/* When a navigation number or name is clicked then the form should be scroll */
/* ed to the top of the section header                                        */
/******************************************************************************/
function gotoSection(event) {

	// Rule: When there is a male/female selection, one of the items must checked
	// if the
	if ( isMaleOrFemaleChekced() == 0 ) return;

	// Rule: If there is only once section visible then just return
	if ( ignore() ) return;


	var indexOfSection = $(this).attr('data-riskFormSection')

	// Remove the active style from the previous link and apply it to the
	// current link.
	var elementContainingListItems = $(this).parent().parent();
	$(elementContainingListItems).children("li").removeClass('active');
	$(this).parent().addClass('active');
	adjust_line_width(indexOfSection);

	// Scroll to the actual spot.
	var scrollTo = ( indexOfSection == 0 ) ? 0 : $(this).attr('data-position-height');
	$('html, body').animate({ scrollTop: scrollTo }, 1000);
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
/* Return (T) An HTML Object is name genddar and either male/female is        */
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

	if ( isMobile()) {
		$("header").css("top", "0px");
		if ( existFormSteps() ) {
 			$("#form-steps").css("top",header_height+"px");
			$("#form-steps").addClass("fixed");
		}

		$("#riskForm").css("margin-top", calculateForMobileRiskFormStart() +"px");
	}

	if ( window_top > div_top || isMobile()) {
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
	var startPoint = $(firstBubble).offset().top + $(firstBubble).height()/2;
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
/******************************************************************************/
function toggle_menu(){

	  let top = $("#toolTitle").offset().top;
		console.log("top = " + top)

		$("#side_nav").css("top", $('#toolTitle').offset().top + 'px');
		$("#side_nav").css("right", 0);
		$("#side_nav").css("position", "fixed");
		$("#side_nav").css("margin", 0);

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

$(function() {
	$(window).on('resize', function(event) {
		if ($('#side_nav').width() > 0)
			$("#side_nav").animate({
				width: "0%"
			});
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
/* Is the device a mobile phone or tablet ?                                   */
/******************************************************************************/
function isMobile() {
	return 	/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
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
	if ( ! $this.is(':focus')) $this.data('mdown', true);
}

// Executes the code to remove or add the border around the input element
// whether it was a mouse event or the user tabbed into it.
function focusBorderToggle(event) {
	var $this = $(this);
	var mouseDown = $this.data('mdown');

	$this.removeData('mdown');

	if ( mouseDown )
		$(event.target).addClass("removeOutline");
	else
		$(event.target).removeClass("removeOutline");
}

///////////////////////////////////////////////////////////////////////////////
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
	$("form :input").not("#reset").attr('disabled', true);
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
function ignore() {
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

	$(formName + " .questions").each(function(index, element) {

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

			//console.log("For HTML Object " + name + " the value is " + inputText)
			return inputText

		}

		function createQuestionCell(index, questionText) {

			// The spacing between the number and the question is different if you
			// two number ( ex. 10) vs one number
		  var paddingRight = ( index > 9 ) ? ".5em" : "1em"

			var question = $("<td></td>").addClass("questions")
			var container = $("<div></div>").css("display","flex").css("flex-direction","row")
			var lineNumber = $("<div></div>").text(index + "." + " ").css("padding-right", paddingRight)
			var questionText = $("<div></div>").text(questionText)

			var questionDiv = container.append(lineNumber).append(questionText)
			return question.append(questionDiv)

		}

		var inputElement = $($(element).nextUntil("label","div")[0]).children('input, select')
		var inputAnswerText = extractAnswerDispalyedOnGui(inputElement)

		//var visibleIndex = (index + 1) + "."
		//var question = $("<td></td>").text( visibleIndex + $(element).text()).addClass("questions")
		var question = createQuestionCell(index + 1, $(element).text())
		var answer = $("<td></td>").text(inputAnswerText).addClass("answers")
		var tableRow = $("<tr></tr>").append(question).append(answer)

		$(tableName + " tbody").append(tableRow)

	});

	//console.log("The HTML for generation of the Table Parameters  ")
	//console.log($(tableName).html())
}

////////////////////////////////////////////////////////////////////////////////
// Startup Code
////////////////////////////////////////////////////////////////////////////////

// TODO : Can we merge $function, $window.load() together.

$(function() {

	// Add the link that "Skip to Main Conetnet will use"
	$("#skipContentHome").attr("href", "javascript:scrollPassLogo()");
	$("#skipContentCalculate").attr("href", "javascript:scrollPassLogo()")
	$("#skipContentAbout").attr("href", "javascript:scrollPassLogo()")


	// Add the footter to the end of the page
	$("#footer").load("./rat-commons/html/footer.html")

	currentPage();

	// If using a Phone or Tablet then there are no margins above or below a
	// section and its section headers
	if ( isMobile() ) {
		removeSectionMargins();
		removeSectionHeaderMargins();
	}

	// Calculate the height of the section so that it will be to scroll to the beginning of
	// the correct section
	//
	// TODO : Change the name of the function
	calc();

	// Rule : When using the mouse the input element with focus should not have the outline
	// Rule : When using the tab the input element with focus should have the outline
	$("#riskForm").children().on('mousedown', function(event)  { mouseDownBorderToggle(event); });
	$("#riskForm").children().on('focusin',   function(event)  { focusBorderToggle(event);  });


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

  // I Have no clue what this does
	if( isMobile() ) $(".toggleTool").on("click keypress", toggleFormDisplay);

  // I have no clue what this does
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
	var header_height=$('header').outerHeight(true);
 	var form_steps_height=$('#form-steps').outerHeight();
 	var logo_height=$('#logo').outerHeight();
	//$("#side_nav").css("margin-top",logo_height+"px");
	$("#side_nav").css("margin-top", $("#toolTitle").position().top + "px")
	if( isMobile() ) {
 		console.log("mobile");
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
		} else {
			$("#main_home").css("padding-top", header_height);
		}

 		$("header").css("background","white");
 		//$("#main").removeClass("container-fluid");
		//console.log("Header Height = " + header_height);
		//console.log("steps height = " + form_steps_height)
		//$("#main_home").css("margin-top", header_height);'

	} else {
		if ( $("#form-steps").length > 0) adjustNavigationBarLine();

	}

	// Determine what spacing should be between the Content and the Buttons
	var cssClass = ( isMobile() )  ? "spacerBetweenQuestionsAndButtonsMobile" : "spacerBetweenQuestionsAndButtonsDesktop";
	if ( $("#calculate").length > 0 ) $("#calculate").addClass(cssClass);


});

$(document).ready(function(){

	$("#riskForm").on("change", enableCalculateButton);

	$('html,body').scrollTop(0);

	if ( $("#AssessPatientRisk").length > 0 )	$("#AssessPatientRisk").on("click", goto_calculatePage);

});

////////////////////////////////////////////////////////////////////////////////
// Handles the generic reset for all the risk analysis tools
////////////////////////////////////////////////////////////////////////////////
function genericResetForm() {
	$('form').trigger('reset')
 	$(window).scrollTop(0);
	$("form :input").attr('disabled', false);
	$("[class*='questions']").css("color","#2e2e2e")
	$("#calculate").attr("disabled", "disabled")
}

///////////////////////////////////////////////////////////////////////////////
// Enable the Caluclate Button if all non disabled inputs have a value
//////////////////////////////////////////////////////////////////////////////
function enableCalculateButton() {
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

	 if(valid==true) enablebutton();

	 //console.log("enableCalculateButton --> " + $("#calculate").attr("disabled"))

	 $("select").on("select", redrawHTMLObject);
	 $("select").on("change", redrawHTMLObject);


}
