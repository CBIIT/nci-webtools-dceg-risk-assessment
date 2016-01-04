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

function displayResult(result) {
  var matches = Number(result).toExponential().toString().match(/(\d+)(?:.(\d+))?e([-+]?\d+)/i);
  var estimate = matches[1];
  var outOf = 2-Number(matches[3]);
  if (matches[2] !== undefined) {
    estimate += matches[2];
    outOf += matches[2].length;
  }
  outOf = Number('1e'+outOf);
  $('#result').append('<h2>'+result+'%</h2><p>Your risk of developing cancer in the next 5 years is '+result+'%. This means that roughly '+estimate+' in '+outOf+' people like you are likely to develop cancer in the next 5 years.').removeClass('hide');
  graphResult(result);
}

function graphResult(result) {
  
}


var validationRules = {
    state: {
        required: true
    },
    county: {
        required: {
            depends: function(el) {
                return $('#state').val() == 'CA';
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
        required: {
            depends: function(el) {
                return $('#gender').val() == 'Male';
            }
        }
    },
    complexion: {
        required: true
    },
    "big-moles": {
        required: {
            depends: function(el) {
                return $('#gender').val() == 'Male';
            }
        }
    },
    "small-moles": {
        required: true
    },
    tan: {
        required: {
            depends: function(el) {
                return $('#gender').val() == 'Female';
            }
        }
    },
    freckling: {
        required: true
    },
    damage: {
        required: {
            depends: function(el) {
                return $('#gender').val() == 'Male';
            }
        }
    }
};
var validationMessages = {
    state: {
        required: "The state in which the patient resides must be selected."
    },
    county: {
        required: "The county in which the patient resides must also be selected."
    },
    gender: {
        required: "The patient's gender must be selected."
    },
    race: {
        required: "The patient's race must be selected."
    },
    age: {
        required: "The patient's age must be selected."
    },
    sunburn: {
        required: "Whether the patient has ever received a sunburn must be recorded."
    },
    complexion: {
        required: "The patient's complexion must be selected."
    },
    "big-moles": {
        required: "The number of moles greater than 5mm in diameter on the patient's back must be selected."
    },
    "small-moles": {
        required: "The number of moles less than or equal to 5mm in diameter on the patient's back must be selected."
    },
    tan: {
        required: "The level to which the patient presents a tan must be selected."
    },
    freckling: {
        required: "The extent of the freckling on the patient's back must be selected."
    },
    damage: {
        required: "Whether the patient has severe solar damage on their next and shoulders must be selected."
    }
};
function validate(){
    $(document.forms.survey).validate({
        rules: validationRules,
        messages: validationMessages,
        errorLabelContainer: '#error',
        wrapper: 'p',
        submitHandler: function(form) {
            $('#error').empty().css('display','none');
            $('#result').addClass('hide').empty();
            $('.error').removeClass('error');
            $.ajax({
              url: form.action,
              type: form.method,
              data: new FormData(form),
              processData: false,
              contentType: false,
              dataType: 'json'
            }).done(function(data) {
              if (data.success) {
                displayResult(data.message);
              } else {
                var message = "";
                if (data.message) {
                  message += "<p>" + data.message + "</p>";
                }
                var index;
                for (index in data.missing) {
                  $('#'+data.missing[index]).addClass('error');
                  message += "<p>The " + data.missing[index] + " question was not answered.</p>";
                }
                for (index in data.nonnumeric) {
                  $('#'+data.nonnumeric[index]).addClass('error');
                  message += "<p>The " + data.missing[index] + " question contained a nonnumeric answer.</p>";
                }
                $('#error').append(message).css('display','block');
              }
            }).fail(function(data) {
              $('#error').append("<p>An unknown error occurred. Please consult the administrator.</p>");
            });
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

window.onload = genderChange();
$(genderChange);
$(validate);