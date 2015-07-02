

var currentMarkers = 1;

$(document).ready(function () {
    $(".loader,#results,#errors, .bm_1, .bm_2, .bm_3").hide();
    controls_visibility(currentMarkers);
    bind_control_events();
    create_popover();

    $('.termToDefine, .dd.termToDefine').on('click', display_definition);
});

function bind_control_events() {
    $("#errors").alert();
   
    $('a#test1,a#test2').on('click', test);

    $('#reset').on('click', reset);
    $('#add-marker').on('click', new_marker);
    $('#delete-marker').on('click', delete_marker);
    $('#calculate').on('click', calculate);

    bind_accordion_action($('#markers').children().first());
}

function bind_accordion_action(el) {
   
   
   
   
   
}

function controls_visibility(numElements) {
   
    if (numElements == 2) {
        $('#delete-marker').show();
        $('#add-marker').show();
    }
    if (numElements > 2) {
        $('#delete-marker').show();
        $('#add-marker').hide();
    }
    if (numElements < 2) {
        $('#delete-marker').hide();
        $('#add-marker').show();
    }
}

function new_marker() {
    var counter = currentMarkers + 1;
    if (currentMarkers <= 3) {
        var markerTemplate = $('#markers').find('.marker').first();

       
        var newElement = markerTemplate.clone();

       
        newElement.removeClass('marker-1').addClass("marker-" + counter);

       
        newElement.find('.input,input').each(function () {
            if ($(this).is("input")) {
                $(this).val("");
            }
            if ($(this).is("select")) {
               
                $(this)[0].selectedIndex = 0;
            }
        });

       
        newElement.find(".panel-heading").each(function (index) {
            var panel_id = '#marker-' + counter + '-option-' + (index + 1);

            $(this).attr('data-target', panel_id);
            $(this).attr('data-parent', '.marker-' + counter);
        });

       
        newElement.find(".panel-collapse").each(function (index) {
            var newPanelContentId = 'marker-' + counter + '-option-' + (index + 1);
            $(this).attr("id", newPanelContentId);
            bind_accordion_action(this);
        });

       
        newElement.find('.marker-title').text("Biomarker #" + counter);
        newElement.find('.termToDefine, .dd.termToDefine')
            .on('click', display_definition);

        currentMarkers++;
       
       
        controls_visibility(currentMarkers);

       
       
        $(newElement[0]).insertAfter($('#markers').children().last());
    }
}

function delete_marker() {
    if (currentMarkers > 1) {
       
        $('#markers').children().last().empty();
        $('#markers').children().last().remove();
        $('.bm_'+currentMarkers).hide();
        currentMarkers--;
    }
    controls_visibility(currentMarkers);
    scrollTop();
}

function calculate() {
    var service;
    var valuesObj = extract_values(false);
    var valid = valuesObj[1];
    if (valid) {
        var input = JSON.stringify(valuesObj[0]);

        var host = window.location.hostname;
        if (host == 'localhost') {
           
            service = 'output_example.json';
        } else {
            service = "http://" + host + "/mrsRest/";
        }

        var to_value = 10 * 1000;

        $('#loader').show();

       
        var promise = $.ajax({
            dataType: 'json',
            method: 'POST',
            contentType: 'application/json',
            url: service,
            data: input,
            timeout: to_value
        });

        promise.then(clean_data, function (error) {
            $("#results, .bm_1, .bm_2, .bm_3").hide();
            display_errors("The service call has failed with the following status: " + error.statusText);
        });

        promise.done(return_data);
        scrollTop();
    }
}

function scrollTop() {
    $('html, body').animate({
        scrollTop: 0
    });
}

function clean_data(data) {
   
    return JSON.parse(JSON.stringify(data));
}

