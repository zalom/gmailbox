$(document).on('turbolinks:load', function() {
   $('label.mt-checkbox').on('click', 'input[type=checkbox]', function(event){
      toggleCheckBox($(event.target));
   });
});

function toggleCheckBox(et){
  var attr = et.attr('checked');
  if (typeof attr !== typeof undefined) {
   et.removeAttr('checked');
  }
  else{
    et.attr('checked', true);
  }
}
