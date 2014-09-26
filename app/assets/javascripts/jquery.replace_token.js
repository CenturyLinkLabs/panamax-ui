//= require jquery.ui.dialog

(function($){

  $.PMX.ReplaceToken = function($el, options) {
    var base = this;

    base.$el = $el;

    base.defaultOptions = {
      $modalContents: $('#update-token-modal'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close')
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
      base.initiateDialog();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.showDialogForm);
    };

    base.showDialogForm = function (e) {
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
        height: 300,
        position: ["top", 30],
        title: 'Replace GitHub Token',
        close: base.handleClose,
        buttons: [
          {
            text: "Save New Token",
            class: 'button-positive',
            click: base.handleTokenSave
          },
          {
            text: "Cancel",
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

    base.handleTokenSave = function () {
      var form = base.defaultOptions.$modalContents.find('form');
      form.submit();
      base.handleClose();
    };

  };

  $.fn.replaceToken = function(options){
    return this.each(function() {
      (new $.PMX.ReplaceToken($(this), options)).init();
    });
  };

})(jQuery);
