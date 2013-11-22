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