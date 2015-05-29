// control actions functions
var optionsText = ["option1", "option2", "option3"];

// keep track of the number of marker elements, to use the number as the id
var currentMarkers = $('#markers').children().length + 1;

$(document).ready(function () {
    controls_visibility(currentMarkers);
    $('#reset').on('click', reset);
    $('#add-marker').on('click', new_marker);
    $('#delete-marker').on('click', delete_marker);
    $('.definition')
        .on('click', display_definition)
        .on('hover', display_definition);
});

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

        // increment included class
        markerTemplate.last().removeClass('marker-1').addClass("marker-" + counter);

        // clone controls
        var newElement = markerTemplate.clone();

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

        // add new marker to #markers element
        $("#markers").append(newElement.fadeIn());
        currentMarkers++;
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

function display_definition(element) {
    var id = element.attr('id');
    var definition = definitions[id];
    return definition;
}

function reset() {
    $('#markers').children(':gt(0)').remove();
    // reset drop downs then, text boxes
    $('select').find('option:first').attr('selected', 'selected');
    $('input').val('');
}