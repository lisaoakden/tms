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
  $('#trainee_list_form').on('submit', function(){
    selectAll($('#trainee_ids'));
    return true;
  });
  $('body').on("click", '#left', function(){
    moveSelect($('#select_trainee_ids'), $('#trainee_ids'));
  });
  $('body').on("click", '#right', function(){
    moveSelect($('#trainee_ids'), $('#select_trainee_ids'));
  });
});
