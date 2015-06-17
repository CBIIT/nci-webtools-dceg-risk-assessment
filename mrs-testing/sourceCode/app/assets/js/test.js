function test() {
    var tbs = $('.collapse.in');
    var values_option_1_bm = [{"markerName": "HPV", "a": 471, "b": 13, "c": 4680, "d": 25207},
        {"markerName": "Pap", "a": 466, "b": 25, "c": 4484, "d": 25396},
        {"markerName": "VIA", "a": 270, "b": 225, "c": 2967, "d": 26909}];

    var values_option_2 = {"ppv": 0.0914, "npv": (1 - 0.0005), "P(M+)": 0.1696, "total": 30371};

    $('#markers').children().each(function (key, value) {

        if ($(this).find('.collapse.in')) {
            id = $(this).find('.collapse.in').prop('id');
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

    });
}