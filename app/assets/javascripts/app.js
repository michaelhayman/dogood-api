//= require jquery
//= require jquery_ujs
//= require magnific-popup

var app = {
  init: function() {
    $(document).on('needsSignIn.APP', function() {

    });

    $(document).on('postGood.APP', function() {
      console.log('hey');
    });
  },

  errorMessage: function(xhr) {
    return xhr.responseJSON.errors.messages[0];
  },

  showError: function(message, selector) {
    $(selector).html(message);
    $(selector).fadeIn().delay(2000).queue(function(n) {
      $(selector).fadeOut();
      n();
    });
  }
}

$(document).ready(function() {
  app.init();
});
