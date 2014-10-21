(function($) {
  $.PMX.FingerTabs = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      cardSelector: '.card'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.initializeTabs();
    };

    base.initializeTabs = function() {
      base.$el.find(base.options.cardSelector).first().css('display', 'block');
    };
  };

  $.fn.fingerTabs = function(options){
    return this.each(function(){
      (new $.PMX.FingerTabs($(this), options)).init();
    });
  };

})(jQuery);
