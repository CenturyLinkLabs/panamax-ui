(function($) {
  $.PMX.Helpers = {
    guid: function() {
      return (new Date()).getTime();
    },

    displayError: function(message) {
      var ajaxErrorTemplate = Handlebars.compile($('#ajax_error_template').html());
      var notification = $(ajaxErrorTemplate(
          { title: 'The following Error occured',
            message: message
          }));

      $(notification).prependTo('main');
    }
  };

})(jQuery);
