modulejs.define('pages/arrivals/show', ['config', 'services/api', 'modal'], function(config, api, modal) {

  $(function() {
    var $header = $('.header');
    var $arrivals = $('.arrivals');
    var $modalPage = $('.js-modal-page');

    $('.js-button-collapse').on('click', function() {
      $header.addClass('header--collapsed');
      $arrivals.addClass('arrivals--collapsed');
    });

    $('.js-button-expand').on('click', function() {
      $header.removeClass('header--collapsed');
      $arrivals.removeClass('arrivals--collapsed');
    });

    // Modal click events. Any page with modals must have a div.js-modal-page class wrapping elements containing modals
    // And there must be an empty div#modal id at the bottom of the page which will be used to create the modal
    $modalPage.on('click', '.js-modal-item', function() {
      modal.show();
    });

    $modalPage.on('click', '.modal__close-button', function() {
      modal.hide();
    });

    $modalPage.on('click', '#modal', function(e) {
      modal.hide();
    });

    $modalPage.on('click', '.modal-content', function(e) {
      e.stopPropagation();
    });
  });
});
