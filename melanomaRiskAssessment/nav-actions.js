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

    $("#quick-title, .menu-title > .minimize, .maximize").on("click", function (e) {
        var nextElm = $(this).next();
        if($(e.target).hasClass("minimize")){
            $(nextElm).slideUp();
            $(e.target).addClass("maximize").removeClass("minimize").text("  [ + ]");
        }
        else{
            $(nextElm).slideDown();
            $(e.target).addClass("minimize").removeClass("maximize").text("  [ - ]");
        }
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
