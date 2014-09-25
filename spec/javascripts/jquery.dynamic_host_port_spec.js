describe('$.fn.dynamicHostPort', function() {
  var subject,
    $dynamicHostPort;

  var serviceResponse = {
    'sub_state': 'running',
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

    it('updates the row if the service is not running', function () {
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('.view-action').text()).toEqual('port is being assigned...');
      expect($('.view-action').attr('href')).toEqual('');
      expect($('.host-port').text()).toEqual('.....');
      expect($('tr.dynamic-host').hasClass('allocating')).toBeTruthy;
    });
  });

  describe('updatePortMappings', function () {

    it ('calls getPortsList', function () {
      subject.init();
      spyOn(subject, 'getPortsList').andReturn([{portNumber: 3333, host: 49100}]);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect(subject.getPortsList).toHaveBeenCalledWith(serviceResponse.docker_status.info.NetworkSettings.Ports);
    });

    it ('removes the class from the loading row', function () {
      subject.init();
      serviceResponse.sub_state = 'stopped';
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('tr:first-child').hasClass('allocating')).toBeTruthy;

      serviceResponse.sub_state = 'running';
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('tr:first-child').hasClass('allocating')).toBeFalsy;
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
