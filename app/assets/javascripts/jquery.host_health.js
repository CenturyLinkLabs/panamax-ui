(function($){
  $.PMX.HostHealth = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.data = {
      cpu: 0,
      memory: 0,
      time_stamp: 'now',
      cpu_percent: 0,
      mem_percent: 0
    };

    base.defaultOptions = {
      timeFormat: 'YYYY/MM/DD, hh:mm:ss',
      interval: 3 * 1000,
      goodColor: '#74A432',
      warningColor: '#F5D04C',
      dangerColor: '#D90000',
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
      base.$el.click(base.toggleDetails);
    };

    base.toggleDetails = function(e) {
      if (base.$el.hasClass('showing')) {
        base.hideHealthDetails();
      } else {
        base.showHealthDetails();
      }
    };

    base.showHealthDetails = function() {
      var details = $(base.options.detailTemplate(base.data));
      base.$el.addClass('showing');
      base.$el.append(details);

      base.healthColors();
    };

    base.hideHealthDetails = function() {
      base.$el.removeClass('showing');
      base.$el.empty();
    };

    base.initiateRequest = function() {
      var oneMegabyte = 1024 * 1024;
      $.ajax({
        url: '/metrics/overall'

      }).success(function(response){
        base.data.cpu = response.overall_cpu.usage;
        base.data.memory = (response.overall_mem.usage / oneMegabyte).toFixed(2) + ' MB';
        base.data.time_stamp = moment(response.timestamp).format(base.options.timeFormat);
        base.calculateHealth(response);
      }).always(function() {
        setTimeout(base.initiateRequest, base.options.interval);
      })
    };

    base.calculateHealth = function(data) {
      // Convert to millicores and take the percentage
      var cpuPercentage = data.overall_cpu.percent,
          memoryPercentage = data.overall_mem.percent;

      base.data.cpu_percent = cpuPercentage;
      base.data.mem_percent = memoryPercentage;
      if (base.$el.hasClass('showing')) {
        base.$el.empty().append($(base.options.detailTemplate(base.data)));
      }
      base.healthColors();
    };

    base.healthColors = function() {
      var cpuPercentage = base.data.cpu_percent,
          memoryPercentage = base.data.mem_percent;

      // overall health is max of cpu and memory
      base.$el.css('background-color', base.colorLevel(Math.max(cpuPercentage, memoryPercentage)));
      base.$el.find(base.options.cpuSelector).css('background-color', base.colorLevel(cpuPercentage));
      base.$el.find(base.options.memSelector).css('background-color', base.colorLevel(memoryPercentage));
    };

    base.colorLevel = function(percentage) {
      if (percentage >= 90) {
        return base.options.dangerColor;
      }

      if (percentage >= 80) {
        return base.options.warningColor;
      }

      return base.options.goodColor;
    }
  };

  $.fn.hostHealth = function(options){
    return this.each(function(){
      (new $.PMX.HostHealth(this, options)).init();
    });
  };
})(jQuery);
