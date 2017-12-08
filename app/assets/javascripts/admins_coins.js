var AdminsCoins = function () {
  var changeTotalSelect = function () {
    var id = $(this).find("option:selected").val()
    getCoin(id, changeTotal);
  }

  var changeTotal = function (coin) {
    systemTotal = parseFloat(coin.as_system_total).toFixed(coin.subdivision);
    $("#systemTotalDisplay").val(systemTotal);
  }

  var getCoin = function (id, callback) {
    $.ajax({ url: "/admins/coins/" + id, type: "GET", dataType: "json", success: callback })
  }

  $("#systemTotalSelect").on("change", changeTotalSelect)
}
