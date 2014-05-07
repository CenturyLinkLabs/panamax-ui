(function($){
  $.PMX.ProgressiveForm = function(el, options){
    var base = this;

    base.$el = el;

    base.defaultOptions = {
      removeLinkSelector: 'a[data-checkbox-selector]',
      removeCheckboxSelectorReference: 'checkbox-selector'
    }

    base.init = function(){
      base.options = $.extend({}, base.defaultOptions, options);
      base.hideInputs();
      base.bindEvents();
    };

    base.hideInputs = function() {
      base.$el.find('input').hide();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.removeLinkSelector, base.handleRemove);
    };

    base.handleRemove = function(e) {
      console.log('handle it');
      e.preventDefault();
      base.uncheckRelatedBox($(e.currentTarget));
      base.$el.submit();
    };

    base.uncheckRelatedBox = function($source) {
      var selector = $source.data(base.options.removeCheckboxSelectorReference);
      var $checkbox = base.$el.find(selector)
      $checkbox.prop('checked', false);
    };
  };

  $.fn.progressiveForm = function(options){
    return this.each(function(){
      (new $.PMX.ProgressiveForm($(this), options)).init();
    });
  };

})(jQuery);
