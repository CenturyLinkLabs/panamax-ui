(function($) {
  $.fn.toggleTargetClass = function() {
    $(this).on('click', function(e) {
      e.preventDefault();
      var $el = $(e.currentTarget);

      var cssClass = $el.data('toggle-class');
      $($el.data('toggle-target')).toggleClass(cssClass);
    });
  };
})(jQuery);
