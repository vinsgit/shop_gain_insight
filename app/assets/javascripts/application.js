//= require jquery3
//= require jquery_ujs
//= require flatpickr
//= require nested_form_fields
//= require select2
//= require bootstrap.min

$(document).ready(function(){
  flatpickr('.flatpickr');
});

$(document).on('change', '.current-shop', function(){
  let selectedValue = $(this).val();
  $.ajax({
    type: 'POST',
    url: '/set_current_shop',
    data: { shop_id: selectedValue }
  });
})