function return_data(data) {
    i = 0;

   
    $("#results, .bm_1, .bm_2, .bm_3").hide();

    do {
        i++;
       
        $('.bm_' + i).show();
    } while (i != currentMarkers);

    $.each(data, function (propName, paramGroup) {
        var ci_lb, ci_ub, params, calc, marker_id;
        append_name();

        params = paramGroup.parameters;
        calc = paramGroup.calculations;
        marker_id = propName;

       
        $.each(params, function (name) {

            var lookup_id = lookup[name];
            var data_item = params[name];
            var formattedText = data_item.Value;
            if (lookup_id != 'rr' && lookup_id != 'nnr' && lookup_id != 'nns') {
                formattedText += "%  ";
                if (data_item["Confidence Interval (lower bound)"] !== null &&
                    data_item["Confidence Interval (upper bound)"] !== null) {
                    ci_lb = data_item["Confidence Interval (lower bound)"];
                    ci_ub = data_item["Confidence Interval (upper bound)"];
                    formattedText += " (" + ci_lb + "%, " + ci_ub + "%)";
                }
            }
            else {
                if (data_item["Confidence Interval (lower bound)"] !== null &&
                    data_item["Confidence Interval (upper bound)"] !== null) {
                    ci_lb = data_item["Confidence Interval (lower bound)"];
                    ci_ub = data_item["Confidence Interval (upper bound)"];
                    formattedText += " (" + ci_lb + ", " + ci_ub + ")";
                }
            }
           
            cell = $('#' + lookup_id + '_result.' + marker_id + '.output');
            cell.attr('title', lookup_id + " " + formattedText);
            cell.text(formattedText);
        });
       
        $.each(calc, function (name) {
            var lookup_id = lookup[name];
            var data_item = calc[name];
            var formattedText = data_item.Value;

            if (lookup_id != 'rr' && lookup_id != 'nnr' && lookup_id != 'nns') {
                formattedText += "%  ";
                if (data_item["Confidence Interval (lower bound)"] !== null &&
                    data_item["Confidence Interval (upper bound)"] !== null) {
                    ci_lb = data_item["Confidence Interval (lower bound)"];
                    ci_ub = data_item["Confidence Interval (upper bound)"];
                    formattedText += " (" + ci_lb + "%, " + ci_ub + "%)";
                }
            }
            else {
                if (data_item["Confidence Interval (lower bound)"] !== null &&
                    data_item["Confidence Interval (upper bound)"] !== null) {
                    ci_lb = data_item["Confidence Interval (lower bound)"];
                    ci_ub = data_item["Confidence Interval (upper bound)"];
                    formattedText += " (" + ci_lb + ", " + ci_ub + ")";
                }
            }

            cell = $('#' + lookup_id + '_result.' + marker_id + '.output');
            cell.attr('title', lookup_id + " " + formattedText);
            cell.text(formattedText);
        });
    });

    $("#results").show();
    $("#loader").hide();
}

function append_name() {
    var i = 0;
    var name;
    do {
        i++;
        var thisNameInputElement = $('.marker-' + i + ' .name-input');
       
        if ((thisNameInputElement.val()).length > 0)
            name = thisNameInputElement.val() + " (CI Low, CI High)";
        else
            name = "Biomarker " + i + " (CI Low, CI High)";

       
        $('#results').find('table thead tr .bm_' + i).attr('title', name).text(name);
    } while (i != currentMarkers);
}

function extract_values(valid) {
    var values = {};

   
    i = 0;
    do {
        i++;

        values["bm_" + i] = {};
        var thisMarker = $('.marker-' + i);

       
        var option_1_controls = thisMarker.find('#marker-' + i + '-option-1 .input').serializeArray();
        var option_2_controls = thisMarker.find('#marker-' + i + '-option-2 .input').serializeArray();

        option_1_controls.forEach(function (element) {
           
            if (element.value.length > 0) {
                values["bm_" + i].option = 1;
                values["bm_" + i][element.name] = element.value;
            }
        });

       
        if (!values["bm_" + i].option) {

           
            values["bm_" + i].option = 2;

            var param_1 = [];
            var param_2 = [];
            var param_3 = [];
            var param_4 = [];

            option_2_controls.filter(function (obj) {
               
                if (obj.name == "param_1" && obj.value.length > 0) {
                    param_1.push(obj);
                }
                if (obj.name == "param_2" && obj.value.length > 0) {
                    param_2.push(obj);
                }
                if (obj.name == "param_3" && obj.value.length > 0) {
                    param_3.push(obj);
                }
                if (obj.name == "sampsize" && obj.value.length > 0) {
                    param_4.push(obj);
                }

            });
            if (param_1.length > 1 && param_2.length > 1 && param_3.length > 1 && param_4.length > 0) {
               
                values["bm_" + i][param_4[0].name] = param_4[0].value;

                var value_length = [param_1[1].value.length, param_2[1].value.length, param_3[1].value.length];

                value_length.forEach(function (el) {
                    if (el > 0) {
                        valid = false;
                       
                        joinObjects(values["bm_" + i], param_1[0], param_1[1]);
                        joinObjects(values["bm_" + i], param_2[0], param_2[1]);
                        joinObjects(values["bm_" + i], param_3[0], param_3[1]);
                    }
                });
            }
           
           
           
        }
    } while (i != currentMarkers);

    valid = validate(values);
    return [values, valid];
}

function joinObjects(parentObj, obj1, obj2) {
   
   
    parentObj[obj1.value] = obj2.value;
    return parentObj;
}

