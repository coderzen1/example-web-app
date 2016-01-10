$(function() {

  var $logoInput = $('#company_logo');
  var $logoImage = $('.logo-image');

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        $logoImage.attr('src', e.target.result);
      };

      reader.readAsDataURL(input.files[0]);
    }
  }

  $logoInput.change(function() {
    readURL(this);
  });
});
