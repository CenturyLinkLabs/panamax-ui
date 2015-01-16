(function($) {
  $.PMX.RemoteContentsDialog = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.modal = null;
    base.options = options;

    base.init = function() {
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.targetSelector, base.handleTargetClick);
    };

    base.handleTargetClick = function(e) {
      e.preventDefault();
      var $target = $(e.currentTarget),
      targetUrl = $target.attr('href');

      base.fetchContents($target, targetUrl);
    };

    base.fetchContents = function($target, targetUrl) {
      $.ajax({
        type: 'GET',
        dataType: 'html',
        headers: {
          'Accept': 'text/html'
        },
        url: targetUrl
      }).done(function(response) {
        base.triggerDialogWith(response);
      });
    };

    base.triggerDialogWith = function(response) {
      var $html = $('<div/>').html(response),
      $content = $html.find('.plain-contents'),
      title = $html.find('title').text();

      base.modal = $.PMX.Helpers.dialog(base, $content, {
        title: title
      });

      base.modal.dialog('open');
    };

    base.handleClose = function() {
      base.modal.dialog('close');
    };
  };

  $.fn.remoteContentsDialog = function(options) {
    return this.each(function() {
      (new $.PMX.RemoteContentsDialog(this, options)).init();
    });
  };

})(jQuery);
