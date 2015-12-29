$(function(){
    $(".goTo").on('click', function() {
        $("html, body").animate({
            scrollTop: $(this.name).offset().top - $("header")[0].clientHeight
        }, 1000);
    });

    $("#content").tabs({
        "show": { effect: "fade", duration: "2000" }
    });

    $(".goToTab").on('click', function() {
        var ind = $(".nav li").index( $("li a[href='" + this.name + "']").parent() );
        $("#content").tabs({active: ind});
    });

    $(window).scroll(fixedToTop);
    fixedToTop();
});

function fixedToTop() {
    var window_top = $(window).scrollTop();
    var div_top = $('#content').offset().top;
    if (window_top >= div_top) {
        $('.nav').addClass('stick-nav-top');
    } else {
        $('.nav').removeClass('stick-nav-top');
    }
}
