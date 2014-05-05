(function($){
  $.PMX.ServiceDestroyer = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      deleteSelector: $('.actions a.delete-action')
    };

    base.init = function(){
      base.defaultOptions.deleteHandler = base.handleDelete;
      base.options = $.extend({}, base.defaultOptions, options);

      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.deleteSelector.selector, base.options.deleteHandler);
    };

    base.handleDelete = function(event) {
      event.preventDefault();
      event.stopPropagation();

      $.ajax({
        url: $(this).attr('href'),
        headers: {
          'Accept': 'application/json'
        },
        type: 'DELETE'
      })
      .done(function() {
        $(base.$el).css('opacity', '0.5')
          .delay(1000)
          .fadeOut('slow')
      })
      .fail(function(){
        alert('Unable to delete service.');
      });
    };
  };

  $.fn.serviceActions = function(options){
    return this.each(function(){
      (new $.PMX.ServiceDestroyer(this, options)).init();
    });
  };
})(jQuery);