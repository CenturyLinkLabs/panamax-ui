(function($) {
  $.PMX.ContextHelp = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      contentSelector: 'section',
      contentLinks: 'section a'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.toggleContent);
      base.$el.on('click', base.options.contentSelector, function(e) { e.preventDefault();e.stopPropagation(); });
      base.$el.on('click', base.options.contentLinks, base.contentClick);
    };

    base.contentClick = function(e) {
      var target = $(e.currentTarget);
      e.preventDefault();
      if (target.hasClass('dismiss')) {
        base.closeContent();
      } else {
        window.open(target.attr('href'), "_blank");
      }
    };

    base.toggleContent = function (e) {
      (base.$el.hasClass('viewing')) ? base.closeContent() : base.openContent();
    };

    base.openContent = function() {
      base.$el.addClass('viewing');
      base.$el.find(base.options.contentSelector).show();
    };

    base.closeContent = function() {
      base.$el.removeClass('viewing');
      base.$el.find(base.options.contentSelector).hide();
    }
  };

  $.fn.contextHelp = function (options) {
    return this.each(function () {
      (new $.PMX.ContextHelp($(this), options)).init();
    });
  };
})(jQuery);
