var Exchange = function (coin) {
  // baseSubdivision == Coin::BTC_SUBDIVISION == 8
  baseSubdivision = coin.base_subdivision;

  destinationRate = coin.btc_rate;
  destinationSubdivision = coin.subdivision;

  var updateFields = function (sourceCoin) {
    var sourceSubdivision = sourceCoin.subdivision;
    var sourceRate = sourceCoin.btc_rate;

    var destinationQuantity = $('#destinationQuantityDisplay').val();

    var quantityInBtc = destinationRate * destinationQuantity;
    var cost = quantityInBtc / sourceRate;

    if (!sourceCoin.crypto_currency)
      cost = Math.round(cost * Math.pow(10, sourceSubdivision)) / Math.pow(10, sourceSubdivision);

    destinationQuantity = (cost * sourceRate) / destinationRate;
    $('#destinationQuantityDisplay').val(destinationQuantity);
    $('#destinationQuantity').val(cost * Math.pow(10, destinationSubdivision));
    var assets = sourceCoin.assets / Math.pow(10, sourceSubdivision);
    $('.balance').text(assets + " " + sourceCoin.code);
    $("#destinationQuantityDisplay").attr({max: assets * sourceRate / destinationRate});
    $('#sourceQuantityDisplay').val(cost);
    $('#sourceQuantity').val(cost * Math.pow(10, sourceSubdivision));
    $('#destinationQuantity').val(destinationQuantity * Math.pow(10, destinationSubdivision));
    $('#sourceRate').val(sourceRate);
  }

  var sourceCoinSelect = $('#source_coin_select');
  var destinationQuantityDisplay = $('#destinationQuantityDisplay');

  $.each([sourceCoinSelect, destinationQuantityDisplay], function () {
    $(this).on("change", function () {
      var sourceCoinId = sourceCoinSelect.find("option:selected").val();
      var quantity = destinationQuantityDisplay.val();
      if (quantity <= 0 || !sourceCoinId || /^\s*$/.test(sourceCoinId)) { return; }
      $.ajax({
        url: "/coins/" + sourceCoinId,
        type: "GET",
        dataType: "json",
        success: updateFields
      });
    });
  });
}

