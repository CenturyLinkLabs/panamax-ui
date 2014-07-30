//= require jquery.ui.dialog

(function($){
  $.PMX.PreviewTemplate = function($el, options) {
    var base = this,
        templateDialog;

    base.$el = $el;

    base.defaultOptions = {
      previewPath: 'data-previewPath'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.triggerPreview);
    };

    base.triggerPreview = function(e) {
      var form_data = base.$el.closest('form').serialize(),
          previewUrl = base.$el.attr(base.options.previewPath);

      e.preventDefault();
      $.ajax({
        type: "POST",
        headers: {
          'Accept': 'application/json'
        },
        url: previewUrl,
        data: form_data
      })
        .done(function(response) {
          templateDialog = base.initiateDialog(response.template);
          prettyPrint();
          templateDialog.dialog('open');
        });
    };

    base.initiateDialog = function (contents) {
      return $('<pre class="prettyprint lang-yaml">' + contents + '</pre>').dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Template File Preview',
        close: base.handleClose,
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      });
    };

    base.handleClose = function () {
      templateDialog.dialog("close");
      $('body').css('overflow', 'auto');
    };
  };

  $.fn.previewTemplate = function(options){
    return this.each(function() {
      (new $.PMX.PreviewTemplate($(this), options)).init();
    });
  };

})(jQuery);
