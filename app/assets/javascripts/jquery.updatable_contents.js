(function($) {
  $.PMX.UpdatableContents = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.options = options;

    base.init = function() {
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.targetSelector, base.handleClick);
    };

    base.handleClick = function(e) {
      if (!base.$el.hasClass(base.options.refreshedClass)) {
        base.fetchNewContent();
      }
    };

    base.fetchNewContent = function() {
      $.ajax(base.$el.data(base.options.urlDataAttribute), {
        headers: {
          'Accept': 'application/json'
        }
      }).done(base.updateContents);
    };

    base.updateContents = function(data) {
      base.$el.html(base.options.template(data));
      base.$el.addClass(base.options.refreshedClass);
    };

  };

  $.fn.updatableContents = function(options) {
    return this.each(function() {
      (new $.PMX.UpdatableContents(this, options)).init();
    });
  };

})(jQuery);
