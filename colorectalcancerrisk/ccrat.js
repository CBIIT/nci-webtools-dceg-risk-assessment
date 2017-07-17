$.validator.addMethod("lessThan", function(value,element,params) {
  var compareTo = params;
  var allowEqual = false;
  if (typeof params === 'object') {
    compareTo = $(params.element).val();
    allowEqual = params.allowEqual===undefined?false:params.allowEqual;
  }
  value = Number(value);
  compareTo = Number(compareTo);
  if (allowEqual) {
    return value <= compareTo;
  } else {
    return value < compareTo;
  }
});
$.validator.addMethod("greaterThan", function(value,element,params) {
  var compareTo = params;
  var allowEqual = false;
  if (typeof params === 'object') {
    compareTo = $(params.element).val();
    allowEqual = params.allowEqual===undefined?false:params.allowEqual;
  }
  value = Number(value);
  compareTo = Number(compareTo);
  if (allowEqual) {
    return value >= compareTo;
  } else {
    return value > compareTo;
  }
});

var validationRules = {
    hispanic: {
        required: true
    },
    race: {
        required: true
    },
    age: {
        required: true,
        min: 50,
        max: 85
    },
    gender: {
        required: true
    },
    height_ft: {
        required: true,
        max: 9
    },
    height_in: {
      required: true,
      max: 9
    },
    weight: {
        required: true,
        min: 50,
        max: 700
    },
    veg_servings: {
        required: true
    },
    veg_amount: {
        required: true
    },
    moderate_months: {
        required: true
    },
    moderate_hours: {
        required: {
            depends: function (el) {
                return $("[name='moderate_months']").val() > 0;
            }
        }
    },
    vigorous_months: {
        required: true
    },
    vigorous_hours: {
        required: {
            depends: function (el) {
                return $("[name='vigorous_months']").val() > 0;
            }
        }
    },
    exam: {
        required: true
    },
    polyp: {
        required: {
            depends: function (el) {
                return $("[name='exam']").val() == "0";
            }
        }
    },
    aspirin: {
        required: true
    },
    non_aspirin: {
        required: true
    },
    family_cancer: {
        required: true
    },
    family_count: {
        required: {
            depends: function (el) {
                return $("[name='family_cancer']").val() == "1";
            }
        }
    },
    period: {
        required: {
            depends: function (el) {
                return $("[name='gender']:checked").val() == "Female";
            }
        }
    },
    last_period: {
        required: {
            depends: function (el) {
                return $("[name='period']:checked").val() == '1';
            }
        }
    },
    hormones: {
        required: {
            depends: function (el) {
                return $("[name='last_period']").val() == '2';
            }
        }
    }
};

var validationMessages = {
    hispanic: {
        required: "You must specify whether you are Hispanic or Latino"
    },
    race: {
        required: "You must specify your race"
    },
    age: {
        required: "You must specify you age",
        min: "This calculator can only be used by people between the ages 50 and 85",
        max: "This calculator can only be used by people between the ages 50 and 85"
    },
    gender: {
        required: "You must specify your gender"
    },
    height_ft: {
        required: "You must specify the feet portion of the height"
    },
    height_in: {
        required: "You must specify the inches portion of the height"
    },
    weight: {
        required: "you must specify your weight",
        min: "The calculator can only be used by people at or over 50 pounds",
        max: "The calculator can only be used by people at or below 700 pounds"
    },
    veg_servings: {
        required: "You must specify how many servings of vegetables you had in the past month"
    },
    veg_amount: {
        required: "You must specify the serving size of the vegetables"
    },
    moderate_months: {
        required: "You must specify how many months you have participated in moderate exercise"
    },
    moderate_hours: {
        required: "You must specify how many hours per week, you have participated in moderate exercise"
    },
    vigorous_months: {
        required: "You must specify how many months you have participated in vigorous exercise"
    },
    vigorous_hours: {
        required: "You must specify how many hous per week you participated in vigorous exercise"
    },
    exam: {
        required: "You must specify whether you had a colonoscopy or sigmoidoscopy exam in the last decade"
    },
    polyp: {
        required: "You must specify whther polyps were found during the exam"
    },
    aspirin: {
        required: "You must specify whether you have taken any medications containing asprin in the past month"
    },
    non_aspirin: {
        required: "You must specify whether you have taken any medications not containing asprin in the past month"
    },
    family_cancer: {
        required: "You must specify whether any relatives had colorectal cancer"
    },
    family_count: {
        required: "You must specify how many relatives had colorectal cancer"
    },
    period: {
        required: "You must specify whether you still have periods"
    },
    last_period: {
        required: "You must specify when you had your last period"
    },
    hormones: {
        required: "You must specify whether you are taking any female hormones"
    }
};
function toggleInputs(input) {
    if ($(input).attr("disabled"))
        $(input).removeAttr('disabled');
    else
        $(input).attr('disabled' ,true);
}


