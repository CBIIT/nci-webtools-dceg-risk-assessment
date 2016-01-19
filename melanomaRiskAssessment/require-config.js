requirejs.config({

    paths:{
        jquery: [ "https://code.jquery.com/jquery-1.11.3" ],
        jqueryUI: [ "https://code.jquery.com/ui/1.11.4/jquery-ui" ],
        "jquery.validate" : ["https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/jquery.validate"],
        "jquery.validate.methods" : [ "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/additional-methods" ],
        globalGlossary:"/common/js/popover-functions",
        mrat: ["mrat"],
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
            
            deps: ["jqueryUI"],
        },
        navActions: {
            deps: ["jqueryUI"],
        },
        definitions: {
            deps: ["globalGlossary"],
        },
        mrat: {
            deps: ["jquery.validate.methods"],
        }
    }
});


require(['mrat', 'definitions', 'navActions'], function() {

});
