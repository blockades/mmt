var getCoin = function (id, callback) {
  $.ajax({ url: "/coins/" + id, type: "GET", dataType: "json", success: callback })
}
