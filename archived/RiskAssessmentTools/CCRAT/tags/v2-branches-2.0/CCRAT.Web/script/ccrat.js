function popUp(e) {
    var targ;
	if (!e) var e = window.event;
	if (e.target) targ = e.target;
	else if (e.srcElement) targ = e.srcElement;
	if (targ.nodeType == 3) // defeat Safari bug
		targ = targ.parentNode;

    if (targ.tagName == "A") {
        day = new Date();
        id = day.getTime();
        eval("page" + id + " = window.open(targ.href, '" + id + "', 'toolbar=0,scrollbars=0,location=0,statusbar=1,menubar=0,resizable=1,width=497,height=262,left = 391.5,top = 261');");
    }
}

function popUp2(href) {
    day = new Date();
    id = day.getTime();
    eval("page" + id + " = window.open(href, '" + id + "', 'toolbar=0,scrollbars=0,location=0,statusbar=1,menubar=0,resizable=1,width=497,height=262,left = 391.5,top = 261');");
}
function getFlashMovie(movieName) {
    var isIE = navigator.appName.indexOf("Microsoft") != -1;
    return (isIE) ? window[movieName] : document[movieName];
}
function formSend(flashIdOrName, avgRisk, uCount, lCount) {
    alert(uCount + ", " + lCount + ", " + avgRisk);
    getFlashMovie(flashIdOrName).sendTextToFlash(uCount, lCount, avgRisk);
    //getFlashMovie(flashIdOrName).sendTextToFlash(uCount, lCount);    
}

