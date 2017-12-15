var WithdrawlRequests = function () {
  $("#coinSelect").on("change", function () {
    var anchor = $("#withdrawLink");
    var href = "/coins/" + $(this).find("option:selected").val() + "/withdrawl_requests/new";
    anchor.attr("href", href);
  });
}

var NewWithdrawlRequest = function (coin) {
  var btcRate = coin.btc_rate;
  var subdivision = coin.subdivision;

  var updateFields = function () {
    $("#rate").val(btcRate);
    var qDisplay = quantityDisplay.val();
    quantityDisplay.val(parseFloat(qDisplay).toFixed(subdivision));
    quantity = qDisplay * Math.pow(10, subdivision);
    $("#quantity").val(quantity);
  }

  var quantityDisplay = $("#quantityDisplay");

  $.each([quantityDisplay], function () {
    $(this).on("change", updateFields);
  });
}
