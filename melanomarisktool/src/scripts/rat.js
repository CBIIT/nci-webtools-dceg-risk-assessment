var validationMessages = {
	region: {
		required: "The region in which the patient resides must be selected."
	},
	gender: {
		required: "The patient's gender must be selected."
	},
	race: {
		required: "The patient's race must be selected."
	},
	age: {
		required: "The patient's age must be selected."
	},
	sunburn: {
		required: "Whether the patient has ever received a sunburn must be recorded."
	},
	complexion: {
		required: "The patient's complexion must be selected."
	},
	"big-moles": {
		required: "The number of moles greater than 5mm in diameter on the patient's back must be selected."
	},
	"small-moles": {
		required: "The number of moles less than or equal to 5mm in diameter on the patient's back must be selected."
	},
	"tan": {
		required: "The level to which the patient presents a tan must be selected."
	},
	freckling: {
		required: "The extent of the freckling on the patient's back must be selected."
	},
	damage: {
		required: "Whether the patient has severe solar damage on their next and shoulders must be selected."
	}
};

var validationRules = {
	region: {
		required: true
	},
	gender: {
		required: true
	},
	race: {
		required: true
	},
	age: {
		required: true
	},
	sunburn: {
		required: {
			depends: function(el) {
				return  $('[name="gender"]').val() == "Male";
			}
		}
	},
	complexion: {
		required: true
	},
	"big-moles": {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Male";
			}
		}
	},
	"small-moles": {
		required: true
	},
	"tan": {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Female";
			}
		}
	},
	freckling: {
		required: true
	},
	damage: {
		required: {
			depends: function(el) {
				return $('[name="gender"]').val() == "Male";
			}
		}
	}
};

function toTop(){
	if (document.getElementById("main-nav").scrollIntoView) {
		document.getElementById("main-nav").scrollIntoView();
	}
	else
		$('html,body').scrollTop(0);
}

function invalidForm(e, validator) {
	$("#errors").addClass('alert alert-danger');
	toTop();
}

function processSubmission(form){
	var fd = new FormData(form);

	$.ajax({
		url: form.action,
		type: form.method,
		dataType: 'json',
		processData: false,
		contentType: false,
		data: fd,
	}).done(resultsDisplay)
	.fail(function() {
		console.log("error");
	})
	.always(function() {
		toTop();
	});
}

function resultsDisplay(response, textStatus, xhr) {
	var results=JSON.parse(response.message)
	var message="Based on the information provided, the patient's estimated risk for developing melanoma over the next 5 years is "+results.risk+"%. For every 1,000 "+ results.gender+"s living in the " +results.regionKey+" region with these characteristics, on average about "+ results.ratio+" will develop melanoma in the next 5 years.";



	$('#main').addClass('hide')
	$('#form-steps').addClass('hide')
	$("#results").addClass('show')
	$("#results_text").html(message);
	$(".risk_header").text(results.risk+"%");
	make_pie_chart(results.risk);

}
function goback_tocalc(){
	$('#main').removeClass('hide')
	$('#form-steps').removeClass('hide')
	$("#results").removeClass('show')
	$("#results_text").html("");
	$("#Pie_chart").html("");
	$(window).scrollTop(0);
}
function make_pie_chart(percent){
	(function(d3) {

        'use strict';

        var dataset = [
          { label: 'Risk', count: percent },
          { label: 'Total', count: 100-percent },
        ];

        var width = 206;
        var height = 206;
        var radius = Math.min(width, height) / 2;

        var color = d3.scaleOrdinal().range(['#2dc799','#EFEFEF']);

        var svg = d3.select('#Pie_chart')
          .append('svg')
          .attr('width', width)
          .attr('height', height)
          .append('g')
          .attr('transform', 'translate(' + (width / 2) +
            ',' + (height / 2) + ')');

        var arc = d3.arc()
          .innerRadius(0)
          .outerRadius(radius);

        var pie = d3.pie()
          .value(function(d) { return d.count; })
          .sort(null);

        var path = svg.selectAll('path')
          .data(pie(dataset))
          .enter()
          .append('path')
          .attr('d', arc)
          .attr('fill', function(d) {
            return color(d.data.label);
          });

      })(window.d3);
}
function formScrollSpy() {
	var window_top = $(window).scrollTop();
	$.each($("#riskForm section"), function(ind, el) {
		var div_top = $(el).offset().top - $(el)[0].scrollHeight;
		if ( window_top > div_top ) {
			$("#form-steps li").removeClass('active');
			$("#form-steps li:eq(" + ind + ")").addClass('active');
			adjust_line_width(ind);
		}
	});

}



