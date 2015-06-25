function validate(values) {
    var valid = true;
    var messages = [];

    $("#errors").empty();

    var $this = document.getElementsByTagName('form').markers;
    var invalidElements = $($this).find(':invalid');

    for (var item in values) {
        var marker_value_keys = Object.keys(values[item]);
        // object will always have one option property so check for less than 2
        if (marker_value_keys.length < 2) {
            valid = false;
            messages.push('You must enter values for either option 1 or 2 in each biomarker.');
        }
    }

    for (var i = 0; i != invalidElements.length; i++) {
        var text;
        valid = invalidElements[i].valid;
        var validityObj = invalidElements[i].validity;
        if (validityObj.badInput) {
            text = "The value you entered contains an invalid character. "
                + invalidElements[i].validationMessage;
        }
        if (validityObj.patternMismatch) {
            text = "The value you entered '" + invalidElements[i].value + "' contains an invalid character. "
                + invalidElements[i].validationMessage;
        }
        if (validityObj.rangeOverflow || validityObj.rangeUnderflow) {
            if (invalidElements[i].min && invalidElements[i].max) {
                text = "The value you entered '" + invalidElements[i].value + "' must be decimal value between " +
                    invalidElements[i].min + " and " + invalidElements[i].max;
            }
            else if (invalidElements[i].min && !invalidElements[i].max) {
                text = "The value you entered '" + invalidElements[i].value + "' must be decimal value greater than " +
                    invalidElements[i].min;
            }
            else {
                text = "The value you entered '" + invalidElements[i].value + "' must be decimal value less than " +
                    invalidElements[i].max;
            }
        }
        // prevent duplicate messages
        if ($.inArray(text, messages) == -1) messages.push(text);
    }

    if (messages.length > 0) {
        valid = false;
        display_errors(messages);
    }
    else $("#errors").fadeOut();

    return valid;
}

function display_errors(message) {
    var text = "";

    if ($.isArray(message) && message.length > 0) {
        $(message).each(function (i, v) {
            text += "<li>" + v + "</li>";
        });
    }
    if (typeof message == "string") {
        text = message;
    }
    if($('#errors').length > 0){
        $("#errors").empty();
        $("#errors").remove();
    }

    $(".title.text-center").after("<div id='errors' class='alert alert-danger fade in'><a href='#' data-dismiss='alert' class='close'>&times;</a>" +
        "<ul class='list-unstyled'>" + text + "</ul></div>");

    $('#errors').fadeIn();
    scrollTop();
}