var WithdrawlRequest = function () {
  var updateFields = function (coin) {
    $("#rate").val(coin.btc_rate);
    var quantityDisplay = $("#quantityDisplay");
    var qDisplay = quantityDisplay.val();
    quantityDisplay.val(parseFloat(qDisplay).toFixed(coin.subdivision));
    quantity = qDisplay * Math.pow(10, coin.subdivision);
    $("#quantity").val(quantity);
  }

  var coinSelect = $("#coinSelect");
  var quantityDisplay = $("#quantityDisplay");

  $.each([coinSelect, quantityDisplay], function () {
    $(this).on("change", function () {
      var coinId = coinSelect.find("option:selected").val();
      if (!coinId) { coinId = Params.get("coin_id") }
      if (!coinId || /^\s*$/.test(coinId)) { return; }
      new getCoin(coinId, updateFields);
    });
  });
}
