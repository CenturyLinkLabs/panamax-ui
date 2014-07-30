(function($) {
  $.PMX.ContextHelp = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      contentSelector: 'section',
      contentLinks: 'section a',
      dismissSelector: 'span.dismiss',
      top: '36px',
      left: '-24px'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el.find(base.options.contentSelector).css(
          {
            'top': base.options.top,
            'left': base.options.left
          });
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.toggleContent);
      base.$el.on('click', base.options.contentSelector, function(e) { e.preventDefault();e.stopPropagation(); });
      base.$el.on('click', base.options.contentLinks, base.contentClick);
      base.$el.on('click', base.options.dismissSelector, base.closeContent);
    };

    base.contentClick = function(e) {
      var target = $(e.currentTarget);

      e.preventDefault();
      window.open(target.attr('href'), "_blank");
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
