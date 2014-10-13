(function($) {
  $.PMX.ManageRegistries = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $registriesForm: $('form.new_registry'),
      registriesFormButtonSelector: '.button-add'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.registriesFormButtonSelector, base.toggleForm);
    };

    base.toggleForm = function (e) {
      e.preventDefault();
      base.options.$registriesForm.slideToggle();
    };
  };

  $.fn.registriesActions = function(options) {
    return this.each(function() {
      (new $.PMX.ManageRegistries(this, options)).init();
    });
  };

})(jQuery);
