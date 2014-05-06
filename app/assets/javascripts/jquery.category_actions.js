//= require jquery.ui.dialog

(function($){
  $.PMX.AddService = function(el) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $addServiceButton: $('a.add-service'),
      $modalContents: $('#add-service-form')
    };

    base.init = function(){
      base.bindEvents();
      base.initiateDialog();

    };

    base.bindEvents = function() {
      base.$el.on('click', base.defaultOptions.$addServiceButton.selector, base.showDialogForm);
    };

    base.showDialogForm = function (e) {
      base.defaultOptions.$modalContents.dialog("open");
      e.preventDefault();
    };

    base.initiateDialog = function() {
      $("#add-service-form").dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 800,
        title: 'Search Images',
        buttons: [
          {
            text: "Cancel",
            class: 'button-secondary',
            click: function () {
              $(this).dialog("close");
            }
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
