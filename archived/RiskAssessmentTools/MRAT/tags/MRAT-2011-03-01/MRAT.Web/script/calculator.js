
/**************************************************************************************************
* Name		: calculator.js
* Purpose	: calculator.js
* Author	: 
* Date		: 07/13/2006
* Changes	:
**************************************************************************************************/
//alert(window.navigator.userAgent);
var gUnselected = "-1000";
var gFemale = "2";
var gSexId = "sex";
var gSmallMolesMalesId = "small_moles_males"; 
var gSmallMolesFemalesId = "small_moles_females"; 
var gLargeMolesId = "large_moles";             
var gBlisterBurnId = "sunburn";      
var gSolarDamageId = "solar_damage";      
var gTanId = "tanning";
var gGroupId = "grp_";
var gbSexMale;

var gbClearResults;
var gbClearSolarDamage;

var gaSmMoleMale = new Array();
var gaSmMoleFemale = new Array();
var gaLgMole = new Array();
var gaBlisterBurn = new Array();
var gaSevereSolarDamage = new Array();
var gaTan = new Array();

/*All Divs 
1           , 2        ,  3        , 4        , 5            , 6               , 7            , 8                , 9m                     , 9f                       , 10             , 11 
"grp_region", "grp_sex", "grp_race", "grp_age", "grp_sunburn", "grp_complexion", "grp_tanning", "grp_large_moles", "grp_small_moles_males", "grp_small_moles_females", "grp_freckling", "grp_solar_damage"
*/
var gaMaleElements      = new Array("grp_sunburn", "grp_complexion", "grp_large_moles", "grp_small_moles_males", "grp_freckling", "grp_solar_damage");
var gaFeMaleElements    = new Array("grp_complexion", "grp_tanning", "grp_small_moles_females", "grp_freckling");
var gaAllElements       = new Array("grp_sunburn", "grp_complexion", "grp_tanning", "grp_large_moles", "grp_small_moles_males", "grp_small_moles_females", "grp_freckling", "grp_solar_damage");


// sets the page to its initial configuration
function pageSetup(){
	gbClearResults = 0;
	gbClearSolarDamage = 0;
	getDocElements(gSmallMolesMalesId, gaSmMoleMale);
	getDocElements(gSmallMolesFemalesId, gaSmMoleFemale);
	getDocElements(gLargeMolesId, gaLgMole);
	getDocElements(gBlisterBurnId, gaBlisterBurn);
	getDocElements(gSolarDamageId, gaSevereSolarDamage);
	getDocElements(gTanId, gaTan);
    HideElements(gaAllElements);
  	//showUSMap(); 
  	handleSex();
}

//display the correct sex-specific factor selectors depending on the selection of the sex selection.
function handleSex(){
   defaultHandler();
   var selectSex = document.getElementById( gSexId );
   var sex = selectSex.options[selectSex.selectedIndex].value;
   
   //hide all the questionaries firs
   HideElements(gaAllElements);
   
   if (sex == "1"){            
        //show male related elements
        ShowElements(gaMaleElements);                
        SetHref(document.getElementById("q5"), "q5", sex); 
        
        SetValue("q6", "6", sex);
        SetValue("q8", "7", sex);
        SetValue("q9m", "8", sex);
        SetValue("q10", "9", sex);
        SetValue("q11", "10", sex);        
        
   } else if (sex == "2"){
        //show female related elements
  	    ShowElements(gaFeMaleElements);
  	    SetValue("q6", "5", sex);
  	    SetValue("q7", "6", sex);
        SetValue("q9f", "7", sex);
        SetValue("q10", "8", sex);        
   } else {
        //reset about-tool.html
        //document.getElementById("q0").href = "about-tool.html";
   }	
}	



//sets a value for a given element id
function SetValue(elementId, newValue, sex){
    var oElmnt = document.getElementById(elementId);
    if(oElmnt != null || oElmnt != undefined){       
        if(window.navigator.userAgent.indexOf("MSIE")>0)
            oElmnt.innerText = newValue;
        else
            oElmnt.textContent = newValue;
        SetHref(oElmnt, "q" + newValue, sex);
	}
}

//sets href for a given element
function SetHref(element, question, sex){
    if(element != null || element != undefined){
        if(sex == "1"){ //1-male
           element.href = "about-tool.html#" + question + "m" ;
        }
        else if(sex == "2"){ //2-female 
           element.href = "about-tool.html#" + question + "f";
        }
        else{
            //n/a
        }
	}
}

