//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require fastclick
//= require magnific-popup/dist/jquery.magnific-popup

var app = {
  init: function() {
    this.attachFastClick();

    $(document).on('needsSignIn.APP', function() {

    });

    $(document).on('postGood.APP', function() {
      console.log('hey');
    });

    this.isLoggedIn = $('body').data('logged-in');
  },

  promptAuth: function() {
    deferred = $.Deferred();

    $(document).triggerHandler('needsSignIn.APP');
    return deferred.promise();
  },

  errorMessage: function(xhr) {
    return xhr.responseJSON.errors.messages[0];
  },

  pluralize: function(count, text) {
    return (count + (count == 1 ? ' ' + text : ' ' + text + 's'));
  },

  showError: function(message, selector) {
    $(selector).html(message);
    $(selector).fadeIn().delay(2000).queue(function(n) {
      $(selector).fadeOut();
      n();
    });
  },

  attachFastClick: function() {
    FastClick.attach(document.body);
  }
}

$(document).ready(function() {
  app.init();
});
