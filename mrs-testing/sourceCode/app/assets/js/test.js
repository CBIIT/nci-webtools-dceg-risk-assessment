    var values_option_1_bm = [{"markerName": "HPV", "a": 471, "b": 13, "c": 4680, "d": 25207},
        {"markerName": "Pap", "a": 466, "b": 25, "c": 4484, "d": 25396},
        {"markerName": "VIA", "a": 270, "b": 225, "c": 2967, "d": 26909}];

    var values_option_2_bm = [{
        "markerName": "HPV",
        "ppv": 0.0914,
        "npv": (1 - 0.0005),
        "prop_m": 0.1696,
        "sampsize": 30371
    },
    {
        "markerName": "Pap",
        "ppv": 0.0842,
        "npv": 0.9,
        "prop_m": 0.163,
        "sampsize": 30371
    },
    {
        "markerName": "VIA",
        "ppv": 0.0834,
        "npv": 0.17,
        "prop_m": 0.1066,
        "sampsize": 30371
    }];
function setup_test(){
    reset();
    
    // add 2 biomarkers
    new_marker();
    new_marker();
}
function test() {    
    setup_test();

    // capture what element triggered test function
    var choice = $(this).prop('id');

    $('#markers').children().each(function (key, markerElement) {    
        var id;
        var index = key + 1;
        
        // open option 1 for each
        if (choice == "test1") {
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

            var params_1 = $('#'+ id ).find('[name=param_1]');
            var params_2 = $('#'+ id ).find('[name=param_2]');
            var params_3 = $('#'+ id ).find('[name=param_3]');
            
            
            for (var i = 0; i < values_option_2_bm.length; i++) {    
                item = values_option_2_bm[key];
                $(markerElement).find('[name="name-input"]').val(item.markerName);
                $(markerElement).find('[name="sampsize"]').val(item.sampsize);
                
                for (var property in item) {
                    value = item[property];
                    if(property != "sampsize" && property != "markerName"){
                        if(i === 0){
                            $(params_1[0]).find('option[value="'+property+'"]').attr('selected','selected');
                            $(params_1[1]).val(value);
                        }
                        if(i == 1){
                            $(params_2[0]).find('option[value="'+property+'"]').attr('selected','selected');
                            $(params_2[1]).val(value);
                        }
                        if(i == 2){
                            $(params_3[0]).find('option[value="'+property+'"]').attr('selected','selected');
                            $(params_3[1]).val(value);
                        }
                    }
                }
            }
        }
    });
}    

