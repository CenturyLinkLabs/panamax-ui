describe('$.fn.serviceHealth', function() {
  var subject;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('host_health.html');
    subject = new $.PMX.ServiceHealth($('.health'),
      { $metricLink: $('.service-link'),
        $dockerStatus: $('.service-status')
      });
  });

  describe('#init', function() {
    it('creates HealthGraph', function() {
      spyOn(subject, 'buildGraph');
      subject.init();
      expect(subject.buildGraph).toHaveBeenCalled();
    });

    it('hides the element', function() {
      subject.init();
      expect($('.health').css('display')).toEqual('none');
    });
  });

  describe('when update-service-status is triggered', function() {
    it('calls checkStatusHandler', function() {
      spyOn(subject, 'checkStatusHandler');
      subject.init();
      $('.service-status').trigger('update-service-status', { sub_state: 'running' });
      expect(subject.checkStatusHandler).toHaveBeenCalled();
    });

    describe('service sub_state is running', function() {
      it('shows the element when sub_state is running', function() {
        spyOn(subject, 'showHealth');
        subject.init();
        $('.service-status').trigger('update-service-status', { sub_state: 'running' });
        expect(subject.showHealth).toHaveBeenCalled();
      });

      it('calls service with proper url', function() {
        jasmine.Ajax.useMock();
        subject.init();
        $('.service-status').trigger('update-service-status', { sub_state: 'running' });
        var request = mostRecentAjaxRequest();
        request.response({
          status: 200,
          responseText: JSON.stringify({ overall_cpu: 10, overall_mem: 10 })
        });
        expect(request.method).toBe('GET');
        expect(request.url).toBe('/service_health/Service');
      });
    });

    describe('service sub_state is not running', function() {
      it('hides the element when sub_state is not running', function() {
        spyOn(subject, 'hideHealth');
        subject.init();
        $('.service-status').trigger('update-service-status', {sub_state: 'loading'});
        expect(subject.hideHealth).toHaveBeenCalled();
      });
    });
  });
});