function fixedToTop() {
	var window_top = $(window).scrollTop();
	var div_top = $("#main-nav").offset().top;
	var form_steps_height=$('#form-steps').outerHeight();
	if ( window_top > div_top ){
		$("#form-steps").addClass('fixed');

		$("#line").find("hr").css("top",form_steps_height-30)
	}
	else{
		$("#form-steps").removeClass('fixed');
	adjust_line_height_dekstop()
	}
}



function toggleFormDisplay(e) {
	e.preventDefault();
 
	if (e.type == "keypress") {
		$(e.target).trigger('click');
	}
 	else {
		$("#riskForm, #summary, #form-steps").toggleClass(function() {
			if($(this).hasClass('show')) {
				$(this).removeClass('show');
			}
			else {
				$(this).addClass('show');
			}
			return this;
		});
	}
}

function toggleGender(e) {
	var value = $(e.target).val();
	switch (value) {
		case "Male":
			$.each($(".female").find("input, select"), function(index, el) {
				$(el).rules("remove", "required");
				$("#riskForm").validate().element(el);
			});

			$.each($(".male").find("input, select"), function(index, el) {
				$(el).rules("add", { required: true });
			});

			$(".female").removeClass('show');
			$(".male").addClass('show');
			break;
		case "Female":
			$.each($(".male").find("input, select"), function(index, el) {
				$(el).rules("remove", "required");
			});

			$.each($(".female").find("input, select"), function(index, el) {
				$(el).rules("add", { required: true });
			});
			
			$(".male").removeClass('show');
			$(".female").addClass('show');
			break;
		default:
			$.each($(".male, .female").find("input, select"), function(index, el) {
				$(el).rules("remove", "required");
			});
			break;
	}
}

if( !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	$(window).scroll(function(e) {
		// e.preventDefault();
		fixedToTop();
		formScrollSpy();
	});

}
else if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){
	$(window).on('touchmove', function(event) {
		formScrollSpy();

	});

}
$(window).load(function(e) {
	if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
		$("#About").find("a").text("About the Model")
	$("[type='reset']").on('click keypress', function(e) {
		if(e.type == "keypress") {
			if ((e.keyCode == 13) || (e.keyCode == 32)){
				$(e.target).trigger('click');
			}
		}
		else {
			$(document.forms.riskForm).removeClass('submitted');
			$("#results, .male, .female").removeClass("show");
			$("#results").empty();
			$("#riskForm").validate().resetForm();
			toTop();
		}
	});

	$(".toggleTool").on("click keypress", toggleFormDisplay);

	$(".responseOptions > label.radio").on('click keypress', function(e) {
		if ($(e.target).hasClass('radio')) {
			$(e.target).prev().trigger('click');
		}
		else if ($(e.target).parents('.radio')) {
			$(e.target).parents('.radio').prev().trigger('click');
		}
		else {
			if(e.type == "keypress") {
				if ((e.keyCode == 13) || (e.keyCode == 32)){
					$(e.target).children(".radio").prev().trigger('click');
				}
			}
			if(e.type == "click") {
				$(e.target).children('.radio').prev().trigger('click');
			}
		}
	});

	$("button.select").on('click keypress', function(e) {
		if(e.type == "keypress") {
			if ((e.keyCode == 13) || (e.keyCode == 32)) {
				$(e.target).prev().trigger('click');
			}
		}
		if(e.type == "click") {
			$(e.target).prev().trigger('click');
		}
	});

	$("input[name='gender']").on("change", toggleGender);
	$("input[name='race']").on("change", function() {
		if(this.value == 1){
			$("#raceModal").modal("show");
			$("form :input").not("[name='race']").attr('disabled', true);
		}
		else {
			$("form :input").not("[name='race']").removeAttr('disabled');
		}
	});

	$('a[data-toggle="tab"]').on('hidden.bs.tab', function(e) {
		if($("nav.navbar-collapse").hasClass('in'))
			$('button[data-toggle="collapse"]').trigger("click");
	});

	// $('.mapDetails').on('click keypress', function(e) {
	// 	if(e.type == "keypress") {
	// 		if ((e.keyCode == 13) || (e.keyCode == 32))
	// 			$(e.target).trigger('click');
	// 	}
	// 	else
	// 		$("#map, #listings").toggleClass('show');
	// });
	var header_height=$('header').outerHeight();
 	var form_steps_height=$('#form-steps').outerHeight();
	 	$("#side_nav").css("margin-top",header_height+"px");
	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
 		console.log("mobile");
 		 $("header").addClass('fixed');
 		 $("#form-steps").addClass('fixed');
 		 if($("#side_nav").width()>0)
 		 	$("#form-steps").css("z-index","999")
 		 else{
 		 	$("#form-steps").css("z-index","1")
 		 }

 		 $("#main").css("margin-top",header_height+form_steps_height+"px"); 
 		 $("#form-steps").css("margin-top",header_height+"px");
 		 $("header").css("background","white"); 
 		 $("#main").removeClass("container-fluid");

 		$("#line").find("hr").css("top",form_steps_height/2)
		$("#About").find("a").text("About the Model")
	}

 	else{
	 	adjust_line_height_dekstop()
 	}
	adjust_line_width()
});

