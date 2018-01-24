var Members = function () {
  $(".item").on("click", function (e) {
    e.preventDefault();
    let attribute = $(this).data("attribute");
    let visible = $(".content[data-attribute=" + attribute + "]");
    let hidden = $(".content");
    hidden.addClass("hidden");
    visible.removeClass("hidden");
  });
}

$(document).on("turbolinks:load", Members);
