(function($){
  $.PMX.ApplicationComposeExporter = function(el, options) {
    var base = this,
      client,
      composeDialog,
      gistConfirmationDialog;

    base.$el = $(el);

    base.defaultOptions = {
      composePath: 'data-composePath',
      downloadPath: 'data-downloadPath',
      composeExportSelector: 'ul.application-button-menu a.export',
      gistConfirmationDialogSelector: '#gistConfirmationDialog',
      gistConfirmationCancelSelector: '.cancel-export',
      gistConfirmationConfirmSelector: '.gist-confirm'
    };

    base.init = function() {
      client = new ZeroClipboard();

      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.composeExportSelector, base.triggerExport);
    };

    base.triggerExport = function(e) {
      var $target = $(e.currentTarget);
      var composeUrl = $target.attr(base.options.composePath);
      base.options.downloadUrl = $target.attr(base.options.downloadPath);

      e.preventDefault();
      $.ajax({
        type: 'GET',
        headers: {
          'Accept': 'application/json'
        },
        url: composeUrl
      })
        .done(function(response) {
          composeDialog = base.initiateDialog(response.compose_yaml);
          composeDialog.dialog('open');

          client.clip($('.clipboard-copy'));
          client.setText(response.compose_yaml);
          client.on('aftercopy', base.afterCopy);
        });
    };

    base.initiateDialog = function (contents) {
      return $.PMX.Helpers.dialog(base, $('<pre class="prettyprint lang-yaml">' + contents + '</pre>'), {
        title: 'Docker Compose YAML',
        draggable: false,
        buttons: [{
          text: 'Save as Local File',
          class: 'button-primary download',
          click: base.handleDownload
        },{
          text: 'Inspect & Validate in Lorry.io',
          class: 'link lorry-export',
          click: base.confirmGistCreation
        },{
          text: 'Copy to Clipboard',
          class: 'link clipboard-copy',
          click: $.noop
        }]
        }
      );
    };

    base.afterCopy = function (e) {
      $(e.target).addClass('copied');
      $(e.target).text('YAML Copied to Clipboard');
    };

    base.handleDownload = function () {
      window.open(base.options.downloadUrl, '_blank');
    };

    base.confirmGistCreation = function () {
      // hide text of underlying dialog
      $('.prettyprint').css('visibility', 'hidden');

      gistConfirmationDialog = $(base.options.gistConfirmationDialogSelector).dialog({
        autoOpen: true,
        dialogClass: 'dialog-dialog',
        maxHeight: 500,
        modal: true,
        resizable: false,
        draggable: false,
        width: 860,
        close: base.cancelExport,
        position: { my: 'top', at: 'top+50', of: window }
      });

      gistConfirmationDialog.on('click', base.options.gistConfirmationCancelSelector, base.cancelExport);
      gistConfirmationDialog.on('click', base.options.gistConfirmationConfirmSelector, base.confirmExport);
    };

    base.cancelExport = function () {
      gistConfirmationDialog.dialog('close');
      $('.prettyprint').css('visibility', 'visible');
    };

    base.confirmExport = function () {
      gistConfirmationDialog.dialog('close');
      base.handleClose();
    };

    base.handleClose = function () {
      composeDialog.dialog('close');
      $('body').css('overflow', 'auto');
    };
  };

  $.fn.composeExportDialog = function(options){
    return this.each(function(){
      (new $.PMX.ApplicationComposeExporter(this, options)).init();
    });
  };
})(jQuery);
