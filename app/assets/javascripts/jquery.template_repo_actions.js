//= require jquery.ui.dialog
//= require jquery.ui.sortable

(function($) {
  $.PMX.ManageTemplateRepos = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $templateRepoForm: $('form.new_template_repo'),
      templateRepoFormButtonSelector: '.button-add',
      deleteRepoSelector: '.actions a.delete-action',
      removeSelector: 'li'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.templateRepoFormButtonSelector, base.toggleForm);
      base.$el.on('click', base.options.deleteRepoSelector, base.handleDelete);
    };

    base.toggleForm = function (e) {
      e.preventDefault();
      base.options.$templateRepoForm.slideToggle();
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
          message: 'Delete this template repository?',
          confirm: function() {
            base.confirmDelete(e);
          }
        }
      )).init();
    };
  };

  $.fn.templateRepoActions = function(options) {
    return this.each(function() {
      (new $.PMX.ManageTemplateRepos(this, options)).init();
    });
  };

})(jQuery);
