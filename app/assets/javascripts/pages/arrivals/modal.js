modulejs.define('modal', function() {

  var $modal;
  var TRANSITION_END_EVENT = 'ontransitionend' in window ? 'transitionend' : null;
  if (!TRANSITION_END_EVENT) {
    TRANSITION_END_EVENT = 'onwebkittransitionend' in window ? 'webkitTransitionEnd' : null;
  }

  function _onTransitionEnd(el, clb) {
    $(el).one(TRANSITION_END_EVENT, function(ev) {
      ev.stopPropagation();
      clb(ev);
    });
  }

  // Properly done open/close animation. Opened class should only do "display: none/block" and the animation should be done with animateClass.
  // Will not work if element doesn't have transition set. Returns a promise to catch animation end.
  function _animateOpenClose($el, inOpenedClass, inAnimateClass, fallbackAnimationTime, forceTimeout) {
    var openedClass = inOpenedClass || 'opened';
    var animateClass = inAnimateClass || 'animate-open';

    return new Promise(function(resolve) {
      if ($el.hasClass(openedClass)) {
        $el.removeClass(animateClass);
        _onTransitionEnd($el[0], function() {
          $el.removeClass(openedClass);
          resolve($el);
        }, fallbackAnimationTime, forceTimeout);
      } else {
        $el.addClass(openedClass);
        setTimeout(function() {
          $el.addClass(animateClass);
          resolve($el);
        }, 50);
      }
    });
  }

  function _openClose() {
    return _animateOpenClose($modal, 'is-shown', 'is-showing');
  }

  function show() {
    $modal = $('#modal');
    return !$modal.hasClass('is-shown') ? _openClose().then(function() {
      $modal.trigger('modal:show');
    }) : Promise.resolve();
  }

  function hide() {
    return $modal.hasClass('is-shown') ? _openClose().then(function() {
      $modal.html('');
      $modal.trigger('modal:hide');
    }) : Promise.resolve();
  }

  return {
    show: show,
    hide: hide
  };
});
