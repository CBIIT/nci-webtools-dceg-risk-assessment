var genderChangeLoaded = false;
function addClass(elementList,className) {
    for (var index = 0; index < elementList.length; index++) {
        elementList[index].className += " "+className;
    }
}
function removeClass(elementList,className) {
    for (var index = 0; index < elementList.length; index++) {
        elementList[index].className = elementList[index].className.replace(className,"").trim();
    }
}

function genderChange() {
    if (!genderChangeLoaded) {
        if( document.all && !document.getElementsByTagName ){
            document.getElementsByTagName = function( nodeName ) {
                if( nodeName == '*' ) return document.all;
                var result = [], rightName = new RegExp( nodeName, 'i' ), i;
                for( i=0; i<document.all.length; i++ )
                    if( rightName.test( document.all[i].nodeName ) )
                        result.push( document.all[i] );
                return result;
            };
        }
        if( typeof document.getElementsByClassName !== "function"){
            document.getElementsByClassName = function( className, nodeName ) {
                var result = [], tag = nodeName||'*', node, seek, i;
                if( document.evaluate ) {
                    seek = '//'+ tag +'[@class="'+ className +'"]';
                    seek = document.evaluate( seek, document, null, 0, null );
                    while( (node = seek.iterateNext()) )
                        result.push( node );
                } else {
                    var rightClass = new RegExp( '(^| )'+ className +'( |$)' );
                    seek = document.getElementsByTagName( tag );
                    for( i=0; i<seek.length; i++ )
                        if( rightClass.test( (node = seek[i]).className ) )
                            result.push( seek[i] );
                }
                return result;
            };
        }
        var lastClass = "select";
        document.getElementById('gender').onchange = function() {
            var className = this.value.toLowerCase();
            var addList;
            var removeList;
            if (lastClass !== "select") {
                removeClass(document.getElementsByClassName(lastClass),"show");
            }
            if (className !== "select") {
                addClass(document.getElementsByClassName(className),"show");
            }
            lastClass = className;
        };
        genderChangeLoaded = true;
    }
}

window.onload = genderChange();
$(genderChange());

window.onsubmit = validate();


var validationRules = {
    state: {
        required: true
    },
    county: {
        required: {
            depends: function(el) {

            }
        }
    },
    gender: {
        required: true
    },
    race: {
        required: true
    },
    age: {
        required: true
    },
    sunburn: {
        required:{
            depends: function(el) {

            }
        }
    },
    complexion: {
        required:{
            depends: function(el) {

            }
        }
    },
    tan: {
        required:{
            depends: function(el) {

            }
        }
    },
    "big-moles": {
        required:{
            depends: function(el) {

            }
        }
    },
    "small-moles": {
        required:{
            depends: function(el) {

            }
        }
    },
    freckling: {
        required:{
            depends: function(el) {

            }
        }
    },
    damage: {
        required:{
            depends: function(el) {

            }
        }
    }

};
var validationMessages = {
    state: {
        required: "State is required"
    },
    county: {
        required: "County is required"
    },
    gender: {
        required: "The patient's Gender is required"
    },
    race: {
        required: "The patient's Race is required"
    },
    age: {
        required: "The patient's Age is required"
    },
    sunburn: {
        required: "You must provide an answer to the sunburn question"
    },
    complexion: {
        required: "You must provide an answer to the complexion question"
    },
    tan: {
        required: "You must provide an answer to the tanning question"
    },
    "big-moles": {
        required: "You must answer question 'How many moles larger than 5mm in diameter are on the patient's back?'"
    },
    "small-moles": {
        required: "You must answer question 'How many moles less than or equal to 5mm in diameter are on the patient's back?'"
    },
    freckling: {
        required: "You must answer question 'How extensive is the freckling on the patient's back and shoulders?'"
    },
    damage: {
        required: "You must answer question 'Does the patient have severe solar damage on the shoulders?'"
    }

};
function validate(){
    $(document.forms.survey).validate({
        rules: validationRules,
        messages: validationMessages,
        errorPlacement: function(error, element) {
        },
        success: function(label) {
        },
        highlight: function(element, errorClass) {
        },
        submitHandler: function(form) {
            $(form).submit();
        }
    });
}
$("#state").on("change", regionFilter);

function regionFilter() {
    if(document.getElementById("state").value == "CA") {
        $("#region_subquestion").show();
    }
    else {
        $("#region_subquestion").hide();
        $("#county").val("");
    }
}
