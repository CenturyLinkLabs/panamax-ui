(function($) {

  $.PMX.addedAnimation = function($element) {
    var $indicateNew = $('<div class="indicate-new"></div>');

    $element.append($indicateNew);
    $indicateNew.fadeOut(2000);
  };

  $.PMX.destroyLink = function(el, options){
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      removeAt: 'li',
      linkSelector: '.actions a.delete-action'
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function(){
      base.$el.on('click', base.options.linkSelector, base.handleDelete);
    };

    base.done = function() {
       if (base.options.success) { base.options.success(); }
    };

    base.fail = function(response){
      (base.options.fail) ? base.options.fail(response) : alert("Unable to complete delete operation");
    };

    base.handleDelete = function(event){
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
        var $target = $(event.currentTarget).closest(base.options.removeAt);
        $target.css('opacity', '0.5')
          .delay(1000)
          .fadeOut('slow', base.done);
      })
      .fail(function(response){
        base.fail(response);
      });
    };
  };

})(jQuery);
