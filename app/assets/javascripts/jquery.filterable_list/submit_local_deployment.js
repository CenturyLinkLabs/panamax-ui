(function($){
  $.PMX.SubmitLocalDeployment = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      submitLinkSelector: '.select-target button.link',
      toggleAttribute: 'data-toggle-class',
      toggleSelector: '.select-target',
      expandedClass: 'expanded',
      disabledClass: 'disabled',
      loadingAttribute: 'data-loading',
      headerSelector: 'header'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.submitLinkSelector, base.submitHandler);
    };

    base.submitHandler = function(e) {
      var target = $(e.currentTarget),
          toggle = target.closest(base.options.toggleSelector);

      base.disableToggle(toggle);
      base.disableElement(toggle, target);
    };

    base.disableToggle = function(element) {
      element.removeAttr(base.options.toggleAttribute);
      element.removeClass(base.options.expandedClass);
    };

    base.disableElement = function(element, target) {
      element.addClass(base.options.disabledClass);
      element.find(base.options.headerSelector).text(target.attr(base.options.loadingAttribute));
    };
  };

  $.fn.submitLocalDeployment = function(options){
    return this.each(function(){
      (new $.PMX.SubmitLocalDeployment(this, options)).init();
    });
  };

})(jQuery);

