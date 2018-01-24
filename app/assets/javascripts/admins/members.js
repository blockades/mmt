var Members = function () {
  $(".item").on("click", function (e) {
    e.preventDefault();
    let selector = $(this).data("selector");
    let visible = $(".content[data-selector=" + selector + "]");
    let hidden = $(".content");
    hidden.addClass("hidden");
    visible.removeClass("hidden");
  });
}

$(document).on("turbolinks:load", Members);
