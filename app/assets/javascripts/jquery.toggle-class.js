(function($) {
  $.fn.toggleTargetClass = function(options) {
    var startingHeight = 0;

    var whenAnimated = function() {
      return {
        init: function($el) {
          var $target = $(options.animateTarget);

          startingHeight = parseInt($target.css('height'));
          $target.wrapInner('<div class="inner"></div>');
        },

        handler: function(e) {
          var $el = $(e.currentTarget),
              $toggle = $($el.data('toggle-target')),
              $target = $(options.animateTarget),
              max = 0;
          e.preventDefault();

          $target.each(function() {
            var $inner = $(this).children('.inner');
            max = Math.max(max, $inner.get(0).scrollHeight);
          });

          max = ($toggle.hasClass('collapsed')) ? max : startingHeight;
          $target.animate({ height: max }, options.speed);
          $toggle.toggleClass('collapsed');
        }
      };
    };

    var notAnimated = function() {
      return {
        init: function() {},

        handler: function(e) {
          var $el = $(e.currentTarget);
          e.preventDefault();
          $($el.data('toggle-target')).toggleClass('collapsed');
        }
      };
    };

    var component = (options && options.animate) ? whenAnimated() : notAnimated();
    component.init($(this));
    $(this).on('click', component.handler);
  };
})(jQuery);
