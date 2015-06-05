// control actions functions
var optionsText = ["option1", "option2", "option3"];

// keep track of the number of marker elements, to use the number as the id
var currentMarkers = $('#markers').children().length + 1;


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

    $('.termToDefine').attr('data-toggle', 'popover');
    $('.termToDefine').attr('role', 'button');
    $('.termToDefine').attr('tabindex', '');
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
        var markerTemplate = $('#markers .marker').first();

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
        $("#markers").append(newElement.fadeIn());
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

    // treat dropdown elements different than link/text elements
    if (!$self.hasClass('dd')) {
        var id = $self.attr('id');
    }
    else {
        // value selected in the dropdown
        var id = $($self.prev()).val();
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

        option_1_controls.forEach(function (element, index, array) {
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
            values["bm_" + i].option = 2;

            // manually mapping each value pair
            values["bm_" + i][option_2_controls[0].value] =option_2_controls[1].value;
            values["bm_" + i][option_2_controls[2].value] =option_2_controls[3].value;
            values["bm_" + i][option_2_controls[4].value] =option_2_controls[5].value;
            values["bm_" + i]["sample_size"] =option_2_controls[6].value;

        }

    } while (i != currentMarkers);

    console.log(JSON.stringify(values));
    return values;
}

function reset() {
    var currentMarkers = $('#markers').children().length;
    controls_visibility(currentMarkers);

    // remove generated markers
    $('#markers').children(':gt(0)').remove();

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
// definitions used for display
var definitionObj = {
    mPlus: {
        term: "Marker Positivity (M+)",
        definition: "Positive test result for biomarker"
    },
    mMinus: {
        term: "Marker Negativity (M-)",
        definition: "Negative test result for biomarker test"
    },
    dPlus: {
        term: "Positive Probability of Disease (Disease Positive)",
        definition: "Has disease"
    },
    dMinus: {
        term: "Negative Probability of Disease (Disease Negative)",
        definition: "Does not have disease"
    },
    danger: {
        term: "Danger",
        definition: "Increase in disease risk from testing positive"
    },
    reassurance: {
        term: "Reassurance",
        definition: "Reduction in disease risk from testing negative"
    },
    pbs: {
        term: "Population Burden Stratification",
        definition: "Extra disease detection in positive group than negative group"
    },
    nnr: {
        term: "Number Needed to Recruit",
        definition: "To detect 1 more disease case in positive group than negative group"
    },
    maxMRS: {
        term: "Maximum possible MRS for a disease with this prevalence",
        definition: "Maximum possible MRS for a disease with this prevalence"
    },
    qSpec: {
        term: "Quality of the specificity",
        definition: "Increase in specificity versus a random test, fixing test positivity"
    },
    qSens: {
        term: "Quality of the sensitivity",
        definition: "Increase in sensitivity versus a random test, fixing test positivity"
    },
    spec: {
        term: "Specificity",
        definition: "Specificity is the proportion whose biomarker test is negative (below the threshold) among" +
        " those without disease."
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
    }
};