var profile = {
  dom: {
    $invocationLink: $('.d-open-user-session-dialog-link'),
    $signIn: $('.d-sign-in'),
    $signInLink: $('.d-sign-in-link'),
    $signInEmail: $('.d-sign-in-email'),
    $createAccount: $('.d-create-account'),
    $createAccountLink: $('.d-create-account-link'),
    $forgotPassword: $('.d-forgot-password'),
    $forgotPasswordLink: $('.d-forgot-password-link'),
    $error: $('.d-error'),
  },

  init: function() {
    profile.attachFollowing();
  },

  attachFollowing: function() {
    $(document).on('click', '.d-follow', function() {
      var that = this,
       $this = $(this),
       deferred,
       data = {
         follow: {
           followable_id: $this.data('id'),
           followable_type: "User"
         }
       },
       method,
       url;

      if (app.isLoggedIn) {
        if ($this.data('following') === true) {
          method = "DELETE";
          url = '/follows/' + $this.data('id');
        } else {
          method = "POST";
          url = '/follows';
        }

        deferred = $.ajax({
          url: url,
          data: data,
          method: method
        }).done(function(response, statusCode, xhr) {
          var isFollowing,
            $followers = $('.d-followers-text'),
            followersCount = $followers.data('count');

          if (method === "DELETE") {
            $this.html('Follow');
            isFollowing = false;
            followersCount--;
          } else {
            $this.html('Following');
            isFollowing = true;
            followersCount++;
          }

          $this.data('following', isFollowing);

          $followers.text(app.pluralize(followersCount, 'follower'));
          $followers.data('count', followersCount++);

        }).fail(function(xhr, statusCode, errorThrown) {
        });
      } else {
        deferred = app.promptAuth();
      }
      return deferred;
    });
  },
}

$(document).ready(function() {
  profile.init();
});