//Hides a given Array of Element IDs
function HideElements(theArray){
	for(var i=0; i < theArray.length; i++){
	    var oElmnt;
	    oElmnt = document.getElementById(theArray[i]);
	    if(oElmnt != null || oElmnt != undefined){
		    oElmnt.style.display = "none";
		    oElmnt.style.position = "relative";
		}
   }	
}
//Un Hides a given Array of Element IDs
function ShowElements(theArray){
	for(var i=0; i < theArray.length; i++){
	    var oElmnt;
	    oElmnt = document.getElementById(theArray[i]);
	    if(oElmnt != null || oElmnt != undefined){
		    oElmnt.style.display = "block";
		    oElmnt.style.position = "relative";
		}
   }	
}

function CalculateRisk() {
	 if (!checkRelevantFormValues()){
	 	return;
	 }		 
  
    // Web Analytics (Omniture) - call web analytics-related function defined in 
    // in analytics_include.html and rendered in the web analytics page-load tag.  
    // If web analytics are turned off,  analytics_include.html is empty and this function is not found.
    // In the future it may be more efficient to attach this JavaScript code 
    // to the appropriate page event (click or submit) so no reference to web analytics
    // will be needed in this file.  
    if(window.Analytics_CalculateRiskConversionEvent)
        window.Analytics_CalculateRiskConversionEvent();
    
    var sParams = getFormValues();
    //document.location = "MelanomaRiskCalculator.aspx" + "?" + sParams;
   
    var selectSex = document.getElementById( gSexId );
    var sex = selectSex.options[selectSex.selectedIndex].value;
    if(sex == "1"){
        document.location = "results_m.aspx" + "?" + sParams;    
    }
    else if(sex == "2"){
        document.location = "results_f.aspx" + "?" + sParams;    
    }
   
    return;    
}

//Checks that all of the relevant DDL objects are non-missing
//  <div> -> <table> -> <tbody> -> <tr> -> <td> -> <select> 
//  So "parentNode.parentNode.parentNode.parentNode.parentNode" is necessary to access the target <div> from the <select>
function checkDDLValues() { 
   var aElements = document.body.getElementsByTagName("select");
   var sItem;

   for(var i = 0;i < aElements.length;i++){ 
      if (aElements[i].parentNode.parentNode.parentNode.parentNode.parentNode.style.display == "block" && aElements[i].value == gUnselected){
      	var sItem = formatId(aElements[i].id);
      	alert("Please complete the form by providing a selection for the " + sItem + " factor.");
      	aElements[i].focus();
        return false;
      }
   }
   return true; 
}


//called by the onkeypress event in the ccmel_main_div template.  Only calls makeRequest if the key pressed was the enter key.
function checkKey(){
	if (window.event && window.event.keyCode == 13){
	   return makeRequest('/cgi-bin/ccmel/calculate.pl');
	}
	return false;   
}	


//Function to check that all relevant values on the form are non-missing.
function checkRelevantFormValues(){
    if(handleRace() == true && handleAge() == true && checkDDLValues() == true)
        return true;
    else
        return false;    
    //return checkDDLValues();
}


//set the page to the default state if the specified conditions are met
function defaultHandler(){
	if (gbClearResults == 1 || (gbClearSolarDamage == 1 && document.getElementById( "sex" ).value == gFemale)){
     showUSMap();
     gbClearResults = 0;
   }
}


// changes the database style format to a more display-friendly format (e.g., "my_db_table" to "my db table")
function formatId(theId){
   var sItem = new String(theId);
   
   while (sItem.indexOf("_") > -1){
      sItem = sItem.replace("_"," ");
   }	
   sItem = sItem.replace("females","");
   sItem = sItem.replace("males","");
 
   return sItem;
}


//adds the objects with the specified class name to the passed array.
function getDocElements(sTargetClass, aTargets){
	var aDivs = document.getElementsByTagName("div");
	for(var i = 0;i < aDivs.length;i++){ 
      if (aDivs[i].className == (gGroupId+sTargetClass)){ 
      	aTargets.push(aDivs[i]);
      }	
   }
}


//Hides the disclaimer. Duh...
function hideDisclaimer(){
	var aDivs = document.getElementsByTagName("div");
	for(var i = 0;i < aDivs.length;i++){ 
      if (aDivs[i].className == "disclaimer"){ 
		  aDivs[i].style.display = "none";
		  aDivs[i].style.position = "relative";
      }	
   }
}


//returns a list of form name and value pairs suitable for url transmission
function getFormValues() { 
   var str = ""; 
   var aElements = document.body.getElementsByTagName("input");    
   for(var i = 0;i < aElements.length;i++){ 
      if(aElements[i].name.toUpperCase() != "__VIEWSTATE")
      str += aElements[i].name + "=" + aElements[i].value + "&";
   }

   var aElements = document.body.getElementsByTagName("select");

   for(var i = 0;i < aElements.length;i++){ 
      str += aElements[i].name + "=" + aElements[i].options[aElements[i].selectedIndex].value + "&";
   }

   str = str.substr(0,(str.length - 1)); 

   return str; 
}

