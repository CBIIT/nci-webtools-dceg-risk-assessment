$(".thumbnail").on("click", function () {
    $(this).toggleClass(function () {
        if ($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
});

function displayResult(result) {
    var matches = Number(result).toExponential().toString().match(/(\d+)(?:.(\d+))?e([-+]?\d+)/i);
    var estimate = matches[1];
    var outOf = 2 - Number(matches[3]);
    if (matches[2] !== undefined) {
        estimate += matches[2];
        outOf += matches[2].length;
    }
    outOf = Number('1e' + outOf);
    $('#result').append('<h2>' + result + '%</h2><p>Your risk of developing cancer in the next 5 years is ' + result + '%. This means that roughly ' + estimate + ' in ' + outOf + ' people like you are likely to develop cancer in the next 5 years.').removeClass('hide');
    graphResult($('#result').append('<div class="chart"></div>').children('.chart'), Number(result));
    document.getElementById("top").scrollIntoView();
}

function graphResult(element, result) {
    for (var i = 0; i < 100; i++) {
        $(element).append('<img src="images/person.svg"/>');
    }
    var fullBars = Math.floor(result / 20);
    var partialBar = (result - (20 * fullBars)) * 5;
    var top = 0;
    for (var j = 0; j < fullBars; i++) {
        $(element).prepend('<div class="bar yours" style="top:' + top + '%;width:100%;"></div>');
        top += 20;
    }
    if (partialBar > 0) {
        $(element).prepend('<div class="bar yours" style="top:' + top + '%;width:' + partialBar + '%;"></div>');
    }
}

function processSubmission(form) {
    $('#error').empty().css('display', 'none');
    $('#result').addClass('hide').empty();
    $('.error').removeClass('error');
    $.ajax({
        url: form.action,
        type: form.method,
        data: new FormData(form),
        processData: false,
        contentType: false,
        dataType: 'json'
    }).done(function (data) {
        if (data.success) {
            displayResult(data.message);
        } else {
            var message = "";
            if (data.message) {
                message += "<p>" + data.message + "</p>";
            }
            var index;
            for (index in data.missing) {
                $('#' + data.missing[index]).addClass('error');
                message += "<p>The " + data.missing[index] + " question was not answered.</p>";
            }
            for (index in data.nonnumeric) {
                $('#' + data.nonnumeric[index]).addClass('error');
                message += "<p>The " + data.missing[index] + " question contained a nonnumeric answer.</p>";
            }
            $('#error').append(message).css('display', 'block');
            document.getElementById("top").scrollIntoView();
        }
    }).fail(function (data) {
        //                $('#error').append("<p>An unknown error occurred. Please consult the administrator.</p>");
        if (data.responseJSON)
            $('#error').append("<p>" + data.responseJSON.message + "</p>").css('display', 'block');
        else
            $('#error').append("<p>" + data.responseText + "</p>").css('display', 'block');
        
        document.getElementById("top").scrollIntoView();
    });
}

function highlightErrorElement(element, errorClass, validClass) {
    if (element.type != "radio") {
        $(element).addClass(errorClass).removeClass(validClass);
    }
    $(element.form).find("label[for='" + element.name + "']")
        .addClass(errorClass);
}

function removeHighlightErrorElement(element, errorClass, validClass) {
    if (element.type != "radio") {
        $(element).removeClass(errorClass).addClass(validClass);
    }
    $(element.form).find("label[for='" + element.name + "']")
        .removeClass(errorClass);
}

function expandCollapseImage() {
    $(this).toggleClass(function () {
        if ($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
}


