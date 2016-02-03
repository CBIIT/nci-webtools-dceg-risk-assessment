    $.validator.addMethod("invalidOption", function (value, element, params) {
        return value != params;
    });

var validationRules = {
    history: {
        required: true,
        invalidOption: 0
    },
    mutation: {
        required: true,
        invalidOption: 0
    },
    age: {
        required: true,
        min: 35,
    },
    race: {
        required: true
    },
    sub_race: {
        required: {
            depends: function () {
                return Number($("#race").val()) === 3;
            }
        }
    },
    age_period: {
        required: true
    },
    childbirth: {
        required: true
    },

    childbirth_age: {
        required: {
            depends: function () {
                return Number($("#childbirth").val()) === 0;
            }
        }
    },

    relatives: {
        required: true
    },
    biopsy: {
        required: true
    },

    biopsy_result: {
        required: {
            depends: function () {
                return Number($("#biopsy").val()) === 0;
            }
        }
    },

    biopsy_ah: {
        required: {
            depends: function () {
                return Number($("#biopsy").val()) === 0;
            }
        }
    },
};

var validationMessages = {
    history: {
        required: "You must answer the history of DCIS or LCIS question",
        invalidOption: "This tool cannot calculate breast cancer risk accurately for women with a medical history of any breast cancer or of DCIS or LCIS. See the 'About' page for more information."
    },
    mutation: {
        required: "You must answer the (BCRA gene / genetic mutation) question",
        invalidOption: 'Other tools may be more appropriate for women with known mutations in either the BRCA1 or BRCA2 gene, or other hereditary syndromes associated with higher risk of breast cancer. See the \"About\" page for more information.'
    },
    age: {
        required: "The woman's age is required",
        min: "This tool only calculates breast cancer risk for women that are 35 or older"
    },
    race: {
        required: "You must select the woman's race"
    },
    sub_race: {
        required: "You must select the woman's sub race"
    },

    age_period: {
        required: "You must enter the woman's age when she first had her period"
    },

    childbirth: {
        required: "You must select whether the woman has ever given birth"
    },

    childbirth_age: {
        required: "You must enter the age of woman when she first gave birth"
    },

    relatives: {
        required: "You must select whether the woman's immediate relatives ever had breast cancer"
    },

    biopsy: {
        required: "You must select whether the woman ever had a breast biopsy"
    },

    biopsy_result: {
        required: "You must select how many breast biopsies the woman had"
    },

    biopsy_ah: {
        required: "You must select whether any biopsies had atypical hyperplasia"
    },

};

function validate() {
    $(document.forms.survey).validate({
        highlight: function (element, errorClass, validClass) {
            if (element.type != "radio") {
                $(element).addClass(errorClass).removeClass(validClass);
            }
            $(element.form).find("label[for='" + element.name + "']")
                .addClass(errorClass);
        },
        unhighlight: function (element, errorClass, validClass) {
            if (element.type != "radio") {
                $(element).removeClass(errorClass).addClass(validClass);
            }
            $(element.form).find("label[for='" + element.name + "']")
                .removeClass(errorClass);
        },
        rules: validationRules,
        messages: validationMessages,
        errorLabelContainer: '#error',
        wrapper: 'p',
        submitHandler: function (form) {
            $('#error').empty().css('display', 'none');
            $('#result').addClass('hide').empty();
            $('.error').removeClass('error');
            $.ajax({
                url: form.action,
                type: form.method,
                data: new FormData(form),
                processData: false,
                contentType: false,
                dataType: 'json'
            }).done(function (data) {
                if (data.success) {
                    displayResult(data.message);
                } else {
                    var message = "";
                    if (data.message) {
                        message += "<p>" + data.message + "</p>";
                    }
                    var index;
                    for (index in data.missing) {
                        $('#' + data.missing[index]).addClass('error');
                        message += "<p>The " + data.missing[index] + " question was not answered.</p>";
                    }
                    for (index in data.nonnumeric) {
                        $('#' + data.nonnumeric[index]).addClass('error');
                        message += "<p>The " + data.missing[index] + " question contained a nonnumeric answer.</p>";
                    }
                    $('#error').append(message).css('display', 'block');
                    document.getElementById("top").scrollIntoView();
                }
            }).fail(function (data) {
                //                $('#error').append("<p>An unknown error occurred. Please consult the administrator.</p>");
                if (data.responseJSON.message)
                    $('#error').append("<p>" + data.responseJSON.message + "</p>").css('display', 'block');
                document.getElementById("top").scrollIntoView();
            });
        }
    });
}

$(validate);

$(".thumbnail").on("click", function () {
    $(this).toggleClass(function () {
        if ($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
});
$("[name='race']").on("change", function () {
    if (Number(this.value) == 3) {
        var aa_subraces = "<option value=''>Select</option><option value='0'>Chinese</option><option value='1'>Japanese</option><option value='2'>Filipino</option><option value='3'>Hawiian</option><option value='4'>Other Pacific Islander</option><option value='5'>Other Asian American</option>";
        $("#subquestion-race").addClass("show");
        $("select#sub_race").empty().append(aa_subraces);
    } else
        $("#subquestion-race").removeClass("show");
});

$("[name='childbirth']").on("change", function () {
    if (Number(this.value) === 0)
        $("#subquestion-childbirth-age").addClass("show");
    else
        $("#subquestion-childbirth-age").removeClass("show");
});

$("[name='biopsy']").on("change", function () {
    if (Number(this.value) === 0)
        $("#subquestion-biopsy,#subquestion-biopsy-ah").addClass("show");
    else
        $("#subquestion-biopsy,#subquestion-biopsy-ah").removeClass("show");
});

$("#reset").on("click", function () {
    $(survey).validate().resetForm();
    $(".show").removeClass("show");
});
