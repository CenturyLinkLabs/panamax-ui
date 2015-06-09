(function($){
  $.PMX.ApplicationDestroyer = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);

      (new $.PMX.destroyLink(base.$el ,
        {
          linkSelector: 'ul.application-button-menu a.delete',
          removeAt: 'div.application',
          disableWith: 'Deleting...'
        })).init();
    };
  };

  $.fn.applicationActions = function(options){
    return this.each(function(){
      (new $.PMX.ApplicationDestroyer(this, options)).init();
      (new $.PMX.ApplicationComposeExporter(this, options)).init();
    });
  };
})(jQuery);
