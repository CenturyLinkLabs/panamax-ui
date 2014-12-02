(function($) {
  $.PMX.DeploymentTargetRefresh = function(refreshPath) {
    var result = $.Deferred();

    $.ajax({
      url: refreshPath,
      // TODO: this is duplicated all over the place
      headers: { 'Accept': 'application/json' },
      method: "POST",
      statusCode: {
        201: function(o) {
          result.resolve(o);
        },
        409: function(r) {
          result.reject({
            message: r.responseJSON.error,
            fixPath: r.getResponseHeader("Location")
          });
        }
      },
    });

    return result.promise();
  };
})(jQuery);
