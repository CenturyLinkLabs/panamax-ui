describe('$.fn.portMappings', function() {
  var subject,
    $portMappings;

  var serviceResponse = {
    'sub_state': 'running',
    'load_state': 'loaded',
    'docker_status': {
      'info': {
        'NetworkSettings': {
          'Ports': {'3333/tcp': [{'HostInterface': '0.0.0.0', 'HostPort': '49100'}]}
        }
      }
    }
  };

  var stoppedServiceResponse = {
    'sub_state': 'stopped',
    'load_state': 'foo',
    'docker_status': {
      'info': {}
    }
  };

  var loadingServiceResponse = {
    'sub_state': 'foo',
    'load_state': 'loading',
    'docker_status': {
      'info': {}
    }
  };

  beforeEach(function() {
    fixture.load('ports-table.html');
  });

  describe('handleResponse', function() {

    describe('when the service is running', function () {
      it('removes the loading class from the table', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;

        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect($('table.port-bindings').hasClass('service-loading')).toBeFalsy;
      });

      it('calls updatePortMappings if the host port is auto-assigned', function() {
        $portMappings = $('#teaspoon-fixtures').find('tr.auto-assigned-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        spyOn(subject, 'updatePortMappings');
        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect(subject.updatePortMappings).toHaveBeenCalledWith(serviceResponse);
      });

      it('does not call updatePortMappings if the host port is present', function() {
        $portMappings = $('#teaspoon-fixtures').find('tr.present-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        spyOn(subject, 'updatePortMappings');
        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect(subject.updatePortMappings).not.toHaveBeenCalled();
      });
    });

    describe('when the service is not running', function () {
      it('adds the loading class to the table', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;
      });

      it('updates the row if the host port is auto-assigned', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr.auto-assigned-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('tr.auto-assigned-host .view-action').text()).toEqual('port is being assigned...');
        expect($('tr.auto-assigned-host .view-action').attr('href')).toEqual('');
        expect($('tr.auto-assigned-host .host-port').text()).toEqual('.....');
      });

      it('does not update the row if the  host port is present', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr.present-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('tr.present-host .view-action').text()).toEqual('localhost:1234');
        expect($('tr.present-host .view-action').attr('href')).toEqual('localhost:1234');
        expect($('tr.present-host .host-port').text()).toEqual('1234');
      });
    });

    describe('when the service is not loaded', function () {
      it('updates the row if the  host port is auto-assigned', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr.auto-assigned-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', loadingServiceResponse);
        expect($('tr.auto-assigned-host .view-action').text()).toEqual('port is being assigned...');
        expect($('tr.auto-assigned-host .view-action').attr('href')).toEqual('');
        expect($('tr.auto-assigned-host .host-port').text()).toEqual('.....');
      });

      it('does not update the row if the  host port is present', function () {
        $portMappings = $('#teaspoon-fixtures').find('tr.present-host');
        subject = new $.PMX.PortMappings($portMappings);
        subject.init();
        $('span.service-status').trigger('update-service-status', loadingServiceResponse);
        expect($('tr.present-host .view-action').text()).toEqual('localhost:1234');
        expect($('tr.present-host .view-action').attr('href')).toEqual('localhost:1234');
        expect($('tr.present-host .host-port').text()).toEqual('1234');
      });
    });
  });

  describe('showLoadingStyles', function () {
    it('adds the loading class from the table', function () {
      $portMappings = $('#teaspoon-fixtures').find('tr');
      subject = new $.PMX.PortMappings($portMappings);
      subject.init();
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeFalsy;

      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;
    });

  });

  describe('hideLoadingStyles', function () {
    it('removes the loading class from the table', function () {
      $portMappings = $('#teaspoon-fixtures').find('tr');
      subject = new $.PMX.PortMappings($portMappings);
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;

      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeFalsy;
    });
  });

  describe('updatePortMappings', function () {

    beforeEach(function () {
      $portMappings = $('#teaspoon-fixtures').find('tr.auto-assigned-host');
      subject = new $.PMX.PortMappings($portMappings);
    });

    it ('calls getPortsList', function () {
      subject.init();
      spyOn(subject, 'getPortsList').andReturn([{portNumber: 3333, host: 49100}]);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect(subject.getPortsList).toHaveBeenCalledWith(serviceResponse.docker_status.info.NetworkSettings.Ports);
    });

    it ('replaces port information', function () {
      subject.init();
      spyOn(subject, 'getPortsList').andReturn([{portNumber: 3333, host: 49100}]);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('tr.auto-assigned-host .view-action').text()).toEqual('localhost:49100');
      expect($('tr.auto-assigned-host .view-action').attr('href')).toEqual('localhost:49100');
      expect($('tr.auto-assigned-host .host-port').text()).toEqual('49100');
    });
  });

  describe('getPortsList', function () {
    beforeEach(function () {
      $portMappings = $('#teaspoon-fixtures').find('tr.auto-assigned-host');
      subject = new $.PMX.PortMappings($portMappings);
    });

    it ('assembles an array of port numbers and host ports', function () {
      $('span.service-status').trigger('update-service-status', serviceResponse);
      var result = subject.getPortsList(serviceResponse.docker_status.info.NetworkSettings.Ports);
      expect(result).toEqual([{portNumber: '3333', host: '49100'}])
    });
  });
});
