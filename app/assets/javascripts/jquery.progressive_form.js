(function($){
  $.PMX.ProgressiveForm = function(el, options){
    var base = this;

    base.$el = el;

    base.defaultOptions = {
      removeLinkSelector: 'a[data-checkbox-selector]',
      removeCheckboxSelectorReference: 'checkbox-selector',
      $submitButton: base.$el.find('input[type="submit"]')
    };

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.hideInputs();
      base.disableSubmit();
      base.bindEvents();
    };

    base.hideInputs = function() {
      base.$el.find('input[type="checkbox"]').hide();
    };

    base.disableSubmit = function() {
      base.options.$submitButton.prop('disabled', true);
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.removeLinkSelector, base.handleRemove);
      base.$el.on('change', 'select', base.handleFormChange);
      base.$el.on('keyup', 'input, textarea', base.handleFormChange);
    };

    base.handleFormChange = function(e) {
      base.options.$submitButton.prop('disabled', false);
    };

    base.handleRemove = function(e) {
      e.preventDefault();
      base.checkRelated($(e.currentTarget));
      base.$el.submit();
    };

    base.checkRelated = function($source) {
      var selector = $source.data(base.options.removeCheckboxSelectorReference);
      var $checkbox = base.$el.find(selector);
      $checkbox.prop('checked', true);
    };
  };

  $.fn.progressiveForm = function(options){
    return this.each(function(){
      (new $.PMX.ProgressiveForm($(this), options)).init();
    });
  };

})(jQuery);
