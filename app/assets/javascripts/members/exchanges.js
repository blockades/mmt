var Exchange = function (coin) {
  var destinationRate = coin.btc_rate;
  var destinationSubdivision = coin.subdivision;

  var sourceCoinId = function () {
    return sourceCoinSelect.find("option:selected").val();
  }

  var calculateDisplay = function (quantity, subdivision) {
    return (Math.round(quantity / Math.pow(10, subdivision) * Math.pow(10, subdivision)) / Math.pow(10, subdivision)).toFixed(subdivision);
  }

  var calculateSource = function (sourceCoin) {
    var sourceSubdivision = sourceCoin.subdivision;
    var sourceRate = sourceCoin.btc_rate;
    var destinationQuantity = $("#destinationQuantity").val();
    var destinationQuantityDisplay = calculateDisplay(destinationQuantity, destinationSubdivision);
    var quantityInBtc = (destinationQuantity * destinationRate) * Math.pow(10, 8 - destinationSubdivision);
    var sourceQuantity = (quantityInBtc / sourceRate) / Math.pow(10, 8 - sourceSubdivision);
    var sourceQuantityDisplay = calculateDisplay(sourceQuantity, sourceSubdivision);

    updateQuantity(sourceQuantity, destinationQuantity);
    updateQuantityDisplay(sourceQuantityDisplay, destinationQuantityDisplay);
    updateRate(sourceRate);
  }

  var calculateDestination = function (sourceCoin) {
    var sourceSubdivision = sourceCoin.subdivision;
    var sourceRate = sourceCoin.btc_rate;
    var sourceQuantity = $('#sourceQuantity').val();
    var sourceQuantityDisplay = calculateDisplay(sourceQuantity, sourceSubdivision);
    var quantityInBtc = (sourceRate * sourceQuantity) * Math.pow(10, 8 - sourceSubdivision);
    var destinationQuantity = (quantityInBtc / destinationRate) / Math.pow(10, 8 - destinationSubdivision);
    var destinationQuantityDisplay = calculateDisplay(destinationQuantity, destinationSubdivision);

    updateQuantity(sourceQuantity, destinationQuantity);
    updateQuantityDisplay(sourceQuantityDisplay, destinationQuantityDisplay);
    updateRate(sourceRate);
  }

  var updateQuantity = function (sourceQuantity, destinationQuantity) {
    $("#sourceQuantity").val(sourceQuantity);
    $("#destinationQuantity").val(destinationQuantity);
  }

  var updateQuantityDisplay = function (sourceQuantityDisplay, destinationQuantityDisplay) {
    $("#sourceQuantityDisplay").val(sourceQuantityDisplay);
    $("#destinationQuantityDisplay").val(destinationQuantityDisplay);
  }

  var updateRate = function (sourceRate) {
    $("#sourceRate").val(sourceRate);
  }

  var sourceCoinSelect = $('#sourceCoinSelect');
  var sourceQuantity = $('#sourceQuantity');
  var destinationQuantity = $('#destinationQuantity');

  $.each([destinationQuantity], function () {
    $(this).on("change", function () {
      var sourceCoin = sourceCoinId();
      if (destinationQuantity.val() <= 0 || !sourceCoin || /^\s*$/.test(sourceCoin)) { return; }
      new getCoin(sourceCoin, calculateSource);
    });
  });

  $.each([sourceCoinSelect, sourceQuantity], function () {
    $(this).on("change", function () {
      var sourceCoin = sourceCoinId();
      if (sourceQuantity.val() <= 0 || !sourceCoin || /^\s*$/.test(sourceCoin)) { return; }
      new getCoin(sourceCoin, calculateDestination);
    });
  });
}
