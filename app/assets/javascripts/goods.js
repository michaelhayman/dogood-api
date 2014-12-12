var goods = {
  init: function() {
    this.attachEvents();
  },

  attachEvents: function() {
    $(document).on('click', '.d-comment-link', function() {
      debugger;
    });
    $(document).on('click', '.d-vote-link', function() {
      debugger;
    });
    $(document).on('click', '.d-follow-link', function() {
      debugger;
    });
  }
}

$(document).ready(function() {
  goods.init();
});
