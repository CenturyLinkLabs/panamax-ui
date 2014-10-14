(function($) {
  $.PMX.ServiceHealth = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      baseUrl: '/service_health',
      serviceData: 'data-service-name',
      $dockerStatus: $('.service-details .service-status'),
      $metricLink: $('.service-details .metric-details')
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.hideHealth();
      base.buildGraph();
      base.bindEvents();
    };

    base.buildGraph = function() {
      base.graph = new $.PMX.HealthGraph(base.$el, base.options);
      base.graph.init();
    };

    base.bindEvents = function () {
      base.options.$dockerStatus.on('update-service-status', base.checkStatusHandler);
    };

    base.showHealth = function() {
      base.options.$metricLink.show();
      base.$el.show();
      base.initiateRequest();
    };

    base.hideHealth = function() {
      base.options.$metricLink.hide();
      base.$el.hide();
    };

    base.checkStatusHandler = function(_, response) {
      (response.sub_state === 'running') ? base.showHealth() : base.hideHealth();
    };

    base.healthUrl = function() {
      var serviceName = base.$el.attr(base.options.serviceData);

      return base.options.baseUrl + '/' + serviceName;
    };

    base.initiateRequest = function() {
      $.ajax({
        url: base.healthUrl(),
        headers: {
          'Accept': 'application/json'
        }
      }).success(function(response) {
        base.graph.calculateHealth(response);
      });
    };
  };

  $.fn.serviceHealth = function(options){
    return this.each(function(){
      (new $.PMX.ServiceHealth($(this), options)).init();
    });
  };
})(jQuery);
