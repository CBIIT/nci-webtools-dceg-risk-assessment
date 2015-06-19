function test(option) {
    var tbs = $('.collapse.in');
    var values_option_1_bm = [{"markerName": "HPV", "a": 471, "b": 13, "c": 4680, "d": 25207},
        {"markerName": "Pap", "a": 466, "b": 25, "c": 4484, "d": 25396},
        {"markerName": "VIA", "a": 270, "b": 225, "c": 2967, "d": 26909}];

    var values_option_2_bm = [{
        "markerName": "HPV",
        "ppv": 0.0914,
        "npv": (1 - 0.0005),
        "P(M+)": 0.1696,
        "total": 30371
    },
        {
            "markerName": "Pap",
            "ppv": 0.0842,
            "npv": 0.9,
            "P(M+)": 0.163,
            "total": 30371
        }, {
            "markerName": "VIA",
            "ppv": 0.0834,
            "npv": 0.17,
            "P(M+)": 0.1066,
            "total": 30371
        }
    ];

    var choice = $(this).prop('id');
    if (currentMarkers == 1) {
        // add 2 biomarkers
        new_marker();
        new_marker();
    }
    // add only 1 biomarker
    if (currentMarkers == 2) new_marker();

    $('#markers').children().each(function (key, value) {

        var id = $(this).find('.collapse.in').prop('id');

        // open option 1 for each
        if (choice == "test1") {
            $(this).find('.collapse:first').addClass('in');
            $(this).find('.collapse:last').removeClass('in');

            // then populate with data
            if (id == "marker-1-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_1_bm[0].markerName);
                $('#' + id).find('#a').val(values_option_1_bm[0].a);
                $('#' + id).find('#b').val(values_option_1_bm[0].b);
                $('#' + id).find('#c').val(values_option_1_bm[0].c);
                $('#' + id).find('#d').val(values_option_1_bm[0].d);
            }
            if (id == "marker-2-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_1_bm[1].markerName);
                $('#' + id).find('#a').val(values_option_1_bm[1].a);
                $('#' + id).find('#b').val(values_option_1_bm[1].b);
                $('#' + id).find('#c').val(values_option_1_bm[1].c);
                $('#' + id).find('#d').val(values_option_1_bm[1].d);
            }
            if (id == "marker-3-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_1_bm[2].markerName);
                $('#' + id).find('#a').val(values_option_1_bm[2].a);
                $('#' + id).find('#b').val(values_option_1_bm[2].b);
                $('#' + id).find('#c').val(values_option_1_bm[2].c);
                $('#' + id).find('#d').val(values_option_1_bm[2].d);
            }
        }

        if (choice == "test2") {
            $(this).find('.collapse:last').addClass('in');
            $(this).find('.collapse:first').removeClass('in');


            if (id == "marker-1-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_2_bm[0].markerName);
                $('#' + id).find('[name="sampsize"]').val(values_option_2_bm[0].total);
                $('#' + id).find('#b').val(values_option_2_bm[0].b);
                $('#' + id).find('#c').val(values_option_2_bm[0].c);
                $('#' + id).find('#d').val(values_option_2_bm[0].d);
            }
            if (id == "marker-2-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_2_bm[1].markerName);
                $('#' + id).find('[name="sampsize"]').val(values_option_2_bm[1].total);
                $('#' + id).find('#a').val(values_option_2_bm[1].a);
                $('#' + id).find('#b').val(values_option_2_bm[1].b);
                $('#' + id).find('#c').val(values_option_2_bm[1].c);
                $('#' + id).find('#d').val(values_option_2_bm[1].d);
            }
            if (id == "marker-3-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_2_bm[2].markerName);
                $('#' + id).find('[name="sampsize"]').val(values_option_2_bm[2].total);
                $('#' + id).find('#a').val(values_option_2_bm[2].a);
                $('#' + id).find('#b').val(values_option_2_bm[2].b);
                $('#' + id).find('#c').val(values_option_2_bm[2].c);
                $('#' + id).find('#d').val(values_option_2_bm[2].d);
            }
        }


    });
}