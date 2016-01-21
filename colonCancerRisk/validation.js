var validationRules = {
    hispanic: {
        required: true
    },
    age: {
        required: true,
        min: true,
        max: true
    },
    gender: {
        required: true
    },
    height: {
        require_from_group: [2, 'height-group']
    },
    weight: {
        required: true
    },
    veg_servings: {
        required: true
    },
    exam: {
        required: true
    },
    medications: {
        required: true
    },
    activity: {
        required: true
    },
    "family_cancer": {
        required: true
    }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
};
var validationMessages = {
    hispanic: {
        required: "You must specify whether you consider yourself Hispanic or Latino"
    },
   
   
   
    age: {
        required: "Age is required",
        min: "This calculator can only be used by people between the ages 50 and 85",
        max: "This calculator can only be used by people between the ages 50 and 85"
    },
    gender: {
        required: "Gender must be selected."
    },
    height: {
        require_from_group: "Enter both feet(ft) and inches(inch) for height"
    },
    weight: {
        required: "Weight is required"
    },
    veg_servings: {
        required: "You must specify servings of vegetables"
    },
    exam: {
        required: "You must specify whether you had a colonoscopy or sigmoidoscopy exam in the last decade"
    },
    medications: {
        required: "You must specify whether you have taken any medications in the past month"
    },
    activity: {
        required: "You must specify whether you have excercised in the past year"
    },
    "family_cancer": {
        required: "You must specify whether any relatives had colon cancer"
    },
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
};
function validate() {
    $(document.forms.survey).validate({

        debug: true,
        highlight: function(element, errorClass, validClass) {
            if(element.type != "radio") {
                $(element).addClass(errorClass).removeClass(validClass);
            }
            $(element.form).find("label[for='" + element.name + "']")
                .addClass(errorClass);
        },
        unhighlight: function(element, errorClass, validClass) {
            if(element.type != "radio") {
                $(element).removeClass(errorClass).addClass(validClass);
            }
            $(element.form).find("label[for='" + element.name + "']")
                .removeClass(errorClass);
        },

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
                    document.getElementById("top").scrollIntoView();
                }
            }).fail(function(data) {
                if(data.responseJSON.message)
                    $('#error').append("<p>"+data.responseJSON.message+"</p>").css('display','block');
                document.getElementById("top").scrollIntoView();
            });
        }
    });
}

$(validate);
