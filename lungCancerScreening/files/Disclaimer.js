$( document ).ready(function() {
    createModal();
});
var template_string='<div class="modal fade" id="modal" tabindex="-1" role="dialog">'
  +'<div class="modal-dialog  modal-lg" role="document">'
    +'<div class="modal-content" >'
      +'<div class="modal-header">'
        +'<b><h2 class="modal-title" id="modalTitle">Modal title</h2></b>'
      +'</div>'
      +'<div class="modal-body"><div id ="container" >'
    
     +"The Lung Cancer Risk Assessment Tool was designed for use by researchers, or to provide general health information. It is not a substitute for medical advice, diagnosis, or treatment of any health condition or problem." 
     +" If you have questions after using this tool, address them to your healthcare provider." 
     +" You should always consult with a healthcare provider before making any decisions, or undertaking any actions or not undertaking any actions related to any healthcare problem or issue you might have at any time, "
     +" now or in the future. Research on lung cancer risk changes frequently; information contained in the tool may be outdated, incomplete or incorrect."
     +'</div><button type="button" id="Agree" style="margin-left:45%;margin-top:1%;display:inline-block" data-dismiss="modal" \" >I understand</button>'
     +'</div></div></div></div>';

function createModal() {
	var header = "Disclaimer";
	$('body').append($(template_string));
	$('#modalTitle').html(header);
	$('#modal').modal({backdrop: 'static', keyboard: false}) 
	$('#modal').modal('show')
}
