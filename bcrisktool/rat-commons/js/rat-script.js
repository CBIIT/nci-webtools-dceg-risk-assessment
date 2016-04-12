$(".thumbnail").on("click", function () {
    $(this).toggleClass(function () {
        if ($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
});

$('[type="reset"]').on("click", function () {
    $("#result").empty().removeClass("show");
});




var personImg;
var img = new Image();
img.src = "rat-commons/images/person.png";
img.onload = function () {
    personImg = this;
    personImg.width = 25;
    personImg.height = 76;
};


var patternImg = new Image();
patternImg.src = "rat-commons/images/stripe.png";

function displayResult(result) {
    if (window.location.hostname.indexOf("dev") == -1 || window.location.hostname.indexOf("localhost") == -1) {
        result = Math.round(Number(result) * 100) / 100;
    } else {
        result = Math.round(Number(result) * 10) / 10;
    }
    var matches = Number(result).toExponential().toString().match(/(\d+)(?:.(\d+))?e([-+]?\d+)/i);
    var estimate = matches[1];
    var outOf = 2 - Number(matches[3]);
    if (matches[2] !== undefined) {
        estimate += matches[2];
        outOf += matches[2].length;
    }
    outOf = Number('1e' + outOf);

    $('#result').empty().append('<h2>' + result + '%</h2><p>Your risk of developing cancer in the next 5 years is ' + result + '%. This means that roughly ' + estimate + ' in ' + outOf + ' people like you are likely to develop cancer in the next 5 years.').addClass('show');

    var canvas = $('<canvas class="chart" width="500" height="380"></canvas>');

    if (canvas[0].getContext && canvas[0].getContext("2d")) {
        $('#result').append(canvas);
        graphResult($("#result canvas")[0], Number(result));
    } else {
        console.log("Canvas not supported!!");
    }
    document.getElementById("top").scrollIntoView();
}

function graphResult(element, result) {
    var ratio = window.devicePixelRatio || 1;

    var ctx1 = element.getContext('2d');
    element.style['max-width'] = element.width + "px";

    element.width *= ratio;
    element.height *= ratio;

   
    ctx1.clearRect(0, 0, personImg.width * 20, personImg.height * 20);
   

    highlightImage(personImg, result, ctx1);
    createMask(personImg, ctx1);

    return window.setInterval(function () {
       
        ctx1.clearRect(0, 0, personImg.width * 20, personImg.height * 20);

        highlightImage(personImg, result, ctx1);
        createMask(personImg, ctx1);
    }, 2000);
}

function highlightImage(img, calcResult, canvasContext) {

    var pattern = canvasContext.createPattern(patternImg, 'repeat');
    canvasContext.fillStyle = pattern;
   


    for (var i = calcResult; i >= 0; i--) {
        var j = Math.floor(Math.random() * 20);
        var k = Math.floor(Math.random() * 5);

        if (calcResult > 0) {
           

            if (calcResult > 0 && calcResult < 1) {
                canvasContext.fillRect(img.width * j, img.height * k, calcResult * img.width, img.height);
            } else if (calcResult > 1) {
                canvasContext.fillRect(img.width * j, img.height * k, img.width, img.height);
            }
        } else
            return;
        calcResult--;
    }
}

function createMask(maskImg, canvasContext) {
    for (var i = 0; i < 20; i++) {
        for (var j = 0; j < 5; j++) {
           
            canvasContext.drawImage(maskImg, maskImg.width * i, maskImg.height * j, maskImg.width, maskImg.height);
        }
    }
}

function processSubmission(form) {

    $('#error').empty().css('display', 'none');
    $('#result').empty();
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
                message += "<p>The " + data.nonnumeric[index] + " question contained a nonnumeric answer.</p>";
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

function resetInputs() {
    $(this).validate().reset();
    $("[name='" + this.name + "'], [for='" + this.name + "']").removeClass("error");

    if (this.type == "radio" || this.type == "checkbox")
        this.checked = false;
    if (this.type == "select-one" || this.type == "select-multiple" || this.type == "text" || this.type == "number")
        this.value = "";
}

$(function () {
    $(".about-question-explanation").on("click", function() {
        toggleShow(this);
    });

    $(".exp-title").on("click", function() {
        toggleShow($(this).next());
    });

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
        toggleShow($('#main-nav'));
    });

    $('#main-nav a').on('click', function () {
        var nextNav = $(this).next('ul.nav');

        if ($('#main-nav').hasClass('show') && nextNav.length === 0)
            $('#main-nav').removeClass('show');

        if (nextNav.length > 0)
            toggleShow(nextNav);
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
        toggleShow($(this).find(".description"));
    });
});

function toggleShow(el){
    $(el).toggleClass("show");
}

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
