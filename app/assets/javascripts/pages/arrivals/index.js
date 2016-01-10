modulejs.define('pages/arrivals/index', ['config', 'services/api', 'modal'], function(config, api, modal) {
  var $header;
  var $boardHeader;
  var $boardHistory;
  var $boardCurrent;

  function repositionBoard(scrollToStart) {
    var currentHeight = $boardCurrent.height();
    var boardHeaderBounding = $boardHeader.get(0).getBoundingClientRect();
    var availableHeight = window.innerHeight - boardHeaderBounding.bottom;
    var padding = Math.max(0, availableHeight - currentHeight);
    $boardCurrent.css('padding-bottom', padding);

    if (scrollToStart === true) { // Not truthy - can also be an event
      window.scrollTo(0, $boardHistory.height() - 5);
    }
  }

  function createLine(line) {
    var planned = moment(line.etas.plannedETA);
    var estimated = moment(line.etas.eta);
    var className = '';
    var arriveIn = estimated.fromNow();
    var diff = planned.diff(estimated);
    if (estimated.diff() < 0) {
      arriveIn = 'Arrived';
    }
    if (diff < 0) {
      className = 'board-line--late';
    } else if (diff > 0) {
      className = 'board-line--early';
    } else {
      estimated = null;
    }

    var customData = line.customData.notes || '';

    // custom modal classes to define which modals will pop up when clicked: 1. js-modal-item-pta
    var $line = $(
      '<div class="board__line board-line ' + className + '">' +
      '<div class="board-line__cell board-line__icon"></div>' +
      '<div class="board-line__cell board-line__main board-line__arrival js-modal-item">' +
      '<span>' +
      '<div class="board-line__planned">' + planned.format('HH:mm') + '</div>' +
      (estimated ? '<div class="board-line__estimated">' + estimated.format('HH:mm') + '</div>' : '') +
      '</span>' +
      '</div>' +
      '<div class="board-line__cell board-line__main board-line__arrive-in">' + arriveIn + '</div>' +
      '<div class="board-line__cell board-line__optional u-background-light">' + customData + '</div>' +
      '</div>'
    );

    return $line;
  }

  function prepareData(rawData) {
    var data = _.sortBy(rawData, function(line) {
      return new Date(line.etas.plannedETA);
    });
    return _.groupBy(data, function(line) {
      var eta = moment(line.etas.eta);
      if (eta.isBefore(moment().subtract(15, 'minutes'))) {
        return 'history';
      }
      return 'current';
    });

  }

  function updateData(initial) {
    var now = moment();
    $('.header__current-date-date').text(now.format('D MMMM YYYY'));
    $('.header__current-date-time').text(now.format('HH:mm'));

    api.getETAs()
      .then(function(data) {
        var lineData = prepareData(data);
        $boardHistory.empty().append(_.map(lineData.history, createLine));
        $boardCurrent.empty().append(_.map(lineData.current, createLine));
        repositionBoard(initial);
      }).fail(function(e) {
        console.log(e);
      });
  }

  $(function() {
    $header = $('.header');
    $boardHeader = $('.board__header');
    $boardHistory = $('.board__history');
    $boardCurrent = $('.board__current');
    var $arrivals = $('.arrivals');
    var $modalPage = $('.js-modal-page');

    $('.js-button-collapse').on('click', function() {
      $header.addClass('header--collapsed');
      $arrivals.addClass('arrivals--collapsed');
      repositionBoard(true);
    });

    $('.js-button-expand').on('click', function() {
      $header.removeClass('header--collapsed');
      $arrivals.removeClass('arrivals--collapsed');
      repositionBoard(true);
    });

    $(window).on('resize', _.throttle(repositionBoard, 200));

    setInterval(updateData, 60 * 1000);
    updateData(true);

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
