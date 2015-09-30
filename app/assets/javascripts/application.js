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

(function worker() {
  $.ajax({
    url: "/news",
    type: 'GET',
    success: function(data) {
      $('#alert_read').show();
    },
    complete: function() {
      // Schedule the next request when the current one's complete
      setTimeout(worker, 5000);
    }
  });
})();
 
});

function find_read() {
      $('#alert_read').animate({opacity: "show"}, 1000);
      $('#alert_read').animate({opacity: "hide"}, 1000);
}

function start_progress() {
  NProgress.configure({ ease: 'ease', speed: 15000 });
  NProgress.configure({ trickleRate: 0.02, trickleSpeed: 3400 });
  NProgress.start();
}

$(document).on("ajax:succes", "a", function(data){
    $(data.id).remove();
});

 

function sh_button() {

   var t = $('#storage_good_minus');
   var cs = $('#ch_count_st').text();

   t.val(t.val().replace(/,/g,"."));

   if ( $.isNumeric(t.val()) && t.val() > 0) { $('#button_to_check').show();} else {$('#button_to_check').hide();}
   if ( ((parseFloat(cs) - parseFloat(t.val())) >= 0) && (t.val() > 0 )) { $('#button_to_check').show();} else {$('#button_to_check').hide();}

   //alert($.isNumeric(t) );
   
}



