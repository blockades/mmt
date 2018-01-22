$(document).on('turbolinks:load', function () {
  $("#transactionsSelect").on("propertychange change keyup", function (e) {
    $(this).closest("form").submit();
  });
});