$( window ).resize(function() {

 	adjust_line_width()
 	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) )
 		$("#line").find("hr").css("top",form_steps_height/2)
 	else{
	 	adjust_line_height_dekstop();
 	}

});
function adjust_line_width(ind){
 	var first_dot=$("#form-steps").find("a")[1]
 	var first_dot_left=$(first_dot).position().left
 	var first_dot_width=$(first_dot).outerWidth(true)
 	var last_dot=$("#form-steps").find("a")[$("#form-steps").find("a").length-1]
 	var last_dot_left=$(last_dot).position().left
 	var last_dot_width=$(last_dot).outerWidth(true)
 	$("#line").find("hr").css("left",first_dot_left+first_dot_width/2+7)
    
    $("#line").find("hr").css("width",last_dot_left-first_dot_left-last_dot_width/2)
	if(ind==1)
		$("#line").find("hr").css("width",last_dot_left-first_dot_left)

    else if(ind==2)
    	$("#line").find("hr").css("width",last_dot_left-first_dot_left+last_dot_width/4)


    
}

function adjust_line_height_dekstop(){
	var header_height=$('header').outerHeight();
 	var form_steps_height=$('#form-steps').outerHeight();
	if(window.innerWidth<992)
	 	$("#line").find("hr").css("top",header_height+form_steps_height/2)
	else
	 	$("#line").find("hr").css("top",header_height+form_steps_height-30)

}
function currentPage() {
	 var path = window.location.pathname;
	 var filename = path.substring(path.lastIndexOf('/')+1);
	 if(filename.indexOf('index') == -1)
	 	$("nav li a[href='" + filename + "']").parent().addClass('active');

}
function smoothScroll(e) {
	if (e.type == "keypress") {
		if ((e.keyCode == 13) || (e.keyCode == 32))
			$(e.target).trigger('click');
	}
 	if(location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
		var target = $(this.hash);
		target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
		if (target.length) {
			$('html, body').animate({
	    		scrollTop: (target.offset().top - target[0].scrollHeight)
	    	}, 1000);
	    	return false;
	    }
	}
}

$(function() {
	currentPage();
	// smooth scrolling to element on page
	$('a[href*="#"]:not([href="#"])').on("click keypress", smoothScroll);


	$("#riskForm").validate({
		rules: validationRules,
		messages: validationMessages,
		ignore: ".skipValidate",
		errorLabelContainer: '#errors',
		wrapper: 'p',
		submitHandler: processSubmission,
		invalidHandler: invalidForm,
		highlight: function(el, errorClass) {
			$("[name='" + el.name + "']").addClass(errorClass);
		},
		unhighlight: function(el, errorClass) {
			$("[name='" + el.name + "']").removeClass(errorClass);
		}
	});
 
});

function toggle_menu(){
    
    if($("#side_nav").width()>0){
    	$("#side_nav").css("width","0%")
    	setTimeout(function(){ $("#form-steps").css("z-index","1"); }, 500);

    }
	
	else{
		$("#form-steps").css("z-index","99")
		$("#side_nav").css("width","70%")

	}

}