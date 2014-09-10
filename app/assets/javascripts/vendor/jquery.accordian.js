(function($) {
  $.fn.accordian = function() {
    $(this).on('click', function(e) {
      e.preventDefault();
      var $el = $(e.currentTarget);

      $($el.data('accordian-collapse')).hide();
      $($el.data('accordian-expand')).show();
    });
  };
})(jQuery);
