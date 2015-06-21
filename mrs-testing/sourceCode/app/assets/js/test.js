function test(option) {
    var choice = $(this).prop('id');
    
    var values_option_1_bm = [{"markerName": "HPV", "a": 471, "b": 13, "c": 4680, "d": 25207},
        {"markerName": "Pap", "a": 466, "b": 25, "c": 4484, "d": 25396},
        {"markerName": "VIA", "a": 270, "b": 225, "c": 2967, "d": 26909}];

    var values_option_2_bm = [{
        "markerName": "HPV",
        "ppv": 0.0914,
        "npv": (1 - 0.0005),
        "prop_m": 0.1696,
        "total": 30371
    },
    {
        "markerName": "Pap",
        "ppv": 0.0842,
        "npv": 0.9,
        "prop_m": 0.163,
        "total": 30371
    },
    {
        "markerName": "VIA",
        "ppv": 0.0834,
        "npv": 0.17,
        "prop_m": 0.1066,
        "total": 30371
    }];

    reset();    
    // add 2 biomarkers
    new_marker();
    new_marker();
    
    $('#markers').children().each(populate_all);
    
    function populate_all (key, value) {
        
        var id = $(this).find('.collapse.in').prop('id');
        
        var index = key+1;
        
        // open option 1 for each
        if (choice == "test1") {
            $(this).find('.collapse:first').addClass('in');
            $(this).find('.collapse:last').removeClass('in');

            // then populate with data
            if (id == "marker-"+index+"-panel-1") {
                $(value).find('[name="name-input"]').val(values_option_1_bm[key].markerName);
                $('#' + id).find('#a').val(values_option_1_bm[key].a);
                $('#' + id).find('#b').val(values_option_1_bm[key].b);
                $('#' + id).find('#c').val(values_option_1_bm[key].c);
                $('#' + id).find('#d').val(values_option_1_bm[key].d);
            }
        }

        if (choice == "test2") {
            $(this).find('.collapse:last').addClass('in');
            $(this).find('.collapse:first').removeClass('in');

            if (id == "marker-"+index+"-panel-2") {
                                
                $('#' + id).find('[name="sampsize"]').val(values_option_2_bm[key].total);
                for (var i = 0; i != values_option_2_bm.length; i++) {
                    element = values_option_2_bm[i];                   
                        for (var item in element) { 
                            if(item == "markerName") $(value).find('[name="name-input"]').val(values_option_2_bm[key][item]); 
                            else {
                                dd_index = $('#' + id).find("option[name='param_"+i+"', value='"+item+"']").index();
                                // dropdown
                                $('#' + id).find('[name="param_'+(i+1)+'"]')[0].selectedIndex = dd_index;
                                // textbox
                                $('#' + id).find('[name="param_'+(i+1)+'"]')[1].val(element[item]);
                            }
                    }
                }
            }
        }
    }
}