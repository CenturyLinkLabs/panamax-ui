(function($){

  $.PMX.ConfirmAndDelete = function($el, options) {
    var base = this;

    base.$el = $el;

    base.init = function () {
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', '[data-delete-confirm]', base.clickHandler);
    };

    base.clickHandler = function(e) {
      e.preventDefault();
      e.stopPropagation(); // so jquery_ujs doesn't catch this

      base.createConfirmation(e);
    };

    base.createConfirmation = function(e) {
      var $target = $(e.currentTarget),
          confirm = new $.PMX.ConfirmDelete($target.closest('.actions'), {
        message: $target.data('delete-confirm'),
        confirm: function () {
          var destroyer = new $.PMX.destroyLink($(), { removeAt: $target.data('delete-remove-at') });

          destroyer.init();
          destroyer.handleDelete(e);
        }
      });
      confirm.init();
    };
  };

  $.fn.confirmAndDelete = function(options){
    return this.each(function() {
      (new $.PMX.ConfirmAndDelete($(this), options)).init();
    });
  };

})(jQuery);
