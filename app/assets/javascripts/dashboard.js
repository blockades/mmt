var Dashboard = function () {
  $(".tab").on("click", function () {
    let attribute = $(this).data("attribute");
    $(".tab").removeClass("active");
    $(this).addClass("active");
    let visible = $("section[data-attribute=" + attribute + "]");
    let hidden = $(".dashboard-widgets").children("section");
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
