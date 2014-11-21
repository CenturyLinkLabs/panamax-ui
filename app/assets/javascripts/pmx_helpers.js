//= require jquery.ui.dialog

(function($) {
  $.PMX.Helpers = {
    guid: function() {
      return (new Date()).getTime();
    },

    displayError: function(message, options) {
      options = options || {};
      var ajaxErrorTemplate = Handlebars.compile($('#ajax_error_template').html());
      var notification = $(ajaxErrorTemplate(
          { title: 'The following Error occured',
            message: new Handlebars.SafeString(message)
          }));

      if(options.style !== undefined) {
        notification.find(".notice-danger").
          removeClass("notice-danger").
          addClass("notice-" + options.style);
      }

      var container;
      if(options.container !== undefined) {
        container = options.container;
      } else {
        container = 'main';
      }

      $(notification).prependTo(container);
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
