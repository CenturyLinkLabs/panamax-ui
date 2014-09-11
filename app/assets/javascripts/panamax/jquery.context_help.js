(function($) {
  $.PMX.ContextHelp = function($el, options) {
    var base = this,
        arrowPosition = 0;

    base.$el = $el;

    base.defaultOptions = {
      contentSelector: 'section',
      contentLinks: 'section a',
      arrowSelector: 'aside.arrow',
      dismissSelector: 'span.dismiss',
      top: '32px',
      left: '-25px'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el.find(base.options.contentSelector).css(
          {
            'top': base.options.top
          });
      arrowPosition = (base.$el.find(base.options.arrowSelector).css('left'))
            ? parseInt(base.$el.find(base.options.arrowSelector).css('left')) : 0;
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.toggleContent);
      base.$el.on('click', base.options.contentSelector, function(e) { e.preventDefault();e.stopPropagation(); });
      base.$el.on('click', base.options.contentLinks, base.contentClick);
      base.$el.on('click', base.options.dismissSelector, base.closeContent);
      $(window).on('resize', base.calculatePosition);
    };

    base.contentClick = function(e) {
      var target = $(e.currentTarget);
      base.$el.find(base.options.contentSelector).css(
        {
          'top': base.options.top
        });
      e.preventDefault();
      window.open(target.attr('href'), "_blank");
    };

    base.shiftContent = function(overflow, maxShift) {
      var leftOffset = Math.abs(parseInt(base.options.left)),
          shift = Math.min(leftOffset + overflow, maxShift),
          arrowShift = Math.min(arrowPosition + overflow, maxShift);

      base.$el.find(base.options.contentSelector).css('left', -shift);
      base.$el.find(base.options.arrowSelector).css('left', arrowShift + 'px');
    };

    base.calculatePosition = function() {
      var viewPortWidth = $(window).width(),
          leftOffset = Math.abs(parseInt(base.options.left)),
          contentWidth = base.$el.find(base.options.contentSelector).outerWidth(),
          maxShift = contentWidth -  leftOffset,
          extendsTo = base.$el.position().left + (maxShift + leftOffset);

      if (extendsTo > viewPortWidth) {
        base.shiftContent(extendsTo - viewPortWidth, maxShift);
      } else {
        base.$el.find(base.options.contentSelector).css('left',base.options.left);
        base.$el.find(base.options.arrowSelector).css('left', arrowPosition + 'px');
      }
    };

    base.toggleContent = function (e) {
      (base.$el.hasClass('viewing')) ? base.closeContent() : base.openContent();
    };

    base.openContent = function() {
      base.$el.addClass('viewing');
      base.calculatePosition();
      base.$el.find(base.options.contentSelector).show();


    };

    base.closeContent = function() {
      base.$el.removeClass('viewing');
      base.$el.find(base.options.contentSelector).hide();
    };
  };

  $.fn.contextHelp = function (options) {
    return this.each(function () {
      (new $.PMX.ContextHelp($(this), options)).init();
    });
  };
})(jQuery);
