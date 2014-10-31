(function($) {
  $.PMX.CancelForm = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.init = function() {
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.handleCancel);
    };

    base.clearForm = function () {
      base.$el.closest('form')[0].reset();
    };

    base.handleCancel = function (e) {
      base.clearForm();
    };
  };

  $.fn.cancelForm = function(options) {
    return this.each(function() {
      (new $.PMX.CancelForm(this, options)).init();
    });
  };

})(jQuery);
