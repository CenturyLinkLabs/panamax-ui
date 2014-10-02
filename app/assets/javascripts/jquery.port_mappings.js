(function($) {
  $.PMX.PortMappings = function(el, options) {
    var base = this;

    base.$el = $(el);

    base.defaultOptions = {
      $pathLink: base.$el.find('a.view-action'),
      $hostPort: base.$el.find('span.host-port'),
      containerPort: base.$el.find('span.container-port').text(),
      hostname: base.$el.find('a.view-action').data('host').trim(),
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
      var hasAutoAssignedPorts = base.$el.hasClass('auto-assigned-host');
      var serviceIsRunning = response.sub_state === 'running' && response.load_state === 'loaded';

      if (serviceIsRunning) {
        base.hideLoadingStyles();
        if (hasAutoAssignedPorts) {
          base.updatePortMappings(response);
        }
      }

      else {
        base.showLoadingStyles();
        if (hasAutoAssignedPorts) {
          base.options.$pathLink.text('port is being assigned...');
          base.options.$pathLink.attr('href', '');
          base.options.$hostPort.text('.....');
        }
      }
    };

    base.showLoadingStyles = function () {
      if (!base.$el.closest('table').hasClass('service-loading')) {
        base.$el.closest('table').addClass('service-loading');
      }
    };

    base.hideLoadingStyles = function () {
      if (base.$el.closest('table').hasClass('service-loading')) {
        base.$el.closest('table').removeClass('service-loading');
      }
    };

    base.updatePortMappings = function(response) {
      base.hideLoadingStyles();
      var portsList = base.getPortsList(response.docker_status.info.NetworkSettings.Ports);
      $.each(portsList, function (index, value) {
        if (value['portNumber'] == base.options.containerPort) {
          var dynamicPort = value['host'];
          var newPath =  base.options.hostname + ':'  + dynamicPort;
          base.options.$hostPort.text(dynamicPort);
          base.options.$pathLink.text(newPath);
          base.options.$pathLink.attr('href', newPath);
        }
      });
    };

    base.getPortsList = function(ports) {
      var portsList = [];
      $.each(ports, function(port, info) {
        if (info) {
          var portNumber = port.split('/')[0];
          portsList.push({portNumber: portNumber, host: info[0].HostPort});
        }
      });
      return portsList;
    };
  };

  $.fn.portMappings = function(options) {
    return this.each(function() {
      (new $.PMX.PortMappings(this, options)).init();
    });
  };

})(jQuery);
