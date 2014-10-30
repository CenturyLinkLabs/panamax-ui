//= require jquery.ui.dialog

(function($) {

  $.PMX.SelectDeploymentTarget = function ($el, options) {
    var base = this,
               targetDialog;

    base.$el = $el;

    base.defaultOptions = {
      targetSelector: '.select-deployment-target',
      filterSelector: '.select-remote-target'
    };


    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', base.options.targetSelector, base.triggerDialogHandler);
    };

    base.triggerDialogHandler = function(e) {
      var $target = $(e.currentTarget),
          targetUrl = $target.attr('href');

      e.preventDefault();
      $.ajax({
        type: "GET",
        dataType: 'html',
        headers: {
          'Accept': 'text/html'
        },
        url: targetUrl
      })
        .done(function(response) {
          var $html = $('<div/>').html(response),
              $content = $html.find(base.options.filterSelector);
          base.initiateDialog($content);
        });
    };

    base.initiateDialog = function ($contents) {
      targetDialog = $contents.dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        draggable: true,
        width: 860,
        position: ["top", 50],
        title: 'Select Remote Deployment Target',
        close: base.handleClose,
        buttons: [
          {
            text: "Dismiss",
            class: 'button-secondary',
            click: base.handleClose
          }
        ]
      });
      targetDialog.dialog('open');
    };

    base.handleClose = function () {
      targetDialog.dialog("close");
      $('body').css('overflow', 'auto');
    };
  };

  $.fn.selectDeploymentTarget = function (options) {
    return this.each(function(){
      (new $.PMX.SelectDeploymentTarget($(this), options)).init();
    });
  };

})(jQuery);
