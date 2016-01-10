$(function() {

  function reset_address_inputs(parent_div) {
    $(parent_div).find(".js-location-street").val("");
    $(parent_div).find(".js-location-zip-code").val("");
    $(parent_div).find(".js-location-number").val("");
  }

  function add_autocomplete($search_address) {
    var autocomplete = new google.maps.places.Autocomplete($search_address);
    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
      var parent_field = $(".js-address-fields");

      if (!place.geometry) {
        return;
      } else {
        reset_address_inputs(parent_field);
        $(parent_field).find(".js-location-longitude").val(place.geometry.location.lng());
        $(parent_field).find(".js-location-latitude").val(place.geometry.location.lat());

        place.address_components.forEach(function(component) {
          if (component.types.indexOf("route") != -1) {
            $(parent_field).find(".js-location-street").val(component.long_name);
          } else if (component.types.indexOf("postal_code") != -1) {
            $(parent_field).find(".js-location-zip-code").val(component.long_name);
          } else if (component.types.indexOf("street_number") != -1) {
            $(parent_field).find(".js-location-number").val(component.long_name);
          } else if (component.types.indexOf("locality") != -1) {
            $(parent_field).find(".js-location-city").val(component.long_name);
          }
        });
      }
    });
  }

  function initialize_search_address() {
    var $search_address = $('.js-search-address');
    add_autocomplete($search_address[0]);
  }

  initialize_search_address();
});
