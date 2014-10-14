(function($) {


  $.PMX.HealthGraph = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      cpuSelector: '.health .cpu .bar',
      memSelector: '.health .mem .bar',
      maxWidth: 60
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
    };

    base.calculateHealth = function(data) {
      var datum = [
        {
          'element': base.$el.find(base.options.cpuSelector),
          'percent': data.overall_cpu.percent
        },
        {
          'element': base.$el.find(base.options.memSelector),
          'percent': data.overall_mem.percent
        }
      ];

      datum.forEach(function(item) {
        base.healthColor(item.element, item.percent);
        base.datumSize(item.element, item.percent);
      });
    };

    base.datumSize = function($el, percent) {
      $el.animate({
        'width': Math.ceil((percent / 100)  * base.options.maxWidth) + 'px'
      }, 600);
    };

    base.healthColor = function($el, percent) {
      $el.removeClass('good warning danger').addClass(base.colorLevel(percent));
    };

    base.colorLevel = function(percentage) {
      if (percentage >= 90) {
        return 'danger';
      }

      if (percentage >= 75) {
        return 'warning';
      }

      return 'good';
    };
  };

  $.fn.healthGraph = function(options){
    return this.each(function(){
      (new $.PMX.HealthGraph($(this), options)).init();
    });
  };

})(jQuery);
