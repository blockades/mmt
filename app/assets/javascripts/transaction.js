var QuantityAsDecimal = function (attributes) {
  var quantity = $(attributes.quantity);
  var display = $(attributes.display);
  var subdivision = attributes.coin.subdivision;

  var updateQuantityDisplay = function () {
    display.val((quantity.val() / Math.pow(10, subdivision)).toFixed(subdivision));
  }

  quantity.on('change', updateQuantityDisplay);
}
