//= require jquery.ui.dialog
//= require jquery.ui.sortable

(function($) {
  $.PMX.ManageTemplateRepos = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $templateRepoForm: $('form.new_template_repo'),
      templateRepoFormButtonSelector: '.button-add',
      deleteRepoSelector: '.actions a.delete-action'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.templateRepoFormButtonSelector, base.toggleForm);
    };

    base.toggleForm = function (e) {
      e.preventDefault();
      base.options.$templateRepoForm.slideToggle();
    };

  };

  $.fn.templateRepoActions = function(options) {
    return this.each(function() {
      (new $.PMX.ManageTemplateRepos(this, options)).init();
    });
  };

})(jQuery);
