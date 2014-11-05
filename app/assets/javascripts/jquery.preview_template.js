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

    base.serializeFormAndFixDocumentation = function(theForm) {
      var doc_element_name = theForm.find('.template_documentation').attr('name');
      var form_data_arr = theForm.serializeArray();

      // Find and replace 'documentation' by striping out any trailing whitespace that precedes a newline
      for (index = 0; index < form_data_arr.length; ++index) {
        if (form_data_arr[index].name == doc_element_name) {
          form_data_arr[index].value = form_data_arr[index].value.replace(/[^\S\n]*(?=\n)/g, '');
          break;
        }
      }
      return $.param(form_data_arr);
    };

    base.triggerPreview = function(e) {
      var form_data = base.serializeFormAndFixDocumentation(base.$el.closest('form')),
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
      return $.PMX.Helpers.dialog(base, $('<pre class="prettyprint lang-yaml">' + contents + '</pre>'), {
        title: 'Template File Preview'
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
