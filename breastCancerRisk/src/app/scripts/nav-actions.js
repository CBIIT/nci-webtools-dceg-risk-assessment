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

    $('#menu-button').on('click',function() {
        $('#main-nav').toggleClass('show');
    });

    $('#main-nav a').on('click',function() {
        var naxtNav = $(this).next('ul.nav');
        if (naxtNav.length > 0) {
            naxtNav.toggleClass('show');
        }
    });

    var currentHash = window.location.hash;
    if (currentHash.length > 0) {
        $('[tabTo] a[href="'+window.location.hash+'"]').parent().click();
    } else {
        $('[tabTo]:first-child').first().click();
    }

    $(window).scroll(fixedToTop);
    fixedToTop();

    $(".section-description").each(function() {

        if(this.innerText.length > 600) {
            var text = "<div class='more'>"+ this.innerHTML +"</div><button class='show-more'><span class='fa fa-arrow-down'></span> Show More</button>";
            this.innerHTML = text;
        }
    });

    $(".show-more").on("click", function() {
        if(!$(this).prev().hasClass("more")){
            this.innerHTML = "<span class='fa fa-arrow-down'></span> Show More";
            $(this).attr("title","Show More");
        }
        else{
            this.innerHTML = "<span class='fa fa-arrow-up'></span> Show Less";
            $(this).attr("title","Show Less");
        }

        $(this).prev().toggleClass("more");
    });
});

function fixedToTop() {
    var window_top = $(window).scrollTop();
    var div_top = $('#content').offset().top;
    if (window_top > div_top) {
        $('#main-nav').addClass('stick-nav-top');
        $("#topButton").css("display","block");
    } else {
        $('#main-nav').removeClass('stick-nav-top');
        $("#topButton").css("display","none");
    }
}