function resetInputs(index, input) {
    switch (input.type) {
        case "radio":
            $("[name='" + input.name + "']").removeAttr('checked');
            break;
        case "checkbox":
            $("[name='" + input.name + "']").removeAttr('checked');
            break;
        case "select":
            $(input).val("");
            break;
        default:
            // statements_def
            break;
   }
}

function invalidForm(e, validator) {
	document.getElementById("errors").scrollIntoView();
	$(document.forms.riskForm).addClass('submitted');
	$("#errors").addClass('alert alert-danger');
}

function processSubmission(form){
	var fd = new FormData(form);

  fd.append("cigarettes", "0");
  fd.append("smoke_age", "25");
  fd.append("cigarettes_num", "2");
  fd.append("smoke_now", 1);

	$.ajax({
		url: form.action,
		type: form.method,
		dataType: 'json',
		processData: false,
		contentType: false,
		data: fd,
	}).done(resultsDisplay)
	.fail(function(xhr, error, textStatus) {
        console.log(xhr, error, textStatus);
		console.log("error");
	})
	.always(function() {
		document.getElementById("errors").scrollIntoView();
	});
}

function resultsDisplay(response, textStatus, xhr) {

  var results=JSON.parse(response.message)
  var messageBeginning = "Based on the information provided, the patient's estimated risk for developing colorectal cancer over "
  var message5years    = "the next 5 years is FillIn compared to a risk of FillIn "
  var message10years   = "the next 10 years is FillIn compareed to a risk of FillInc"
  var messageLifeTime  = "their lifetime ( to age 90) is <Fill in> compared to a risk of <Fill In>"
  var messageEnding= "for a patient of the same age and race/ethnicity from the general US population.";

  $('#main').addClass('hide')
  $('#form-steps').addClass('hide')

  $("#results").addClass('show')

  $("#results_text_5_years").html(messageBeginning + message5years + messageEnding);
  $("#results_text_10_years").html(messageBeginning + message10years + messageEnding);
  $("#results_text_lifetime").html(messageBeginning + messageLifeTime + messageEnding);

  $("[id^='results_text']").css("text-align", "left");


  $(".risk_header").text(response.message+"%");

  make_pie_chart(response.message, "#Pie_chart1");
  make_pie_chart(response.message, "#Pie_chart2");
  make_pie_chart(response.message, "#Pie_chart3");
  make_pie_chart(response.message, "#Pie_chart4");
  make_pie_chart(response.message, "#Pie_chart5");
  make_pie_chart(response.message, "#Pie_chart6");

}

function goback_tocalc() {
  $('#main').removeClass('hide')
  $('#form-steps').removeClass('hide')
  $("#results").removeClass('show')
  $("#results_text").html("");
  $("#Pie_chart").html("");
  $(window).scrollTop(0);
}

function make_pie_chart(percent,id){
  console.log(percent);
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

      var svg = d3.select(id)
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
  var formStepsHeight = $('#form-steps').height() + 50;

  var activeIndex = 0;
  $('#riskForm section').each(function(index, el) {
    var rect = el.getBoundingClientRect();

    if (rect.top - formStepsHeight < 0 && rect.bottom > 0) {
      activeIndex = index;
    }
  })
  $('#form-steps li').removeClass('active');


  if(Math.ceil($(window).scrollTop() + $(window).height()) == $(document).height()) {
    activeIndex = 3;
  }

  $("#form-steps li:eq(" + activeIndex + ")").addClass('active');
  adjust_line_width(activeIndex);
}

function fixedToTop(div_top,use_mobile) {
  var header_height=$('header').outerHeight();
	var window_top = $(window).scrollTop();
	var div_top = $("#"+div_top).offset().top;
	var form_steps_height=$('#form-steps').outerHeight();
	if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){
			$("#main").css("margin-top",0+"px");
 			$("#form-steps").css("margin-top",0+"px");
	}

  if ( window_top > div_top ) {
		  $("#form-steps").addClass('fixed');
      if($(window).width()>=992)
        $("#line").find("hr").css("top",form_steps_height-30)
      else
        $("#line").find("hr").css("top",form_steps_height-37)
	} else{
		$("#form-steps").removeClass('fixed');
		adjust_line_height_dekstop()
	}
}

