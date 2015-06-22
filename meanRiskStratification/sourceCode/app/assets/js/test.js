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

        // add 2 biomarkers
        new_marker();
        new_marker();
    });
}

function test() {
    setup_test();
    // capture what element triggered test function
    var choice = $(this).prop('id');

    $('#markers').children().each(function (key, markerElement) {
        var id;

        if (choice == "test1") {
            // open option 1 for each
            $(this).find('.collapse:first').addClass('in');
            $(this).find('.collapse:last').removeClass('in');

            id = $(this).find('.collapse.in').prop('id');

            // then populate with data
            $(markerElement).find('[name="name-input"]').val(values_option_1_bm[key].markerName);
            $('#' + id).find('#a').val(values_option_1_bm[key].a);
            $('#' + id).find('#b').val(values_option_1_bm[key].b);
            $('#' + id).find('#c').val(values_option_1_bm[key].c);
            $('#' + id).find('#d').val(values_option_1_bm[key].d);
        }

        if (choice == "test2") {
            // collapse all option 1 panels and expand all option 2 panels
            $(this).find('.collapse:last').addClass('in');
            $(this).find('.collapse:first').removeClass('in');

            id = $(this).find('.collapse.in').prop('id');

            var data = [
                values_option_2_bm[0],
                values_option_2_bm[1],
                values_option_2_bm[2]
            ];
            // marker name
            $(markerElement).find('input[name="name-input"]').val(data[key].markerName);
            // sample size
            $(markerElement).find('input[name="sampsize"]').val(data[key].sampsize);

            var dataItem = data[key];

            //first row
            $(markerElement).find('input[name="param_1"]').val(dataItem.ppv);

            // second row
            $(markerElement).find('input[name="param_2"]').val(dataItem.npv);

            // third row
            $(markerElement).find('input[name="param_3"]').val(dataItem.prob_m);
        }
    });
}