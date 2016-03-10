requirejs.config({
    paths:{
        jquery: "https://code.jquery.com/jquery-1.11.3",
        jqueryUI: "https://code.jquery.com/ui/1.11.4/jquery-ui",
        "jquery.validate" : "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/jquery.validate" ,
        "jquery.validate.methods" : "https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.14.0/additional-methods" ,
        globalGlossary:"/common/js/popover-functions",
        ccrat: "ccrat",
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
           
            deps: ["jqueryUI"],
        },
        ratScript: {
            deps: ["jqueryUI"],
        },
        definitions: {
            deps: ["globalGlossary"],
        },
        validation: {
            deps: ["jquery.validate.methods", "ratScript"],
        },
        ccrat:{
            deps: ["validation"]
        }
    }
});


require(['ccrat', 'definitions'], function() {

});
