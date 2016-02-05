requirejs.config({

    paths:{
        jquery: [ "https://code.jquery.com/jquery-1.11.3" ],
        jqueryUI: [ "https://code.jquery.com/ui/1.11.4/jquery-ui" ],
        "jquery.validate" : ["https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/jquery.validate"],
        "jquery.validate.methods" : [ "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/additional-methods" ],
        globalGlossary:"/common/js/popover-functions",
        bcrat: ["bcrat"],
        ratScript: "rat-commons/js/rat-script",
        definitions: "definitions"
    },
    shim: {
        jqueryUI: {
            deps: ["jquery"],
        },
        "jquery.validate": {
            deps: ["jquery"],
        },
        "jquery.validate.methods": {
            deps: ["jquery.validate"],
        },
        globalGlossary: {
            // define what this script depends on in order to run
            deps: ["jqueryUI"],
        },
        ratScript: {
            deps: ["jqueryUI"],
        },
        definitions: {
            deps: ["globalGlossary"],
        },
        bcrat: {
            deps: ["jquery.validate.methods", "ratScript"],
        }
    }
});

// load scripts for additional tools by defining in paths and adding to array
require(['bcrat', 'definitions'], function() {

});
