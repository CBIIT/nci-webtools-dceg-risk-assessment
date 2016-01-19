$(".notice-show").each(function(i, el){
    $(this).on("click", showNotice);
});

function showNotice(e){
    var noticeElement = $( $(e.target.parentElement).prev()[0] );
    if(noticeElement.hasClass("notice")) {
        var display = noticeElement.is(":visible") ? false: true;
        noticeElement.toggle(display);
    }
}

$("input[name='hispanic']").on("change", function(){
    $("#subquestion-race").find("input").val("");
    if(this.value === "0"){
        $("#subquestion-race").removeClass("show");
    }
    else {
        $("#subquestion-race").addClass("show").effect("highlight", 500);
    }
});

$("input[name='gender']").on("change", function() {
    $(".male,.female").find("input[type='radio']").attr("checked", false);
    $(".male,.female").find("select").val("");

    if(this.value === "Male"){
        $(".male").addClass("show").effect("highlight", 500);
        $(".female").removeClass("show");
    }
    else {
        $(".female").addClass("show").effect("highlight", 500);
        $(".male").removeClass("show");
    }
});

$("select[name='medications']").on("change", function(){
    $("#subquestion-medications").find("input, select").val("");
    if(this.value === "0"){
        $("#subquestion-medications").addClass("show").effect("highlight", 500);
    }
    else {
        if (this.value == "1")
            $("#subquestion-medications").find("input, select").val(this.value);
        $("#subquestion-medications").removeClass("show");
    }
});

$("input[name='activity']").on("change", function(){
    $("#subquestion-activity").find("input").val("");
    if(this.value <= "0"){
        $("#subquestion-activity").removeClass("show");
        $("#subquestion-activity").find("input").val(this.value);
    }
    else {
        $("#subquestion-activity").addClass("show").effect("highlight", 500);
    }
});

$("input[name='active-months']").on("change", function(){
    $("#subquestion-active-months").find("select").val("");
    if(this.value <= "0"){
        $("#subquestion-active-months").removeClass("show");
    }
    else {
        $("#subquestion-active-months").addClass("show").effect("highlight", 500);
    }
});

$("select[name='veg_servings']").on("change", function(){
    $("#subquestion-veg").find("input").val("");
    if(this.value > 0){
        $("#subquestion-veg").addClass("show").effect("highlight", 500);
    }
    else {
        $("#subquestion-veg").removeClass("show");
    }
});

$("select[name='exam']").on("change", function(){
    $("#subquestion-exam").find("input").val("");
    if(this.value >= 0){
        $("#subquestion-exam").addClass("show").effect("highlight", 500);
    }
    else {
        $("#subquestion-exam").removeClass("show");
    }
});

$("select[name='cigarettes']").on("change", function() {
    $("#subquestion-smoke-age").find("select").val("");
    if(this.value === "0")
        $("#subquestion-smoke-age").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-smoke-age").removeClass("show");
});

$("select[name='smoke_age']").on("change", function() {
    if(this.value >= 6)
        $("#subquestion-smoke-now").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-smoke-now").removeClass("show");
});

$("input[name='smoke_now']").on("change", function() {
    $("#subquestion-smoke-quit").find("select").val("");
    if(this.value === "0")
        $("#subquestion-smoke-quit").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-smoke-quit").removeClass("show");
});

$("input[name='period']").on("change", function() {
    $("#subquestion-period, #subquestion-hormones").find("input, select").val("");
    if(this.value === "1")
        $("#subquestion-period, #subquestion-hormones").removeClass("show");
    else
        $("#subquestion-period").addClass("show").effect("highlight", 500);
});

$("select[name='last_period']").on("change", function() {
    $("#subquestion-hormones").find("select").val("");
    if(this.value == "2")
        $("#subquestion-hormones").addClass("show").effect("highlight", 500);
    else
        $("#subquestion-hormones").removeClass("show");
});



$("select[name='family-cancer']").on("change", function(){
    $("#subquestion-family-cancer").find("input, select").val("");
    if(this.value === "0"){
        $("#subquestion-family-cancer").addClass("show").effect("highlight", 500);
    }
    else {
        if (this.value == "1")
            $("#subquestion-family-cancer").find("input, select").val(this.value);
        $("#subquestion-family-cancer").removeClass("show");
    }
});
