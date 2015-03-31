// This file is included in all sites and subsites.  This is a
// manifest file that'll be compiled into including all the files
// listed below.  Add new JavaScript/Coffee code in separate files in
// the application directory and they'll automatically be included.
// It's not advisable to add code directly here, but if you do, it'll
// appear at the bottom of the the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ./application
//= require nprogress
//= require nprogress-turbolinks


$(document).ready(function() {
  $('input.import_submit').attr('onclick','start_progress()');
  $('#myModal').on('hidden.bs.modal', function (e) {
  //alert($('#zakaz'))
  //$.put('/storages/del_check');
  var id_good = $('#ch_id').text();
  //alert(id_good)
  if ( $('#zakaz').is(":visible") == false ) { $.ajax({
                                                 url: "/storages/del_check",
                                                 type: 'PUT',
                                                 data: {'nocheck': id_good}
                                                 });
                                               //location.reload();
                                                 $('#c'+id_good).children('.storage').children('#storage_check').prop( "checked", false );
                                               } 
})
});


function start_progress() {
  NProgress.configure({ ease: 'ease', speed: 15000 });
  NProgress.configure({ trickleRate: 0.02, trickleSpeed: 3400 });
  NProgress.start();
}

$(document).on("ajax:succes", "a", function(data){
    $(data.id).remove();
});

function sh_modal_ch(n,t,c,p,id) {
   $('#ch_count_st').text(c);
   $('#ch_text').text(t);
   $('#ch_id').text(id);

   $('#ch_cena_st').text(p);

   $('#storage_good_minus').val('');
   $('#storage_good_minus').focus();
   if ( $('#c'+n+' .boolean').is(':checked') ) { $('#myModal').modal('show');}
}

function sh_button() {
   var t = $('#storage_good_minus').val();
   var cs = $('#ch_count_st').text();

   if ( $.isNumeric(t) ) { $('#button_to_check').show();} else {$('#button_to_check').hide();}
   if ( parseFloat(cs) - parseFloat(t) >= 0) { $('#button_to_check').show();} else {$('#button_to_check').hide();}

   //alert($.isNumeric(t) );
   
}

function rem_li(id) {
 if ($('#list li').length < 1){ $('#list li').remove(); $('#zakaz').hide();}
 var summ = 0; 
 $.ajax({url: "/storages/del_check",
         type: 'PUT',
         data: {'nocheck': id}
        });

  $('#c'+id).children('.storage').children('#storage_check').prop( "checked", false );

  $("#list li").each(function() { summ += parseFloat(this.innerHTML.split('{')[1]); });
  $('#ch_summ').text('Загальна вартість товару - '+summ.toFixed(2)+' грн.');
  
 //alert(summ);
}

