////////////////////////////////////////////////////////////////////////////////
// Display the results for the Melenoma Cancer Risk Analysis Tool             //
////////////////////////////////////////////////////////////////////////////////
function resultsDisplay(response, textStatus, xhr) {
	var results=JSON.parse(response.message)
	var message="Based on the information provided, the patient's estimated risk for developing melanoma over the next 5 years is "+results.risk+"%. For every 1,000 "+ results.gender+"s living in the " +results.regionKey+" region with these characteristics, on average about "+ results.ratio+" will develop melanoma in the next 5 years.";

	$('#main').addClass('hide')
	$('#form-steps').addClass('hide')
	$("#results").addClass('show')
	$("#results_text").html(results.message);
	$(".risk_header").text(results.risk+"%");

  fiveYearPatientRiskColor="#2DC799";

	make_pie_chart(results.risk, "#results_graph", fiveYearPatientRiskColor, "#EFEFEF");

}

/*
 * Display the correct form object for the gender
 */
function toggleGender(e) {
	var value = $(e.target).val();
	$("#skin-section").removeClass("no_display")
	$("#skin").removeClass("no_display")
	$("#physical-section").removeClass("no_display")
	$("#physical").removeClass("no_display")
	switch (value) {
		case "Male":
			$('.small_mole_answer')[0].innerHTML="Less than seven"
			$('.small_mole_answer')[1].innerHTML="Seven to sixteen"
			$('.small_mole_answer')[2].innerHTML="Seventeen or more"
			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});
			$(".female").removeClass('show');
			$(".male").addClass('show');
			break;
		case "Female":
			$('.small_mole_answer')[0].innerHTML="Less than five"
			$('.small_mole_answer')[1].innerHTML="Five to eleven"
			$('.small_mole_answer')[2].innerHTML="Twelve or more"
			$.each($(".male").find("input, select"), function(index, el) {
				$(el).prop("required", false);
				$("#riskForm").validate().element(el);
			});

			$.each($(".female").find("input, select"), function(index, el) {
				$(el).prop("required", true);
			});

			$(".male").removeClass('show');
			$(".female").addClass('show');
			break;
		default:
			$.each($(".male, .female").find("input, select"), function(index, el) {
				$(el).prop("required", false);
			});
			break;
	}
}
