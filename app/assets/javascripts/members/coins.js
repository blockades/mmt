var getCoin = function (id, callback) {
  $.ajax({ url: "/coins/" + id, type: "GET", dataType: "json", success: callback })
}

var MemberTotal = function () {
  var changeTotalSelect = function () {
    var id = $(this).find("option:selected").val()
    new getCoin(id, changeTotal);
  }

  var changeTotal = function (coin) {
    memberTotal = parseFloat(coin.member_total_display).toFixed(coin.subdivision);
    $("#totalDisplay").val(memberTotal);
  }

  $("#totalSelect").on("propertychange change keyup", changeTotalSelect)
}

$(document).on("turbolinks:load", function () {
  new MemberTotal;
});
