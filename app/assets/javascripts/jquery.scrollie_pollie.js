(function($){
  $.PMX.ScrolliePollie = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;
    base.timer = null;
    base.index = 0;

    base.defaultOptions = {
      refreshInterval: 1000
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.$el.html('');
      base.fetch();
    };

    base.fetch = function() {
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.endpoint()
      });

      base.xhr.done(function(response) {
        base.updateContents(response);
        clearTimeout(base.timer);
        base.timer = setTimeout(base.fetch, base.options.refreshInterval);
      });
    };

    base.updateContents = function(lines) {
      var textLines = '';

      $.each(lines, function(i, line) {
       textLines += '<p>' + line + '</p>';
      });

      base.index += lines.length;

      if (textLines.length) {
        var scrolledToBottom = base.scrolledToBottom();

        base.$el.append(textLines);

        if (scrolledToBottom) {
          base.$el.animate({ scrollTop: base.$el[0].scrollHeight });
        }
      }
    };

    base.endpoint = function() {
      return base.$el.data('source') + '?index=' + base.index;
    };

    base.scrolledToBottom = function() {
      var div = base.$el[0];
      return (div.scrollHeight - div.clientHeight) <= (div.scrollTop + 1);
    };
  };

  $.fn.scrolliePollie = function(options){
    return this.each(function(){
      (new $.PMX.ScrolliePollie(this, options)).init();
    });
  };

})(jQuery);
