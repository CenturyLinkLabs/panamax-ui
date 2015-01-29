(function($) {
  $.PMX.UpdatableContentsPolling = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;
    base.timer = null;

    base.defaultOptions = {
      refreshInterval: 1000,
      template: Handlebars.compile($('#job_template').html() || ''),
      urlDataAttribute: 'source'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);

      base.fetchContents();
    };

    base.fetchContents = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.endpoint()
      });

      base.xhr.done(function(response) {
        base.updateContents(response);
        clearTimeout(base.timer);
        base.timer = setTimeout(
          base.fetchContents,
          base.options.refreshInterval
        );
      });
    };

    base.updateContents = function(response) {
      var contents = base.options.template(response);
      base.$el.html(contents);
    };

    base.endpoint = function() {
      return base.$el.data(base.options.urlDataAttribute);
    };
  };

  $.fn.updatableContentsPolling = function(options) {
    return this.each(function() {
      (new $.PMX.UpdatableContentsPolling(this, options)).init();
    });
  };

})(jQuery);
