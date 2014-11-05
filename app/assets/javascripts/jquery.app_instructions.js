//= require jquery.ui.dialog

(function($) {

  $.PMX.AppInstructionsDialog = function (el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $modalContents: $('#post-run-html')
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
      $.PMX.Helpers.dialog(base, base.defaultOptions.$modalContents, {
        title: 'Post-Run Instructions',
        height: 700,
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
      });
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
