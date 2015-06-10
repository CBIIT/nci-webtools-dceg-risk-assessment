<<<<<<< HEAD
var marker_base = $('#markers');
=======
// control actions functions
var optionsText = ["option1", "option2", "option3"];
>>>>>>> 0a4aadb7a519de702431db92b6ad267cd86a90c4

// keep track of the number of marker elements, to use the number as the id
var currentMarkers = marker_base.children().length + 1;


$(document).ready(function () {
    $("#results").hide();
    controls_visibility(currentMarkers);
    bind_control_events();
    create_popover();

    $('.termToDefine, .dd.termToDefine').on('click', display_definition);
});

function bind_control_events() {
    // testing
    $('<button class="btn btn-sm btn-sucess" id="test">TEST</button>').appendTo('#control-group');
    $('button#test').on('click', test);

    $('#reset').on('click', reset);
    $('#add-marker').on('click', new_marker);
    $('#delete-marker').on('click', delete_marker);
    $('#calculate').on('click', calculate);
}

function create_popover() {
    panel_actions();
    var term_element = $('.termToDefine');
    term_element.attr('data-toggle', 'popover');
    term_element.attr('role', 'button');
    term_element.attr('tabindex', '');
}

function panel_actions() {
    // make sure only one panel can open at a time in a group
    $('.panel-collapse').on('show.bs.collapse', function () {
        $('.panel-collapse').not(document.getElementById($(this).attr('id')))
            .removeClass('in')
            .addClass('collapse');
    });
}
function controls_visibility(numElements) {
    if (numElements == 2) {
        $('#delete-marker').show();
        $('#add-marker').show();
    }
    else if (numElements > 2) {
        $('#delete-marker').show();
        $('#add-marker').hide();
    }
    else {
        $('#delete-marker').hide();
        $('#add-marker').show();
    }
}

function new_marker() {
    var counter = currentMarkers + 1;
    if (currentMarkers < 3) {
        var markerTemplate = marker_base.find('.marker').first();

        // clone controls
        var newElement = markerTemplate.clone();

        // increment included class
        newElement.removeClass('marker-1').addClass("marker-" + counter);

        // make sure previous values don't get copied also
        newElement.find('.input').each(function () {
            if ($(this).is("input")) {
                $(this).val("");
            }
            if ($(this).is("select")) {
                $(this)[0].selectedIndex = 0;
            }
        });

        // dynamically generate the id for the new panel elements
        newElement.find(".panel-title a").each(function (index) {
            $(this).attr('href', '#marker-' + counter + '-panel-' + (index + 1));
        });

        // generate new Ids for each on of the sub panels within the new generated marker
        newElement.find(".panel-collapse").each(function (index) {
            var newPanelContentId = 'marker-' + counter + '-panel-' + (index + 1);
            $(this).attr("id", newPanelContentId).addClass("collapse");
        });

        newElement.find('.marker-title').text("Biomarker #" + counter);
        newElement.find(".panel-toggle").each(function (index) {
            $(this).attr("href", "#marker-" + counter + "-panel-" + (index + 1));
        });

        newElement.find('.termToDefine, .dd.termToDefine').on('click', display_definition);

        // add new marker to #markers element
        marker_base.append(newElement.fadeIn());
        currentMarkers++;

        panel_actions();
        controls_visibility(currentMarkers);
    }
}

function delete_marker() {
    if (currentMarkers > 1) {
        // remove last child
        $('#markers').children().last().remove();
    }
    currentMarkers--;
    controls_visibility(currentMarkers);
}

function display_definition() {
    // used to identify a specific element, since there will be multiple popover elements on the page
    var $self = $(this);
    var id;
    // treat drop down elements different than link/text elements
    if (!$self.hasClass('dd')) {
        id = $self.attr('id');
    }
    else {
        // value selected in the drop down
        id = $self.prev().val();
    }

    var definition = definitionObj[id].definition;
    var term = definitionObj[id].term;

    if (definition || term) {
        $self.popover(
            {container: 'body', trigger: 'click', placement: 'top', title: term, content: definition}
        );
    }
    $self.popover();
    $self.popover('show');

    setTimeout(function () {
        $self.popover('hide');
        $self.popover('destroy');
    }, 5000);
}

function calculate() {
<<<<<<< HEAD
    var service;

    var valuesObj = extract_values(false);
    var invalid = valuesObj[1];
    if (!invalid) {
        var input = JSON.stringify(valuesObj[0]);

        var host = window.location.hostname;
        service = "http://" + host + "/mrsRest/";

        // call json file instead of service
        //service = 'test_json.json';

        // ajax call, change to actual service name
        var promise = $.ajax({
            dataType: 'json',
            method: 'POST',
            contentType: 'application/json',
            url: service,
            data: input
        });

        promise.then(clean_data, function (error) {
            console.log('Error: ' + JSON.stringify(error));
        });

        promise.done(return_data);

        $("#results").show();
    }
    else {
        // show error message somewhere
        if (!$("#errors")[0]) {
            $('h1.title').after($("<div><b class='text-danger'>Must enter values for either option 1 or 2 for the biomarkers</b></div>")
                .attr('id', 'errors')
                .addClass('well-sm'));
            setTimeout(function () {
                $('#errors').fadeOut().remove();
            }, 4000);
        }
    }
}

