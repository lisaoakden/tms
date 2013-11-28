function moveSelect(source, destination){
  $(source).find(':selected').each(function(){
    $(destination).append($(this).clone());
    $(this).remove();
  });
}
function selectAll(source){
  $(source).find('option').each(function(){
    $(this).attr('selected', 'selected');
  });
}
$(function(){
  $('#user_list_form').on('submit', function(){
    selectAll($('#trainee_ids'));
  });
  $('#left').click(function(){
    moveSelect($('#select_trainee_ids'), $('#trainee_ids'));
  });
  $('#right').click(function(){
    moveSelect($('#trainee_ids'), $('#select_trainee_ids'));
  });
});
