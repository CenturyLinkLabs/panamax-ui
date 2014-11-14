describe('$.fn.exposedPorts', function() {
  var subject,
    $portMappings;

  var serviceResponse = {
    'sub_state': 'running',
    'load_state': 'loaded',
    'default_exposed_ports': ['3000/tcp']
  };

  var stoppedServiceResponse = {
    'sub_state': 'stopped',
    'load_state': 'foo'
  };

  var loadingServiceResponse = {
    'sub_state': 'foo',
    'load_state': 'loading'
  };

  beforeEach(function() {
    fixture.load('exposed-ports-table.html');
  });

  describe('handleResponse', function() {

    describe('when the service is running', function () {
      it('removes the loading message from the table', function () {
        $exposedPorts = $('#teaspoon-fixtures').find('table');
        subject = new $.PMX.ExposedPorts($exposedPorts);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('table.exposed-ports').find('tr.loading').length).toBe(1);

        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect($('table.port-bindings').find('tr.loading').length).toBe(0);
      });

      it('calls updateExposedPorts', function() {
        $exposedPorts = $('#teaspoon-fixtures').find('table');
        subject = new $.PMX.ExposedPorts($exposedPorts);
        subject.init();
        spyOn(subject, 'updateExposedPorts');
        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect(subject.updateExposedPorts).toHaveBeenCalledWith(serviceResponse);
      });
    });

    describe('when the service is stopped', function () {
      it('adds the loading message to the table', function () {
        $exposedPorts = $('#teaspoon-fixtures').find('table');
        subject = new $.PMX.ExposedPorts($exposedPorts);
        subject.init();
        $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
        expect($('table.exposed-ports').find('tr.loading').length).toBe(1);
      });
    });

    describe('when the service is loading', function () {
      it('adds the loading message to the table', function () {
        $exposedPorts = $('#teaspoon-fixtures').find('table');
        subject = new $.PMX.ExposedPorts($exposedPorts);
        subject.init();
        $('span.service-status').trigger('update-service-status', loadingServiceResponse);
        expect($('table.exposed-ports').find('tr.loading').length).toBe(1);
      });
    });
  });

  describe('showLoadingMessage', function () {
    it('adds the loading message to the table', function () {
      $exposedPorts = $('#teaspoon-fixtures').find('table');
      subject = new $.PMX.ExposedPorts($exposedPorts);
      subject.init();
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(0);

      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(1);
    });

  });

  describe('hideLoadingMessage', function () {
    it('removes the loading message from the table', function () {
      $exposedPorts = $('#teaspoon-fixtures').find('table');
      subject = new $.PMX.ExposedPorts($exposedPorts);
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(1);

      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(0);
    });
  });

  describe('updateExposedPorts', function () {
    beforeEach(function () {
      $exposedPorts = $('#teaspoon-fixtures').find('table');
      subject = new $.PMX.ExposedPorts($exposedPorts);
    });

    it('removes the loading message from the table', function () {
      subject.init();
      $('span.service-status').trigger('update-service-status', stoppedServiceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(1);
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect($('table.exposed-ports').find('tr.loading').length).toBe(0);
    });

    it ('calls formatPort', function () {
      subject.init();
      spyOn(subject, 'formatPort').andReturn("3000 / TCP");
      $('span.service-status').trigger('update-service-status', serviceResponse);
      expect(subject.formatPort).toHaveBeenCalledWith(serviceResponse.default_exposed_ports[0]);
    });

    describe ('when default_exposed_ports exist in the table', function () {
      it ('does not update the table', function () {
        subject.init();
        $('table.exposed-ports').append(
            '<tr class="image-defined"><td>5432</td><td><div class="info">' +
            'exposed by base image - remote deployment will require explicit port declaration</div></td></tr>'
        );
        beforeUpdate = $('table.exposed-ports').html();
        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect($('table.exposed-ports').html()).toEqual(beforeUpdate);
      });
    });

    describe ('when default_exposed_ports do not exist in the table', function () {
      it ('adds port information', function () {
        subject.init();
        expect($('table.exposed-ports').find('.image-defined').length).toBe(0);;
        $('span.service-status').trigger('update-service-status', serviceResponse);
        expect($('table.exposed-ports').find('.image-defined').length).toBe(1);;
      });
    });
  });

  describe('formatPort', function () {
    beforeEach(function () {
      $exposedPorts = $('#teaspoon-fixtures').find('table');
      subject = new $.PMX.ExposedPorts($exposedPorts);
    });

    it ('adds spacing and upcases the protocol', function () {
      $('span.service-status').trigger('update-service-status', serviceResponse);
      var result = subject.formatPort(serviceResponse.default_exposed_ports[0]);
      expect(result).toEqual("3000 / TCP")
    });
  });
});
