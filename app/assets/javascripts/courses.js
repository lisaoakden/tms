$(function() {
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