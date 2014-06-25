(function($){
  $.PMX.ServiceStatus = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;
    base.timer = null;

    base.defaultOptions = {
      refreshInterval: 2500,
      $panamaxState: base.$el.find('.panamax-state'),
      $fleetState: base.$el.find('.fleet-state'),
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.fetchStatus();
    };

    base.fetchStatus = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.$el.data('source')
      });

      base.xhr.done(function(response, status) {
        base.updateStatus(response);
        clearTimeout(base.timer);
        base.timer = setTimeout(base.fetchStatus, base.options.refreshInterval);
      });
    };

    base.updateStatus = function(service) {
      base.$el.removeClass().addClass('service-status').addClass(service.status);
      base.options.$panamaxState.text(base.formatPanamaxState(service.status));
      base.options.$fleetState.text(service.sub_state);
    };

    base.formatPanamaxState = function(state) {
      // Initial capital letter
      return state.charAt(0).toUpperCase() + state.slice(1);
    };
  };

  $.fn.serviceStatus = function(options){
    return this.each(function() {
      (new $.PMX.ServiceStatus($(this), options)).init();
    });
  };

})(jQuery);
