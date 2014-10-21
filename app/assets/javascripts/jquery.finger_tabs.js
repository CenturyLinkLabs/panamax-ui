(function($) {
  $.PMX.FingerTabs = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      cardSelector: '.card',
      tabSelector: '.tab',
      activeIconSelector: '.tab.active .icon',
      tabsSelector: '.tabs',
      hideSelector: '.hide',
      labelSelector: 'label',
      updateFormEvent: { event: 'progressiveForm:changed',
                         target: 'body'
                       }
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.initializeTabs();
      base.bindEvents();
    };

    base.initializeTabs = function() {
      base.selectTab($(base.$el.find(base.options.tabSelector).first()));
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.tabSelector, base.tabClickHandler);
      base.$el.on('click', base.options.hideSelector, base.hideHandler);
      $(base.options.updateFormEvent.target).on(base.options.updateFormEvent.event, base.dataChangedHandler);
    };

    base.hideHandler = function(e) {
      base.$el.find(base.options.tabsSelector).toggleClass('slim');
    };

    base.selectTab = function($tab_element) {
      var tab_for = $tab_element.find(base.options.labelSelector).attr('for');
      base.resetTabs();
      $tab_element.addClass('active');
      base.$el.find(base.options.cardSelector + '.' + tab_for).addClass('active');

    };

    base.resetTabs = function() {
      base.$el.find(base.options.cardSelector).removeClass('active');
      base.$el.find(base.options.tabSelector).removeClass('active');
    };

    base.tabClickHandler = function(e) {
      var $target = $(e.currentTarget);
      base.selectTab($target);
    };

    base.dataChangedHandler = function(e) {
      base.$el.find(base.options.activeIconSelector).addClass('changed');
    };
  };

  $.fn.fingerTabs = function(options){
    return this.each(function(){
      (new $.PMX.FingerTabs($(this), options)).init();
    });
  };

})(jQuery);
