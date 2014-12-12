var goods = {
  init: function() {
    this.attachEvents();
  },

  attachEvents: function() {
    $(document).on('click', '.d-comment-link', function() {
    });
    $(document).on('click', '.d-vote-link', function() {
      var method, data, url;

      data = {
        vote: {
          votable_id: $(this).data('id'),
          votable_type: "Good"
        }
      };

      if ($(this).data('state') === "on") {
        method = "DELETE";
        url = '/votes/' + $(this).data('id');
      } else {
        method = "POST";
        url = '/votes';
      }

      $.ajax({
        url: url,
        data: data,
        method: method
      }).done(function(response, statusCode, xhr) {
        debugger;
        location.reload();
      }).fail(function(xhr, statusCode, errorThrown) {
        debugger;
        // userSession.showError(userSession.errorMessage(xhr));
      });
    });
    $(document).on('click', '.d-follow-link', function() {
      debugger;
    });
  }
}

$(document).ready(function() {
  goods.init();
});
