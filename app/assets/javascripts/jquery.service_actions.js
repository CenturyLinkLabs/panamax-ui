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

    base.cleanList = function() {
      var $services = base.$el.parent();

      base.$el.remove();
      if ($services.find('li').length === 0) {
        $services.remove();
      }

    };

    base.postDelete = function() {
      $(base.$el).css('opacity', '0.5')
        .delay(1000)
        .fadeOut('slow', base.cleanList);
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
        base.postDelete();
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