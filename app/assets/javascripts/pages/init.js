$(function() {
  var PAGES = {
    'arrivals': 'pages/arrivals/index',
    'truck-arrivals': 'pages/arrivals/show'
  };

  var pageName = $('.js-page').data('page-name');
  if (pageName && pageName in PAGES) {
    modulejs.require(PAGES[pageName]);
  }
});