function clean_data(data) {
    return data;
}

function return_data(data) {
    params = data.parameters;
    calc = data.calculations;
    var prop_array = Object.getOwnPropertyNames(params);
    // loop through appending data to table
    $.each(params, function (name, obj) {
        var lookup_id = lookup[name];
        var data_item = params[name];

        var formattedText = data_item["Value"] + "%";
        if (data_item["Confidence Interval (lower bound)"] != null && data_item["Confidence Interval (upper bound)"] != null) {
            formattedText += " (" + data_item["Confidence Interval (lower bound)"] + "%, "
                + data_item["Confidence Interval (upper bound)"] + "%)";
        }

        var text = $('<b></b>');
        text.attr('title', lookup_id + " " + formattedText);
        text.text(formattedText);
        $('#' + lookup_id + '_result.output').html(text);
    });
    $.each(calc, function (name, obj) {
        var lookup_id = lookup[name];
        var data_item = calc[name];

        var formattedText = data_item["Value"] + "%";
        if (data_item["Confidence Interval (lower bound)"] != null && data_item["Confidence Interval (upper bound)"] != null) {
            formattedText += " (" + data_item["Confidence Interval (lower bound)"] + "%, "
                + data_item["Confidence Interval (upper bound)"] + "%)";
        }

        var text = $('<b></b>');
        text.attr('title', lookup_id + " " + formattedText);
        text.text(formattedText);
        $('#' + lookup_id + '_result.output').html(text);
    });
    $("#results").show();
}

function append_name() {
    i = 1;
    do {
        var thisNameInputElement = $('.marker-' + i + ' #name-input');
        // append biomarker Name to results table header
        if (thisNameInputElement.val().length > 0)
            var name = thisNameInputElement.val();
        else
            name = "Biomarker " + i;

        $('#results').find('table thead tr:first-child')
            .append('<th title="' + name + '" class="active markerName">' + name + '</th>');
    } while (i != currentMarkers);
}

function extract_values(invalid) {
=======
    var params, calc;
    var input = extract_values();
    var host = window.location.hostname;

    if (host == 'localhost') service = 'ncias-d1207-v.nci.nih.gov:8080/meanstoriskRest/';
    else {
        var service = "http://" + host + "/mrsRest";
    }

    // ajax call, change to actual service name
    var promise = $.ajax({
        method: 'POST',
        contentType: 'text/json',
        url: service,
        data: input
    });

    promise.then(function (data) {
        // clean before return

        return data;
    }, function (error) {
        console.log('Error: ' + error);
    });

    promise.done(function (data) {
        params = data.parameters;
        $.each(data, function (name, obj) {
            $.each(obj, function (id, val) {
                $('#' + id + '.output').html(val);
            });
        });

        calc = data.calculations;
        $("#results").show();
    });
}

function extract_values() {
>>>>>>> 0a4aadb7a519de702431db92b6ad267cd86a90c4
    var values = {};
    // find biomarkers with values first, use currentMarkers for iteration
    i = 0;
    do {
        i++;
        values["bm_" + i] = {};
        var thisMarker = $('.marker-' + i);

        // inside this marker find inputs by group
        var option_1_controls = thisMarker.find('#marker-' + i + '-panel-1 .input').serializeArray(); // option 1
        var option_2_controls = thisMarker.find('#marker-' + i + '-panel-2 .input').serializeArray(); // option 2

        option_1_controls.forEach(function (element) {
            if (element.value.length > 0) {
                values["bm_" + i][element.name] = element.value;

                // set option value if there is none
                if (!values["bm_" + i].option) {
                    values["bm_" + i].option = 1;
                }
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

                if (obj.name == "param_1") {
                    param_1.push(obj);
                }
                if (obj.name == "param_2") {
                    param_2.push(obj);
                }
                if (obj.name == "param_3") {
                    param_3.push(obj);
                }
                if (obj.name == "sampsize") {
                    param_4.push(obj);
                }

            });
            var value_length = [param_1[1].value.length, param_2[1].value.length, param_3[1].value.length];
            value_length.forEach(function (el, ind, arr) {
                if (el > 0) {
                    invalid = false;
                    // manually mapping each value pair
                    values["bm_" + i][param_1[0].value] = param_1[1].value;
                    values["bm_" + i][param_2[0].value] = param_2[1].value;
                    values["bm_" + i][param_3[0].value] = param_3[1].value;
                }
                else {
                    invalid = true;
                }
            });
            // sample size
            values["bm_" + i][param_4[0].name] = param_4[0].value;
        }
    } while (i != currentMarkers);

    return [values, invalid];
}

function reset() {
    var currentMarkers = marker_base.children().length;
    controls_visibility(currentMarkers);

    // remove generated markers
    marker_base.children(':gt(0)').remove();

    // reset drop downs then, text boxes
    $('select').find('option:first').attr('selected', 'selected');
    $('input').val('');
}

function test() {
    var tbs = $('input.input');
    var dds = $('select.input');
    for (var i = 0; i != tbs.length; i++) {
        // random value between 0 and 300
        var randomValue = Math.random() * (300 - 1) + 1;
        tbs[i].value = randomValue;
    }

    for (var j = 0; j != dds.length; j++) {
        var randomIndex = Math.floor(Math.random() * dds[j].length);
        dds[j].selectedIndex = randomIndex;
    }
}