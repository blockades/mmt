var Dashboard = function () {
  $(".tab").on("click", function () {
    var attribute = $(this).data("attribute");
    $(".tab").removeClass("active");
    $(this).addClass("active");
    var visible = $("section[data-attribute=" + attribute + "]");
    var hidden = $(".dashboard-widgets").children("section");
    hidden.addClass("hidden");
    visible.removeClass("hidden");
  });

  var transactionSelect = $("#transactionSelect");
  var memberSelect = $("#memberSelect");
  $.each([transactionSelect, memberSelect], function () {
    $(this).on("propertychange change keyup", function (e) {
      $(this).closest("form").submit();
    });
  });
}

$(document).on("turbolinks:load", Dashboard);
