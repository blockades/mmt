App.notification = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function () {

  },
  disconnected: function () {

  },
  received: function (data) {
    $('.notifications > .count').html(data.count);
  }
});
