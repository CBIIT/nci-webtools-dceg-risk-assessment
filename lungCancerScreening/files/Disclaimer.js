$( document ).ready(function() {
    createModal();
});
var template_string='<div class="modal fade" id="modal" tabindex="-1" role="dialog">'
  +'<div class="modal-dialog  modal-lg" role="document">'
    +'<div class="modal-content" >'
      +'<div class="modal-header">'
        +'<b><h2 class="modal-title" id="modalTitle">Modal title</h4></b>'
      +'</div>'
      +'<div class="modal-body"><div id ="container" >'
    
     +"These prediction tools are for researchers or general health information only. The prediction tools are not to be used as a substitute for medical advice, diagnosis, or treatment of any health condition or problem." 
     +" Users of the prediction tools should not rely on information provided by the prediction tools for their own health problems. Questions should be addressed to your own physician or other healthcare provider. " 
     +"You are hereby advised to consult with a physician or other professional healthcare provider prior to making any decisions, or undertaking any actions or not undertaking any actions related to any healthcare problem or issue you might have at any time, "
     +"now or in the future. Health related information changes frequently and therefore information contained in the prediction tools may be outdated, incomplete or incorrect."
      
      +'</div><button type="button" id="Agree" style="margin-left:45%;margin-top:1%;display:inline-block" data-dismiss="modal" \" >I understand</button>'
      +'</div></div></div></div>';

function createModal() {
	var header = "Disclaimer";
	$('body').append($(template_string));
	$('#modalTitle').html(header);
	$('#modal').modal({backdrop: 'static', keyboard: false}) 
	$('#modal').modal('show')
}
