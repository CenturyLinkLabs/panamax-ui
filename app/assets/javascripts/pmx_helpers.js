//= require jquery.ui.dialog

(function($) {
  $.PMX.Helpers = {
    guid: function() {
      return (new Date()).getTime();
    },

    displayError: function(message, options) {
      var defaultOptions = { style: "danger", container: "main" };
      options = $.extend({}, defaultOptions, options);

      var ajaxErrorTemplate = Handlebars.compile($('#ajax_error_template').html());
      var notification = $(ajaxErrorTemplate(
          { title: 'The following Error occured',
            message: new Handlebars.SafeString(message)
          }));

      notification.find(".notice-container").addClass("notice-" + options.style);
      $(notification).prependTo(options.container);
    },

    dialog: function(scope, $content, options) {
      var defaultOptions = {
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: { my: "top", at: "top+50", of: window },
        title: 'Dialog',
        close: scope.handleClose,
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: scope.handleClose
          }
        ]
      };

      return $content.dialog($.extend({}, defaultOptions, options));
    }
  };

})(jQuery);
