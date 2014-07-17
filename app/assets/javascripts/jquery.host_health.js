(function($){
  $.PMX.HostHealth = function(el, options) {
    var base = this;

    base.timer = null;

    base.$el = $(el);
    base.data = {
      cpu: 0,
      memory: 0,
      time_stamp: 'NA',
      cpu_percent: 0,
      mem_percent: 0
    };

    base.defaultOptions = {
      timeFormat: 'YYYY/MM/DD, hh:mm:ss',
      interval: 10 * 1000,
      healthSelector: 'aside.host > .health',
      cpuSelector: '.cpu .health',
      memSelector: '.memory .health',
      detailTemplate: Handlebars.compile($('#host_health_template').html())
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.initiateRequest();
    };

    base.bindEvents = function() {
      base.$el.on('mouseenter', base.showHealthDetails);
      base.$el.on('mouseleave', base.hideHealthDetails);
    };

    base.showHealthDetails = function() {
      var details = $(base.options.detailTemplate(base.data));

      base.$el.addClass('showing');
      $(base.options.healthSelector).append(details);
      base.healthColors();
    };

    base.hideHealthDetails = function() {
      base.$el.removeClass('showing');
      $(base.options.healthSelector).empty();
    };

    base.initiateRequest = function() {
      var oneMegabyte = 1024 * 1024;

      $.ajax({
        url: '/host_health',
        headers: {
          'Accept': 'application/json'
        }
      }).success(function(response){
        base.data.cpu = response.overall_cpu.usage;
        base.data.memory = (response.overall_mem.usage / oneMegabyte).toFixed(2) + ' MB';
        base.data.time_stamp = moment(response.timestamp).format(base.options.timeFormat);
        base.calculateHealth(response);
      }).always(function() {
        if (base.timer !== null) { clearTimeout(base.timer); }
        base.timer = setTimeout(base.initiateRequest, base.options.interval);
      });
    };

    base.calculateHealth = function(data) {
      // Convert to millicores and take the percentage
      var cpuPercentage = data.overall_cpu.percent,
          memoryPercentage = data.overall_mem.percent;

      base.data.cpu_percent = cpuPercentage;
      base.data.mem_percent = memoryPercentage;
      if (base.$el.hasClass('showing')) {
        $(base.options.healthSelector).empty().append($(base.options.detailTemplate(base.data)));
      }
      base.healthColors();
    };

    base.healthColors = function() {
      var cpuPercentage = base.data.cpu_percent,
          memoryPercentage = base.data.mem_percent;

      // overall health is max of cpu and memory
      $(base.options.healthSelector).removeClass('good warning danger').addClass(base.colorLevel(Math.max(cpuPercentage, memoryPercentage)));
      base.$el.find(base.options.cpuSelector).removeClass('good warning danger').addClass(base.colorLevel(cpuPercentage));
      base.$el.find(base.options.memSelector).removeClass('good warning danger').addClass(base.colorLevel(memoryPercentage));
    };

    base.colorLevel = function(percentage) {
      if (percentage >= 90) {
        return 'danger';
      }

      if (percentage >= 80) {
        return 'warning';
      }

      return 'good';
    };
  };

  $.fn.hostHealth = function(options){
    return this.each(function(){
      (new $.PMX.HostHealth(this, options)).init();
    });
  };
})(jQuery);
