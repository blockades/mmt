var Dashboard = function () {
  $(".tab").on("click", function () {
    var selector = $(this).data("selector");
    $(".tab").removeClass("active");
    $(this).addClass("active");
    $(".dashboard-widgets").children().addClass("hidden");
    $("#" + selector).removeClass("hidden");
  });

  $("#transactionsSelect").on("propertychange change keyup", function (e) {
    $(this).closest("form").submit();
  });
}

$(document).on("turbolinks:load", Dashboard);
