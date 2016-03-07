$(function () {
    $(".about-question-explanation").on("click", function() {
        toggleShow(this);
    });

    $(".exp-title").on("click", function() {
        toggleShow($(this).next());
    });

    $('.goTo').on('click', function () {
        $(this.name)[0].scrollIntoView();
    });

    $('#content').on('click', '[tabTo]', function (e) {
        if (history && history.pushState && $(this).children('a').length == 1) {
            e.preventDefault();
            history.pushState({}, '', $(this).children('a').eq(0).attr('href'));
        }
        $('[tabTo],[tab]').removeClass('active');
        $(this).addClass('active');
        $('[tab="' + $(this).attr('tabTo') + '"]').addClass('active');
    });

    $('.goToTab').on('click', function () {
        $('[tabTo="' + this.name + '"]').trigger('click');
    });

    $('#menu-button').on('click', function () {
//        $('#main-nav').toggleClass('show');
        toggleShow($('#main-nav'));
    });

    $('#main-nav a').on('click', function () {
        var nextNav = $(this).next('ul.nav');

        if ($('#main-nav').hasClass('show') && nextNav.length === 0)
            $('#main-nav').removeClass('show');

        if (nextNav.length > 0)
            toggleShow(nextNav);
//            nextNav.toggleClass('show');
        else
            $('#quick-link > ul.nav').removeClass('show');
    });

    var currentHash = window.location.hash;
    if (currentHash.length > 0) {
        $('[tabTo] a[href="' + window.location.hash + '"]').parent().click();
    } else {
        $('[tabTo]:first-child').first().click();
    }

    $(window).scroll(fixedToTop);
    fixedToTop();

    $(".section-description").on("click", function () {
//        $(this).find(".description").toggleClass("show");
        toggleShow($(this).find(".description"));
    });
});

function toggleShow(el){
    $(el).toggleClass("show");
}

function fixedToTop() {
    var window_top = $(window).scrollTop();
    var div_top = $('#content').offset().top;
    if (window_top > div_top) {
        $('#main-nav').addClass('stick-nav-top');
        $("#topButton").css("display", "block");
    } else {
        $('#main-nav').removeClass('stick-nav-top');
        $("#topButton").css("display", "none");
    }
}
