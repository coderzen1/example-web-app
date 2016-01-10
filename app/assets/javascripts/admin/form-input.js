$(function() {
  // add red border to inputs when error pops up on any screen
  if ($('.form-input__error')) {
    $('.form-input__error').prev().children().addClass('form-input__error-border');
  }
});
