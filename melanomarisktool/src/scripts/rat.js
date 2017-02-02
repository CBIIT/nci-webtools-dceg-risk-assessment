var validationMessages = {
	state: {
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

$(function() {
	$(".toggleTool").on("click", toggleFormDisplay);
	$(document).on('click keypress', 'a#state-listing', function(e) {
		e.preventDefault();
		$("#map, #listings").toggleClass('show');
	});

	$(document).on('click keypress', "#listings button", function(event) {
		$("#state-listing").trigger('click')
	});
	$(window).scroll(function(e) {
		e.preventDefault();
		fixedToTop();
		formScrollSpy();
	});

	$(document.forms.riskForm).on("submit", function(e) {
		alert('submitted');
		console.log(e.target);
		processSubmission();
	});

});
function processSubmission(){

	    $.ajax({
        url: riskForm.action,
        type: riskForm.method,
        data: new FormData(riskForm),
        processData: false,
        contentType: false,
        dataType: 'json'
    }).done(function (data) {
        if (data.success) {
            displayResult(data.message);
        } else {
            var message = "";
            if (data.message) {
                message += "<p>" + data.message + "</p>";
            }
            var index;
            for (index in data.missing) {
                $('#' + data.missing[index]).addClass('error');
                message += "<p>The " + data.missing[index] + " question was not answered.</p>";
            }
            for (index in data.nonnumeric) {
                $('#' + data.nonnumeric[index]).addClass('error');
                message += "<p>The " + data.nonnumeric[index] + " question contained a nonnumeric answer.</p>";
            }
            $('#error').append(message).css('display', 'block');
            document.getElementById("main").scrollIntoView();
        }
    }).fail(function (data) {
        if (data.responseJSON)
            $('#error').append("<p>" + data.responseJSON.message + "</p>").css('display', 'block');
        else
            $('#error').append("<p>" + data.responseText + "</p>").css('display', 'block');

        document.getElementById("main").scrollIntoView();
    });
}
function formScrollSpy() {
	var window_top = $(window).scrollTop();

	$.each($("#riskForm section"), function(ind, el) {	
		var div_top = $(el).offset().top - 20 ;

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