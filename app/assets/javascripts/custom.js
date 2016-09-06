$(document).on('turbolinks:load', function() {
  $('#check_all').on('click', 'input[type=checkbox]', function() {
    //resetChecked();
    if($(this).prop('checked') === 'checked' || $(this).prop('checked')){
      checkAll();
    }
    else{
      unCheckAll();
    }
  });
  $('.single-label').on('click', 'input[type=checkbox]', function() {
    $('#check_all > input[type=checkbox]').prop('checked', false);
  });
});

function checkAll(){
  $('tbody').find('label.single-label > input[type=checkbox]').each(function() {
    $(this).prop('checked', true);
  });
}

function unCheckAll(){
  $('tbody').find('label.single-label > input[type=checkbox]').each(function() {
    $(this).prop('checked', false);
  });
}

/*

$('tbody').find('label.mt-checkbox > input[type=checkbox]').each(function() {
  toggleCheckBox($(this));
});

*/
