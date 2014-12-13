var resetPassword = {
  dom: {
    $error: $('.d-error'),
    $resetPassword: $('.d-reset-password')
  },

  init: function() {
    this.attachEvents();
  },

  attachEvents: function() {
    var that = this;

    this.dom.$resetPassword.find('form').on('submit', function(event) {
      event.preventDefault();
      var data = $(this).serializeArray();

      that.resetPassword(data);
    });
  },

  resetPassword: function(data) {
    var that = this;

    $.ajax({
      url: '/users/password',
      data: data,
      method: 'put'
    }).done(function(response, statusCode, xhr) {
      location.href = location.origin;
    }).fail(function(xhr, statusCode, errorThrown) {
      var message = xhr.responseJSON.errors.messages[0];
      app.showError(message, that.dom.$error);
    });
  }
}

$(document).ready(function() {
  resetPassword.init();
});
