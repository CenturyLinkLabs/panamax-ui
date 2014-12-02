(function($) {
  $.PMX.NewRemoteDeployment = function($el, options) {
    var base = this;
    base.$el = $el;

    base.init = function() {
      base.options = options;
      base.$submitButton = base.$el.find("button.deploy");

      base.disableSubmission();
      base.checkTargetHealth();
    };

    base.disableSubmission = function() {
      base.$submitButton.prop("disabled", true);
    };

    base.enableSubmission = function() {
      base.$submitButton.prop("disabled", false);
    };

    base.checkTargetHealth = function() {
      $.PMX.DeploymentTargetRefresh(base.options.refreshPath).
        done(function(m) {
          base.enableSubmission();
        }).
        fail(function(o) {
          $.PMX.Helpers.displayError(
            o.message,
            { style: 'warning', container: base.$el }
          );
        });
    };
  };

  $.fn.newRemoteDeployment = function(options) {
    return this.each(function() {
      (new $.PMX.NewRemoteDeployment($(this), options)).init();
    });
  };
})(jQuery);
