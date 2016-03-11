$.validator.addMethod("lessThan", function(value,element,params) {
  var compareTo = params;
  var allowEqual = false;
  if (typeof params === 'object') {
    compareTo = $(params.element).val();
    allowEqual = params.allowEqual===undefined?false:params.allowEqual;
  }
  value = Number(value);
  compareTo = Number(compareTo);
  if (allowEqual) {
    return value <= compareTo;
  } else {
    return value < compareTo;
  }
});
$.validator.addMethod("greaterThan", function(value,element,params) {
  var compareTo = params;
  var allowEqual = false;
  if (typeof params === 'object') {
    compareTo = $(params.element).val();
    allowEqual = params.allowEqual===undefined?false:params.allowEqual;
  }
  value = Number(value);
  compareTo = Number(compareTo);
  if (allowEqual) {
    return value >= compareTo;
  } else {
    return value > compareTo;
  }
});

var validationRules = {
    race: {
        required: true
    },
    age: {
        required: true,
        min: 50,
        max: 85
    },
    gender: {
        required: true
    },
    height_feet: {
        required: true,
        max: 9
    },
    weight: {
        required: true,
        min: 50,
        max: 700
    },
    veg_servings: {
        required: true
    },
    exam: {
        required: true
    },
    polyp: {
        required: {
            depends: function (el) {
                return $("[name='exam']").val() == "0";
            }
        }
    },
    aspirin: {
        required: true
    },
    non_aspirin: {
        required: true
    },
    moderate_months: {
        required: true
    },
    moderate_hours: {
        required: {
            depends: function (el) {
                return $("[name='moderate_months']").val() > 0;
            }
        }
    },
    vigorous_months: {
        required: true
    },
    vigorous_hours: {
        required: {
            depends: function (el) {
                return $("[name='vigorous_months']").val() > 0;
            }
        }
    },
    "family_cancer": {
        required: true
    },
    family_count: {
        required: {
            depends: function (el) {
                return $("[name='family_cancer']").val() == "1";
            }
        }
    },
    veg_amount: {
        required: {
            depends: function (el) {
                return $("[name='veg_servings']").val() > 0;
            }
        }
    },
    cigarettes: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male";
            }
        }
    },
    smoke_age: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0";
            }
        },
        lessThan: { "element": "[name='age']", "allowEqual": true }
    },
    cigarettes_num: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0" && $("#smoke_age").val() > 0;
            }
        }
    },
    smoke_now: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0" && $("#smoke_age").val() > 0;
            }
        }
    },
    smoke_quit: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0" && $("#smoke_age").val() > 0 && $("[name='smoke_now']:checked").val() == "0";
            }
        },
        lessThan: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0" && $("#smoke_age").val() > 0 && $("[name='smoke_now']:checked").val() == "0";
            },
            param: { "element": "[name='age']", "allowEqual": true }
        },
        greaterThan: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Male" && $("#cigarettes").val() === "0" && $("#smoke_age").val() > 0 && $("[name='smoke_now']:checked").val() == "0";
            },
            param: { "element": "[name='smoke_age']", "allowEqual": true }
        }
    },
    period: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Female";
            }
        }
    },
    last_period: {
        required: {
            depends: function (el) {
                return $("[name='period']:checked").val() == '1';
            }
        }
    },
    hormones: {
        required: {
            depends: function (el) {
                return $("[name='last_period']").val() == '2';
            }
        }
    }
};
var validationMessages = {
    race: {
        required: "Your race must be selected"
    },
    age: {
        required: "Age is required",
        min: "This calculator can only be used by people between the ages 50 and 85",
        max: "This calculator can only be used by people between the ages 50 and 85"
    },
    gender: {
        required: "Gender must be selected"
    },
    height_feet: {
        required: "Enter height in feet and inches"
    },
    weight: {
        required: "Weight is required",
        min: "Weight must be greater than 50"
    },
    veg_servings: {
        required: "You must specify how many servings of vegetables you had in the past month"
    },
    veg_amount: {
        required: "You must specify the serving size of the vegetables"
    },
    exam: {
        required: "You must specify whether you had a colonoscopy or sigmoidoscopy exam in the last decade"
    },
    polyp: {
        required: "You must specify whther polyps were found during the exam"
    },
    aspirin: {
        required: "You must specify whether you have taken any medications containing asprin in the past month"
    },
    non_aspirin: {
        required: "You must specify whether you have taken any medications not containing asprin in the past month"
    },
    moderate_months: {
        required: "You must specify how many months you have participated in moderate exercise"
    },
    vigorous_months: {
        required: "You must specify how many months you have participated in vigorous exercise"
    },
    "family_cancer": {
        required: "You must specify whether any relatives had colorectal cancer"
    },
    "family_count": {
        required: "You must specify how many relatives had colorectal cancer"
    },
    cigarettes: {
        required: "You must specify whether you have smoked cigarettes"
    },
    cigarettes_num: {
        required: "You must specify the amount of cigarettes you have smoked regularly"
    },
    "smoke_age": {
        required: "You must specify the age you began smoking",
        lessThan: "Cigarette smoking \"start age\" cannot be greater than ACTUAL age. Please select an appropriate age."
    },
    "smoke_now": {
        required: "You must specify whether you currently smoke",
    },
    smoke_quit: {
        required: "You must specify the age at which you last quit smoking",
        lessThan: "Smoking cigarettes \"quit age\" cannot be greater than the ACTUAL age. Please select an appropriate age.",
        greaterThan: "Smoking cigarettes \"quit age\" cannot be less than the smoking cigarettes \"start age\". Please select an appropriate age."
    },
    period: {
        required: "You must specify whether you still have periods"
    },
    last_period: {
        required: "You must specify when you had your last period"
    },
    hormones: {
        required: "You must specify whether you are taking any female hormones"
    }
};

function validate() {
    $(document.forms.survey).validate({
        ignoreTitle: true,
        ignore: ".ignore",
        highlight: highlightErrorElement,
        unhighlight: removeHighlightErrorElement,
        rules: validationRules,
        messages: validationMessages,
        errorLabelContainer: '#error',
        wrapper: 'p',
        submitHandler: processSubmission
    });
}

$(validate);
