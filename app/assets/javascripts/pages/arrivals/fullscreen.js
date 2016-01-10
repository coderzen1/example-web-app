$(function() {

  $('.js-button-fullscreen').on('click', function() {
    if (!screenfull.enabled) {
      return;
    }

    screenfull.toggle();

    document.addEventListener(screenfull.raw.fullscreenchange, function() {
      console.log('Is app in fullscreen mode? ' + (screenfull.isFullscreen ? 'Yes' : 'No'));
    });

    document.addEventListener(screenfull.raw.fullscreenerror, function(event) {
      console.error('Failed to enable fullscreen', event);
    });
  });

});
