(function($){
  $.PMX.ServiceDestroyer = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
    };

    base.init = function (){
      base.options = $.extend({}, base.defaultOptions, options);

      (new $.PMX.destroyLink(base.$el, {success: base.cleanList })).init();
    };

    base.cleanList = function (){
      var $services = base.$el.parent();

      base.$el.remove();
      if ($services.find('li').length === 0) {
        $services.remove();
      }
    };
  };

  $.fn.serviceActions = function(options){
    return this.each(function(){
      (new $.PMX.ServiceDestroyer(this, options)).init();
    });
  };
})(jQuery);