// var genderChangeLoaded = false;
// function addClass(elementList,className) {
//     for (var index = 0; index < elementList.length; index++) {
//         elementList[index].className += " "+className;
//     }
// }
// function removeClass(elementList,className) {
//     for (var index = 0; index < elementList.length; index++) {
//         elementList[index].className = elementList[index].className.replace(className,"").trim();
//     }
// }
// function genderChange() {
//     if (!genderChangeLoaded) {
//         if( document.all && !document.getElementsByTagName ){
//             document.getElementsByTagName = function( nodeName ) {
//                 if( nodeName == '*' ) return document.all;
//                 var result = [], rightName = new RegExp( nodeName, 'i' ), i;
//                 for( i=0; i<document.all.length; i++ )
//                     if( rightName.test( document.all[i].nodeName ) )
//                         result.push( document.all[i] );
//                 return result;
//             };
//         }
//         if( typeof document.getElementsByClassName !== "function"){
//             document.getElementsByClassName = function( className, nodeName ) {
//                 var result = [], tag = nodeName||'*', node, seek, i;
//                 if( document.evaluate ) {
//                     seek = '//'+ tag +'[@class="'+ className +'"]';
//                     seek = document.evaluate( seek, document, null, 0, null );
//                     while( (node = seek.iterateNext()) )
//                         result.push( node );
//                 } else {
//                     var rightClass = new RegExp( '(^| )'+ className +'( |$)' );
//                     seek = document.getElementsByTagName( tag );
//                     for( i=0; i<seek.length; i++ )
//                         if( rightClass.test( (node = seek[i]).className ) )
//                             result.push( seek[i] );
//                 }
//                 return result;
//             };
//         }
//         var lastClass = "select";
//         document.getElementById('gender').onchange = function() {
//             var className = this.value.toLowerCase();
//             var addList;
//             var removeList;
//             if (lastClass !== "select") {
//                 removeClass(document.getElementsByClassName(lastClass),"show");
//             }
//             if (className !== "select") {
//                 addClass(document.getElementsByClassName(className),"show");
//             }
//             lastClass = className;
//         };
//         genderChangeLoaded = true;
//     }
// }

// var validationRules = {
//     state: {
//         required: true
//     },
//     county: {
//         required: {
//             depends: function(el) {
//                 return $('#state').val() == 'CA';
//             }
//         }
//     },
//     gender: {
//         required: true
//     },
//     race: {
//         required: true
//     },
//     age: {
//         required: true
//     },
//     sunburn: {
//         required: {
//             depends: function(el) {
//                 return $('#gender').val() == 'Male';
//             }
//         }
//     },
//     complexion: {
//         required: true
//     },
//     "big-moles": {
//         required: {
//             depends: function(el) {
//                 return $('#gender').val() == 'Male';
//             }
//         }
//     },
//     "small-moles": {
//         required: true
//     },
//     tan: {
//         required: {
//             depends: function(el) {
//                 return $('#gender').val() == 'Female';
//             }
//         }
//     },
//     freckling: {
//         required: true
//     },
//     damage: {
//         required: {
//             depends: function(el) {
//                 return $('#gender').val() == 'Male';
//             }
//         }
//     }
// };
// var validationMessages = {
//     state: {
//         required: "The state in which the patient resides must be selected."
//     },
//     county: {
//         required: "The county in which the patient resides must also be selected."
//     },
//     gender: {
//         required: "The patient's gender must be selected."
//     },
//     race: {
//         required: "The patient's race must be selected."
//     },
//     age: {
//         required: "The patient's age must be selected."
//     },
//     sunburn: {
//         required: "Whether the patient has ever received a sunburn must be recorded."
//     },
//     complexion: {
//         required: "The patient's complexion must be selected."
//     },
//     "big-moles": {
//         required: "The number of moles greater than 5mm in diameter on the patient's back must be selected."
//     },
//     "small-moles": {
//         required: "The number of moles less than or equal to 5mm in diameter on the patient's back must be selected."
//     },
//     tan: {
//         required: "The level to which the patient presents a tan must be selected."
//     },
//     freckling: {
//         required: "The extent of the freckling on the patient's back must be selected."
//     },
//     damage: {
//         required: "Whether the patient has severe solar damage on their next and shoulders must be selected."
//     }
// };

// function validate(){
//     $(document.forms.survey).validate({
//         rules: validationRules,
//         messages: validationMessages,
//         errorLabelContainer: '#error',
//         wrapper: 'p',
//         submitHandler: processSubmission
//     });
// }
// $("#state").on("change", regionFilter);

// function regionFilter() {
//     if(document.getElementById("state").value == "CA") {
//         $(".counties").show();
//     }
//     else {
//         $(".counties").hide();
//         $("#county").val("");
//     }
// }

// window.onload = genderChange();
// $(genderChange);
// $(validate);

// $("#reset").on("click", function(){
//     $(survey).validate().resetForm();
//     $(".show").removeClass("show");
// });


// $(function(){
//     var titles = {
//         "risk-calculator": "Risk Calculator",
//         "about": "About",
//         "cancer-risk": "Melanoma Risk Factors",
//         "source-code": "Access Source Code"
//     };

//     $('.goTo').on('click', function() {
//         $("html, body").animate({
//             scrollTop: $(this.name).offset().top - $("header")[0].clientHeight
//         }, 1000);
//     });

//     $('#content').on('click','[tabTo]',function(e) {
//         document.title  =  "Melanoma Risk Assessment Tool (MRAT) | " + titles[$(this).attr('tabTo')];
//     });
// });
