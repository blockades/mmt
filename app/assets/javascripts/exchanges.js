$(document).on('turbolinks:load', function () {
  var cost = 0;
  var exchange_rate = 0.0;
  var source_coin_select = $('#source_coin_select');

  var destination_quantity = $('#quantity');
  var destination_quantity_display = $('#quantity_display');
  var destination_rate = $('#destination_rate');

  var source_rate_display = $('#source_rate_display');
  var source_rate = $('#source_rate');
  var source_quantity_display = $('#source_quantity_display');
  var source_quantity = $('#source_quantity');

  var updateFields = function (coin) {
    var btc_to_destination_coin_rate = parseFloat(destination_rate.text());
    exchange_rate = parseFloat(coin.btc_rate);
    var quantity = parseFloat(destination_quantity_display.val());
    var quantity_in_btc = btc_to_destination_coin_rate * quantity;
    cost = calculateCost(exchange_rate, quantity_in_btc);
    rounded = roundCost(cost, coin.coin.subdivision);
    if (!coin.coin.crypto_currency && rounded != cost) {
      // Round up to 2 decimal places and readjust for fiat currencies
      cost = rounded;
      destination_cost = (cost * coin.btc_rate) / destination_rate.text();
      destination_quantity_display.val(destination_cost);
      destination_quantity.val(destination_cost * Math.pow(10, subdivision));
    }
    $.each([source_quantity_display], updateCost);
    source_quantity.val(cost * Math.pow(10, coin.coin.subdivision));
    $.each([source_rate_display, source_rate], updateRate);
  }

  var roundCost = function (cost, subdivision) {
    return Math.round(cost * 10**subdivision) / 10**subdivision;
  }

  var calculateCost = function (rate, quantity) {
    return quantity / exchange_rate;
  }

  var updateCost = function () {
    $(this).text(cost);
    $(this).val(cost);
  }

  var updateRate = function () {
    $(this).text(exchange_rate);
    $(this).val(exchange_rate);
  }

  $.each([source_coin_select, destination_quantity_display], function () {
    $(this).on('change', function () {
      var source_coin_id = source_coin_select.find('option:selected').val();
      var quantity = destination_quantity.val();
      if (!quantity || /^\s*$/.test(quantity) || !source_coin_id || /^\s*$/.test(source_coin_id)) { return; }
      $.ajax({
        url: "/coins/" + source_coin_id,
        type: "GET",
        dataType: "json",
        success: updateFields
      });
    });
  });
});
