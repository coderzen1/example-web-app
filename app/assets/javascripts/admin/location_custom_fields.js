$(function() {
  var customFieldCounter = 0;
  $('.js-add-custom-field').click(function(e) {
    e.preventDefault();
    customFieldCounter = $('.js-field').length;
    if (customFieldCounter < 4) {
      var $customField = $('.js-add-field-input');
      var input =
        '<div class="js-field custom-field__item">' +
        '<div class="form-input">' +
        '<div class="ptv-grid__column-1">' +
        '<label class="form-input__label custom-field__item-label" for="location_custom_fields">' +
        'Custom fields' +
        '</label>' +
        '</div>' +
        '<div class="ptv-grid__column-2">' +
        '<input name="location[custom_fields][]" value="' +
        $customField.val() +
        '" id="location_custom_fields" class="form-input__field form-input__field--large custom-field__item-field" type="text">' +
        '<a class="js-remove-custom-field form-input__button--remove custom-fields__button-remove" href=""><img src="/x.svg" /></a>' +
        '</div>' + // end column-2
        '</div>' + //end form-input
        '</div>';
      var $customFieldsDiv = $('.js-custom-fields');
      if ($customField.val() !== '') {
        $customFieldsDiv.append(input);
        $customField.val('');
      }
    }
  });

  $('.js-custom-fields').on('click', '.js-remove-custom-field', function(e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).parents('.js-field').remove();
  });

  // Add datepicker to book vehicle page, above custom fields on page
  var datepicker = new Pikaday({
    field: $('.js-datepicker')[0]
  });
});
