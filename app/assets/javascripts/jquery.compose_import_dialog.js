(function($) {
  $.PMX.ApplicationComposeImporter = function (el, options) {
    var base = this,
      composeDialog;

    base.$el = $(el);

    base.defaultOptions = {
      composeImportSelector: '.compose-import',
      composeImportDialogSelector: '#app-from-compose-modal',
      composeImportFilenameSelector: '.import-file-name'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.composeImportSelector, base.triggerImport);
      $(base.options.composeImportDialogSelector).on('change', $('input[type=file]'), base.updateFilename);
    };

    base.triggerImport = function (e) {
      e.preventDefault();
      composeDialog = $.PMX.Helpers.dialog(base, $(base.options.composeImportDialogSelector), {
          title: 'Run a Docker Compose YAML',
          buttons: [
            {
              text: 'Run Compose YAML',
              class: 'button-primary',
              click: base.importFile
            }
          ]
        }
      );
      composeDialog.dialog('open');
    };

    base.updateFilename = function () {
      var filename = $(base.options.composeImportDialogSelector).find($('input[type=file]')).val();
      $(base.options.composeImportDialogSelector).find(base.options.composeImportFilenameSelector).text(filename);
    };

    base.importFile = function (e) {
      e.preventDefault();
      $(base.options.composeImportDialogSelector).find('form').submit();
      $(e.currentTarget).attr('disabled', 'disabled');
      $(e.currentTarget).find('span').text('Running...');
    };

    base.handleClose = function () {
      composeDialog.dialog('close');
      $('body').css('overflow', 'auto');
    };
  };

  $.fn.composeImportDialog = function(options){
    return this.each(function(){
      (new $.PMX.ApplicationComposeImporter(this, options)).init();
    });
  };
})(jQuery);
