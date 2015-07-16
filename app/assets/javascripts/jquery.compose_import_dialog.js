//= require jquery.ui.tabs

(function($) {
  $.PMX.ApplicationComposeImporter = function (el, options) {
    var base = this,
      composeDialog,
      importTabs;

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
      importTabs = $(base.options.composeImportDialogSelector).find('#tabs').tabs(
        {
          heightStyle: 'fill'
        }
      );
    };

    base.updateFilename = function () {
      var filename = $(base.options.composeImportDialogSelector).find($('input[type=file]')).val();
      filename = filename.replace('C:\\fakepath\\', '');
      $(base.options.composeImportDialogSelector).find(base.options.composeImportFilenameSelector).text(filename);
    };

    base.importFile = function (e) {
      var activeTabIndex = importTabs.tabs( 'option', 'active' ),
        formId = activeTabIndex === 0 ? '#upload-form' : '#uri-form';

      e.preventDefault();
      $(base.options.composeImportDialogSelector).find(formId).submit();
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
