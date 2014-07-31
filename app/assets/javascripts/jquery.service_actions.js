(function($) {
  $.PMX.ServiceDestroyer = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);

      (new $.PMX.destroyLink(base.$el, {success: base.cleanList })).init();
    };

    base.cleanList = function () {
      var $services = base.$el.parent();

      base.$el.trigger('category-change');

      base.$el.remove();
      if ($services.find('li').length === 0) {
        $services.remove();
      }
    };
  };


  $.PMX.ServiceNameDisplay = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $serviceLink: base.$el.find('a').first(),
      tooltipSelector: '.tooltip'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el.on('mouseenter', base.options.$serviceLink, base.showServiceName);
      base.$el.on('mouseleave', base.options.$serviceLink, base.hideServiceName);
      base.$el.on('mousedown', base.hideServiceName);
    };

    base.showServiceName = function () {
      if ($(base.options.$serviceLink).html().length > 24) {
        $('<span class="tooltip">' + base.options.$serviceLink.html() + '</span>').appendTo(base.$el);
      };
    };

    base.hideServiceName = function () {
      base.$el.find('.tooltip').remove();
    };
  };

  $.fn.serviceActions = function(options) {
    return this.each(function() {
      (new $.PMX.ServiceDestroyer(this, options)).init();
      (new $.PMX.ServiceNameDisplay(this, options)).init();
    });
  };
})(jQuery);
