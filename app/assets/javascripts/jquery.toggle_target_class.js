(function($) {
  $.fn.toggleTargetClass = function() {
    $(this).on('click', function(e) {
      e.preventDefault();
      var $el = $(e.currentTarget),
          target = ($el.data('toggle-target') || $(this)),
          cssClass = $el.data('toggle-class');

      $(target).toggleClass(cssClass);
    });
  };
})(jQuery);
