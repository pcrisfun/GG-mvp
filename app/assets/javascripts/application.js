// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-migrate-min
//= require jquery_ujs
//= require jquery.ui.sortable
//= require jquery.cookie
//= require bootstrap
//= require bootstrap-tooltip
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require jquery.tokeninput
//= require rails.validations
//= require rails.validations.simple_form
//= require fancybox
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require masonry/jquery.masonry.min
//= require masonry/jquery.imagesloaded.min
//= require masonry/modernizr-transitions
//= require bootstrap-editable/bootstrap-editable
//= require select2
//= require moment
//= require jquery.hashchange.min
//= require jquery.easytabs.min
//= require_tree .




$(document).ready(function () {
  $("[data-behaviour~='datepicker']").datepicker({
    format: 'mm/dd/yyyy',
    onClose: function(dateText, inst) { $(inst.input).change().focusout(); },
    changeMonth: true,
    changeYear: true
  }).on('changeDate', function(ev) {
    var inputs = $(this).closest('form').find(':input');
    inputs.eq( inputs.index(this)+ 1 ).focus();
    $(this).datepicker('hide');
  });

  $("[data-behaviour~='timepicker']").timepicker();
  $("[data-behaviour~='combodate']").combodate({ minYear: 1920, firstItem: 'none' });
  $("[rel=tooltip]").tooltip();
  $("[rel=popover]").popover({trigger: 'hover'});
  //$("[rel=popover]").popover({'trigger': 'trigger'});
  //$("[rel=popover]").click(function(e) {
  //   e.preventDefault();
  //   $(this).focus();
  // });
  $("a.fancybox").fancybox();
  $('#apprenticeship_skill_list').tokenInput('/event_skills.json', { crossDomain: false, allowCustomEntry : true, theme: 'facebook', prePopulate: $('#apprenticeship_skill_list').data('pre'), hintText: "Separate each with a comma" });
  $('#apprenticeship_requirement_list').tokenInput('/event_requirements.json', { crossDomain: false, 'allowCustomEntry' : true, theme: 'facebook', prePopulate: $('#apprenticeship_requirement_list').data('pre'), hintText: "Separate each with a comma" });
  $('#apprenticeship_tool_list').tokenInput('/event_tools.json', { crossDomain: false, 'allowCustomEntry' : true,  theme: 'facebook', prePopulate: $('#apprenticeship_tool_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_skill_list').tokenInput('/event_skills.json', { crossDomain: false, allowCustomEntry : true, theme: 'facebook', prePopulate: $('#workshop_skill_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_requirement_list').tokenInput('/event_requirements.json', { crossDomain: false, 'allowCustomEntry' : true, theme: 'facebook', prePopulate: $('#workshop_requirement_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_tool_list').tokenInput('/event_tools.json', { crossDomain: false, 'allowCustomEntry' : true,  theme: 'facebook', prePopulate: $('#workshop_tool_list').data('pre'), hintText: "Separate each with a comma" });
  $('.rotating-testimonials').easytabs({ animationSpeed: 400, updateHash: false, cycle: 9000 });

  $("form").on("keypress", function (e) {
      if (e.keyCode == 13) {
          return false;
      }
  });

});

$(function() {
  $('#workshop_price').keyup(function() {
    var total = Math.round($(this).val() * 1.2 * 100)/100;
    $('#workshop_total_price').text(isNaN(total) ? "" : ("" + total));
  }).keyup();
});
