describe('$.fn.errorInterceptor', function() {
  var subject;

  beforeEach(function() {
    fixture.load('error-interceptor.html');
    subject = new $.PMX.ErrorInterceptor($('.errors'), {excludePaths: ['excludeMe']});
    subject.init();
  });

  describe('when an error occurs', function() {
    it('a notification is created within main', function() {
      subject.handleError($.Event(), null, {url: 'http://someplace/with/errors'}, 'Unknown error');

      expect($('main .notice-danger').length).toEqual(1);
    });

    it('ignores errors from excluded urls', function() {
      subject.handleError($.Event(), null, {url: 'http://someplace/excludeMe/errors'}, 'Unknown error');

      expect($('main .notice-danger').length).toEqual(0);
    })
  });
});
