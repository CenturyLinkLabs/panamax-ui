//= require jquery.ui.dialog

(function($){

  $.PMX.DockerInspect = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      $modalContents: $('#docker-inspect'),
      linkSelector: 'a',
      dockerStatusSelector: '.service-details .service-status',
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close')
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.initiateDialog();
    };

    base.bindEvents = function () {
      base.$el.on('click',base.options.linkSelector ,base.showDialogHandler);
      $(base.options.dockerStatusSelector).on('update-service-status', base.checkStatusHandler);
    };

    base.showLink = function() {
      base.$el.fadeIn();
    };

    base.hideLink = function() {
      base.$el.fadeOut();
    };

    base.checkStatusHandler = function(_, response) {
      (response.sub_state === 'running') ? base.showLink() : base.hideLink();
    };

    base.insertInspectData = function(wndHandle) {
      var content = $(base.options.$modalContents).text();

      $(wndHandle.document.body).html(content);
    };

    base.handleNewWindowOpen = function () {
       var wnd = window.open();
       base.options.$modalContents.dialog("close");
       base.insertInspectData(wnd);
    };

    base.showDialogHandler = function (e) {
      e.preventDefault();
      base.options.$modalContents.dialog("open");
    };

    base.initiateDialog = function () {
      $.PMX.Helpers.dialog(base, base.defaultOptions.$modalContents, {
        height: 500,
        title: 'Docker Inspect',
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          },
          {
            text: "Open in New Browser Window",
            class: 'button-dark-blue',
            click: base.handleNewWindowOpen
          }
        ]
      });
    };

    base.handleClose = function () {
      base.defaultOptions.$modalContents.dialog("close");
      $('body').css('overflow', 'auto');
    };
  };

  $.fn.dockerInspect = function(options){
    return this.each(function() {
      (new $.PMX.DockerInspect($(this), options)).init();
    });
  };

})(jQuery);
