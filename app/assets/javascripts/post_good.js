var postGood = {
  dom: {
    $error: $('.d-error')
  },

  init: function() {
    this.attachEvents();
    //this.test();
  },

  test: function() {
    this.setDone(false);
  },

  attachEvents: function() {
    this.attachForm();
  },

  setDone: function(done) {
    $('.d-first-step').hide();
    $('.d-second-step').show();
    $('.d-done').val(done);
    history.pushState({}, '', '/goods/new/nominate')
  },

  attachForm: function() {
    var that = this;
    $('d-nominate').on('click', function(event) {
      event.preventDefault();
      that.setDone(false);
    });

    $('.d-ask-for-help').on('click', function(event) {
      event.preventDefault();
      that.setDone(true);
    });

    $('form#d-post-good').on('submit', function(event) {
      event.preventDefault();

      var url = '/goods',
        method = "POST",
        data = $(this).serialize();

      $.ajax({
        url: url,
        data: data,
        method: method
      }).done(function(response, statusCode, xhr) {
        debugger;
      }).fail(function(xhr, statusCode, errorThrown) {
        var message = xhr.responseJSON.errors.messages[0];
        app.showError(message, that.dom.$error);
        xhr.responseJSON
      });
    });
  }
}

$(document).ready(function() {
  postGood.init();
});
