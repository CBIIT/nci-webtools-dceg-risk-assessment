var validationRules = {

};
var validationMessages = {
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

$(".thumbnail").on("click", function() {
    $(this).toggleClass(function() {
        if($(this).hasClass("expand"))
            return;
        else
            return "expand";
    });
    this.scrollIntoView();
});

$("#reset").on("click", function(){
    $(survey).validate().resetForm();
    $(".show").removeClass("show");
});
