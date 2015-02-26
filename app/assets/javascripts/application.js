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