function reset() {
   
    var markerChildren = $('#markers').children();

   
    $('select').find('option:first').attr('selected', 'selected');
    $('input').val('');

   
    $('.output').text('');
    $("#results, .bm_1, .bm_2, .bm_3").hide();

   
    $("#errors").fadeOut();

   
    markerChildren.not(':first').each(function () {
        $(this).empty();
        $(this).remove();
    });
    currentMarkers = 1;
    controls_visibility(currentMarkers);
}
function create_popover() {
    var term_element = $('.termToDefine');
    term_element.attr('data-toggle', 'popover');
    term_element.attr('role', 'button');
    term_element.attr('tabindex', '');
}

function display_definition() {
   
   
    var $self = $(this);
    var id;
   
    if (!$self.hasClass('dd')) {
        if (!$self.hasClass('header') && $self.prop('tagName') != 'TD')
            id = ($self.attr('class')).replace('termToDefine', '').trim();
        if ($self.prop('tagName') == 'TD')
            id = ($self.attr('class')).replace('termToDefine', '').trim();
        else
            id = $self.attr('id');
    }
    else {
       
        id = $self.prev().val();
    }

    var definition = definitionObj[id].definition;
    var term = definitionObj[id].term;

    if (definition || term) {
        $self.popover(
            {container: 'body',
                trigger: 'manual',
                placement: 'top',
                title: term,
                content: definition}
        ).on('mouseout', function () {
                $self.popover('hide');
                $self.popover('destroy');
            });

        $self.popover();
        $self.popover('show');
    }
}


var definitionObj = {
    prob_m: {
        term: "Marker Positivity (M+)",
        definition: "Marker positivity, or probability of positive test result for biomarker"
    },
    m_neg: {
        term: "Marker Negativity (M-)",
        definition: "Negative test result for biomarker test"
    },
    prob_d: {
        term: "Disease Positive (D+)",
        definition: "Disease prevalence, or probability of disease"
    },
    d_neg: {
        term: "Disease Negative (D-)",
        definition: "Does not have disease"
    },
    concern: {
        term: "Concern",
        definition: "Increase in disease risk from testing positive. Formula: Concern = PPV-P(D+)"
    },
    reassurance: {
        term: "Reassurance",
        definition: "Reduction in disease risk from testing negative. Formula: Reassurance = P(D+)-cNPV"
    },
    pbs: {
        term: "Population Burden Stratification (PBS)",
        definition: "Extra disease detection in positive group than negative group. " +
        "Formula: PBS = a-b"
    },
    nns: {
        term: "Number Needed to Screen",
        definition: "Definition for number needed to screen. Formula: Usual NNS = 1/RD"
    },
    nnr: {
        term: "Number Needed to Recruit",
        definition: "To detect 1 more disease case in positive group than negative group. Formula: NNR = 1/PBS"
    },
    max_mrs: {
        term: "Maximum possible MRS for a disease with this prevalence",
        definition: "Maximum possible MRS for a disease with this prevalence. Formula: max risk strat=2q(1-q)"
    },
    q_spec: {
        term: "Quality of the specificity",
        definition: "Increase in specificity versus a random test, fixing test positivity"
    },
    q_sens: {
        term: "Quality of the sensitivity",
        definition: "Increase in sensitivity versus a random test, fixing test positivity. Formula: Danger*=ybar=sens-p"
    },
    spec: {
        term: "Specificity",
        definition: "Specificity is the proportion whose biomarker test is negative (below the threshold) among" +
        " those without disease. Formula: Reassurance*=xbar=spec-(1-p)"
    },
    sens: {
        term: "Sensitivity",
        definition: "Sensitivity is the proportion whose biomarker test is positive (above the threshold) among " +
        "those who are positive for disease."
    },
    ppv: {
        term: "Positive Predictive Value (PPV)",
        definition: "Probability of disease, given a positive test result from biomarker.  Unlike sensitivity " +
        "and specificity, PPV's reflect disease prevalence and is useful for risk stratification."
    },
    npv: {
        term: "Negative Predictive Value (NPV)",
        definition: "Definition for NPV"
    },
    mrs: {
        term: "Mean Risk Stratification (MRS)",
        definition: "Average change in pretest-posttest disease risk. Formula: MRS=2tp(1-p)"
    },
    sampsize: {term: "Sample Size", definition: ""},
    test: {term: "Test", definition: "empty"},
    auc: {
        term: "Area under the receiver operator characteristic curve",
        definition: " for a biomarker is the average sensitivity (or, equivalently, the integral of the sensitivity) in " +
        "the interval of cSpecificity from 0 to 1 (specificity from 1 to 0), itself equal to the area between the ROC " +
        "curve and the x-axis."
    },
    cnpv: {
        term: "Complement of Negative Predictive Value (cNPV)",
        definition: "Probability of disease, given a negative test result from biomarker. Unlike sensitivity and " +
        "specificity, cNPV's reflect disease prevalence and is useful for risk stratification."
    },
};
var lookup = {
    "Danger": "concern",
    "Reassurance": "reassurance",
    "Quality of the sensitvity": "q_sens",
    "Quality of the specificity": "q_spec",
    "Mean Risk Stratification": "mrs",
    "Maximum possible MRS": "max_mrs",
    "Population Burden Stratification": "pbs",
    "Number Needed to Recruit": "nnr",
    "Number Needed to Screen": "nns",
    "a": "a",
    "b": "b",
    "c": "c",
    "d": "d",
    "P(D+,M+)": "d_pos",
    "P(D+,M-)": "pos_d_neg_m",
    "P(D-,M+)": "neg_d_pos_m",
    "P(D-,M-)": "m_neg",
    "Marker Positivity": "prob_m",
    "Disease Prevalence": "prob_d",
    "Positive Predictive Value": "ppv",
    "complement of the Negative Predictive Value": "c_npv",
    "Sensitivity": "sens",
    "Specificity": "spec",
    "complement of the Specificity": "c_spec",
    "RR": "rr",
    "Risk Difference": "r_diff",
    "Youden": "youden",
    "Area Under the Curve": "auc",
    "Confidence Interval (lower bound)": "ci_lb",
    "Confidence Interval (upper bound)": "ci_ub",
    "Value":"value",
    "Test":"test"
};
var values_option_1_bm = [
    {"markerName": "HPV", "a": 471, "b": 13, "c": 4680, "d": 25207},
    {"markerName": "Pap", "a": 466, "b": 25, "c": 4484, "d": 25396},
    {"markerName": "VIA", "a": 270, "b": 225, "c": 2967, "d": 26909}
];