//loads the results of the http_request call into the "results" object
//Got the status and readyState values from examples on the web -- standard stuff.
function getResults() {   //!!!alert("Inside getResults()");
    gbClearResults = 1;
    if (http_request.readyState == 4) {
        if (http_request.status == 200) {
        	  //hideDisclaimer();
        	  var resultWin = document.getElementById( "results" );
           resultWin.innerHTML = http_request.responseText; 
           alert(http_request.responseText);
        } 
        else {
           alert('There was a problem with the request.');
        }
    }
    showMapDirections();
}

function getResults_backup() {   //!!!alert("Inside getResults()");
    gbClearResults = 1;
    if (http_request.readyState == 4) {
        if (http_request.status == 200) {
        	  //hideDisclaimer();
        	  var resultWin = document.getElementById( "results" );
           resultWin.innerHTML = http_request.responseText; 
           alert(http_request.responseText);
        } 
        else {
           alert('There was a problem with the request.');
        }
    }
    showMapDirections();
}


//checks if the race selection
function handleRace(){
   var o = document.getElementById("race");
   var val = o.options[o.selectedIndex].value ; 
   if (val == "1" ){
       return true;
   }
   else{
       alert("This tool can only accurately calculate melanoma risk for patients who are non-Hispanic whites.");
       o.focus();
       return false;
   }
}

//checks if the race selection
function handleAge(){
   var o = document.getElementById("age");
   var val = o.options[o.selectedIndex].value ; 
   if (val >= "20" && val <= "70" ){
    return true;
   }
   else{
    alert("This tool only calculates risk for patients between 20 and 70 years of age.");  
    o.focus();
    return false;   
   }  
}



	
// forces the specified image element to be the only one that is highlighted	
function highlightImage(sId){
   document.getElementById("freckling_mild").border="1";  	
   document.getElementById("freckling_moderate").border="1";  	
   document.getElementById("freckling_severe").border="1";  	
   document.getElementById("severe_damage").border="1";  	
	
   document.getElementById(sId).border="2";  	
}	


//creates the http_request object, loads the parameters, and sends the request
function makeRequest_backup() {
	 if (!checkRelevantFormValues()){
	 	return false;
	 }	
	 
    var sParams = getFormValues();
        
    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        http_request = new XMLHttpRequest();
        if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml');
            // See note below about this line
        }
    } else if (window.ActiveXObject) { // IE
        try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                http_request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {}
        }
    }

    if (!http_request) {
        alert('Giving up :( Cannot create an XMLHTTP instance');
        return false;
    }
    //!!!!
    alert(sParams);
    http_request.onreadystatechange = getResults;
    http_request.open('POST', '/Script/calculate.pl', true);
    http_request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"); 
    http_request.send(sParams);
    
}


function showMapDirections(){
	document.getElementById( "region_label" ).innerHTML = '(Click <u>here</u> to view map)';
}	
			
function showMildFreckling(){
	highlightImage("freckling_mild");
	gbClearSolarDamage = 0;
	var resultWin = document.getElementById( "results" ); // "results" also in use in the main template file
   var str = '<div id="image_display"><img width="100%" height="100%" src="/melanomarisktool/images/freckled_back_mild.jpg" alt="Mild freckling on the back and shoulders" />';
	str += '<div id="results_footnote2"><p>Mild freckling on the back and shoulders</p></div></div>';
   resultWin.innerHTML = str; 
   showMapDirections();
   
}

function showModerateFreckling(){
	highlightImage("freckling_moderate");
	gbClearSolarDamage = 0;
	var resultWin = document.getElementById( "results" ); // "results" also in use in the main template file
   var str = '<div id="image_display"><img width="100%" height="100%" src="/melanomarisktool/images/freckled_back_moderate.jpg" alt="Moderate freckling on the back and shoulders" />';
	str += '<div id="results_footnote2"><p>Moderate freckling on the back and shoulders</p></div></div>';
   resultWin.innerHTML = str; 
   showMapDirections();
   
}

function showSevereDamage(){
	highlightImage("severe_damage");
	gbClearSolarDamage = 1;
	var resultWin = document.getElementById( "results" ); // "results" also in use in the main template file
   var str = '<div id="image_display"><img width="100%" height="100%" src="/melanomarisktool/images/sun_damage_severe.jpg" alt="Severe solar damage to the neck and shoulders" />';
	str += '<div id="results_footnote2"><p>Severe solar damage to the neck and shoulders</p></div></div>';
   resultWin.innerHTML = str; 
   showMapDirections();
}


