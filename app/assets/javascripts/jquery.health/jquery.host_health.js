(function($) {
  $.PMX.HostHealth = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      baseUrl: '/host_health',
      interval: 6 * 1000
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.buildGraph();
      base.initiateRequest();
    };

    base.buildGraph = function() {
      base.graph = new $.PMX.HealthGraph(base.$el, base.options);
      base.graph.init();
    };

    base.initiateRequest = function() {
      $.ajax({
        url: base.options.baseUrl,
        headers: {
          'Accept': 'application/json'
        }
      }).success(function(response) {
        base.graph.calculateHealth(response);
      }).always(function() {
        if (base.timer !== null) { clearTimeout(base.timer); }
        base.timer = setTimeout(base.initiateRequest, base.options.interval);
      });
    };
  };

  $.fn.hostHealth = function(options){
    return this.each(function(){
      (new $.PMX.HostHealth($(this), options)).init();
    });
  };
})(jQuery);
