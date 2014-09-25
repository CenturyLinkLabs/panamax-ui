(function($) {
  $.PMX.ServiceStatus = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;
    base.timer = null;

    base.defaultOptions = {
      refreshInterval: 2000,
      $panamaxState: base.$el.find('.panamax-state'),
      $serviceSubState: base.$el.find('.sub-state'),
      $serviceActiveState: base.$el.find('.active-state'),
      $serviceLoadState: base.$el.find('.load-state'),
      $tooltip: base.$el.find('.tooltip')
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.fetchStatus();
    };

    base.bindEvents = function() {
      base.$el.on('mouseenter', base.options.$panamaxState, base.showServiceDetails);
      base.$el.on('mouseleave', base.options.$panamaxState, base.hideServiceDetails);
      base.$el.on('update-service-status', base.updateStatus);
    };

    base.fetchStatus = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.$el.data('source')
      });

      base.xhr.done(function(response, status) {
        base.$el.trigger('update-service-status', [response]);
        clearTimeout(base.timer);
        base.timer = setTimeout(base.fetchStatus, base.options.refreshInterval);
      });
    };

    base.updateStatus = function(_, service) {
      base.$el.removeClass().addClass('service-status').addClass(service.status);
      base.options.$panamaxState.text(base.formatPanamaxState(service.status));
      base.options.$serviceSubState.text(base.formatPanamaxState(service.sub_state));
      base.options.$serviceActiveState.text(base.formatPanamaxState(service.active_state));
      base.options.$serviceLoadState.text(base.formatPanamaxState(service.load_state));
    };

    base.formatPanamaxState = function(state) {
      // Initial capital letter
      if (state == null) {
        return "-";
      }
      else {
        return state.charAt(0).toUpperCase() + state.slice(1);
      }
    };

    base.showServiceDetails = function() {
      base.options.$tooltip.css('display', 'block');
    };

    base.hideServiceDetails = function() {
      base.options.$tooltip.css('display', 'none');
    };
  };

  $.fn.serviceStatus = function(options){
    return this.each(function() {
      (new $.PMX.ServiceStatus($(this), options)).init();
    });
  };

})(jQuery);
