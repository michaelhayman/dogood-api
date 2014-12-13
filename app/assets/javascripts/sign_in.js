var userSession = {
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
    userSession.setupSignIn();
    userSession.setupCreateAccount();
    userSession.setupForgotPassword();
    userSession.attachDialog();
    userSession.dom.$signIn.show();

    userSession.test();
  },

  test: function() {
    $(document).triggerHandler('needsSignIn.APP');
  },

  reset: function() {
    userSession.hideAll();
    userSession.dom.$signIn.show();
  },

  hideAll: function() {
    userSession.dom.$signIn.hide();
    userSession.dom.$createAccount.hide();
    userSession.dom.$forgotPassword.hide();
  },

  setupSignIn: function() {
    userSession.dom.$signIn.find('form').on('submit', function(event) {
      event.preventDefault();
      var data = $(this).serializeArray(),
        email = data[0].value,
        password = data[1].value;

      userSession.signIn(data);
    });

    userSession.dom.$signInLink.on('click', function(event) {
      userSession.hideAll();
      userSession.dom.$signIn.show();
    });
  },

  signIn: function(data) {
    $.ajax({
      url: '/users/sign_in',
      data: data,
      method: 'POST'
    }).done(function(response, statusCode, xhr) {
      location.reload();
    }).fail(function(xhr, statusCode, errorThrown) {
      userSession.showError(userSession.errorMessage(xhr));
    });
  },

  errorMessage: function(xhr) {
    return xhr.responseJSON.errors.messages[0];
  },

  attachDialog: function() {
    $(document).on('needsSignIn.APP', function() {
      if (!userSession.isLoggedIn) {
        $.magnificPopup.open({
          items: {
            src: '#d-user-session-dialog',
            type: 'inline'
          },
          midClick: true,
          callbacks: {
            open: function() {
              // userSession.reset();
            }
          }
        });
      }
    });
  },

  setupCreateAccount: function() {
    userSession.dom.$createAccount.find('form').on('submit', function(event) {
      event.preventDefault();
      var data = $(this).serializeArray(),
        name = data[2].value;

      if (name === '') {
        userSession.showError('Please enter your name.');
      } else {
        userSession.createAccount(data);
      }
    });

    userSession.dom.$createAccountLink.on('click', function(event) {
      userSession.hideAll();
      userSession.dom.$createAccount.show();
    });
  },

  createAccount: function(data) {
    $.ajax({
      url: '/users',
      data: data,
      method: 'POST'
    }).done(function(response, statusCode, xhr) {
      location.reload();
    }).fail(function(xhr, statusCode, errorThrown) {
      userSession.showError(userSession.errorMessage(xhr));
    });
  },

  setupForgotPassword: function() {
    userSession.dom.$forgotPassword.find('form').on('submit', function(event) {
      var data = $(this).serializeArray();
      event.preventDefault();
      userSession.forgotPassword(data);
    });

    userSession.dom.$forgotPasswordLink.on('click', function(event) {
      userSession.hideAll();
      userSession.dom.$forgotPassword.show();
    });
  },

  forgotPassword: function(data) {
    var email = data[2].value;

    $.ajax({
      url: '/users/password',
      data: data,
      method: 'POST'
    }).done(function(response, statusCode, xhr) {
      alert('Password sent, please check your email.');
      userSession.hideAll();
      userSession.dom.$signInEmail.val(email);
      userSession.dom.$signIn.show();
    }).fail(function(xhr, statusCode, errorThrown) {
      userSession.showError(userSession.errorMessage(xhr));
    });
  },

  showError: function(message) {
    userSession.dom.$error.html(message);
    userSession.dom.$error.fadeIn().delay(2000).queue(function(n) {
      userSession.dom.$error.fadeOut();
      n();
    });
  }
}

$(document).ready(function() {
  userSession.init();
});
