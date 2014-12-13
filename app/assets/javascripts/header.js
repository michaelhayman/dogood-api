
var header = {
  init: function() {
    $(document).on('click', '.d-open-user-session-dialog-link', function() {
      $(document).triggerHandler('needsSignIn.APP');
    });
  }
}

$(document).ready(function() {
  header.init();
});
