function toggle(obj) {

	var el = document.getElementById(obj);

	if ( el.style.display != 'none' ) {
		el.style.display = 'none';
	} else {
	    el.style.display = '';;
	}
}


//allows only digits [0-9]
function onlyDigit(obj) {
    reg = /[^0-9]/g;
    obj.value = obj.value.replace(reg, "");
}

//allows only digits[0-9] and period .
function onlyDigit2(obj) {
    reg = /[^0-9.]/g;
    obj.value = obj.value.replace(reg, "");
}

function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode
         if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

         return true;
      }

function showWomanMisc(input, divName, comparedValue, secondInput, secondDiv, rblID) {
    var inputnum = $('[name=' + input + ']:checked').val();

    if (inputnum != undefined) {
        if (inputnum == comparedValue) {
            $('#' + divName).css('color', "#aaaaaa");
            $('#' + divName).find('div').css('color', "#aaaaaa");
            $('#' + divName).find('select').attr('disabled', true);
            $('#' + divName).find('option').removeAttr("selected");
            $('#' + divName).find('input').attr('checked', false);
            $('#' + divName).find('input').attr('disabled', true);
        } else {
             if (secondInput == 'GT2') {
                 $('#' + secondDiv).css('color', "#000000");
                 $('[name=' + rblID + ']').removeAttr('disabled');
            } else {
            $('#' + secondDiv).css('color', "#aaaaaa");
            $('[name=' + rblID + ']').attr('checked', false);
            $('[name=' + rblID + ']').attr('disabled', true);
            }
        }
    }
}

function showDiv(inputnum, divname, ddlID) {
    if (inputnum != undefined && inputnum != 'NAN') {
        if (inputnum > 0) {
            $('#' + divname).css('color', "#000000");
            $('#' + ddlID).removeAttr('disabled');
        } else {
            $('#' + divname).css('color', "#aaaaaa");
            $('#' + ddlID).find('option').removeAttr("selected");
            $('#' + ddlID).attr('disabled', true);
        }
    }
}
function showDivEstrogen(inputnum, divname, rblID) {
        if (inputnum == 'GT2') {
            $('#' + divname).css('color', "#000000");
            $('[name=' + rblID + ']').removeAttr('disabled');
        } else {
            $('#' + divname).css('color', "#aaaaaa");
            $('[name=' + rblID + ']').attr('checked', false);
            $('[name=' + rblID + ']').attr('disabled', true);
        }
}
/* Used for enable or disable div and inside select or input ctrls with radio button lists*/
function showDivWithInput(input, divName, comparedValue) {
    var inputnum = $('[name=' + input + ']:checked').val();
    if (inputnum != undefined) {
        if (inputnum == comparedValue) {
            $('#' + divName).css('color', "#000000");
            $('#' + divName).find('div').css('color', "#000000");
            $('#' + divName).find('select').removeAttr('disabled');
            $('#' + divName).find('input').removeAttr('disabled');
        } else {
            $('#' + divName).css('color', "#aaaaaa");
            $('#' + divName).find('div').css('color', "#aaaaaa");
            $('#' + divName).find('select').attr('disabled', true);
            $('#' + divName).find('option').removeAttr("selected");
            $('#' + divName).find('input').attr('checked', false);
            $('#' + divName).find('input').attr('disabled', true);
//            if(input=="ctl00$cphMain$WUCDemo$rblhispanic")
//            {
//                showPopUpMessage(input,comparedValue);
//            }
        }
    }
}

function showDivHispanic(input, divName, comparedValue) {
    showDivWithInput(input, divName, comparedValue);
}

function showDivWithSmoke(input, divName, comparedValue, startSmokeValue, smokeNowID, ageQuitDiv, secondCValue) {
    var inputnum = $('[name=' + input + ']:checked').val();

    if (inputnum != undefined) {
        if (inputnum == comparedValue) {
        //Check startsmoke
            if (startSmokeValue == 1 || startSmokeValue == 'NAN') {
                $('#currentlysmoke').css('color', "#aaaaaa");
                $('#currentlysmoke').find('div').css('color', "#aaaaaa");
                $('#currentlysmoke').find('select').attr('disabled', true);
                $('#currentlysmoke').find('option').removeAttr("selected");
                $('#currentlysmoke').find('input').attr('checked', false);
                $('#currentlysmoke').find('input').attr('disabled', true);
            } else {
                var inputSmokeNow = $('[name=' + smokeNowID + ']:checked').val();

                if (inputSmokeNow != secondCValue) {
                    $('#' + ageQuitDiv).css('color', "#aaaaaa");
                    $('#' + ageQuitDiv).find('select').attr('disabled', true);
                    $('#' + ageQuitDiv).find('input').find('option').removeAttr("selected");
                }
            }

        } else {
            $('#' + divName).css('color', "#aaaaaa");
            $('#' + divName).find('div').css('color', "#aaaaaa");
            $('#' + divName).find('select').attr('disabled', true);
            $('#' + divName).find('option').removeAttr("selected");
            $('#' + divName).find('input').attr('checked', false);
            $('#' + divName).find('input').attr('disabled', true);
        }
    }
}

function showagestarted(inputnum) {
    if (inputnum == 1 || inputnum == 'NAN') {
        $('#currentlysmoke').css('color', "#aaaaaa");
        $('#currentlysmoke').find('div').css('color', "#aaaaaa");
        $('#currentlysmoke').find('select').attr('disabled', true);
        $('#currentlysmoke').find('option').removeAttr("selected");
         $('#currentlysmoke').find('input').attr('checked', false);
         $('#currentlysmoke').find('input').attr('disabled', true);
    } else {
        $('#currentlysmoke').find('div').css('color', "#000000");
        $('#currentlysmoke').find('select').removeAttr('disabled');
        $('#currentlysmoke').find('input').removeAttr('disabled');
    }
}


function switch_tabs(obj) {
    $('.tabinfo-content').hide();
    $('.tabsinfo a').removeClass("selected");
    var id = obj.attr("rel");

    $('#' + id).show();
    obj.addClass("selected");
}


function hidediv(obj) {
    var el = document.getElementById(obj);
    el.style.display = 'none';
}
function displaydiv(obj) {
    var el = document.getElementById(obj);
    el.style.display = '';
}
function getFlashMovie(movieName) {
    var isIE = navigator.appName.indexOf("Microsoft") != -1;
    return (isIE) ? window[movieName] : document[movieName];
}
function formSend(TopCount, BotCount) {
    getFlashMovie("final_dyn_v3.swf").sendTextToFlash(TopCount, BotCount);
}


function showPopUpMessage(elementId,comparedValue)
{
    if(elementId=="ctl00$cphMain$WUCDemo$rblhispanic")
    {
       var inputnum = $('[name=' + elementId + ']:checked').val();

       if(inputnum=="Yes")
       {
            showDivWithInput(elementId,'qdivRace','No');
            toggle('More_Hisp');
       }
       else
       {
           showDivWithInput(elementId,'qdivRace','No');
       }
    }
    else if(elementId=="ctl00$cphMain$WUCDemo$rblRace")
    {
        var inputnum = $('[name=' + elementId + ']:checked').val();
        if(inputnum=="Black")
        {
                toggle('More_Black');

        }
        else if(inputnum=="Asian")
        {
                toggle('More_Asain');

        }
    }
 
}

