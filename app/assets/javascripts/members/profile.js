var Profile = function () {
  var form = $("form.edit_member");
  var username = $(".group[data-selector=username]");
  var phoneNumber = $(".group[data-selector=phoneNumber]");

  $.each([phoneNumber, username], function () {
    var self = this;
    var scopedLink = $(this).find("a.edit");
    var content = $(this).find(".content");
    scopedLink.on("click", function (e) {
      e.preventDefault();
      let fields = $(self).find(".fields");
      fields.hasClass("hidden") ? fields.removeClass("hidden") : fields.addClass("hidden")
    });
    var submit = $(this).find(".submit");
    submit.on("keydown", function (e) {
      if (e.keyCode == "13") form.submit();
    });
  });
}

$(document).on("turbolinks:load", Profile);
