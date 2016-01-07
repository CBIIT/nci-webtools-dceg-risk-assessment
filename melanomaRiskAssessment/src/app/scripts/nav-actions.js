$(function(){
    $('.goTo').on('click', function() {
        $("html, body").animate({
            scrollTop: $(this.name).offset().top - $("header")[0].clientHeight
        }, 1000);
    });

    $('#content').on('click','[tabTo]',function(e) {
        if (history && history.pushState && $(this).children('a').length == 1) {
            e.preventDefault();
            history.pushState({},'',$(this).children('a').eq(0).attr('href'));
        }
        $('[tabTo],[tab]').removeClass('active');
        $(this).addClass('active');
        $('[tab="'+$(this).attr('tabTo')+'"]').addClass('active');
    });

    $('.goToTab').on('click', function() {
        $('[tabTo="'+this.name+'"]').trigger('click');
    });

    var currentHash = window.location.hash;
    if (currentHash.length > 0) {
      $('[tabTo] a[href="'+window.location.hash+'"]').parent().click();
    } else {
      $('[tabTo]:first-child').first().click();
    }

    $(window).scroll(fixedToTop);
    fixedToTop();
});

function fixedToTop() {
    var window_top = $(window).scrollTop();
    var div_top = $('#content').offset().top;
    if (window_top > div_top) {
        $('.nav').addClass('stick-nav-top');
        $("#topButton").css("display","block");
    } else {
        $('.nav').removeClass('stick-nav-top');
        $("#topButton").css("display","none");
    }
}
