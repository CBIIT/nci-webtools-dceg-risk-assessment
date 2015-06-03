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
    $('#reset').on('click', reset);
    $('#add-marker').on('click', new_marker);
    $('#delete-marker').on('click', delete_marker);
    $('#calculate').on('click', calculate);
}

function create_popover() {
    $('.termToDefine').attr('data-toggle', 'popover');
    $('.termToDefine').attr('role', 'button');
    $('.termToDefine').attr('tabindex', '');
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

        newElement.find('.termToDefine, .dd.termToDefine').on('click', display_definition);

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
            {container: 'body', trigger: 'focus click', placement: 'top', title: term, content: definition}
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

    // find biomarkers with values first
    $('.marker div[id*="marker-"]').each(function () {
        extract_values(this);
    });

    // ajax call
    var promise = $.ajax({
        url: "test_json.json",
        //data: input,
        contentType: 'text/json'
    });

    promise.then(function (data) {
        return data;
    }, function (error) {
        console.log('Error: ' + error);
    });

    promise.done(function (data) {
        params = data.parameters;
        calc = data.calculations;
        $("#results").show();
    });
}

function extract_values(inputGroup) {
    var thisGroupId = $(inputGroup).attr('id');
    $("#" + thisGroupId + 'input, select').each(
        function () {
            var inputValue = $(this).val();
            var associatedName = $(this).attr('id');

            console.log("inputValue: " + inputValue);
            console.log("associatedName: " + associatedName);
        });
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