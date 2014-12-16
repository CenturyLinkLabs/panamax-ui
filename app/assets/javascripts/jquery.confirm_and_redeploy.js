(function($){

  $.PMX.ConfirmAndRedeploy = function($el, options) {
    var base = this;

    base.$el = $el;
    base.confirm = null;

    base.defaultOptions = {
      disableWith: 'Redeploying...'
    };

    base.init = function () {
      base.options = $.extend({}, base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      base.$el.on('click', '[data-action-confirm]', base.clickHandler);
    };

    base.clickHandler = function(e) {
      e.preventDefault();
      e.stopPropagation(); // so jquery_ujs doesn't catch this

      base.createConfirmation(e);
    };

    base.createConfirmation = function(e) {
      var $target = $(e.currentTarget);
      base.confirm = new $.PMX.ConfirmDelete($target.closest('.actions'),
                                             base.buildOptions(e));
      base.confirm.init();
    };

    base.disable = function($target) {
      if (base.options.disableWith) {
        $target.html(base.options.disableWith);
        $target.addClass('disabled');
      }
    };

    base.buildOptions = function(e) {
      var $target = $(e.currentTarget),
        options = {
          message: $target.data('action-confirm'),
          confirm: function () {
            base.disable($target);
            base.confirm.unWrapElements(base.$el.find('button.yes'));

            $.ajax({
              url: $target.attr('href'),
              headers: {
                'Accept': 'application/json'
              },
              type: 'POST'
            })
              .done(function() {
                location.reload();
              });
          }
        };

      if ($target.data('action-button-text')) {
        options.buttonText = $target.data('action-button-text');
      }

      return options;
    };
  };

  $.fn.confirmAndRedeploy = function(options){
    return this.each(function() {
      (new $.PMX.ConfirmAndRedeploy($(this), options)).init();
    });
  };

})(jQuery);
