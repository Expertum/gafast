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
});


function start_progress() {
  NProgress.configure({ ease: 'ease', speed: 150000 });
  NProgress.configure({ trickleRate: 0.02, trickleSpeed: 5400 });
  NProgress.start();
}

$(document).on("ajax:succes", "a", function(data){
    $(data.id).remove();
});

function sh_modal_ch(n,t,c,p) {
   $('#ch_count_st').text(c);
   $('#ch_text').text(t);

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


