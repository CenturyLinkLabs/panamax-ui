//= require jquery.ui.dialog

(function($){
  $.PMX.TemplateDetailsDialog = function(el, options) {
    var base = this;

    base.$el = $(el);
    base.xhr = null;

    base.defaultOptions = {
      $modalContents: $('#template-details-dialog'),
      $titlebarCloseButton: $('button.ui-dialog-titlebar-close'),
      $templateRow: $('#template_' + options.template_id),
      buttonSelector: '.actions button.button-positive',
      dialogContentSelector: '.ui-dialog-content',
      loadingTemplate: Handlebars.compile($('#loading_row_template').html())
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.initiateDialog();
    };

    base.calculateHeight = function() {
      var browserHeight = $( window ).height();
      return Math.ceil(browserHeight * 0.9);
    };

    base.initiateDialog = function () {
      $.PMX.Helpers.dialog(base, base.defaultOptions.$modalContents, {
        dialogClass: 'template-details-dialog',
        height: base.calculateHeight(),
        title: 'Template Details',
        open: base.fetchTemplateDetails,
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      });

      // must set height here or jQueryUI sets inline style to auto
      base.defaultOptions.$modalContents.find(base.options.dialogContentSelector).css('height', '100%');

    };

    base.handleClose = function () {
      base.defaultOptions.$modalContents.dialog("close");
      base.options.$modalContents.html('');
      $('body').css('overflow', 'auto');
    };

    base.showTemplateDialog = function() {
      base.defaultOptions.$modalContents.dialog("open");
    };

    base.fetchTemplateDetails = function() {
      base.displayLoadingIndicator();
      if (base.xhr) {
        base.xhr.abort();
      }

      base.xhr = $.ajax({
        url: base.options.url,
        dataType: 'html'
      });

      base.xhr.done(function(response, status) {
        base.options.$modalContents.html(response);
      });
    };

    base.displayLoadingIndicator = function() {
      var forDetails = base.options.loadingTemplate({loading_copy: 'Loading Template Details'});
      base.options.$modalContents.html(forDetails);
    };

    base.handleSubmit = function(e) {
      var $actionsFormSubmit = base.options.$templateRow.find(base.options.buttonSelector);
      e.preventDefault();

      $actionsFormSubmit.click();
      base.handleClose();
    };
  };
})(jQuery);
