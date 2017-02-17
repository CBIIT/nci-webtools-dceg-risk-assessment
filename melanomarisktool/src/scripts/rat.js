var validationMessages = {
	region: {
		required: "The state in which the patient resides must be selected."
	},
	county: {
		required: "The county in which the patient resides must also be selected."
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
	county: {
		required: {
			depends: function(el) {
				return $('#state').val() == 'CA';
			}
		}
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
				return $('#gender').val() == "Male";
			}
		}
	},
	complexion: {
		required: true
	},
	"big-moles": {
		required: {
			depends: function(el) {
				return $('#gender').val() == "Male";
			}
		}
	},
	"small-moles": {
		required: true
	},
	tan: {
		required: {
			depends: function(el) {
				return $('#gender').val() == "Female";
			}
		}
	},
	freckling: {
		required: true
	},
	damage: {
		required: {
			depends: function(el) {
				return $('#gender').val() == "Male";
			}
		}
	}
};

function invalidForm(e, validator) {
	document.getElementById("errors").scrollIntoView();
	$(document.forms.riskForm).addClass('submitted');
	$("#errors").addClass('alert alert-danger');
}

function processSubmission(form){
	var fd = new FormData(form);

	return $.ajax({
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
		document.getElementById("errors").scrollIntoView();
	});
}

function resultsDisplay(response, textStatus, xhr) {
	$("#results").addClass('show').html(response.message);
}

function formScrollSpy() {
	var window_top = $(window).scrollTop();

	$.each($("#riskForm section"), function(ind, el) {	
		var div_top = $(el).offset().top - $(el)[0].scrollHeight;

		if ( window_top > div_top ){
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
	if (value == "Male") {
		$.each($(".female").find("input, select"), function(index, el) {
			$(el).rules("remove", "required");
		});

		$.each($(".male").find("input, select"), function(index, el) {
			$(el).rules("add", { required: true });
		});

		$(".female").removeClass('show');
		$(".male").addClass('show');
	}
	else if(value == "Female") {
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
	}
	else {
		$(".male, .female").removeClass('show').find("input, select").removeAttr("required");
		$.each($(".male, .female").find("input, select"), function(index, el) {
			$(el).rules("remove", "required");
		});
	}
}

$(window).scroll(function(e) {
	e.preventDefault();
	fixedToTop();
	formScrollSpy();
});

$(function() {
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

	$("input[name='gender']").on("change", toggleGender);
	$("input[name='race']").on("change", function() {
		$("form :input").not("[name='race']").removeAttr('disabled');
		if(this.value == 1){
			$("#raceModal").modal("show");
			$("form :input").not("[name='race']").attr('disabled', true);
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

});