function toggleFormDisplay(e) {
	e.preventDefault();

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

function toggleGender(e) {
    var value = $(e.target).val();
    switch (value) {
        case "Male":
            $.each($(".female").find("input, select"), function(index, el) {
                $(el).rules("remove", "required");
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
            if($("[name='" + el.name + "']").val().length > 0)
                    $("[name='" + el.name + "']").val("");
            });

            $.each($(".female").find("input, select"), function(index, el) {
                $(el).rules("add", { required: true });
            });

            $(".male").removeClass('show');
            $(".female").addClass('show');
            break;
        default:
            $(".male, .female").removeClass('show').find("input, select").removeAttr("required");
            $.each($(".male, .female").find("input, select"), function(index, el) {
                $(el).rules("remove", "required");
            });
            break;
    }
}

if( !/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
	$(window).scroll(function(e) {
		// e.preventDefault();
		if($(window).width()>=753)
			var top_div="main-nav"
		else
			var top_div="toolTitle"

		fixedToTop(top_div);
		formScrollSpy();
	});

}
else if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)){
	$(window).on('touchmove', function(event) {
		if($(window).width()>=753)
			var top_div="main-nav"
		else
			var top_div="toolTitle"

		fixedToTop(top_div,true);
		formScrollSpy();

	});
}

function adjust_line_width(ind){
  	var first_dot=$("#form-steps").find("a")[1]
  	var first_dot_left    = parseInt($(first_dot).position().left);
  	var first_dot_width   = parseInt($(first_dot).outerWidth(true));
  	var last_dot=$("#form-steps").find("a")[$("#form-steps").find("a").length-1]
  	var last_dot_left     = parseInt($(last_dot).position().left);
  	var last_dot_width    = parseInt($(last_dot).outerWidth(true));
    var left = first_dot_left + first_dot_width/2 + 10;
    $("#line").find("hr").css("left", left);

   if($(window).width()<992 ||navigator.userAgent.search("Firefox")>-1) {
     $("#line").find("hr").css("width",last_dot_left-first_dot_left-last_dot_width/2+10)
   } else {
     $("#line").find("hr").css("width",last_dot_left-first_dot_left-last_dot_width/2+20);
   }

   if (ind == 0 ) {
     $("#line").find("hr").css("width",last_dot_left-first_dot_left -15 );
   } else if(ind==1) {
     $("#line").find("hr").css("width",last_dot_left-first_dot_left)
   } else if (ind==2) {
     $("#line").find("hr").css("width",last_dot_left-first_dot_left+last_dot_width/4-30)
   } else if (ind==3) {
     $("#line").find("hr").css("width", last_dot_left-first_dot_left+last_dot_width/4 - 15);
  }
}

function adjust_line_height_dekstop(){
	var header_height=parseInt($('header').outerHeight());
 	var form_steps_height=parseInt($('#form-steps').outerHeight());

  // When the window is scrolled enought the header is no longer shown, so we
  // remove it from the calculation
  if ( $(window).scrollTop() > header_height)
  {
      header_height = 0;
  }

  if($(window).width()<992) {
    var top = header_height + form_steps_height / 2;
    $("#line").find("hr").css("top", (header_height + form_steps_height / 2));
  }
  else
    $("#line").find("hr").css("top",header_height+form_steps_height-30)
  //console.log("height = " +   $("#line").find("hr").css("top"));
}

