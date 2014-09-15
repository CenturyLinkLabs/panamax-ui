(function($) {
  $.PMX.WatchImageSelections = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      allSelector: 'input#all',
      observerSelector: 'input[type=checkbox]',
      submitSelector: 'button[type=submit]',
      deleteCheckbox: '.images input[type=checkbox]'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('change', base.options.allSelector, base.checkboxStateHandler);
      base.$el.on('change', base.options.observerSelector, base.submitStateHandler);
    };

    base.submitStateHandler = function(e) {
      var checked = base.$el.find(base.options.deleteCheckbox).filter(':checked'),
          submitButton = base.$el.find(base.options.submitSelector);

      if (checked.length > 0) {
        submitButton.prop('disabled', false);
      } else {
        submitButton.prop('disabled', true);
      }
    };

    base.checkboxStateHandler = function(e) {
      var $target = $(e.currentTarget),
          checked = $target.is(':checked');

      base.$el.find(base.options.deleteCheckbox).prop('checked', checked);
    };
  };

  $.fn.imageActions = function(options) {
    return this.each(function() {
      (new $.PMX.WatchImageSelections($(this), options)).init();
    });
  };

})(jQuery);
