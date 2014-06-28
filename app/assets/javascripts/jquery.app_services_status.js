(function($){
  $.PMX.AppServicesStatus = function($el, options) {
    var base = this;

    base.$el = $el;
    base.xhr = null;
    base.timer = null;

    base.defaultOptions = {
      refreshInterval: 2500,
      rowSelector: '.category-panel ul.services li',
      serviceStatusClass: 'app-service-status'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.fetchServicesStatus();
    };

    base.fetchServicesStatus = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.$el.data('source')
      });

      base.xhr.done(function(response, status) {
        base.updateServicesStatus(response);
        clearTimeout(base.timer);
        base.timer = setTimeout(base.fetchServicesStatus, base.options.refreshInterval);
      });
    };

    base.updateServicesStatus = function(services) {
      for (i in services) {
        var $serviceRow = base.$el.find(base.options.rowSelector + "[data-id='" + services[i].id + "']");
        base.updateStatus($serviceRow.find('.' + base.options.serviceStatusClass), services[i]);
      }
    };

    base.updateStatus = function($el, service) {
      $el.removeClass().addClass(base.options.serviceStatusClass).addClass('status-' + service.status);
    };

  };

  $.fn.appServicesStatus = function(options){
    return this.each(function() {
      (new $.PMX.AppServicesStatus($(this), options)).init();
    });
  };
})(jQuery);
