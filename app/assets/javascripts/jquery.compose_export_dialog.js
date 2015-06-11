(function($){
  $.PMX.ApplicationComposeExporter = function(el, options) {
    var base = this,
      client,
      composeDialog;

    base.$el = $(el);

    base.defaultOptions = {
      composePath: 'data-composePath',
      downloadPath: 'data-downloadPath',
      composeExportSelector: 'ul.application-button-menu a.export'
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
        buttons: [{
          text: 'Save as Local File',
          class: 'button-primary download',
          click: base.handleDownload
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
