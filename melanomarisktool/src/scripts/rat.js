var validationMessages = {
	region: {
		required: "The state in which the patient resides must be selected."
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
	tan: {
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
				return $(el).val().length == 0 && $('[name="gender"]').val() == "Male";
			}
		}
	},
	complexion: {
		required: true
	},
	"big-moles": {
		required: {
			depends: function(el) {
				return $(el).val().length == 0 && $('[name="gender"]').val() == "Male";
			}
		}
	},
	"small-moles": {
		required: true
	},
	tan: {
		required: {
			depends: function(el) {
				return $(el).val().length == 0 && $('[name="gender"]').val() == "Female";
			}
		}
	},
	freckling: {
		required: true
	},
	damage: {
		required: {
			depends: function(el) {
				return $(el).val().length == 0 && $('[name="gender"]').val() == "Male";
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
	$("#results").addClass('show').html(response.message);
}

function formScrollSpy() {
	var window_top = $(window).scrollTop();

	$.each($("#riskForm section"), function(ind, el) {
		var div_top = $(el).offset().top - $(el)[0].scrollHeight;

		if ( window_top > div_top ) {
			$("#form-steps li").removeClass('active');
			$("#form-steps li:eq(" + ind + ")").addClass('active');
		}
	});
}

function fixedToTop() {
	var window_top = $(window).scrollTop();
	var div_top = $(document.forms.riskForm).offset().top;

	if ( window_top > div_top )
		$("#form-steps").addClass('fixed');
	else
		$("#form-steps").removeClass('fixed');
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

$(window).scroll(function(e) {
	// e.preventDefault();
	fixedToTop();
	formScrollSpy();
});

$(window).load(function(e) {
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

	$('.mapDetails').on('click keypress', function(e) {
		if(e.type == "keypress") {
			if ((e.keyCode == 13) || (e.keyCode == 32))
				$(e.target).trigger('click');
		}
		else
			$("#map, #listings").toggleClass('show');
	});
});

$(function() {


	$("#riskForm").validate({
		rules: validationRules,
		messages: validationMessages,
		ignore: ".skipValidate",
		errorLabelContainer: '#errors',
		errorContainer: "#errors",
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