//= require jquery.ui.dialog

(function($) {

  $.PMX.AppInstructionsDialog = function (el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $modalContents: $('#post-run-html'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close')
    };


    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.initiateDialog();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.showInstructions);
    };

    base.showInstructions = function (e) {
      e.preventDefault();

      base.defaultOptions.$modalContents.dialog("open");
    };

    base.initiateDialog = function () {
      base.defaultOptions.$modalContents.dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Post-Run Instructions',
        close: base.handleClose,
        buttons: [
          {
            text: "Open in New Browser Window",
            class: 'button-primary',
            click: base.handleNewWindowOpen
          },
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      })
    };

    base.handleClose = function () {
      base.defaultOptions.$modalContents.dialog("close");
      $('body').css('overflow', 'auto');
    };

    base.handleNewWindowOpen = function () {
      base.defaultOptions.$modalContents.dialog("close");
      window.open(base.documentationEndpoint(), "_blank");
    };

    base.documentationEndpoint = function () {
      return base.$el.data('doc-url');
    };
  };

  $.fn.appInstructionsDialog = function (options) {
    return this.each(function(){
      (new $.PMX.AppInstructionsDialog(this, options)).init();
    });
  };

})(jQuery);