$(window).load(function(e) {
  currentPage();
	$(document).on('click', "[type='reset']", function(e) {
		$(document.forms.riskForm).removeClass('submitted');
		$("#results").empty().removeClass('show');
		$(document.forms.riskForm).validate().resetForm();
		document.getElementById("errors").scrollIntoView();
	});

	$(".toggleTool").on("click", toggleFormDisplay);

	$(document).on('click keypress', ".responseOptions > label.radio", function(e) {
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

  $('#hisp-notice').on("click", function() {
    $.each( $("#riskForm :input"), function (i, input) {
      toggleInputs(input);
    });
  });


	$("input[name='gender']").on("change", toggleGender);
	$("input[name='race']").on("change", function() {
		// $("form :input").not("[name='race']").removeAttr('disabled');

        switch (this.value) {
            case 1:
                $('#af-notice').addClass('show');
                break;
            case 2:
                $('#as-notice').addClass('show');
                break;
            default:
                return;
        }
        $("#raceModal").modal("show");
	});

  //

    $("input[name='hispanic']").on("change", function (el) {

            if (this.value == "0") {
                $("#hisp-notice").addClass("show");
                $("#raceModal").modal("show");

                $.each( $("#riskForm :input"), function (i, input) {
                    toggleInputs(input);
                });
            }


    });

    $("input[name='moderate_months']").on("blur", function () {
        $.each($("#subquestion-moderate-hours").find("select,input"), resetInputs);

        if (this.value > "0") {
            $("#subquestion-moderate-hours").addClass("show");
        }
        else {
            $("#subquestion-moderate-hours").removeClass("show");
        }
    });

    $("input[name='vigorous_months']").on("blur", function () {
        $.each($("#subquestion-vigorous_months").find("select,input"), resetInputs);

        if (this.value > "0") {
            $("#subquestion-vigorous_months").addClass("show");
        } else {
            $("#subquestion-vigorous_months").removeClass("show");
        }
    });

    $("select[name='veg_servings']").on("change", function () {
        $.each($("#subquestion-veg").find("select,input"), resetInputs);

        if (this.value > 0) {
            $("#subquestion-veg").addClass("show");
        } else {
            $("#subquestion-veg").removeClass("show");
        }
    });

    $("select[name='exam']").on("change", function () {
        $.each($("#subquestion-exam").find("select,input"), resetInputs);

        if (this.value == "0") {
            $("#subquestion-exam").addClass("show");
        } else {
            $("#subquestion-exam").removeClass("show");
        }
    });

    $("input[name='smoked']").on("change", function () {
        $.each($("#subquestion-smoke-age").find("select,input"), resetInputs);

        if(this.value == "0"){
            $("#subquestion-smoke-age").addClass("show");
        }
        else {
            $("#subquestion-smoke-age").removeClass("show");
        }
    });

    $("select[name='cigarettes']").on("change", function () {
        $.each($("#subquestion-smoke-age").find("select,input"), resetInputs);

        if (this.value === "0")
            $("#subquestion-smoke-age").addClass("show");
        else {
            $("#subquestion-smoke-age").removeClass("show");
            $("#subquestion-smoke-now").removeClass("show");
            $("#subquestion-smoke-quit").removeClass("show");
        }
    });

    $("select[name='smoke_age']").on("change", function () {
        $.each($("#subquestion-smoke-now").find("select,input"), resetInputs);

        if (this.value >= 6)
            $("#subquestion-smoke-now").addClass("show");
        else
            $("#subquestion-smoke-now").removeClass("show");
    });

    $("input[name='smoke_now']").on("change", function () {
        $.each($("#subquestion-smoke-quit").find("select,input"), resetInputs);

        if (this.value === "0")
            $("#subquestion-smoke-quit").addClass("show");
        else
            $("#subquestion-smoke-quit").removeClass("show");
    });

    $("input[name='period']").on("change", function () {
        $.each($("#subquestion-period, #subquestion-hormones").find("select,input"), resetInputs);

        if (this.value == "0")
            $("#subquestion-period, #subquestion-hormones").removeClass("show");
        else
            $("#subquestion-period").addClass("show");
    });

    $("select[name='last_period']").on("change", function () {
        if (this.value == "2")
            $("#subquestion-hormones").addClass("show");
        else
            $("#subquestion-hormones").removeClass("show");
    });

    $("select[name='family_cancer']").on("change", function () {
        $.each($("#subquestion-family-cancer").find("select,input"), resetInputs);

        if (this.value === "1") {
            $("#subquestion-family-cancer").addClass("show");
        } else {
            $("#subquestion-family-cancer").removeClass("show");
        }
    });


	$(document).on('hidden.bs.tab', 'a[data-toggle="tab"]', function(e) {
		if($("nav.navbar-collapse").hasClass('in'))
			$('button[data-toggle="collapse"]').trigger("click");
	});

	$(document).on('click keypress', 'a#state-listing', function(e) {
		e.preventDefault();
		$("#map, #listings").toggleClass('show');
	});

	$(document).on('click keypress', "#listings > button", function(e) {
		$("#state-listing").trigger('click');
	});

	$(document.forms.riskForm).validate({
		rules: validationRules,
		messages: validationMessages,
		ignore: ".skipValidate",
		errorLabelContainer: '#errors',
		errorContainer: "#errors",
		wrapper: 'p',
		submitHandler: processSubmission,
		invalidHandler: invalidForm
	});

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

     $("#main").css("margin-top",header_height+"px");
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

$(window).resize(function() {
	if(window.location.pathname=="/calculator.html");
    adjust_line_width();
	 	if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
      var form_steps_height=$('#form-steps').outerHeight();
	 		$("#line").find("hr").css("top",form_steps_height/2);
	 	} else{
		 	adjust_line_height_dekstop();
	 	}
	 });

   // Purpose : When the user clicks on the Risk Calculator, About the Model & Source code
   // The bottom part of the menu item should be changed to a different color.  This is
   // done by inserting the active command.
   function currentPage() {
   	 var path = window.location.pathname;
   	 var filename = path.substring(path.lastIndexOf('/')+1);
   	 $("nav li a[href='" + filename + "']").parent().addClass('active');
   }
