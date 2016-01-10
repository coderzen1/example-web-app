$(function() {
  // set header nav clock
  var clockDate = moment().format("Do MMMM YYYY");
  var clockTime = moment().format("H:mm");

  $('.header__current-date-date').html(clockDate);
  $('.header__current-date-time').html(clockTime);

  // header nav menu functions
  var mainMenuButton = '.js-nav-dropdown--main';
  var locationsButton = '.js-nav-dropdown--locations';
  var $navMainMenu = $('.nav-dropdown__menu--main');
  var $navLocationsDropdown = $('.nav-dropdown__menu--locations');

  function toggleMainMenu() {
    $navMainMenu.toggleClass('active');
    $('.nav-dropdown__menu-item--header').toggleClass('active');
    $('.nav-dropdown__menu-options').toggleClass('active');
  }

  function toggleLocationsMenu() {
    $navLocationsDropdown.toggleClass('active');
    $('.nav-dropdown__menu-item--location').toggleClass('active');
  }

  $(mainMenuButton).on('click', function() {
    if ($navLocationsDropdown.hasClass('active')) {
      toggleLocationsMenu();
    }

    toggleMainMenu();
  });

  $(locationsButton).on('click', function() {
    if ($navMainMenu.hasClass('active')) {
      toggleMainMenu();
    }

    toggleLocationsMenu();
  });

  $('body').on('click', function() {
    if ($navMainMenu.hasClass('active')) {
      toggleMainMenu();
    }

    if ($navLocationsDropdown.hasClass('active')) {
      toggleLocationsMenu();
    }
  });

  $('body').on('click', mainMenuButton, function(e) {
    e.stopPropagation();
  })

  $('body').on('click', locationsButton, function(e) {
    e.stopPropagation();
  })
});
