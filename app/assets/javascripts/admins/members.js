var Members = function () {
  $(".item").on("click", function (e) {
    e.preventDefault();
    var attribute = $(this).data("attribute");
    var visible = $(".content[data-attribute=" + attribute + "]");
    var hidden = $(".content");
    hidden.addClass("hidden");
    visible.removeClass("hidden");
  });
}

$(document).on("turbolinks:load", Members);
