(function($) {
  $.PMX.ErrorInterceptor = function($el, options) {
    var base = this,
        abortedStatus = 0;

    base.$el = $el;

    base.defaultOptions = {
      excludePaths: ['host_health', 'journal']
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      // global handler
      base.$el.ajaxError(base.handleError);
    };

    base.handleError = function( event, jqxhr, settings, thrownError) {
      if (base.notExcludedUrl(settings.url) && jqxhr.status !== abortedStatus) {
        $.PMX.Helpers.displayError(thrownError);
      }
    };

    base.notExcludedUrl = function(url) {
      for(var i=0; i<base.options.excludePaths.length; i++) {
        if (url.lastIndexOf(base.options.excludePaths[i]) !== -1) { return false; }
      }
      return true;
    };
  };

  $.fn.errorInterceptor = function(options) {
    return this.each(function() {
      (new $.PMX.ErrorInterceptor($(this), options)).init();
    });
  };

})(jQuery);
