$(function(){
    $(".goTo").on('click', function() {
        $("html, body").animate({
            scrollTop: $(this.name).offset().top - 200
        }, 1000);
    });
});
