describe('$.fn.serviceStatus', function() {
  var subject,
      $serviceStatus;

  var serviceResponse = {
    'status': 'foo',
    'sub_state': 'bar',
    'active_state': 'baz',
    'load_state': 'buzz'
  };

  beforeEach(function() {
    jasmine.Ajax.useMock();
    spyOn(window, 'setTimeout');

    fixture.load('service-status.html');
    $serviceStatus = $('#teaspoon-fixtures').find('.service-status');

    subject = new $.PMX.ServiceStatus($serviceStatus);
  });

  describe('init', function() {

    it('queries the service endpoint', function() {
      subject.init();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/foo/bar');
    });

    it('displays the sub state', function() {
      subject.init();
      mockAjaxResponse();

      expect($('.sub-state').text()).toEqual(
        subject.formatPanamaxState(serviceResponse.sub_state));
    });

    it('displays the loading state', function() {
      subject.init();
      mockAjaxResponse();

      expect($('.load-state').text()).toEqual(
        subject.formatPanamaxState(serviceResponse.load_state));
    });

    it('displays the active state', function() {
      subject.init();
      mockAjaxResponse();

      expect($('.active-state').text()).toEqual(
        subject.formatPanamaxState(serviceResponse.active_state));
    });

    it('displays the Panamax state', function() {
      subject.init();
      mockAjaxResponse();

      expect($('.panamax-state').text()).toEqual(
        subject.formatPanamaxState(serviceResponse.status));
    });

    it('adds a CSS class matching the service status', function() {
      subject.init();
      mockAjaxResponse();

      expect($serviceStatus.attr('class')).toContain('service-status');
      expect($serviceStatus.attr('class')).toContain(serviceResponse.status);
    });

    it('calls window.setTimeout', function() {
      subject.init();
      mockAjaxResponse();

      expect(window.setTimeout).toHaveBeenCalledWith(
        subject.fetchStatus, subject.options.refreshInterval);
    });

    describe('hovering on the panamax-state element', function() {
      var mouseenter = $.Event('mouseenter');
      var mouseleave = $.Event('mouseleave');

      it('displays the tooltip on mouseenter', function() {
        subject.init();
        $('.panamax-state').trigger(mouseenter);
        expect($('.tooltip').css('display')).toBe('block');
      });

      it('hides the tooltip on mouseleave', function() {
        subject.init();
        $('.panamax-state').trigger(mouseleave);
        expect($('.tooltip').css('display')).toBe('none');
      });
    });

    describe('when a request is already in-progress', function() {

      var fakeAjax = {
        abort: function() {},
        done: function() { return fakeAjax; }
      };

      beforeEach(function() {
        subject.xhr = fakeAjax;
        spyOn(fakeAjax, 'abort');
      });

      it('aborts previous requests', function() {
        subject.init();
        expect(fakeAjax.abort.calls.length).toEqual(1);
      });
    });
  });

  var mockAjaxResponse = function() {
    mostRecentAjaxRequest().response({
      status: 200,
      responseText: JSON.stringify(serviceResponse)
    });
  };
});
