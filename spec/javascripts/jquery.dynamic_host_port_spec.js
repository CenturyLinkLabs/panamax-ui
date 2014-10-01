describe('$.fn.dynamicHostPort', function() {
  var subject,
    $dynamicHostPort;

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
    $dynamicHostPort = $('#teaspoon-fixtures').find('tr.dynamic-host');
    subject = new $.PMX.DynamicHostPort($dynamicHostPort);
  });

  describe('handleResponse', function() {

    it('calls updateLink if the service is running', function() {
      subject.init();
      spyOn(subject, 'updatePortMappings');
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect(subject.updatePortMappings).toHaveBeenCalledWith(serviceResponse);
    });

    it('updates the table and rows if the service is not running', function () {
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('.view-action').text()).toEqual('port is being assigned...');
      expect($('.view-action').attr('href')).toEqual('');
      expect($('.host-port').text()).toEqual('.....');
      expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;
    });

    it('updates the table and rows if the service is not loaded', function () {
      subject.init();
      $('span.service-status').trigger('update-service-status', loadingServiceResponse);
      expect($('.view-action').text()).toEqual('port is being assigned...');
      expect($('.view-action').attr('href')).toEqual('');
      expect($('.host-port').text()).toEqual('.....');
      expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;
    });

  });

  describe('updatePortMappings', function () {

    it ('calls getPortsList', function () {
      subject.init();
      spyOn(subject, 'getPortsList').andReturn([{portNumber: 3333, host: 49100}]);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect(subject.getPortsList).toHaveBeenCalledWith(serviceResponse.docker_status.info.NetworkSettings.Ports);
    });

    it ('removes the loading class from the table', function () {
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeTruthy;

      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.port-bindings').hasClass('service-loading')).toBeFalsy;
    });

    it ('replaces port information', function () {
      subject.init();
      spyOn(subject, 'getPortsList').andReturn([{portNumber: 3333, host: 49100}]);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('.view-action').text()).toEqual('localhost:49100');
      expect($('.view-action').attr('href')).toEqual('localhost:49100');
      expect($('.host-port').text()).toEqual('49100');
    });
  });

  describe('getPortsList', function () {
    it ('assembles an array of port numbers and host ports', function () {
      $('span.service-status').trigger('update-service-status', serviceResponse);
      var result = subject.getPortsList(serviceResponse.docker_status.info.NetworkSettings.Ports);
      expect(result).toEqual([{portNumber: '3333', host: '49100'}])
    });
  });
});
