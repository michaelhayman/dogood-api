var goods = {
  init: function() {
    this.attachEvents();
  },

  attachEvents: function() {
    this.attachVoting();
    this.attachCommenting();
    this.attachFollowing();
  },

  attachCommenting: function() {
    $(document).on('click', '.d-comment-link', function() {
    });
  },

  attachVoting: function() {
    $(document).on('click', '.d-vote-link', function() {
      var that = this,
        deferred;

      if (app.isLoggedIn) {
        var data = {
          vote: {
            votable_id: $(this).data('id'),
            votable_type: "Good"
          }
        },
        method,
        url;

        if ($(this).data('state') === "on") {
          method = "DELETE";
          url = '/votes/' + $(this).data('id');
        } else {
          method = "POST";
          url = '/votes';
        }

        deferred = $.ajax({
          url: url,
          data: data,
          method: method
        }).done(function(response, statusCode, xhr) {
          goods.react(that, '.d-votes-link-wrapper', '.d-votes-count', 'vote', '.d-vote', method);
        }).fail(function(xhr, statusCode, errorThrown) {
        });
      } else {
        deferred = app.promptAuth();
      }

      return deferred;
    });
  },

  attachFollowing: function() {
    $(document).on('click', '.d-follow-link', function() {
      var that = this,
       deferred,
       data = {
         follow: {
           followable_id: $(this).data('id'),
           followable_type: "Good"
         }
       },
       method,
       url;

      if (app.isLoggedIn) {
        if ($(this).data('state') === "on") {
          method = "DELETE";
          url = '/follows/' + $(this).data('id');
        } else {
          method = "POST";
          url = '/follows';
        }

        deferred = $.ajax({
          url: url,
          data: data,
          method: method
        }).done(function(response, statusCode, xhr) {
          goods.react(that, '.d-follows-link-wrapper', '.d-follows-count', 'follower', '.d-follow', method);
        }).fail(function(xhr, statusCode, errorThrown) {
        });
      } else {
        deferred = app.promptAuth();
      }
      return deferred;
    });
  },

  react: function(that, wrapper, link, text, button, method) {
    var $countWrapper = $(that).parent().parent().find(wrapper),
      $countLink = $countWrapper.find(link),
      count;

    count = $countWrapper.data('count');
    if (method === "DELETE") {
      $(that).find(button).removeClass('on');
      $(that).data('state', 'off');
      count--;
    } else {
      $(that).find(button).addClass('on');
      $(that).data('state', 'on');
      count++;
    }

    $countWrapper.data('count', count);
    $countLink.text(count + (count == 1 ? ' ' + text : ' ' + text + 's'));

    if (count === 0) {
      $countWrapper.addClass('d-hidden');
    } else {
      $countWrapper.removeClass('d-hidden');
    }
  }
}

$(document).ready(function() {
  goods.init();
});
