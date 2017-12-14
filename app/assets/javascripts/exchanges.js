var Exchange = function (coin) {
  var destinationRate = coin.btc_rate;
  var destinationSubdivision = coin.subdivision;

  var getCoin = function (id, callback) {
    $.ajax({ url: "/coins/" + id, type: "GET", dataType: "json", success: callback });
  }

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
    updateFields(sourceQuantity, destinationQuantity, sourceQuantityDisplay, destinationQuantityDisplay, sourceRate);
  }

  var calculateDestination = function (sourceCoin) {
    var sourceSubdivision = sourceCoin.subdivision;
    var sourceRate = sourceCoin.btc_rate;
    var sourceQuantity = $('#sourceQuantity').val();
    var sourceQuantityDisplay = calculateDisplay(sourceQuantity, sourceSubdivision);
    var quantityInBtc = (sourceRate * sourceQuantity) * Math.pow(10, 8 - sourceSubdivision);
    var destinationQuantity = (quantityInBtc / destinationRate) / Math.pow(10, 8 - destinationSubdivision);
    var destinationQuantityDisplay = calculateDisplay(destinationQuantity, destinationSubdivision);
    updateFields(sourceQuantity, destinationQuantity, sourceQuantityDisplay, destinationQuantityDisplay, sourceRate);
  }

  var updateFields = function (sourceQuantity, destinationQuantity, sourceQuantityDisplay, destinationQuantityDisplay, sourceRate) {
    $("#sourceQuantity").val(sourceQuantity);
    $("#sourceQuantityDisplay").val(sourceQuantityDisplay);
    $("#sourceRate").val(sourceRate);
    $("#destinationQuantity").val(destinationQuantity);
    $("#destinationQuantityDisplay").val(destinationQuantityDisplay);
  }

  var sourceCoinSelect = $('#sourceCoinSelect');
  var sourceQuantity = $('#sourceQuantity');
  var destinationQuantity = $('#destinationQuantity');

  $.each([destinationQuantity], function () {
    $(this).on("change", function () {
      var sourceCoin = sourceCoinId();
      if (destinationQuantity.val() <= 0 || !sourceCoin || /^\s*$/.test(sourceCoin)) { return; }
      getCoin(sourceCoin, calculateSource);
    });
  });

  $.each([sourceCoinSelect, sourceQuantity], function () {
    $(this).on("change", function () {
      var sourceCoin = sourceCoinId();
      if (sourceQuantity.val() <= 0 || !sourceCoin || /^\s*$/.test(sourceCoin)) { return; }
      getCoin(sourceCoin, calculateDestination);
    });
  });
}

