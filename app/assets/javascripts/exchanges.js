$(document).on('turbolinks:load', function () {
  var cost = 0;
  var exchange_rate = 0.0;
  var source_coin_select = $('#source_coin_select');

  var destination_quantity = $('#destination_quantity');
  var destination_quantity_display = $('#destination_quantity_display');
  var destination_rate = $('#destination_rate');

  var source_rate_display = $('#source_rate_display');
  var source_rate = $('#source_rate');
  var source_quantity_display = $('#source_quantity_display');
  var source_quantity = $('#source_quantity');

  var calculateCost = function (coin) {
    var btc_to_destination_coin_rate = parseFloat(destination_rate.text());
    exchange_rate = parseFloat(coin.btc_rate);
    var quantity = parseFloat(destination_quantity_display.val());
    var quantity_in_btc = btc_to_destination_coin_rate * quantity;
    cost = quantity_in_btc / exchange_rate;
    $.each([source_quantity_display], updateCost);
    source_quantity.val(cost * Math.pow(10, coin.coin.subdivision));
    $.each([source_rate_display, source_rate], updateRate);
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
        success: calculateCost
      });
    });
  });
});
