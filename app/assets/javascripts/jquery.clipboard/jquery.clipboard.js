(function($) {
  $.PMX.Clipboard = function($el, options) {
    var base = this,
        clipboard = null;

    base.$el = $el;

    base.defaultOptions = {
      clipboardAfterAttr: 'clipboard-after'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      clipboard = new ZeroClipboard(base.$el);
      base.bindEvents();
    };

    base.bindEvents = function() {
      var callback = base.options.afterCopy || base.afterCopy;
      clipboard.on('aftercopy', callback);
    };

    base.afterCopy = function() {
      if (base.$el.data(base.options.clipboardAfterAttr)) {
        base.$el.text(base.$el.data(base.options.clipboardAfterAttr));
      }
    };
  };
  $.fn.clipboard = function(options){
    return this.each(function(){
      (new $.PMX.Clipboard($(this), options)).init();
    });
  };
})(jQuery);
