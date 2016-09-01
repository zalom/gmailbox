$(document).on('turbolinks:load', function() {
  $('#check_all').on('click', 'input[type=checkbox]', function() {
    $('tbody').find('label.mt-checkbox > input[type=checkbox]').each(function() {
      toggleCheckBox($(this));
    });
  });
});

function toggleCheckBox(et){
  et.prop('checked') === 'checked' || et.prop('checked') ? et.prop('checked', false) : et.prop('checked', true);
}
