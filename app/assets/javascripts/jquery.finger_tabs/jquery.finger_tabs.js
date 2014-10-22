(function($) {
  $.PMX.FingerTabs = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      cardSelector: '.card',
      tabSelector: '.tab',
      tabsSelector: '.tabs',
      hideSelector: '.hide',
      labelSelector: 'label'
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
    };

    base.hideHandler = function(e) {
      base.$el.find(base.options.tabsSelector).toggleClass('slim');
    };

    base.selectTab = function($tab_element) {
      var tab_for = $tab_element.find(base.options.labelSelector).attr('for');
      console.log(tab_for);
      base.resetTabs();
      $tab_element.addClass('active');
      base.$el.find(base.options.cardSelector + '.' + tab_for).css('display', 'block');

    };

    base.resetTabs = function() {
      base.$el.find(base.options.cardSelector).css('display', 'none');
      base.$el.find(base.options.tabSelector).removeClass('active');
    };

    base.tabClickHandler = function(e) {
      var $target = $(e.currentTarget);
      base.selectTab($target);
    }
  };

  $.fn.fingerTabs = function(options){
    return this.each(function(){
      (new $.PMX.FingerTabs($(this), options)).init();
    });
  };

})(jQuery);
