(function($){
  $.PMX.NoticeDestroyer = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      noticeDismiss: 'section.notice a.dismiss'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.noticeDismiss, base.dismissNotice);
    };

    base.dismissNotice = function (e) {
      var $target = $(e.currentTarget),
          $noticeDiv = $target.closest('div[class^=notice]');

      $noticeDiv.css('opacity', '0.5')
                .delay(1000)
                .fadeOut('slow', function () {
                  $(this).remove()
                });
    };
  };

  $.fn.noticeActions = function (options) {
    return this.each(function () {
      (new $.PMX.NoticeDestroyer(this, options)).init();
    });
  };
})(jQuery);