var values_option_2_bm = [{
    "markerName": "HPV",
    "ppv": 0.0914,
    "npv": 0.95,
    "prob_m": 0.1696,
    "sampsize": 30371
},
    {
        "markerName": "Pap",
        "ppv": 0.0842,
        "npv": 0.9,
        "prob_m": 0.163,
        "sampsize": 30371
    },
    {
        "markerName": "VIA",
        "ppv": 0.0834,
        "npv": 0.17,
        "prob_m": 0.1066,
        "sampsize": 30371
    }];
function setup_test() {
    $.when(reset).done(function () {
        if ($('#markers').children().length != 1) {
            reset();
        }

       
        new_marker();
        new_marker();
    });
}

function test() {
    setup_test();
   
    var choice = $(this).prop('id');

    $('#markers').children().each(function (key, markerElement) {
        var id;

        if (choice == "test1") {
           
            $(this).find('.collapse:first').addClass('in');
            $(this).find('.collapse:last').removeClass('in');

            id = $(this).find('.collapse.in').prop('id');

           
            $(markerElement).find('[name="name-input"]').val(values_option_1_bm[key].markerName);
            $('#' + id).find('#a').val(values_option_1_bm[key].a);
            $('#' + id).find('#b').val(values_option_1_bm[key].b);
            $('#' + id).find('#c').val(values_option_1_bm[key].c);
            $('#' + id).find('#d').val(values_option_1_bm[key].d);
        }

        if (choice == "test2") {
           
            $(this).find('.collapse:last').addClass('in');
            $(this).find('.collapse:first').removeClass('in');

            id = $(this).find('.collapse.in').prop('id');

            var data = [
                values_option_2_bm[0],
                values_option_2_bm[1],
                values_option_2_bm[2]
            ];
           
            $(markerElement).find('input[name="name-input"]').val(data[key].markerName);
           
            $(markerElement).find('input[name="sampsize"]').val(data[key].sampsize);

            var dataItem = data[key];

           
            $(markerElement).find('input[name="param_1"]').val(dataItem.ppv);

           
            $(markerElement).find('input[name="param_2"]').val(dataItem.npv);

           
            $(markerElement).find('input[name="param_3"]').val(dataItem.prob_m);
        }
    });
}
function validate(values) {
    var valid = true;
    var messages = [];

    $("#errors").empty();

    var $this = document.getElementsByTagName('form').markers;
    var invalidElements = $($this).find(':invalid');

    for (var item in values) {
        var marker_value_keys = Object.keys(values[item]);
       
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