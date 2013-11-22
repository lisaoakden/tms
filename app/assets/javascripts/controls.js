$(function() {
  $("a.non-redirect").click(function(event){
    event.preventDefault();
  });

  $('.date-field').datepicker({ 
    nextText: '',
    prevText: '',
    dateFormat: 'dd/mm/yy'
  });
})