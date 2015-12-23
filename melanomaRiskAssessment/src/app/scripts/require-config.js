requirejs.config({
    // Wait time before using fallback script
    waitSeconds: 2,
    paths:{
        // pass array to define fallback local script location in case cdn can't be reached
        jquery: ["https://code.jquery.com/jquery-1.11.3", "src/node_modules/jquery/dist/jquery"],
        jqueryUI: ["https://code.jquery.com/ui/1.11.4/jquery-ui", "src/node_modules/jquery-ui/jquery-ui"],
        globalGlossary:"/common/js/popover-functions",
        mrat: ["mrat"],
        navActions: "nav-actions",
        definitions: "definitions"
    },
    shim: {
        jqueryUI: {
            deps: ["jquery"],
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
        }
    }
});

// load scripts for additional tools by defining in paths and adding to array
require(['mrat', 'definitions', 'navActions'], function() {

});