function showSevereFreckling(){
	highlightImage("freckling_severe");
	gbClearSolarDamage = 0;
	var resultWin = document.getElementById( "results" ); // "results" also in use in the main template file
   var str = '<div id="image_display"><img width="100%" height="100%" src="/melanomarisktool/images/freckled_back_severe.jpg" alt="Severe freckling on the back and shoulders" />';
	str += '<div id="results_footnote2"><p>Severe freckling on the back and shoulders</p></div></div>';
   resultWin.innerHTML = str; 
   showMapDirections();
}


function showUSMap(){
	gbClearSolarDamage = 0;
	var resultWin = document.getElementById( "results" ); // "results" also in use in the main template file
   var str = '<div id="map_display"><img width="100%" height="100%" src="/melanomarisktool/images/us_map.jpg" alt="regional map of the continental united states" />';
	str += '<div id="results_footnote"><p>Caution:&nbsp;&nbsp;';
	str += 'This map is only a guide.&nbsp;&nbsp;The final choice of region should be made by the health care provider.';
	str += '&nbsp;&nbsp;The model is valid only for residents of the continental United States.</p></div></div>';
   resultWin.innerHTML = str; 
}


//hides the specified elements	
function hideElements(theArray, iLength){
	for(var i=0; i < theArray.length; i++){
		theArray[i].style.display = "none";
		theArray[i].style.position = "relative";
   }	
}


	
//unhides the specified elements	
function unHideElements(theArray, iLength){
	for(var i=0; i < theArray.length; i++){
		theArray[i].style.display = "block";
		theArray[i].style.position = "relative";
   }	
}	
	
function printResults(){
   var winResults = document.getElementById( "results_display" );
   var winLi1 = document.getElementById( "li1" );
   var winLi2 = document.getElementById( "li2" );
   var winLi3 = document.getElementById( "li3" );
   var sResults;
 
   sResults = '<h3>Melanoma Risk Calculator</h3><br />'
            + winLi1.innerHTML
            + winLi2.innerHTML
            + winLi3.innerHTML
            + '<br />'
            + winResults.innerHTML;
           
   top.hidden_frame.document.getElementById( "ccmelprn" ).innerHTML = sResults;
   top.hidden_frame.focus(); 
   top.hidden_frame.print(); 
   top.main_frame.focus(); 
}
	
function doPrint() {
 var winResults = document.getElementById( "results" );
 var winLi1 = document.getElementById( "li1" );
 var winLi2 = document.getElementById( "li2" );
 var winLi3 = document.getElementById( "li3" );

 top.consoleRef=window.open('','myconsole',
  'width=350,height=250'
   +',menubar=1'
   +',toolbar=1'
   +',status=0'
   +',scrollbars=1'
   +',resizable=1')
 top.consoleRef.document.writeln(
  '<html><head><title>Melanoma Risk Calculator</title></head>'
   +'<body bgcolor=white onLoad="self.focus()">'
   + '<h3>Melanoma Risk Calculator</h3><br />'
   + winLi1.innerHTML
   + winLi2.innerHTML
   + winLi3.innerHTML
   + winResults.innerHTML 
//   + '<div id="print_control"><br /><input id="print_button" value="Print" type="button" onmousedown="document.getElementById("print_control").style.display = "none"; window.print();" /></div>'
   +'</body></html>'
 );
 top.consoleRef.document.close();
 top.consoleRef.document.print();
}

/**************************************************************************************************
* Name		: 
* Purpose	: 
* Author	: 
* Date		: 07/13/2006
* Changes	:
**************************************************************************************************/
function PrintResults(gender){
   //defaultHandler();
   var selectSex = document.getElementById( gSexId );
   var sex = selectSex.options[selectSex.selectedIndex].value;
   
   //hide all the questionaries firs
   HideElements(gaAllElements);
   
   if (gender == "1"){            
        //show male related elements
        ShowElements(gaMaleElements);                
        SetHref(document.getElementById("q5"), "q5", sex); 
        
        SetValue("q6", "6", sex);
        SetValue("q8", "7", sex);
        SetValue("q9m", "8", sex);
        SetValue("q10", "9", sex);
        SetValue("q11", "10", sex);        
        
   } else if (gender == "2"){
        //show female related elements
  	    ShowElements(gaFeMaleElements);
  	    SetValue("q6", "5", sex);
  	    SetValue("q7", "6", sex);
        SetValue("q9f", "7", sex);
        SetValue("q10", "8", sex);        
   } else {
        //reset about-tool.html
        //document.getElementById("q0").href = "about-tool.html";
   }	
}	
