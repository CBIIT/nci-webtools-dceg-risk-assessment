// keep track of the number of marker elements, to use the number as the id,
// track by value not by page element, tracking by element can be unreliable
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
    // testing
    $('a#test1,a#test2').on('click', test);

    $('#reset').on('click', reset);
    $('#add-marker').on('click', new_marker);
    $('#delete-marker').on('click', delete_marker);
    $('#calculate').on('click', calculate);

    bind_accordion_action($('#markers').children().first());
}

function bind_accordion_action(el) {
    // bind action to specific element
    //$(el).on('show.bs.collapse', function (e) {
    //    alert('Event fired on #' + e.currentTarget.id);
    //
    //     e.target.id
    //});
}

function controls_visibility(numElements) {
    // controls the visibility of the add/remove marker buttons
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

        // clone controls
        var newElement = markerTemplate.clone();

        // increment included class
        newElement.removeClass('marker-1').addClass("marker-" + counter);

        // make sure previous values don't get copied also
        newElement.find('.input,input').each(function () {
            if ($(this).is("input")) {
                $(this).val("");
            }
            if ($(this).is("select")) {
                // set to first selection in dropdown
                $(this)[0].selectedIndex = 0;
            }
        });

        // dynamically generate the id for the new panel elements
        newElement.find(".panel-heading").each(function (index) {
            var panel_id = '#marker-' + counter + '-option-' + (index + 1);

            $(this).attr('data-target', panel_id);
            $(this).attr('data-parent', '.marker-' + counter);
        });

        // generate new Ids for each on of the sub panels within the new generated marker
        newElement.find(".panel-collapse").each(function (index) {
            var newPanelContentId = 'marker-' + counter + '-option-' + (index + 1);
            $(this).attr("id", newPanelContentId);
            bind_accordion_action(this);
        });

        // change title for new marker
        newElement.find('.marker-title').text("Biomarker #" + counter);
        newElement.find('.termToDefine, .dd.termToDefine')
            .on('click', display_definition);

        currentMarkers++;
        // after currentMarkers has been updated make sure panel events
        // gets to the newly created marker
        controls_visibility(currentMarkers);

        // add new marker to #markers element
        //$('#markers').append(newElement);
        $(newElement[0]).insertAfter($('#markers').children().last());
    }
}

function delete_marker() {
    if (currentMarkers > 1) {
        // remove last child
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
    var valid = valuesObj[1]; // get the boolean value that was returned
    if (valid) {
        var input = JSON.stringify(valuesObj[0]);

        var host = window.location.hostname;
        if (host == 'localhost') {
            // call json file instead of service
            service = 'output_example.json';
        } else {
            service = "http://" + host + "/mrsRest/";
        }

        var to_value = 10 * 1000; //ten seconds

        $('#loader').show();

        // ajax call, change to actual service name
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
    // check to make sure json is in the right format
    return JSON.parse(JSON.stringify(data));
}

function return_data(data) {
    i = 0;

    // hide all again before showing
    $("#results, .bm_1, .bm_2, .bm_3").hide();

    do {
        i++;
        // propName should be bm_#
        $('.bm_' + i).show();
    } while (i != currentMarkers);

    $.each(data, function (propName, paramGroup) {
        var ci_lb, ci_ub, params, calc, marker_id;
        append_name();

        params = paramGroup.parameters;
        calc = paramGroup.calculations;
        marker_id = propName;

        // loop through appending data to table
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
            // append text to table cell
            cell = $('#' + lookup_id + '_result.' + marker_id + '.output');
            cell.attr('title', lookup_id + " " + formattedText);
            cell.text(formattedText);
        });
        // same loop but through calculations
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
        // append biomarker Name to results table header
        if ((thisNameInputElement.val()).length > 0)
            name = thisNameInputElement.val() + " (CI Low, CI High)";
        else
            name = "Biomarker " + i + " (CI Low, CI High)";

        // find the element to append the text to
        $('#results').find('table thead tr .bm_' + i).attr('title', name).text(name);
    } while (i != currentMarkers);
}

function extract_values(valid) {
    var values = {};

    // find biomarkers with values first, use currentMarkers for iteration
    i = 0;
    do {
        i++;

        values["bm_" + i] = {};
        var thisMarker = $('.marker-' + i);

        // inside this marker find inputs by group
        var option_1_controls = thisMarker.find('#marker-' + i + '-option-1 .input').serializeArray(); // option 1
        var option_2_controls = thisMarker.find('#marker-' + i + '-option-2 .input').serializeArray(); // option 2

        option_1_controls.forEach(function (element) {
            // don't add empty values to object
            if (element.value.length > 0) {
                values["bm_" + i].option = 1;
                values["bm_" + i][element.name] = element.value;
            }
        });

        // check option variable
        if (!values["bm_" + i].option) {

            // apply option flag
            values["bm_" + i].option = 2;

            var param_1 = [];
            var param_2 = [];
            var param_3 = [];
            var param_4 = [];

            option_2_controls.filter(function (obj) {
                // filter each pair into separate arrays
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
                // sample size
                values["bm_" + i][param_4[0].name] = param_4[0].value;

                var value_length = [param_1[1].value.length, param_2[1].value.length, param_3[1].value.length];

                value_length.forEach(function (el) {
                    if (el > 0) {
                        valid = false;
                        // manually mapping each value pair
                        joinObjects(values["bm_" + i], param_1[0], param_1[1]);
                        joinObjects(values["bm_" + i], param_2[0], param_2[1]);
                        joinObjects(values["bm_" + i], param_3[0], param_3[1]);
                    }
                });
            }
            //else {
            //    valid = true;
            //}
        }
    } while (i != currentMarkers);

    valid = validate(values);
    return [values, valid];
}

function joinObjects(parentObj, obj1, obj2) {
    // takes in two objects extracts the value from obj1 as
    // the new key and the value from obj2 as the new value
    parentObj[obj1.value] = obj2.value;
    return parentObj;
}

function reset() {
    // resets form to initial state
    var markerChildren = $('#markers').children();

    // reset drop downs then, text boxes, hide results, then clear the cells
    $('select').find('option:first').attr('selected', 'selected');
    $('input').val('');

    // clear all output cells
    $('.output').text('');
    $("#results, .bm_1, .bm_2, .bm_3").hide();

    // close errors if showing
    $("#errors").fadeOut();

    // remove generated markers first, .remove() doesn't remove element from DOM
    markerChildren.not(':first').each(function () {
        $(this).empty();
        $(this).remove();
    });
    currentMarkers = 1;
    controls_visibility(currentMarkers);
}