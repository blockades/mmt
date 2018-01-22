var Allocation = function (coin) {
  var coinId = coin.id;

  var setPreviousTransactionId = function (transaction) {
    if (!transaction) return;
    $("#previousTransactionId").val(transaction.id);
  }

  var getTransaction = function () {
    var memberId = $(this).find("option:selected").val();
    if (!memberId) return;
    $.ajax({
      url: "/admins/allocate/" + coinId + "/prev",
      type: "GET",
      data: { allocation: { destination_id: memberId } },
      success: setPreviousTransactionId
    });
  }

  $("#systemAllocationSelect").on("propertychange change keyup", getTransaction);
}
