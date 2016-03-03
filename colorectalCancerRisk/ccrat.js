$(function(){
    var titles = {
        "risk-calculator": "Risk Calculator",
        "about": "About",
        "risk-factors": "Colorectal Cancer Risk Factors",
        "source-code": "Access Source Code"
    };

    $('.goTo').on('click', function() {
        $("html, body").animate({
            scrollTop: $(this.name).offset().top - $("header")[0].clientHeight
        }, 1000);
    });

    $('#content').on('click','[tabTo]',function(e) {
        document.title  =  "Colorectal Cancer Risk Assessment Tool (CCRAT) | " +
            titles[$(this).attr('tabTo')];
    });
});

$(".notice-show").each(function (i, el) {
    $(this).on("click", showNotice);
});

function showNotice(e) {
    var noticeElement = $($(e.target.parentElement).prev()[0]);
    if (noticeElement.hasClass("notice")) {
        var display = noticeElement.is(":visible") ? false : true;
        noticeElement.toggle(display);
    }
}

function resetInputs() {
    if (this.type == "radio" || this.type == "checkbox")
        this.checked = false;
    if (this.type == "select-one" || this.type == "select-multiple" || this.type == "text")
        this.value = "";
}

$("#reset, .goToTab[name='risk-calculator']").on("click", function () {
    $(survey).validate().resetForm();
    $('.show').removeClass("show");
});

$("input[name='hispanic']").on("change", function () {
    $.each(document.getElementsByName("race"), resetInputs);

    if (this.value == "1") {
        $("#subquestion-race").addClass("show").effect("highlight", 500);
    } else {
        $("#subquestion-race").removeClass("show");
    }
});

$("input[name='gender']").on("change", function () {
    $.each($(".male,.female").find("input,select"), resetInputs);

    if (this.value === "Male") {
        $(".male").addClass("show").effect("highlight", 500);
        $(".female").removeClass("show");
    } else {
        $(".female").addClass("show").effect("highlight", 500);
        $(".male").removeClass("show");
    }
});

$("input[name='moderate_months']").on("blur", function () {
    $.each($("#subquestion-moderate-hours").find("select,input"), resetInputs);

    if (this.value > "0") {
        $("#subquestion-moderate-hours").addClass("show").effect("highlight", 500);
    }
    else {
        $("#subquestion-moderate-hours").removeClass("show");
    }
});

$("input[name='vigorous_months']").on("blur", function () {
    $.each($("#subquestion-vigorous_months").find("select,input"), resetInputs);

    if (this.value > "0") {
        $("#subquestion-vigorous_months").addClass("show").effect("highlight", 500);
    } else {
        $("#subquestion-vigorous_months").removeClass("show");
    }
});

$("select[name='veg_servings']").on("change", function () {
    $.each($("#subquestion-veg").find("select,input"), resetInputs);

    if (this.value > 0) {
        $("#subquestion-veg").addClass("show").effect("highlight", 500);
    } else {
        $("#subquestion-veg").removeClass("show");
    }
});

$("select[name='exam']").on("change", function () {
    $.each($("#subquestion-exam").find("select,input"), resetInputs);

    if (this.value == "0") {
        $("#subquestion-exam").addClass("show").effect("highlight", 500);
    } else {
        $("#subquestion-exam").removeClass("show");
    }
});

$("input[name='smoked']").on("change", function () {
    $.each($("#subquestion-smoke-age").find("select,input"), resetInputs);

    if(this.value == "0"){
        $("#subquestion-smoke-age").addClass("show").effect("highlight", 500);
    }
    else {
        $("#subquestion-smoke-age").removeClass("show");
    }
});

$("select[name='cigarettes']").on("change", function () {
    $.each($("#subquestion-smoke-age").find("select,input"), resetInputs);

    if (this.value === "0")
        $("#subquestion-smoke-age").addClass("show").effect("highlight", 500);
    else {
        $("#subquestion-smoke-age").removeClass("show");
        $("#subquestion-smoke-now").removeClass("show");
        $("#subquestion-smoke-quit").removeClass("show");
    }
});

$("select[name='smoke_age']").on("change", function () {
    $.each($("#subquestion-smoke-now").find("select,input"), resetInputs);

    if (this.value >= 6)
        $("#subquestion-smoke-now").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-smoke-now").removeClass("show");
});

$("input[name='smoke_now']").on("change", function () {
    $.each($("#subquestion-smoke-quit").find("select,input"), resetInputs);

    if (this.value === "0")
        $("#subquestion-smoke-quit").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-smoke-quit").removeClass("show");
});

$("input[name='period']").on("change", function () {
    $.each($("#subquestion-period, #subquestion-hormones").find("select,input"), resetInputs);

    if (this.value == "0")
        $("#subquestion-period, #subquestion-hormones").removeClass("show");
    else
        $("#subquestion-period").addClass("show").effect("highlight", 500);
});

$("select[name='last_period']").on("change", function () {
    if (this.value == "2")
        $("#subquestion-hormones").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-hormones").removeClass("show");
});

$("select[name='family_cancer']").on("change", function () {
    $.each($("#subquestion-family-cancer").find("select,input"), resetInputs);

    if (this.value === "1") {
        $("#subquestion-family-cancer").addClass("show").effect("highlight", 500);
    } else {
        $("#subquestion-family-cancer").removeClass("show");
    }
});
