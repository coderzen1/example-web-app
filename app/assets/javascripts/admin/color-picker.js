$(function() {

  function Color(r, g, b, a) {
    this.r = r;
    this.b = b;
    this.g = g;
    this.a = typeof a === 'number' ? a : 1;
  }

  Color.prototype.toString = function() {
    var r = Math.round(this.r);
    var g = Math.round(this.g);
    var b = Math.round(this.b);
    var a = this.a;

    if (a === 1) {
      return "rgb(" + r + ", " + g + ", " + b + ")";
    }
    else {
      return "rgba(" + r + ", " + g + ", " + b + ", " + a + ")";
    }
  };


  Color.prototype.add = function(color) {
    var a = color.a;

    return new Color(
      (1 - a) * this.r + a * color.r,
      (1 - a) * this.g + a * color.g,
      (1 - a) * this.b + a * color.b
    );
  };


  function findRGB(haystack) {
    var match = /([\d]{1,3})[^\d]+([\d]{1,3})[^\d]+([\d]{1,3})/.exec(haystack);

    return match && new Color(
      parseInt(match[1], 10),
      parseInt(match[2], 10),
      parseInt(match[3], 10)
    );
  }

  function calculate_color() {
    var $colorInput = $('.js-company-dashboard-colors');
    if ($colorInput) {
      var inputColor = findRGB($colorInput.val());
      if (inputColor) {
        rgba = inputColor;
        rgba.a = 1;
      }

      var bgColor = findRGB('rgb(255, 255, 255)');
      if (bgColor) {
        bg = bgColor;
      }
      if (inputColor) {
        rgba.a = 0.75;
        rgb = bg.add(rgba);
        $('.js-second-dashboard-color').val(rgb);

        rgba.a = 0.5;
        rgb = bg.add(rgba);
        $('.js-third-dashboard-color').val(rgb);
      }
    }
  }
  var chosenColor;


  function insertThemeColor(color) {
    $('.js-dashboard-color-code').text(chosenColor);
    $('.js-dashboard-display-column .form-input--dashboard-display-column').css('background-color', color);
    $('.js-company-dashboard-colors input').attr('value', color);
    calculate_color();
  }

  $('.js-company-dashboard-colors').spectrum({
    preferredFormat: 'rgb',
    color: themeColor,
    showInput: true,
    allowEmpty: true,
    showButtons: true,
    showPalette: true,
    palette: [themeColor],
    replacerClassName: 'form-input__color-picker-box',
    beforeShow: function(color) {
      $('.js-dashboard-color-code').spectrum('show');
    },
    change: function(color) {
      chosenColor = color.toHexString();
      insertThemeColor(chosenColor);
    }
  });

  insertThemeColor(themeColor);

});
