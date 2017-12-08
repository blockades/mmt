var AdminsCoins = function () {
  var changeTotalSelect = function () {
    var id = $(this).find("option:selected").val()
    getCoin(id, changeTotal);
  }

  var changeTotal = function (coin) {
    $("#systemTotalDisplay").val(coin.as_system_total);
  }

  var getCoin = function (id, callback) {
    $.ajax({ url: "/admins/coins/" + id, type: "GET", dataType: "json", success: callback })
  }

  $("#systemTotalSelect").on("change", changeTotalSelect)
}
