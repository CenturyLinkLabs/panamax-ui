(function($){
  $.PMX.ApplicationMenuActions = function (el, options){
    var base = this;
    base.$el = $(el);

    base.defaultOptions = {
      $applicationMenu: base.$el.find('ul.menu'),
      applicationMenuButtonSelector: 'a.options'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.applicationMenuButtonSelector, base.handleApplicationMenu);
    };

    base.handleApplicationMenu = function (e) {
      e.preventDefault;
      base.options.$applicationMenu.slideToggle();
    };
  };

  $.fn.applicationMenuActions = function(options) {
    return this.each(function(){
      (new $.PMX.ApplicationMenuActions(this, options)).init();
    });
  };
})(jQuery);
