describe('$.fn.hostHealth', function() {
  var subject;

  beforeEach(function() {
    jasmine.Ajax.useMock();
    fixture.load('host_health.html');
    subject = new $.PMX.HostHealth($('.health'));
    spyOn(subject, 'buildGraph');
    spyOn(window, 'setTimeout');
    spyOn(window, 'clearTimeout');
  });

  describe('#init', function() {
    it('queries for the overall metrics', function() {
      subject.init();
      var request = mostRecentAjaxRequest();
      expect(request.url).toBe('/host_health');
    });

    it('creates HealthGraph', function() {
      subject.init();
      expect(subject.buildGraph).toHaveBeenCalled();
    });

    it('initiates setTimeout', function() {
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: ''
      });
      expect(window.setTimeout).toHaveBeenCalled();
    });

    it('clears the previously set timeout', function() {
      var fakeTimer = {fakeTimer: true};
      subject.timer = fakeTimer;
      subject.init();
      var request = mostRecentAjaxRequest();

      request.response({
        status: 200,
        responseText: ''
      });
      expect(window.clearTimeout).toHaveBeenCalledWith(fakeTimer);
    });
  });
});
