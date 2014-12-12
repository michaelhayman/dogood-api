
var header = {
  init: function() {
    $(document).on('click', '.d-profile-icon', function() {
      $(document).triggerHandler('needsSignIn.APP');
    });

    $(document).on('click', '.d-post-icon', function() {
      console.log('hey');
    });
  }
}

$(document).ready(function() {
  header.init();
});
