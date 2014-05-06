//= require jquery.ui.dialog

(function($){
  $.PMX.AddService = function(el) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $addServiceButton: $('a.add-service'),
      $modalContents: $('#add-service-form'),
      $dialogBox: $('.ui-dialog'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close')

    };

    base.init = function(){
      base.bindEvents();
      base.initiateDialog();

    };

    base.bindEvents = function() {
      base.$el.on('click', base.defaultOptions.$addServiceButton.selector, base.showDialogForm);
      base.defaultOptions.$dialogBox.on('click', base.defaultOptions.$titlebarCloseButton.selector, base.handleClose);
    };

    base.showDialogForm = function (e) {
      base.defaultOptions.$modalContents.dialog("open");
      e.preventDefault();
      $('body').css('overflow', 'hidden')
    };

    base.handleClose = function() {
      $(this).dialog("close");
      $('.image-results').empty();
      $('#search_form_query').val('');
      $('body').css('overflow', 'auto')
    };

    base.initiateDialog = function() {
      base.defaultOptions.$modalContents.dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Search Images',
        buttons: [
          {
            text: "Cancel",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      })
    }
  };

  $.fn.categoryActions = function(){
    return this.each(function(){
      (new $.PMX.AddService(this)).init();
    });
  };
})(jQuery);
