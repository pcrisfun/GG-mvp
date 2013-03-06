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
//= require jquery_ujs
//= require masonry/jquery.masonry.min
//= require jquery.cookie
//= require bootstrap
//= require bootstrap-tooltip
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require jquery.tokeninput
//= require rails.validations
//= require fancybox
//= require_tree .




$(document).ready(function () {
	//$("[data-behaviour~='datepicker']").datepicker({"autoclose": true, "date-format": 'mm/dd/yyyy'});
  $("[data-behaviour~='datepicker']").datepicker({
        format: 'mm/dd/yyyy'
    })
  .on('changeDate', function(ev){
    $("[data-behaviour~='datepicker']").datepicker('hide');
  });
	$("[data-behaviour~='timepicker']").timepicker();
  $("[rel=tooltip]").tooltip();
  $("[rel=popover]").popover({"trigger": 'focus'});
  $("a.fancybox").fancybox();
  $('#apprenticeship_skill_list').tokenInput('/event_skills.json', { crossDomain: false, allowCustomEntry : true, theme: 'facebook', prePopulate: $('#apprenticeship_skill_list').data('pre'), hintText: "Separate each with a comma" });
  $('#apprenticeship_requirement_list').tokenInput('/event_requirements.json', { crossDomain: false, 'allowCustomEntry' : true, theme: 'facebook', prePopulate: $('#apprenticeship_requirement_list').data('pre'), hintText: "Separate each with a comma" });
  $('#apprenticeship_tool_list').tokenInput('/event_tools.json', { crossDomain: false, 'allowCustomEntry' : true,  theme: 'facebook', prePopulate: $('#apprenticeship_tool_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_skill_list').tokenInput('/event_skills.json', { crossDomain: false, allowCustomEntry : true, theme: 'facebook', prePopulate: $('#workshop_skill_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_requirement_list').tokenInput('/event_requirements.json', { crossDomain: false, 'allowCustomEntry' : true, theme: 'facebook', prePopulate: $('#workshop_requirement_list').data('pre'), hintText: "Separate each with a comma" });
  $('#workshop_tool_list').tokenInput('/event_tools.json', { crossDomain: false, 'allowCustomEntry' : true,  theme: 'facebook', prePopulate: $('#workshop_tool_list').data('pre'), hintText: "Separate each with a comma" });
});