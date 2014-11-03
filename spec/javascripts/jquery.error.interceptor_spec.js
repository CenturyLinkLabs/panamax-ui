describe('$.fn.errorInterceptor', function() {
  var subject;

  beforeEach(function() {
    subject = new $.PMX.ErrorInterceptor($('.errors'), {excludePaths: ['excludeMe']});
    spyOn($.PMX.Helpers, 'displayError');
    subject.init();
  });

  describe('when an error occurs', function() {
    it('a notification is created within main', function() {
      subject.handleError($.Event(), {status: 500}, {url: 'http://someplace/with/errors'}, 'Unknown error');

      expect($.PMX.Helpers.displayError).toHaveBeenCalledWith('Unknown error');
    });

    it('ignores errors from excluded urls', function() {
      subject.handleError($.Event(), null, {url: 'http://someplace/excludeMe/errors'}, 'Unknown error');

      expect($.PMX.Helpers.displayError).not.toHaveBeenCalled();
    })
  });
});
