// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .
$(function() {
	$('.date-field').datepicker({ 
		nextText: '',
		prevText: '',
		dateFormat: 'dd/mm/yy'
	});

  $('.subject').click(function() {
    if($(this).is(':checked')) {
      $(this).closest('tr').find('td.subject-duration').find('input').show();
      $(this).closest('tr').find('td.subject-tasks').find('ul').show();
    }
    else {
      $(this).closest('tr').find('td.subject-duration').find('input').hide();
      $(this).closest('tr').find('td.subject-tasks').find('ul').hide();
    }
  });
})

function moveSelect(source, destination) {
  $(source).find(":selected").each(function() {
    $(destination).append($(this).clone());
    $(this).remove();
  });
}
function selectAll(source) {
  $(source).find("option").each(function() {
    $(this).attr('selected', 'selected');
  });
}