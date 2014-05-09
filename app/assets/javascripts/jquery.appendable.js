(function($){
  $.PMX.AdditionalItem = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      cancelSelector: '.cancel'
    }

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.cancelSelector, base.handleCancel);
    };

    base.handleCancel = function(e) {
      e.preventDefault();
      base.$el.remove();
    };
  };

  $.PMX.Appendable = function($el, options){
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      $trigger: $('.button-add'),
      $elementToAppend: $('#row_template'),
      addCallback: function() { return null }
    }

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.options.$trigger.on('click', base.handleTriggerClick);
    };

    base.handleTriggerClick = function(e) {
      e.preventDefault();
      base.appendItem();
    };

    base.appendItem = function() {
      var newItem = new $.PMX.AdditionalItem(base.options.$elementToAppend.clone());
      base.$el.append(newItem.$el);
      newItem.init();
      base.options.addCallback(newItem);
    };
  };

  $.fn.appendable = function(options){
    return this.each(function(){
      (new $.PMX.Appendable($(this), options)).init();
    });
  };

})(jQuery);
