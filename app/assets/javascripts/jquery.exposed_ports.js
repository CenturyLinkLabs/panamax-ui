(function($) {
  $.PMX.ExposedPorts = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $exposedPortTableBody: base.$el.find('tbody'),
      serviceStatusSelector: 'span.service-status'
    };

    base.init = function() {
      base.options = $.extend({},base.defaultOptions, options);
      base.bindEvents();
    };

    base.bindEvents = function () {
      $(base.options.serviceStatusSelector).on('update-service-status', base.handleResponse);
    };

    base.handleResponse = function (_, response) {
      var serviceIsRunning = response.sub_state === 'running' && response.load_state === 'loaded';

      if (serviceIsRunning) {
        base.updateExposedPorts(response);
      }
      else {
        base.showLoadingMessage();
      }
    };

    base.showLoadingMessage = function () {
      if (base.$el.find('tr.loading').length === 0) {
        base.options.$exposedPortTableBody.append(
            '<tr class="loading"><td colspan="2">' +
            'More port information may be available when service enters running state' +
            '</td></tr>'
        );
      }
    };

    base.hideLoadingMessage = function () {
      if (base.$el.find('tr.loading').length > 0) {
        base.$el.find('tr.loading').remove();
      }
    };

    base.formatPort = function (exposed_port) {
      return exposed_port.replace("/", " / ").toUpperCase();
    };

    base.updateExposedPorts = function(response) {
      base.hideLoadingMessage();
      var exposed_ports = response.default_exposed_ports;

      if ((base.$el.find('tr.image-defined').length == 0) && exposed_ports.length > 0) {
        $.each(exposed_ports, function(index, exposed_port) {
          var port = base.formatPort(exposed_port);
          base.options.$exposedPortTableBody.append(
              '<tr class="image-defined"><td>'+
              port +
              '</td><td><div class="info">' +
              'exposed by base image - remote deployment will require explicit port declaration' +
              '</div></td></tr>'
          );
        });
      }
    };
  };

  $.fn.exposedPorts = function(options) {
    return this.each(function() {
      (new $.PMX.ExposedPorts(this, options)).init();
    });
  };

})(jQuery);
