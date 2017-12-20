var getAdminCoin = function (id, callback) {
  $.ajax({ url: "/admins/coins/" + id, type: "GET", dataType: "json", success: callback })
}

var SystemTotal = function () {
  var changeTotalSelect = function () {
    var id = $(this).find("option:selected").val()
    new getAdminCoin(id, changeTotal);
  }

  var changeTotal = function (coin) {
    systemTotal = parseFloat(coin.system_total_display).toFixed(coin.subdivision);
    $("#systemTotalDisplay").val(systemTotal);
  }

  $("#systemTotalSelect").on("change", changeTotalSelect)
}

$(document).on("turbolinks:load", function () {
  new SystemTotal;
});
