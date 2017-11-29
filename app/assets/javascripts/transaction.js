$.fn.extend({
  asInteger: function (attributes) {
    var subdivision = attributes.subdivision;
    var quantity_display = $(this);
    var quantity = $(attributes.actual);

    var updateQuantity = function () {
      input_quantity = parseFloat($(this).val());
      integer_value = input_quantity * Math.pow(10, subdivision);
      quantity.val(integer_value);
    }

    quantity_display.on("change", updateQuantity);
  }
});

$(document).on('turbolinks:load', function () {
  if (typeof subdivision !== 'undefined') {
    $('#destination_quantity_display').asInteger({
      actual: '#destination_quantity',
      subdivision: subdivision
    });
  }
});
