PMX.Tracker = {
  trackEvent: function() {
    [].unshift.call(arguments, 'event');
    [].unshift.call(arguments, 'send');
    PMX.Console.log(arguments);
    window.gaTracker.apply(this, arguments);
  }
};

(function($){
  $.fn.analyticsClickTracker = function() {
    $(this).on('click', '[data-tracking-method="click"]', function(e) {
      var $el = $(e.currentTarget),
      category = $el.data('tracking-category'),
      action = $el.data('tracking-action'),
      label = $el.data('tracking-label');
      PMX.Tracker.trackEvent(category, action, label);
    });
  };

})(jQuery);
