(function($) {
  $.PMX.ManageRegistries = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $registriesForm: $('form.create-registry'),
      registriesFormButtonSelector: '.button-add',
      deleteRegistrySelector: '.actions a.delete-action',
      removeSelector: 'li',
      cancelButtonSelector: 'form a.cancel'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.registriesFormButtonSelector, base.toggleForm);
      base.$el.on('click', base.options.cancelButtonSelector, base.handleCancel);
      base.$el.on('click', base.options.deleteRegistrySelector, base.handleDelete);
    };

    base.toggleForm = function (e) {
      e.preventDefault();
      base.options.$registriesForm.slideToggle();
    };

    base.clearForm = function () {
      base.options.$registriesForm.find('input[type="text"]').val('');
    };

    base.handleCancel = function (e) {
      base.clearForm();
      base.toggleForm(e);
    };

    base.confirmDelete = function(e) {
      var destroyer = new $.PMX.destroyLink($(e.currentTarget).closest(base.options.removeSelector));

      destroyer.init();
      destroyer.handleDelete(e);
    };

    base.handleDelete = function(e) {
      e.preventDefault();

      var $target = $(e.currentTarget);
      (new $.PMX.ConfirmDelete($target.closest('.actions'),
        {
          message: 'Delete this registry?',
          confirm: function() {
            base.confirmDelete(e);
          }
        }
      )).init();
    };
  };

  $.fn.registriesActions = function(options) {
    return this.each(function() {
      (new $.PMX.ManageRegistries(this, options)).init();
    });
  };

})(jQuery);
