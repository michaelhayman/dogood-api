var postGood = {
  dom: {
    $error: $('.d-error')
  },

  init: function() {
    this.attachEvents();
    //this.test();
  },

  attachEvents: function() {
    var that = this;

    $('.d-nominate').on('change', function(event) {
      if ($(this).is(':checked')) {
        $('.d-nominee-row').show();
      }
    });

    $('.d-ask-for-help').on('change', function(event) {
      if ($(this).is(':checked')) {
        $('.d-nominee-row').hide();
      }
    });

    $('form#d-post-good').on('submit', function(event) {
      event.preventDefault();

      var url = '/goods',
        method = "POST",
        data = new FormData($(this)[0]);

      $.ajax({
        url: url,
        method: method,
        data: data,
        // enctype: 'multipart/form-data',
        processData: false,
        contentType: false
      }).done(function(response, statusCode, xhr) {
        location.href = location.origin + '/goods/' + response.responseJSON.goods.id;
      }).fail(function(xhr, statusCode, errorThrown) {
        var message = xhr.responseJSON.errors.messages[0];
        app.showError(message, that.dom.$error);
      });
    });

    $('input[type=file]').change(function(e) {
      $('#d-evidence-preview').hide();
      that.readURL(this);
    });
  },

  readURL: function(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader(),
        $preview = $('#d-evidence-preview');

      reader.onload = function (e) {
        $preview.attr('src', e.target.result);
        $preview.show();
      }

      reader.readAsDataURL(input.files[0]);
    }
  }
}

$(document).ready(function() {
  postGood.init();
});
