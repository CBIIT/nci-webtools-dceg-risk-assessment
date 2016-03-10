$(".thumbnail").on("click", function () {
    $(this).toggleClass(function () {
        if ($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
});

$('[type="reset"]').on("click",function() {
    $("#result").empty().removeClass("show");
});

/*
    functions for canvas graphic generation
*/
function displayResult(result) {
    var matches = Number(result).toExponential().toString().match(/(\d+)(?:.(\d+))?e([-+]?\d+)/i);
    var estimate = matches[1];
    var outOf = 2 - Number(matches[3]);
    if (matches[2] !== undefined) {
        estimate += matches[2];
        outOf += matches[2].length;
    }
    outOf = Number('1e' + outOf);

    if (window.location.hostname.indexOf("dev") == -1)
        result = Number(result).toFixed(1);

    $('#result').append('<h2>' + result + '%</h2><p>Your risk of developing cancer in the next 5 years is ' + result + '%. This means that roughly ' + estimate + ' in ' + outOf + ' people like you are likely to develop cancer in the next 5 years.').addClass('show');

    graphResult($('#result').append('<canvas class="chart" width="500" height="380"></canvas>').children('.chart')[0], Number(result));
    $("#result").addClass("show");
    document.getElementById("top").scrollIntoView();
}

function graphResult(element, result) {

    var ratio = window.devicePixelRatio || 1;

    var ctx1 = element.getContext('2d');
    element.style['max-width'] = element.width + "px";

    element.width *= ratio;
    element.height *= ratio;

    var img = new Image();
    img.src = "../images/person.svg";
    img.onload = function () {
        var $this = this;

        $this.width = this.width / 9.5;
        $this.height = this.height / 8;

        // Clear Canvas
        ctx1.clearRect(0, 0, $this.width * 20, $this.height * 20);
        ctx1.scale(ratio, ratio);

        highlightImage($this, result, ctx1);
        createMask($this, ctx1);

        return window.setInterval(function () {
            // Clear Canvas
            ctx1.clearRect(0, 0, $this.width * 20, $this.height * 20);
            ctx1.scale(ratio, ratio);

            highlightImage($this, result, ctx1);
            createMask($this, ctx1);
        }, 2000);
    };
}

function highlightImage(img, calcResult, canvasContext) {

    for (var i = calcResult; i >= 0; i--) {
        var j = Math.floor(Math.random() * 20);
        var k = Math.floor(Math.random() * 5);

        if (calcResult > 0) {
            canvasContext.fillStyle = "#bb0e3d";

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
