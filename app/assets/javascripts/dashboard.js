var Dashboard = function () {
  $(".switch").on("click", function (e) {
    e.preventDefault();
    var attribute = $(this).data("attribute");
    $(".tab").removeClass("active");
    var active = $(".tab[data-attribute=" + attribute + "]")
    active.addClass("active");
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
