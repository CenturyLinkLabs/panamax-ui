(function($) {
  $.PMX.ErrorInterceptor = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      excludePaths: ['host_health', 'search', 'journal'],
      ajaxErrorTemplate: Handlebars.compile($('#ajax_error_template').html())
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      // global handler
      base.$el.ajaxError(base.handleError);
    };

    base.handleError = function( event, jqxhr, settings, thrownError) {
      if (base.notExcludedUrl(settings.url)) {
        base.renderNotification(thrownError);
      };
    };

    base.notExcludedUrl = function(url) {
      for(var i=0; i<base.options.excludePaths.length; i++) {
        if (url.lastIndexOf(base.options.excludePaths[i]) !== -1) return false;
      }
      return true;
    };

    base.renderNotification = function(message) {
      var notification = $(base.options.ajaxErrorTemplate(
          { title: 'The following Error occured',
            message: message
          }));

      $(notification).prependTo('main');
    };

  };

  $.fn.errorInterceptor = function(options) {
    return this.each(function() {
      (new $.PMX.ErrorInterceptor($(this), options)).init();
    });
  };

})(jQuery);
