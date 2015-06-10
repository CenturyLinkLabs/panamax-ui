(function($){
  $.PMX.ApplicationComposeExporter = function(el, options) {
    var base = this,
      composeDialog;

    base.$el = $(el);

    base.defaultOptions = {
      composePath: 'data-composePath',
      composeExportSelector: 'ul.application-button-menu a.export'
    };

    base.init = function() {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function() {
      base.$el.on('click', base.options.composeExportSelector, base.triggerExport);
    };

    base.triggerExport = function(e) {
      var $target = $(e.currentTarget);
      var composeUrl = $target.attr(base.options.composePath);

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

          $('.clipboard-copy').attr('data-clipboard-text', $('#composeYaml').text());
          new $.PMX.Clipboard($('.clipboard-copy'), {
            afterCopy: base.afterCopy
          }).init();
        });
    };

    base.initiateDialog = function (contents) {
      var dialogContents = $('<pre id="composeYaml" class="prettyprint lang-yaml">' + contents + '</pre>');
      return $.PMX.Helpers.dialog(base, dialogContents, {
          title: 'Docker Compose YAML',
          buttons: [{
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
