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
  }
}

$(document).ready(function() {
  app.init();
});
