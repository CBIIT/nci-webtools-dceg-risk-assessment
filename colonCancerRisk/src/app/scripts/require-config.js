requirejs.config({
    // Wait time before using fallback script
    waitSeconds: 2,
    paths:{
        // pass array to define fallback local script location in case cdn can't be reached
        jquery: [ "https://code.jquery.com/jquery-1.11.3", "src/node_modules/jquery/dist/jquery" ],
        jqueryUI: [ "https://code.jquery.com/ui/1.11.4/jquery-ui", "src/node_modules/jquery-ui/jquery-ui" ],
        "jquery.validate" : ["https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/jquery.validate", "src/node_modules/jquery-validation/dist/jquery.validate"],
        "jquery.validate.methods" : [ "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/additional-methods", "src/node_modules/jquery-validation/dist/additional-methods" ],
        globalGlossary:"/common/js/popover-functions",
        ccrat: ["ccrat"],
        navActions: "nav-actions",
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
        navActions: {
            deps: ["jqueryUI"],
        },
        definitions: {
            deps: ["globalGlossary"],
        },
        ccrat: {
            deps: ["jquery.validate.methods"],
        }
    }
});

// load scripts for additional tools by defining in paths and adding to array
require(['ccrat', 'definitions', 'navActions'], function() {

});
