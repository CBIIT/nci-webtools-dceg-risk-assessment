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
    $(this).toggleClass("expand");
    this.scrollIntoView();
}



$(function () {


    $('.goTo').on('click', function () {
        $(this.name)[0].scrollIntoView();
    });

    $('#content').on('click', '[tabTo]', function (e) {
        if (history && history.pushState && $(this).children('a').length == 1) {
            e.preventDefault();
            history.pushState({}, '', $(this).children('a').eq(0).attr('href'));
        }
        $('[tabTo],[tab]').removeClass('active');
        $(this).addClass('active');
        $('[tab="' + $(this).attr('tabTo') + '"]').addClass('active');
    });

    $('.goToTab').on('click', function () {
        $('[tabTo="' + this.name + '"]').trigger('click');
    });

    $('#menu-button').on('click', function () {
        $('#main-nav').toggleClass('show');
    });

    $('#main-nav a').on('click', function () {
        var nextNav = $(this).next('ul.nav');

        if ($('#main-nav').hasClass('show') && nextNav.length === 0)
            $('#main-nav').removeClass('show');

        if (nextNav.length > 0)
            nextNav.toggleClass('show');
        else
            $('#quick-link > ul.nav').removeClass('show');
    });

    var currentHash = window.location.hash;
    if (currentHash.length > 0) {
        $('[tabTo] a[href="' + window.location.hash + '"]').parent().click();
    } else {
        $('[tabTo]:first-child').first().click();
    }

    $(window).scroll(fixedToTop);
    fixedToTop();

    $(".section-description").on("click", function () {
        $(this).find(".description").toggleClass("show");
    });
});

function fixedToTop() {
    var window_top = $(window).scrollTop();
    var div_top = $('#content').offset().top;
    if (window_top > div_top) {
        $('#main-nav').addClass('stick-nav-top');
        $("#topButton").css("display", "block");
    } else {
        $('#main-nav').removeClass('stick-nav-top');
        $("#topButton").css("display", "none");
    }
}
