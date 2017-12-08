var Exchange = function (coin) {
  // baseSubdivision == Coin::BTC_SUBDIVISION == 8
  baseSubdivision = coin.base_subdivision;

  destinationRate = coin.btc_rate;
  destinationSubdivision = coin.subdivision;

  var updateFields = function (sourceCoin) {
    var sourceSubdivision = sourceCoin.subdivision;
    var sourceRate = sourceCoin.btc_rate;
    var sourceQuantityDisplay = $('#sourceQuantityDisplay').val();

    var quantityInBtc = sourceRate * sourceQuantityDisplay;
    var destinationQuantityDisplay = quantityInBtc / destinationRate;

    if (!sourceCoin.crypto_currency) {
      destinationQuantityDisplay = (destinationQuantityDisplay * Math.pow(10, sourceSubdivision)) / Math.pow(10, sourceSubdivision);
    } else if (!coin.crypto_currency) {
      destinationQuantityDisplay = Math.round(destinationQuantityDisplay * 100) / 100;
    }

    var sourceQuantity = (destinationQuantityDisplay * destinationRate) / sourceRate;
    var sourceQuantityDisplay = Math.round(sourceQuantity * Math.pow(10, sourceSubdivision)) / Math.pow(10, sourceSubdivision);
    var sourceQuantity = sourceQuantity * Math.pow(10, sourceSubdivision);
    var destinationQuantity = destinationQuantityDisplay * Math.pow(10, destinationSubdivision);
    $('#sourceQuantityDisplay').val(sourceQuantityDisplay);
    $('#sourceQuantity').val(sourceQuantity);
    $('#destinationQuantityDisplay').val(destinationQuantityDisplay);
    $('#destinationQuantity').val(destinationQuantity);
    $('#sourceRate').val(sourceRate);
  }

  var sourceCoinSelect = $('#sourceCoinSelect');
  var sourceQuantityDisplay = $('#sourceQuantityDisplay');

  $.each([sourceCoinSelect, sourceQuantityDisplay], function () {
    $(this).on("change", function () {
      var sourceCoinId = sourceCoinSelect.find("option:selected").val();
      var quantity = sourceQuantityDisplay.val();
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

